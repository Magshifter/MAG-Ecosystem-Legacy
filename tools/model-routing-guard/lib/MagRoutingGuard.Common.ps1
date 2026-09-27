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

function Get-MagGuardContinueToken {
    param($Plan)
    if ($null -ne $Plan -and $Plan.PSObject.Properties['continue_token'] -and -not [string]::IsNullOrWhiteSpace([string]$Plan.continue_token)) {
        return ([string]$Plan.continue_token).Trim()
    }
    return '+'
}

function Test-MagGuardPoContinueAck {
    param($Plan)
    if ($null -eq $Plan -or -not $Plan.PSObject.Properties['runtime']) { return $false }
    $r = $Plan.runtime
    if ($r.PSObject.Properties['po_continue_ack'] -and [bool]$r.po_continue_ack) { return $true }
    return $false
}

function Test-MagGuardPromptContinue {
    param($Plan, $HookInput)
    if ($null -eq $HookInput -or -not $HookInput.PSObject.Properties['prompt']) { return $false }
    $prompt = [string]$HookInput.prompt
    if ([string]::IsNullOrWhiteSpace($prompt)) { return $false }
    return ($prompt.Trim() -eq (Get-MagGuardContinueToken -Plan $Plan))
}

function Test-MagGuardPoModelAccepted {
    param($Plan, $Segment)
    # One-shot model-gate accept for the current segment only.
    # Does NOT disable Guard for the rest of the prompt session: BOUNDARY /
    # ESCALATION / CHALLENGE / AUTHORITY / segment change can STOP+propose again.
    if ($null -eq $Plan -or $null -eq $Segment -or -not $Plan.PSObject.Properties['runtime']) { return $false }
    $r = $Plan.runtime
    if (-not $r.PSObject.Properties['po_model_gate_accepted_segment']) { return $false }
    $accepted = [string]$r.po_model_gate_accepted_segment
    if ([string]::IsNullOrWhiteSpace($accepted)) { return $false }
    return ($accepted -eq [string]$Segment.segment_id)
}

function Get-MagGuardProposalText {
    param($Segment, $Mapping)
    $class = if ($null -ne $Segment) { [string]$Segment.routing_class } else { '' }
    $prefixes = @()
    if ($null -ne $Mapping -and $Mapping.PSObject.Properties['classes'] -and -not [string]::IsNullOrWhiteSpace($class)) {
        $entry = $Mapping.classes.PSObject.Properties[$class]
        if ($null -ne $entry -and $entry.Value.PSObject.Properties['model_id_prefixes']) {
            $prefixes = @($entry.Value.model_id_prefixes | ForEach-Object { [string]$_ } | Select-Object -First 5)
        }
    }
    $required = @()
    if ($null -ne $Segment -and $Segment.PSObject.Properties['required_model_ids'] -and $Segment.required_model_ids) {
        $required = @($Segment.required_model_ids | ForEach-Object { [string]$_ } | Where-Object { $_ } | Select-Object -First 5)
    }
    $suggest = if ($required.Count -gt 0) { ($required -join ', ') } elseif ($prefixes.Count -gt 0) { ($prefixes -join ', ') } else { '(none mapped — choose any model you accept)' }
    return ("Proposed class={0}; suggested model(s)={1}. Switch only if you agree, then send + . Your + accepts THIS gate only — Guard stays active and may propose again later in this session." -f $(if ($class) { $class } else { '(unknown)' }), $suggest)
}

function Accept-MagGuardPoContinue {
    param(
        [string]$PlanPath,
        $Plan,
        $Segment,
        [string]$AcceptedGate = 'model'
    )
    if ($null -eq $Plan -or [string]::IsNullOrWhiteSpace($PlanPath)) { return }
    if (-not $Plan.PSObject.Properties['runtime']) {
        $Plan | Add-Member -NotePropertyName runtime -NotePropertyValue ([pscustomobject]@{}) -Force
    }
    $rt = [hashtable]@{}
    foreach ($p in $Plan.runtime.PSObject.Properties) {
        $rt[$p.Name] = $p.Value
    }
    $rt['po_continue_ack'] = $false
    $rt['blocking_signal'] = $null
    $rt['signal'] = $null
    # Clear legacy field if present
    if ($rt.ContainsKey('po_accepted_segment')) { $rt.Remove('po_accepted_segment') }
    if ($null -ne $Segment -and -not [string]::IsNullOrWhiteSpace([string]$Segment.segment_id)) {
        # Model/observation gate accept for this segment — not a session-wide disable.
        if ($AcceptedGate -eq 'model') {
            $rt['po_model_gate_accepted_segment'] = [string]$Segment.segment_id
        }
    }
    $rt['last_po_continue_gate'] = $AcceptedGate
    $Plan.runtime = [pscustomobject]$rt
    if ($Plan.PSObject.Properties['signal']) { $Plan.signal = $null }
    if (-not (Test-Path -LiteralPath $PlanPath)) { return }
    $json = $Plan | ConvertTo-Json -Depth 20
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($PlanPath, $json + "`n", $utf8)
}

# Backward-compatible alias used by hooks / older call sites.
function Clear-MagGuardPoContinueAck {
    param([string]$PlanPath, $Plan, $Segment = $null)
    if ($null -eq $Segment) { $Segment = Get-MagGuardCurrentSegment -Plan $Plan }
    Accept-MagGuardPoContinue -PlanPath $PlanPath -Plan $Plan -Segment $Segment
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
        [string]$HookName = 'beforeSubmitPrompt',
        [string]$PlanPath = ''
    )
    $enforcement = Get-MagGuardEnforcement -Plan $Plan
    $observed = Get-MagGuardObservedModelId -HookInput $HookInput
    if ([string]::IsNullOrWhiteSpace($PlanPath)) { $PlanPath = Get-MagGuardPlanPath }

    if ($null -eq $Plan) {
        $behavior = [string]$enforcement.missing_plan_behavior
        if ($behavior -eq 'STOP') {
            return [pscustomobject]@{
                Continue = $false
                Signal   = 'MISSING_PLAN'
                Action   = 'STOP'
                Message  = 'MAG Model Routing Guard: routing plan missing. Create C:\laragon\repos\.mag\routing-plan.json or set missing_plan_behavior=INERT.'
                PoAck    = $false
            }
        }
        return [pscustomobject]@{
            Continue = $true
            Signal   = 'INERT'
            Action   = 'CONTINUE'
            Message  = ''
            PoAck    = $false
        }
    }

    $seg = Get-MagGuardCurrentSegment -Plan $Plan
    if ($null -eq $seg) {
        return [pscustomobject]@{
            Continue = $false
            Signal   = 'AUTHORITY_CONFLICT'
            Action   = 'STOP'
            Message  = 'MAG Model Routing Guard: current_segment not found in plan. Replan or send + after fixing the plan — + accepts your decision.'
            PoAck    = $false
        }
    }

    $promptContinue = Test-MagGuardPromptContinue -Plan $Plan -HookInput $HookInput
    $poAck = Test-MagGuardPoContinueAck -Plan $Plan
    $mapping = Read-MagGuardMapping
    $proposal = Get-MagGuardProposalText -Segment $seg -Mapping $mapping

    function New-Decision([string]$Signal, [bool]$Stop, [string]$Action, [string]$Message, [bool]$Ack = $false) {
        return [pscustomobject]@{
            Continue = -not $Stop
            Signal   = $Signal
            Action   = $Action
            Message  = $Message
            PoAck    = $Ack
        }
    }

    # Product Owner continue: prompt "+" (or plan continue_token) OR runtime.po_continue_ack.
    # Must be evaluated BEFORE any STOP so "+" itself is never blocked.
    # "+" acknowledges the current gate only — Guard remains active for later gates in this session.
    if ($promptContinue -or $poAck) {
        try { Accept-MagGuardPoContinue -PlanPath $PlanPath -Plan $Plan -Segment $seg -AcceptedGate 'model' } catch { }
        return (New-Decision 'PO_CONTINUE' $false 'PO_CONTINUE' '' $true)
    }

    $declared = Get-MagGuardDeclaredSignal -Plan $Plan -Segment $seg

    if ($declared -in @('AUTHORITY_CONFLICT', 'REPLAN_REQUIRED')) {
        return (New-Decision $declared $true 'STOP' ("MAG Model Routing Guard: {0}. {1}" -f $declared, $proposal))
    }

    if ($declared -eq 'MODEL_ESCALATION_REQUIRED' -and [string]$enforcement.escalation_behavior -eq 'STOP') {
        return (New-Decision $declared $true 'STOP' ("MAG Model Routing Guard: MODEL_ESCALATION_REQUIRED. {0}" -f $proposal))
    }

    if ($declared -eq 'MODEL_BOUNDARY' -and [string]$enforcement.boundary_behavior -eq 'STOP') {
        return (New-Decision $declared $true 'STOP' ("MAG Model Routing Guard: MODEL_BOUNDARY. {0}" -f $proposal))
    }

    if ($declared -eq 'RUNTIME_CHALLENGE') {
        $chal = [string]$enforcement.challenge_behavior
        if ($chal -eq 'STOP' -or $chal -eq 'STOP_IF_EXPENSIVE_OR_WRONG') {
            return (New-Decision $declared $true 'STOP' ("MAG Model Routing Guard: RUNTIME_CHALLENGE. {0}" -f $proposal))
        }
        return (New-Decision $declared $false 'WARN' '')
    }

    if ($declared -eq 'MODEL_DOWNGRADE_RECOMMENDED') {
        return (New-Decision $declared $false 'WARN' '')
    }

    # After PO "+" on a model/observation gate: do not re-nag the same model identity
    # for this segment. Other gates (boundary/escalation/challenge/authority) still STOP.
    if (Test-MagGuardPoModelAccepted -Plan $Plan -Segment $seg) {
        if ($HookName -eq 'preCompact') {
            return (New-Decision 'CONTEXT_WARNING' $false 'WARN' '')
        }
        return (New-Decision 'MODEL_PO_ACCEPTED' $false 'CONTINUE' '')
    }

    $match = Test-MagGuardModelAllowed -ObservedModelId $observed -Segment $seg -Mapping $mapping

    if ($match.Reason -eq 'MODEL_UNOBSERVED') {
        return (New-Decision 'MODEL_OBSERVATION_UNKNOWN' $true 'STOP' ("MAG Model Routing Guard: model not observed. {0} After you decide, send + — Guard continues without re-blocking on observation." -f $proposal))
    }

    if (-not $match.Ok) {
        $sig = if ($match.Reason -eq 'ROUTING_MAPPING_UNKNOWN') { 'ROUTING_MAPPING_UNKNOWN' } else { 'MODEL_MISMATCH' }
        if ([string]$enforcement.mismatch_behavior -eq 'STOP' -or $sig -eq 'ROUTING_MAPPING_UNKNOWN') {
            $msg = if ($sig -eq 'ROUTING_MAPPING_UNKNOWN') {
                "MAG Model Routing Guard: ROUTING_MAPPING_UNKNOWN for class '$($seg.routing_class)'. $proposal After you decide, send + ."
            }
            else {
                "MAG Model Routing Guard: MODEL_MISMATCH (observed=$observed). $proposal After you decide, send + ."
            }
            return (New-Decision $sig $true 'STOP' $msg)
        }
        return (New-Decision $sig $false 'WARN' '')
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


