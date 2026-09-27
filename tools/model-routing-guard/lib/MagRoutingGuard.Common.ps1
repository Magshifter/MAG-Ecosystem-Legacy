#Requires -Version 7.0
# MAG Model Routing Guard — shared logic. Not MAG authority.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:MagGuardRoot = if ((Split-Path -Leaf $PSScriptRoot) -eq 'lib') {
    Split-Path -Parent $PSScriptRoot
} else {
    $PSScriptRoot
}
$script:DefaultReposRoot = 'C:\laragon\repos'
$script:DefaultPlanPath = Join-Path $script:DefaultReposRoot '.mag\routing-plan.json'
$script:DefaultEvidencePath = Join-Path $script:DefaultReposRoot '.mag\routing-evidence.jsonl'
$script:DefaultMappingPath = Join-Path $script:MagGuardRoot 'capability-mapping.json'

function Get-MagGuardReposRoot {
    if (-not [string]::IsNullOrWhiteSpace($env:MAG_REPOS_ROOT)) {
        return $env:MAG_REPOS_ROOT.TrimEnd('\', '/')
    }
    return $script:DefaultReposRoot
}

function Get-MagGuardPlanPath {
    $root = Get-MagGuardReposRoot
    return (Join-Path $root '.mag\routing-plan.json')
}

function Get-MagGuardEvidencePath {
    $root = Get-MagGuardReposRoot
    return (Join-Path $root '.mag\routing-evidence.jsonl')
}

function Read-MagGuardStdinJson {
    $script:MagGuardInputState = 'empty'
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $null
    }
    try {
        $parsed = $raw | ConvertFrom-Json
        $script:MagGuardInputState = if ($null -eq $parsed) { 'json_null' } elseif ($parsed -is [pscustomobject]) { 'object' } else { 'non_object' }
        return $parsed
    }
    catch {
        return $null
    }
}

function Read-MagGuardPlan {
    param([string]$Path = (Get-MagGuardPlanPath))
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $null
    }
    try {
        $obj = Get-Content -LiteralPath $Path -Raw -Encoding utf8 | ConvertFrom-Json
        if ($null -eq $obj) { return $null }
        if (-not $obj.PSObject.Properties['routing_plan_version'] -or $obj.routing_plan_version -ne 1) { return $null }
        if ($obj.PSObject.Properties['accepted'] -and $obj.accepted -ne $true) { return $null }
        foreach ($key in @('procedure_id','identity','current_segment','segments')) {
            if (-not $obj.PSObject.Properties[$key] -or -not $obj.$key) { return $null }
        }
        foreach ($segment in @($obj.segments)) {
            foreach ($key in @('segment_id','routing_class','boundary_condition')) {
                if (-not $segment.PSObject.Properties[$key]) { return $null }
            }
        }
        return $obj
    }
    catch {
        return $null
    }
}

function Read-MagGuardMapping {
    param([string]$Path = $script:DefaultMappingPath)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $null
    }
    try {
        return (Get-Content -LiteralPath $Path -Raw -Encoding utf8 | ConvertFrom-Json)
    }
    catch {
        return $null
    }
}

function Get-MagGuardCurrentSegment {
    param($Plan)
    if ($null -eq $Plan) { return $null }
    $id = [string]$Plan.current_segment
    $segs = @($Plan.segments)
    if ($segs.Count -lt 1) { return $null }
    if ([string]::IsNullOrWhiteSpace($id)) { return $segs[0] }
    foreach ($s in $segs) {
        if ([string]$s.segment_id -eq $id) { return $s }
    }
    return $null
}

function Get-MagGuardObservation {
    param($HookInput)
    $values = @{}
    foreach ($key in @('model_id', 'model')) {
        $value = if ($null -ne $HookInput -and $HookInput.PSObject.Properties[$key]) { $HookInput.$key } else { $null }
        $values[$key] = if ($value -is [string]) { $value.Trim() } else { $null }
    }
    foreach ($key in @('model_id', 'model')) {
        $value = $values[$key]
        if ($value -and $value -notmatch '^(default|auto|unknown|null|none|undefined)$' -and $value.Length -le 128 -and $value -match '^[a-zA-Z0-9][a-zA-Z0-9 ._:/+-]*$') {
            return [pscustomobject]@{ Id = $value.ToLowerInvariant(); Source = $key }
        }
    }
    return [pscustomobject]@{ Id = $null; Source = 'none' }
}

function Get-MagGuardObservedModelId {
    param($HookInput)
    return (Get-MagGuardObservation -HookInput $HookInput).Id
}

function Write-MagGuardObservationDiagnostic {
    param($HookInput, $Decision, [string]$HookName)
    $root = Join-Path (Get-MagGuardReposRoot) '.mag'
    if (-not (Test-Path -LiteralPath (Join-Path $root 'routing-observation-debug.enabled'))) { return }
    $event = [ordered]@{ hook_event = $HookName; input_state = $(if (Test-Path variable:script:MagGuardInputState) { $script:MagGuardInputState } else { 'direct_call' }) }
    foreach ($key in @('model', 'model_id', 'hook_event_name', 'cursor_version')) {
        $value = if ($null -ne $HookInput -and $HookInput.PSObject.Properties[$key]) { $HookInput.$key } else { $null }
        $event[$key] = if ($value -is [string] -and $value.Length -le 128 -and $value -match '^[a-zA-Z0-9 ._:/+-]*$') { $value } elseif ($null -eq $value) { $null } else { '[non-scalar-or-redacted]' }
    }
    # Never serialize model_params values or the input object (may contain prompt/session data).
    $event['model_params_present'] = ($null -ne $HookInput -and $null -ne $HookInput.PSObject.Properties['model_params'])
    $event['observation_source'] = (Get-MagGuardObservation -HookInput $HookInput).Source
    $event['signal'] = $Decision.Signal
    $event['action'] = $Decision.Action
    Add-Content -LiteralPath (Join-Path $root 'routing-observation-debug.jsonl') -Value ($event | ConvertTo-Json -Compress) -Encoding utf8
}

function Test-MagGuardModelAllowed {
    param(
        [string]$ObservedModelId,
        $Segment,
        $Mapping
    )
    if ([string]::IsNullOrWhiteSpace($ObservedModelId)) {
        return [pscustomobject]@{ Ok = $false; Reason = 'MODEL_UNOBSERVED' }
    }
    $obs = $ObservedModelId.Trim().ToLowerInvariant()

    $required = @()
    if ($null -ne $Segment -and $Segment.PSObject.Properties['required_model_ids'] -and $Segment.required_model_ids) {
        $required = @($Segment.required_model_ids | ForEach-Object { [string]$_ })
    }
    if ($required.Count -gt 0) {
        foreach ($r in $required) {
            if ([string]::IsNullOrWhiteSpace($r)) { continue }
            $p = $r.ToLowerInvariant()
            if ($obs -eq $p -or $obs.StartsWith($p)) {
                return [pscustomobject]@{ Ok = $true; Reason = 'REQUIRED_ID' }
            }
        }
        return [pscustomobject]@{ Ok = $false; Reason = 'MODEL_MISMATCH' }
    }

    $class = if ($null -ne $Segment) { [string]$Segment.routing_class } else { '' }
    if ([string]::IsNullOrWhiteSpace($class)) {
        return [pscustomobject]@{ Ok = $false; Reason = 'ROUTING_MAPPING_UNKNOWN' }
    }
    if ($null -eq $Mapping -or -not $Mapping.PSObject.Properties['classes']) {
        return [pscustomobject]@{ Ok = $false; Reason = 'ROUTING_MAPPING_UNKNOWN' }
    }
    $entry = $Mapping.classes.PSObject.Properties[$class]
    if ($null -eq $entry) {
        return [pscustomobject]@{ Ok = $false; Reason = 'ROUTING_MAPPING_UNKNOWN' }
    }
    $prefixes = @($entry.Value.model_id_prefixes | ForEach-Object { [string]$_ })
    if ($prefixes.Count -lt 1) {
        return [pscustomobject]@{ Ok = $false; Reason = 'ROUTING_MAPPING_UNKNOWN' }
    }
    foreach ($p0 in $prefixes) {
        if ([string]::IsNullOrWhiteSpace($p0)) { continue }
        $p = $p0.ToLowerInvariant()
        if ($obs -eq $p -or $obs.StartsWith($p) -or $obs.Contains($p)) {
            return [pscustomobject]@{ Ok = $true; Reason = 'MAPPING' }
        }
    }
    return [pscustomobject]@{ Ok = $false; Reason = 'MODEL_MISMATCH' }
}

function Get-MagGuardEnforcement {
    param($Plan)
    $defaults = @{
        mismatch_behavior        = 'STOP'
        boundary_behavior        = 'STOP'
        escalation_behavior      = 'STOP'
        downgrade_behavior       = 'WARN'
        challenge_behavior       = 'STOP_IF_EXPENSIVE_OR_WRONG'
        missing_plan_behavior    = 'INERT'
        missing_model_behavior   = 'STOP'
    }
    if ($null -eq $Plan -or -not $Plan.PSObject.Properties['enforcement'] -or $null -eq $Plan.enforcement) {
        return [pscustomobject]$defaults
    }
    $e = $Plan.enforcement
    foreach ($k in @($defaults.Keys)) {
        if ($e.PSObject.Properties[$k] -and -not [string]::IsNullOrWhiteSpace([string]$e.$k)) {
            $defaults[$k] = [string]$e.$k
        }
    }
    return [pscustomobject]$defaults
}

function Get-MagGuardDeclaredSignal {
    param($Plan, $Segment)
    # Explicit plan/runtime signal only (observable).
    foreach ($candidate in @(
            $(if ($Plan -and $Plan.PSObject.Properties['signal']) { [string]$Plan.signal }),
            $(if ($Plan -and $Plan.PSObject.Properties['runtime'] -and $Plan.runtime.PSObject.Properties['blocking_signal']) { [string]$Plan.runtime.blocking_signal }),
            $(if ($Plan -and $Plan.PSObject.Properties['runtime'] -and $Plan.runtime.PSObject.Properties['signal']) { [string]$Plan.runtime.signal }),
            $(if ($Segment -and $Segment.PSObject.Properties['signal']) { [string]$Segment.signal })
        )) {
        if (-not [string]::IsNullOrWhiteSpace($candidate) -and $candidate -ne 'none' -and $candidate -ne 'NONE') {
            return $candidate.Trim().ToUpperInvariant()
        }
    }
    # Boundary condition declared-complete / po-declared counts as BOUNDARY when set.
    if ($null -ne $Segment) {
        $bc = [string]$Segment.boundary_condition
        if ($bc -eq 'declared-complete' -or $bc -eq 'po-declared') {
            return 'MODEL_BOUNDARY'
        }
    }
    return $null
}

function Test-MagGuardPoContinueAck {
    param($Plan)
    if ($null -eq $Plan -or -not $Plan.PSObject.Properties['runtime']) { return $false }
    $r = $Plan.runtime
    if ($r.PSObject.Properties['po_continue_ack'] -and [bool]$r.po_continue_ack) { return $true }
    return $false
}

function Clear-MagGuardPoContinueAck {
    param([string]$PlanPath, $Plan)
    if ($null -eq $Plan -or -not (Test-Path -LiteralPath $PlanPath)) { return }
    if (-not $Plan.PSObject.Properties['runtime']) {
        $Plan | Add-Member -NotePropertyName runtime -NotePropertyValue ([pscustomobject]@{}) -Force
    }
    $rt = [hashtable]@{}
    foreach ($p in $Plan.runtime.PSObject.Properties) {
        $rt[$p.Name] = $p.Value
    }
    $rt['po_continue_ack'] = $false
    if ($rt.ContainsKey('blocking_signal')) { $rt['blocking_signal'] = $null }
    if ($rt.ContainsKey('signal')) { $rt['signal'] = $null }
    $Plan.runtime = [pscustomobject]$rt
    if ($Plan.PSObject.Properties['signal']) { $Plan.signal = $null }
    $json = $Plan | ConvertTo-Json -Depth 20
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($PlanPath, $json + "`n", $utf8)
}

function Write-MagGuardEvidence {
    param(
        $Plan,
        [string]$ObservedModelId,
        [string]$Signal,
        [string]$Action,
        [string]$Note = ''
    )
    if ($null -ne $Plan -and $Plan.PSObject.Properties['evidence'] -and $Plan.evidence.PSObject.Properties['enabled'] -and -not [bool]$Plan.evidence.enabled) {
        return
    }
    $path = Get-MagGuardEvidencePath
    $dir = Split-Path -Parent $path
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    $seg = Get-MagGuardCurrentSegment -Plan $Plan
    $evt = [ordered]@{
        ts                 = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ssK')
        procedure_id       = $(if ($Plan) { [string]$Plan.procedure_id } else { '' })
        identity           = $(if ($Plan) { [string]$Plan.identity } else { '' })
        segment_id         = $(if ($seg) { [string]$seg.segment_id } else { '' })
        routing_class      = $(if ($seg) { [string]$seg.routing_class } else { '' })
        observed_model_id  = $ObservedModelId
        signal             = $Signal
        action             = $Action
        note               = $Note
    }
    $line = ($evt | ConvertTo-Json -Compress)
    Add-Content -LiteralPath $path -Value $line -Encoding utf8
}

function Resolve-MagGuardDecision {
    param(
        $Plan,
        $HookInput,
        [string]$HookName = 'beforeSubmitPrompt'
    )
    $enforcement = Get-MagGuardEnforcement -Plan $Plan
    $observed = Get-MagGuardObservedModelId -HookInput $HookInput

    if ($null -eq $Plan) {
        $behavior = [string]$enforcement.missing_plan_behavior
        if ($behavior -eq 'STOP') {
            return [pscustomobject]@{
                Continue = $false
                Signal   = 'MISSING_PLAN'
                Action   = 'STOP'
                Message  = 'MAG Model Routing Guard: routing plan missing. Create C:\laragon\repos\.mag\routing-plan.json or set missing_plan_behavior=INERT.'
            }
        }
        # INERT (+ optional notice is not shown on every prompt — truly inert)
        return [pscustomobject]@{
            Continue = $true
            Signal   = 'INERT'
            Action   = 'CONTINUE'
            Message  = ''
        }
    }

    $seg = Get-MagGuardCurrentSegment -Plan $Plan
    if ($null -eq $seg) {
        return [pscustomobject]@{
            Continue = $false
            Signal   = 'AUTHORITY_CONFLICT'
            Action   = 'STOP'
            Message  = 'MAG Model Routing Guard: current_segment not found in plan. Replan required.'
        }
    }

    $declared = Get-MagGuardDeclaredSignal -Plan $Plan -Segment $seg
    $poAck = Test-MagGuardPoContinueAck -Plan $Plan

    # Precedence helper
    function New-Decision([string]$Signal, [bool]$Stop, [string]$Action, [string]$Message) {
        return [pscustomobject]@{
            Continue = -not $Stop
            Signal   = $Signal
            Action   = $Action
            Message  = $Message
            PoAck    = $poAck
        }
    }

    if ($declared -in @('AUTHORITY_CONFLICT', 'REPLAN_REQUIRED')) {
        if ($poAck) {
            return (New-Decision $declared $false 'PO_CONTINUE' '')
        }
        return (New-Decision $declared $true 'STOP' ("MAG Model Routing Guard: {0}. Product Owner replan/resolution required, then set runtime.po_continue_ack=true and send +." -f $declared))
    }

    $mapping = Read-MagGuardMapping
    $match = Test-MagGuardModelAllowed -ObservedModelId $observed -Segment $seg -Mapping $mapping

    if ($match.Reason -eq 'MODEL_UNOBSERVED') {
        return (New-Decision 'MODEL_OBSERVATION_UNKNOWN' $true 'STOP' 'MAG Model Routing Guard: MODEL_OBSERVATION_UNKNOWN. No concrete model identity supplied. Enforcement remains stopped. Product Owner can run Set-MagGuardMaintenance.ps1 -Action Suspend -ProductOwnerApproved from an external terminal for repair.')
    }

    if (-not $match.Ok) {
        $sig = if ($match.Reason -eq 'ROUTING_MAPPING_UNKNOWN') { 'ROUTING_MAPPING_UNKNOWN' } else { 'MODEL_MISMATCH' }
        if ($poAck -and $sig -eq 'MODEL_MISMATCH') {
            # Ack alone must not bypass mismatch — PO must actually switch model.
        }
        if ([string]$enforcement.mismatch_behavior -eq 'STOP' -or $sig -eq 'ROUTING_MAPPING_UNKNOWN') {
            $msg = if ($sig -eq 'ROUTING_MAPPING_UNKNOWN') {
                "MAG Model Routing Guard: ROUTING_MAPPING_UNKNOWN for class '$($seg.routing_class)'. Refresh capability-mapping.json or set required_model_ids."
            }
            else {
                "MAG Model Routing Guard: MODEL_MISMATCH. Required class=$($seg.routing_class); observed=$observed. Switch model to match Capability Mapping, then retry."
            }
            return (New-Decision $sig $true 'STOP' $msg)
        }
        return (New-Decision $sig $false 'WARN' '')
    }

    if ($declared -eq 'MODEL_ESCALATION_REQUIRED') {
        if ($poAck) { return (New-Decision $declared $false 'PO_CONTINUE' '') }
        if ([string]$enforcement.escalation_behavior -eq 'STOP') {
            return (New-Decision $declared $true 'STOP' 'MAG Model Routing Guard: MODEL_ESCALATION_REQUIRED. Product Owner must change to stronger class/model, set runtime.po_continue_ack=true, then send +.')
        }
    }

    if ($declared -eq 'MODEL_BOUNDARY') {
        if ($poAck) { return (New-Decision $declared $false 'PO_CONTINUE' '') }
        if ([string]$enforcement.boundary_behavior -eq 'STOP') {
            return (New-Decision $declared $true 'STOP' 'MAG Model Routing Guard: MODEL_BOUNDARY. Switch model for next segment, set runtime.po_continue_ack=true (and clear boundary signal), then send +.')
        }
    }

    if ($declared -eq 'RUNTIME_CHALLENGE') {
        if ($poAck) { return (New-Decision $declared $false 'PO_CONTINUE' '') }
        $chal = [string]$enforcement.challenge_behavior
        if ($chal -eq 'STOP' -or $chal -eq 'STOP_IF_EXPENSIVE_OR_WRONG') {
            return (New-Decision $declared $true 'STOP' 'MAG Model Routing Guard: RUNTIME_CHALLENGE (blocking). Resolve with Product Owner (downgrade/escalation/replan), set runtime.po_continue_ack=true, then send +.')
        }
        return (New-Decision $declared $false 'WARN' '')
    }

    if ($declared -eq 'MODEL_DOWNGRADE_RECOMMENDED') {
        return (New-Decision $declared $false 'WARN' '')
    }

    if ($HookName -eq 'preCompact') {
        return (New-Decision 'CONTEXT_WARNING' $false 'WARN' '')
    }

    return (New-Decision 'MODEL_MATCH' $false 'CONTINUE' '')
}

function Emit-MagGuardHookResponse {
    param(
        [bool]$Continue,
        [string]$UserMessage = ''
    )
    $obj = [ordered]@{ continue = [bool]$Continue }
    if (-not $Continue -and -not [string]::IsNullOrWhiteSpace($UserMessage)) {
        $obj['user_message'] = $UserMessage
    }
    $json = ($obj | ConvertTo-Json -Compress)
    [Console]::Out.Write($json)
}


