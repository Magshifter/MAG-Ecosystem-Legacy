#Requires -Version 7.0
# MAG Model Routing Guard — shared logic. Not MAG authority.
# Subordinate to AI_GUIDELINES.md §24.4 via enforcement-contract.v1.json (operational projection only).
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:MagGuardRoot = if ((Split-Path -Leaf $PSScriptRoot) -eq 'lib') {
    Split-Path -Parent $PSScriptRoot
} else {
    $PSScriptRoot
}
$script:DefaultMappingPath = Join-Path $script:MagGuardRoot 'capability-mapping.json'
$script:DefaultContractPath = Join-Path $script:MagGuardRoot 'enforcement-contract.v1.json'
$script:LoadedContract = $null

# Workspace root contract (W4): explicit -ReposRoot wins over MAG_REPOS_ROOT; no silent default.
# Resolve-MagGuardReposRoot validates before any write and pins MAG_REPOS_ROOT for this process only.
function Resolve-MagGuardReposRoot {
    param([string]$ReposRoot = '')
    $candidate = if (-not [string]::IsNullOrWhiteSpace($ReposRoot)) { $ReposRoot }
        elseif (-not [string]::IsNullOrWhiteSpace($env:MAG_REPOS_ROOT)) { $env:MAG_REPOS_ROOT }
        else { $null }
    if ($null -eq $candidate) { throw 'repos_root_not_configured: pass -ReposRoot or set MAG_REPOS_ROOT' }
    $candidate = $candidate.Trim()
    if (-not [System.IO.Path]::IsPathFullyQualified($candidate)) { throw "repos_root_not_absolute:$candidate" }
    $full = [System.IO.Path]::GetFullPath($candidate).TrimEnd('\', '/')
    if (-not [System.IO.Path]::IsPathFullyQualified($full) -or [System.IO.Path]::GetPathRoot($full).TrimEnd('\', '/') -eq $full) {
        throw "repos_root_is_volume_root:$candidate"
    }
    if (-not (Test-Path -LiteralPath $full -PathType Container)) { throw "repos_root_not_found:$full" }
    $env:MAG_REPOS_ROOT = $full
    return $full
}

function Get-MagGuardReposRoot {
    if (-not [string]::IsNullOrWhiteSpace($env:MAG_REPOS_ROOT)) {
        return $env:MAG_REPOS_ROOT.TrimEnd('\', '/')
    }
    throw 'repos_root_not_configured: pass -ReposRoot or set MAG_REPOS_ROOT'
}

function Get-MagGuardPlanPath { return (Join-Path (Get-MagGuardReposRoot) '.mag\routing-plan.json') }
function Get-MagGuardEvidencePath { return (Join-Path (Get-MagGuardReposRoot) '.mag\routing-evidence.jsonl') }
function Get-MagGuardModePath { return (Join-Path (Get-MagGuardReposRoot) '.mag\routing-enforcement-state.json') }
function Get-MagGuardPendingPath { return (Join-Path (Get-MagGuardReposRoot) '.mag\routing-pending.json') }
function Get-MagGuardMaintenancePath { return (Join-Path (Get-MagGuardReposRoot) '.mag\routing-maintenance.json') }
function Get-MagGuardLegacyModePath { return (Join-Path (Get-MagGuardReposRoot) '.mag\routing-guard-mode.json') }

function Ensure-MagGuardMagDir {
    $dir = Join-Path (Get-MagGuardReposRoot) '.mag'
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    return $dir
}

function Write-MagGuardUtf8File {
    param([string]$Path, [string]$Content)
    Ensure-MagGuardMagDir | Out-Null
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($Path, $Content + "`n", $utf8)
}

function Get-MagGuardPlanFingerprint {
    param([string]$Path = (Get-MagGuardPlanPath))
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}

function Read-MagGuardContract {
    param([string]$Path = $script:DefaultContractPath)
    if ($null -ne $script:LoadedContract -and $script:LoadedContract._path -eq $Path) {
        return $script:LoadedContract
    }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw 'enforcement_contract_missing'
    }
    try {
        $obj = Get-Content -LiteralPath $Path -Raw -Encoding utf8 | ConvertFrom-Json
    }
    catch {
        throw 'enforcement_contract_invalid_json'
    }
    if ($null -eq $obj -or [string]::IsNullOrWhiteSpace([string]$obj.contract_version)) {
        throw 'enforcement_contract_version_unsupported'
    }
    if ([string]$obj.canonical_owner -ne 'AI_GUIDELINES.md' -or [string]$obj.canonical_section -ne '24.4') {
        throw 'enforcement_contract_canonical_mismatch'
    }
    # Promoted contracts must not require an ACTIVE overlay. Historical provenance only.
    if ($obj.PSObject.Properties['active_overlay'] -and -not [string]::IsNullOrWhiteSpace([string]$obj.active_overlay)) {
        throw 'enforcement_contract_active_overlay_not_allowed'
    }
    if (-not $obj.PSObject.Properties['precedence'] -or -not $obj.PSObject.Properties['signals']) {
        throw 'enforcement_contract_incomplete'
    }
    $obj | Add-Member -NotePropertyName _path -NotePropertyValue $Path -Force
    $script:LoadedContract = $obj
    return $obj
}

function ConvertTo-MagGuardEnforcementState {
    param([string]$Raw)
    $v = ([string]$Raw).Trim().ToUpperInvariant()
    switch ($v) {
        { $_ -in @('ENFORCED', 'PRO') } { return 'ENFORCED' }
        { $_ -in @('ADVISORY', 'AUTO') } { return 'ADVISORY' }
        { $_ -in @('SUSPENDED', 'OFF') } { return 'SUSPENDED' }
        default { return $null }
    }
}

function Read-MagGuardMaintenance {
    $path = Get-MagGuardMaintenancePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        return [pscustomobject]@{ Active = $false; PreviousState = $null; Raw = $null }
    }
    try {
        $obj = Get-Content -LiteralPath $path -Raw -Encoding utf8 | ConvertFrom-Json
    }
    catch {
        return [pscustomobject]@{ Active = $false; PreviousState = $null; Raw = $null }
    }
    $active = $false
    if ($obj.PSObject.Properties['maintenance_active']) { $active = [bool]$obj.maintenance_active }
    $prev = $null
    if ($obj.PSObject.Properties['previous_enforcement_state']) {
        $prev = ConvertTo-MagGuardEnforcementState ([string]$obj.previous_enforcement_state)
    }
    return [pscustomobject]@{ Active = $active; PreviousState = $prev; Raw = $obj }
}

function Read-MagGuardEnforcementState {
    param(
        $Plan,
        [string]$Path = (Get-MagGuardModePath)
    )
    $maint = Read-MagGuardMaintenance
    if ($maint.Active) {
        return [pscustomobject]@{
            State            = 'SUSPENDED'
            Source           = 'maintenance'
            MaintenanceActive = $true
            PreviousState    = $maint.PreviousState
            HardBlock        = $false
        }
    }

    $filePath = $Path
    if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
        $legacy = Get-MagGuardLegacyModePath
        if (Test-Path -LiteralPath $legacy -PathType Leaf) { $filePath = $legacy }
    }

    if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
        if ($null -ne $Plan) {
            return [pscustomobject]@{
                State = 'ENFORCED'; Source = 'default_with_plan'; MaintenanceActive = $false
                PreviousState = $null; HardBlock = $true
            }
        }
        return [pscustomobject]@{
            State = 'SUSPENDED'; Source = 'default_no_plan'; MaintenanceActive = $false
            PreviousState = $null; HardBlock = $false
        }
    }

    try {
        $obj = Get-Content -LiteralPath $filePath -Raw -Encoding utf8 | ConvertFrom-Json
    }
    catch {
        if ($null -ne $Plan) {
            return [pscustomobject]@{
                State = 'ENFORCED'; Source = 'corrupt_default_enforced'; MaintenanceActive = $false
                PreviousState = $null; HardBlock = $true
            }
        }
        throw 'enforcement_state_unreadable'
    }

    $raw = $null
    if ($obj.PSObject.Properties['state']) { $raw = [string]$obj.state }
    elseif ($obj.PSObject.Properties['mode']) { $raw = [string]$obj.mode }
    $state = ConvertTo-MagGuardEnforcementState $raw
    if (-not $state) {
        if ($null -ne $Plan) {
            return [pscustomobject]@{
                State = 'ENFORCED'; Source = 'invalid_default_enforced'; MaintenanceActive = $false
                PreviousState = $null; HardBlock = $true
            }
        }
        throw 'enforcement_state_unknown'
    }

    return [pscustomobject]@{
        State = $state
        Source = 'file'
        MaintenanceActive = $false
        PreviousState = $null
        HardBlock = ($state -eq 'ENFORCED')
        Raw = $obj
    }
}

function Save-MagGuardEnforcementState {
    param(
        [ValidateSet('ENFORCED', 'ADVISORY', 'SUSPENDED')][string]$State,
        [string]$Note = '',
        [string]$Path = (Get-MagGuardModePath)
    )
    $obj = [ordered]@{
        version = 1
        state   = $State
        set_at  = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        note    = $Note
    }
    Write-MagGuardUtf8File -Path $Path -Content ($obj | ConvertTo-Json -Depth 5)
    return (Read-MagGuardEnforcementState -Plan (Read-MagGuardPlan) -Path $Path)
}

function Get-MagGuardModeCommand {
    param($HookInput)
    if ($null -eq $HookInput -or -not $HookInput.PSObject.Properties['prompt']) { return $null }
    $prompt = ([string]$HookInput.prompt).Trim()
    if ([string]::IsNullOrWhiteSpace($prompt)) { return $null }
    $map = @{
        'guard enforced'         = 'ENFORCED'
        'guard advisory'         = 'ADVISORY'
        'guard suspended'        = 'SUSPENDED'
        'guard pro'              = 'ENFORCED'
        'guard auto'             = 'ADVISORY'
        'guard off'              = 'SUSPENDED'
        'активуємо план pro'     = 'ENFORCED'
        'активувати план pro'    = 'ENFORCED'
        'активуємо pro'          = 'ENFORCED'
        'увімкни guard'          = 'ENFORCED'
        'увімкни guard pro'      = 'ENFORCED'
        'вимкни guard'           = 'SUSPENDED'
    }
    $key = $prompt.ToLowerInvariant()
    if ($map.ContainsKey($key)) { return $map[$key] }
    return $null
}

function Read-MagGuardStdinJson {
    $script:MagGuardInputState = 'empty'
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { return $null }
    try {
        $parsed = $raw | ConvertFrom-Json
        $script:MagGuardInputState = if ($null -eq $parsed) { 'json_null' } elseif ($parsed -is [pscustomobject]) { 'object' } else { 'non_object' }
        return $parsed
    }
    catch { return $null }
}

function Read-MagGuardPlan {
    param([string]$Path = (Get-MagGuardPlanPath))
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    try {
        $obj = Get-Content -LiteralPath $Path -Raw -Encoding utf8 | ConvertFrom-Json
        if ($null -eq $obj) { return $null }
        if (-not $obj.PSObject.Properties['routing_plan_version'] -or $obj.routing_plan_version -ne 1) { return $null }
        if ($obj.PSObject.Properties['accepted'] -and $obj.accepted -ne $true) { return $null }
        foreach ($key in @('procedure_id', 'identity', 'current_segment', 'segments')) {
            if (-not $obj.PSObject.Properties[$key] -or -not $obj.$key) { return $null }
        }
        foreach ($segment in @($obj.segments)) {
            foreach ($key in @('segment_id', 'routing_class', 'boundary_condition')) {
                if (-not $segment.PSObject.Properties[$key]) { return $null }
            }
        }
        return $obj
    }
    catch { return $null }
}

function Read-MagGuardMapping {
    param([string]$Path = $script:DefaultMappingPath)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    try { return (Get-Content -LiteralPath $Path -Raw -Encoding utf8 | ConvertFrom-Json) }
    catch { return $null }
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

function Test-MagGuardModelIdCompatibleWithClass {
    param([string]$ModelId, [string]$RoutingClass, $Mapping)
    if ([string]::IsNullOrWhiteSpace($ModelId) -or [string]::IsNullOrWhiteSpace($RoutingClass)) { return $false }
    if ($null -eq $Mapping -or -not $Mapping.PSObject.Properties['classes']) { return $false }
    $entry = $Mapping.classes.PSObject.Properties[$RoutingClass]
    if ($null -eq $entry -or -not $entry.Value.PSObject.Properties['model_id_prefixes']) { return $false }
    $obs = $ModelId.Trim().ToLowerInvariant()
    foreach ($p0 in @($entry.Value.model_id_prefixes)) {
        if ([string]::IsNullOrWhiteSpace([string]$p0)) { continue }
        $p = ([string]$p0).ToLowerInvariant()
        if ($obs -eq $p -or $obs.StartsWith($p) -or $obs.Contains($p)) { return $true }
    }
    return $false
}

function Test-MagGuardModelAllowed {
    param([string]$ObservedModelId, $Segment, $Mapping)
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
    if ([string]::IsNullOrWhiteSpace($class) -or $null -eq $Mapping -or -not $Mapping.PSObject.Properties['classes']) {
        return [pscustomobject]@{ Ok = $false; Reason = 'ROUTING_MAPPING_UNKNOWN' }
    }
    if (-not (Test-MagGuardModelIdCompatibleWithClass -ModelId $obs -RoutingClass $class -Mapping $Mapping)) {
        $entry = $Mapping.classes.PSObject.Properties[$class]
        if ($null -eq $entry) {
            return [pscustomobject]@{ Ok = $false; Reason = 'ROUTING_MAPPING_UNKNOWN' }
        }
        $prefixes = @()
        if ($entry.Value.PSObject.Properties['model_id_prefixes']) {
            $prefixes = @($entry.Value.model_id_prefixes | ForEach-Object { [string]$_ })
        }
        if ($prefixes.Count -lt 1) {
            return [pscustomobject]@{ Ok = $false; Reason = 'ROUTING_MAPPING_UNKNOWN' }
        }
        return [pscustomobject]@{ Ok = $false; Reason = 'MODEL_MISMATCH' }
    }
    return [pscustomobject]@{ Ok = $true; Reason = 'MAPPING' }
}

function Get-MagGuardExplicitRecommendedClass {
    param($Plan, $Segment, $Pending = $null)
    foreach ($src in @($Pending, $Segment, $Plan, $(if ($Plan -and $Plan.PSObject.Properties['runtime']) { $Plan.runtime } else { $null }))) {
        if ($null -eq $src) { continue }
        if ($src.PSObject.Properties['recommended_routing_class'] -and -not [string]::IsNullOrWhiteSpace([string]$src.recommended_routing_class)) {
            return ([string]$src.recommended_routing_class).Trim().ToUpperInvariant()
        }
    }
    return $null
}

function Get-MagGuardExplicitModelOverride {
    param($Plan, $Segment, $Pending = $null)
    foreach ($src in @($Pending, $Segment, $Plan, $(if ($Plan -and $Plan.PSObject.Properties['runtime']) { $Plan.runtime } else { $null }))) {
        if ($null -eq $src) { continue }
        if ($src.PSObject.Properties['recommended_model_id_override'] -and -not [string]::IsNullOrWhiteSpace([string]$src.recommended_model_id_override)) {
            return ([string]$src.recommended_model_id_override).Trim()
        }
    }
    return $null
}

function Get-MagGuardRecommendationReason {
    param($Plan, $Segment, $Pending = $null)
    foreach ($src in @($Pending, $Segment, $Plan, $(if ($Plan -and $Plan.PSObject.Properties['runtime']) { $Plan.runtime } else { $null }))) {
        if ($null -eq $src) { continue }
        if ($src.PSObject.Properties['recommendation_reason'] -and -not [string]::IsNullOrWhiteSpace([string]$src.recommendation_reason)) {
            return ([string]$src.recommendation_reason).Trim()
        }
    }
    return $null
}

function Get-MagGuardNextSegmentRoutingClass {
    param($Plan, $Segment)
    if ($null -eq $Plan -or $null -eq $Segment) { return $null }
    $nextId = $null
    foreach ($key in @('next_segment_id', 'boundary_next_segment', 'next_segment')) {
        if ($Segment.PSObject.Properties[$key] -and -not [string]::IsNullOrWhiteSpace([string]$Segment.$key)) {
            $nextId = [string]$Segment.$key
            break
        }
    }
    if ([string]::IsNullOrWhiteSpace($nextId)) { return $null }
    foreach ($s in @($Plan.segments)) {
        if ([string]$s.segment_id -eq $nextId -and $s.PSObject.Properties['routing_class'] -and -not [string]::IsNullOrWhiteSpace([string]$s.routing_class)) {
            return ([string]$s.routing_class).Trim().ToUpperInvariant()
        }
    }
    return $null
}

function Test-MagGuardMappingClassValid {
    param([string]$RoutingClass, $Mapping)
    if ([string]::IsNullOrWhiteSpace($RoutingClass) -or $null -eq $Mapping -or -not $Mapping.PSObject.Properties['classes']) { return $false }
    $entry = $Mapping.classes.PSObject.Properties[$RoutingClass]
    if ($null -eq $entry) { return $false }
    if (-not $entry.Value.PSObject.Properties['preferred_model_id'] -or [string]::IsNullOrWhiteSpace([string]$entry.Value.preferred_model_id)) { return $false }
    if (-not $entry.Value.PSObject.Properties['model_id_prefixes'] -or @($entry.Value.model_id_prefixes).Count -lt 1) { return $false }
    return (Test-MagGuardModelIdCompatibleWithClass -ModelId ([string]$entry.Value.preferred_model_id) -RoutingClass $RoutingClass -Mapping $Mapping)
}

function Resolve-MagGuardTargetClass {
    param($Plan, $Segment, [string]$Signal, $Mapping, $Pending = $null)
    $current = if ($null -ne $Segment -and $Segment.PSObject.Properties['routing_class']) {
        ([string]$Segment.routing_class).Trim().ToUpperInvariant()
    } else { '' }
    $explicit = Get-MagGuardExplicitRecommendedClass -Plan $Plan -Segment $Segment -Pending $Pending
    switch ($Signal) {
        'MODEL_MISMATCH' {
            return [pscustomobject]@{ Class = $current; Required = $true; Ok = -not [string]::IsNullOrWhiteSpace($current) }
        }
        'MODEL_OBSERVATION_UNKNOWN' {
            return [pscustomobject]@{ Class = $current; Required = $true; Ok = -not [string]::IsNullOrWhiteSpace($current) }
        }
        'MODEL_ESCALATION_REQUIRED' {
            $ok = (-not [string]::IsNullOrWhiteSpace($explicit)) -and (Test-MagGuardMappingClassValid -RoutingClass $explicit -Mapping $Mapping)
            return [pscustomobject]@{ Class = $explicit; Required = $true; Ok = $ok }
        }
        'MODEL_BOUNDARY' {
            $next = Get-MagGuardNextSegmentRoutingClass -Plan $Plan -Segment $Segment
            $pick = if ($next) { $next } else { $explicit }
            $ok = (-not [string]::IsNullOrWhiteSpace($pick)) -and (Test-MagGuardMappingClassValid -RoutingClass $pick -Mapping $Mapping)
            return [pscustomobject]@{ Class = $pick; Required = $true; Ok = $ok }
        }
        'MODEL_DOWNGRADE_RECOMMENDED' {
            if ([string]::IsNullOrWhiteSpace($explicit)) {
                return [pscustomobject]@{ Class = $null; Required = $false; Ok = $true }
            }
            $ok = Test-MagGuardMappingClassValid -RoutingClass $explicit -Mapping $Mapping
            return [pscustomobject]@{ Class = $explicit; Required = $false; Ok = $ok }
        }
        default {
            return [pscustomobject]@{ Class = $null; Required = $false; Ok = $true }
        }
    }
}

function Resolve-MagGuardConcreteRecommendation {
    param(
        [string]$TargetClass,
        [string]$OverrideModelId,
        $Mapping,
        [bool]$Required = $true
    )
    if ([string]::IsNullOrWhiteSpace($TargetClass)) {
        return [pscustomobject]@{
            Ok = -not $Required
            Unknown = $Required
            ModelId = $null
            DisplayName = $null
            Effort = $null
            SpeedTier = $null
            UsedOverride = $false
            Reason = 'no_target_class'
        }
    }
    if ($null -eq $Mapping -or -not (Test-MagGuardMappingClassValid -RoutingClass $TargetClass -Mapping $Mapping)) {
        return [pscustomobject]@{
            Ok = $false
            Unknown = $true
            ModelId = $null
            DisplayName = $null
            Effort = $null
            SpeedTier = $null
            UsedOverride = $false
            Reason = 'mapping_invalid'
        }
    }
    $entry = $Mapping.classes.$TargetClass
    if (-not [string]::IsNullOrWhiteSpace($OverrideModelId)) {
        if (-not (Test-MagGuardModelIdCompatibleWithClass -ModelId $OverrideModelId -RoutingClass $TargetClass -Mapping $Mapping)) {
            return [pscustomobject]@{
                Ok = $false
                Unknown = $true
                ModelId = $null
                DisplayName = $null
                Effort = $null
                SpeedTier = $null
                UsedOverride = $true
                Reason = 'override_incompatible'
            }
        }
        $display = [string]$OverrideModelId
        if ($entry.PSObject.Properties['display_name'] -and ([string]$entry.preferred_model_id).ToLowerInvariant() -eq $OverrideModelId.ToLowerInvariant()) {
            $display = [string]$entry.display_name
        }
        return [pscustomobject]@{
            Ok = $true
            Unknown = $false
            ModelId = $OverrideModelId
            DisplayName = $display
            Effort = $(if ($entry.PSObject.Properties['preferred_effort']) { $entry.preferred_effort } else { $null })
            SpeedTier = $(if ($entry.PSObject.Properties['preferred_speed_tier']) { [string]$entry.preferred_speed_tier } else { $null })
            UsedOverride = $true
            Reason = 'override'
        }
    }
    $effort = $null
    if ($entry.PSObject.Properties['preferred_effort'] -and $null -ne $entry.preferred_effort -and [string]$entry.preferred_effort -ne '') {
        $effort = [string]$entry.preferred_effort
    }
    return [pscustomobject]@{
        Ok = $true
        Unknown = $false
        ModelId = [string]$entry.preferred_model_id
        DisplayName = $(if ($entry.PSObject.Properties['display_name']) { [string]$entry.display_name } else { [string]$entry.preferred_model_id })
        Effort = $effort
        SpeedTier = $(if ($entry.PSObject.Properties['preferred_speed_tier']) { [string]$entry.preferred_speed_tier } else { 'standard' })
        UsedOverride = $false
        Reason = 'preferred'
    }
}

function Resolve-MagGuardRecommendation {
    param($Plan, $Segment, [string]$Signal, $Mapping, $Pending = $null)
    $target = Resolve-MagGuardTargetClass -Plan $Plan -Segment $Segment -Signal $Signal -Mapping $Mapping -Pending $Pending
    $override = Get-MagGuardExplicitModelOverride -Plan $Plan -Segment $Segment -Pending $Pending
    $reason = Get-MagGuardRecommendationReason -Plan $Plan -Segment $Segment -Pending $Pending
    if ($Signal -eq 'MODEL_DOWNGRADE_RECOMMENDED' -and [string]::IsNullOrWhiteSpace([string]$target.Class)) {
        return [pscustomobject]@{
            TargetOk = $true
            MappingUnknown = $false
            TargetClass = $null
            Recommendation = $null
            RecommendationReason = $reason
            CurrentClass = $(if ($Segment) { [string]$Segment.routing_class } else { '' })
        }
    }
    if ($target.Required -and -not $target.Ok) {
        return [pscustomobject]@{
            TargetOk = $false
            MappingUnknown = $true
            TargetClass = $target.Class
            Recommendation = $null
            RecommendationReason = $reason
            CurrentClass = $(if ($Segment) { [string]$Segment.routing_class } else { '' })
        }
    }
    if (-not $target.Required -and -not $target.Ok) {
        return [pscustomobject]@{
            TargetOk = $false
            MappingUnknown = $true
            TargetClass = $target.Class
            Recommendation = $null
            RecommendationReason = $reason
            CurrentClass = $(if ($Segment) { [string]$Segment.routing_class } else { '' })
        }
    }
    if ([string]::IsNullOrWhiteSpace([string]$target.Class)) {
        return [pscustomobject]@{
            TargetOk = $true
            MappingUnknown = $false
            TargetClass = $null
            Recommendation = $null
            RecommendationReason = $reason
            CurrentClass = $(if ($Segment) { [string]$Segment.routing_class } else { '' })
        }
    }
    $rec = Resolve-MagGuardConcreteRecommendation -TargetClass ([string]$target.Class) -OverrideModelId $override -Mapping $Mapping -Required:$true
    return [pscustomobject]@{
        TargetOk = $rec.Ok
        MappingUnknown = $rec.Unknown
        TargetClass = [string]$target.Class
        Recommendation = $rec
        RecommendationReason = $reason
        CurrentClass = $(if ($Segment) { [string]$Segment.routing_class } else { '' })
    }
}

function Get-MagGuardDeclaredSignal {
    param($Plan, $Segment)
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
    if ($null -ne $Segment) {
        $bc = [string]$Segment.boundary_condition
        if ($bc -eq 'declared-complete' -or $bc -eq 'po-declared') {
            return 'MODEL_BOUNDARY'
        }
    }
    return $null
}

function Test-MagGuardPromptContinue {
    param($Plan, $HookInput, $Contract)
    if ($null -eq $HookInput -or -not $HookInput.PSObject.Properties['prompt']) { return $false }
    $prompt = ([string]$HookInput.prompt).Trim()
    if ([string]::IsNullOrWhiteSpace($prompt)) { return $false }
    $token = '+'
    if ($null -ne $Plan -and $Plan.PSObject.Properties['continue_token'] -and -not [string]::IsNullOrWhiteSpace([string]$Plan.continue_token)) {
        $token = ([string]$Plan.continue_token).Trim()
    }
    elseif ($null -ne $Contract -and $Contract.PSObject.Properties['continuation_token']) {
        $token = [string]$Contract.continuation_token
    }
    return ($prompt -eq $token)
}

function Read-MagGuardPending {
    $path = Get-MagGuardPendingPath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
    try {
        $obj = Get-Content -LiteralPath $path -Raw -Encoding utf8 | ConvertFrom-Json
        if ($null -eq $obj -or -not $obj.PSObject.Properties['signal']) { return $null }
        return $obj
    }
    catch { return $null }
}

function Clear-MagGuardPending {
    $path = Get-MagGuardPendingPath
    if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Force }
}

function Save-MagGuardPending {
    param(
        $Plan,
        $Segment,
        [string]$Signal,
        [string[]]$RequiredResolution,
        [string]$ObservedModelId = ''
    )
    $fp = Get-MagGuardPlanFingerprint
    $recClass = Get-MagGuardExplicitRecommendedClass -Plan $Plan -Segment $Segment
    $override = Get-MagGuardExplicitModelOverride -Plan $Plan -Segment $Segment
    $reason = Get-MagGuardRecommendationReason -Plan $Plan -Segment $Segment
    $obj = [ordered]@{
        version              = 1
        procedure_id         = $(if ($Plan) { [string]$Plan.procedure_id } else { '' })
        segment_id           = $(if ($Segment) { [string]$Segment.segment_id } else { '' })
        signal               = $Signal
        required_resolution  = @($RequiredResolution)
        observed_at_stop     = $ObservedModelId
        plan_fingerprint     = $fp
        timestamp            = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    }
    if ($recClass) { $obj['recommended_routing_class'] = $recClass }
    if ($override) { $obj['recommended_model_id_override'] = $override }
    if ($reason) { $obj['recommendation_reason'] = $reason }
    Write-MagGuardUtf8File -Path (Get-MagGuardPendingPath) -Content ($obj | ConvertTo-Json -Depth 6)
}

function Get-MagGuardProposalText {
    param(
        $Plan,
        $Segment,
        $Mapping,
        [string]$Signal,
        [string[]]$RequiredResolution,
        [string]$ObservedModelId = '',
        $Pending = $null
    )
    $bundle = Resolve-MagGuardRecommendation -Plan $Plan -Segment $Segment -Signal $Signal -Mapping $Mapping -Pending $Pending
    $current = if ($bundle.CurrentClass) { $bundle.CurrentClass } else { '(unknown)' }
    $obs = if ([string]::IsNullOrWhiteSpace($ObservedModelId)) { 'UNKNOWN' } else { $ObservedModelId }
    $reason = if ($bundle.RecommendationReason) { $bundle.RecommendationReason } else { 'n/a' }
    $res = if ($RequiredResolution -and $RequiredResolution.Count -gt 0) { ($RequiredResolution -join ' | ') } else { 'n/a' }

    if ($bundle.MappingUnknown -or ($Signal -eq 'ROUTING_MAPPING_UNKNOWN')) {
        return ("Signal={0}; current class={1}; recommended class/model unresolved (ROUTING_MAPPING_UNKNOWN); observed={2}; reason={3}; required resolution={4}. Fix mapping/target class (or compatible override), then send +. + alone does not override." -f $Signal, $current, $obs, $reason, $res)
    }

    if ($Signal -eq 'MODEL_DOWNGRADE_RECOMMENDED' -and ($null -eq $bundle.Recommendation -or -not $bundle.TargetClass)) {
        return ("Signal={0}; current class={1}; recommended class=(none supplied); no concrete model recommendation; observed={2}; reason={3}. Product Owner may switch; downgrade alone does not hard-block. Guard does not infer a lower class." -f $Signal, $current, $obs, $reason)
    }

    if ($null -eq $bundle.Recommendation -or -not $bundle.Recommendation.Ok) {
        return ("Signal={0}; current class={1}; concrete recommendation unavailable; observed={2}; reason={3}; required resolution={4}." -f $Signal, $current, $obs, $reason, $res)
    }

    $rec = $bundle.Recommendation
    $effort = if ($null -eq $rec.Effort -or [string]$rec.Effort -eq '') { 'model-default' } else { [string]$rec.Effort }
    $speed = if ($rec.SpeedTier) { [string]$rec.SpeedTier } else { 'standard' }
    $target = [string]$bundle.TargetClass
    $modelLine = '{0} (`{1}`)' -f $rec.DisplayName, $rec.ModelId

    switch ($Signal) {
        'MODEL_MISMATCH' {
            return ("Signal={0}; required class={1}; recommended model={2}; effort={3}; speed={4}; observed={5}; required action=switch to a compatible {1} model or replan, then send +. + alone does not override." -f $Signal, $target, $modelLine, $effort, $speed, $obs)
        }
        'MODEL_ESCALATION_REQUIRED' {
            return ("Signal={0}; current class={1}; recommended class={2}; recommended model={3}; effort={4}; speed={5}; observed={6}; reason={7}; required action=switch to the recommended or another compatible {2} model, then send +. + alone does not override." -f $Signal, $current, $target, $modelLine, $effort, $speed, $obs, $reason)
        }
        'MODEL_BOUNDARY' {
            return ("Signal={0}; current class={1}; recommended class={2}; recommended model={3}; effort={4}; speed={5}; observed={6}; reason={7}; required action=switch to the recommended or another compatible {2} model, then send +. + alone does not override." -f $Signal, $current, $target, $modelLine, $effort, $speed, $obs, $reason)
        }
        'MODEL_DOWNGRADE_RECOMMENDED' {
            return ("Signal={0}; current class={1}; recommended class={2}; recommended model={3}; effort={4}; speed={5}; observed={6}; reason={7}; required action=Product Owner may switch; continuation is not blocked solely by downgrade." -f $Signal, $current, $target, $modelLine, $effort, $speed, $obs, $reason)
        }
        default {
            return ("Signal={0}; current class={1}; recommended class={2}; recommended model={3}; effort={4}; speed={5}; observed={6}; reason={7}; required resolution={8}. Satisfy the resolution, then send +. + alone does not override." -f $Signal, $current, $(if ($target) { $target } else { 'n/a' }), $modelLine, $effort, $speed, $obs, $reason, $res)
        }
    }
}

function Write-MagGuardEvidence {
    param(
        $Plan,
        [string]$ObservedModelId,
        [string]$Signal,
        [string]$Action,
        [string]$Note = '',
        [string]$ContractVersion = ''
    )
    if ($null -ne $Plan -and $Plan.PSObject.Properties['evidence'] -and $Plan.evidence.PSObject.Properties['enabled'] -and -not [bool]$Plan.evidence.enabled) {
        return
    }
    $path = Get-MagGuardEvidencePath
    Ensure-MagGuardMagDir | Out-Null
    $seg = Get-MagGuardCurrentSegment -Plan $Plan
    $evt = [ordered]@{
        ts                = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ssK')
        procedure_id      = $(if ($Plan) { [string]$Plan.procedure_id } else { '' })
        identity          = $(if ($Plan) { [string]$Plan.identity } else { '' })
        segment_id        = $(if ($seg) { [string]$seg.segment_id } else { '' })
        routing_class     = $(if ($seg) { [string]$seg.routing_class } else { '' })
        observed_model_id = $ObservedModelId
        signal            = $Signal
        action            = $Action
        note              = $Note
        contract_version  = $ContractVersion
    }
    Add-Content -LiteralPath $path -Value (($evt | ConvertTo-Json -Compress)) -Encoding utf8
}

function New-MagGuardDecision {
    param(
        [string]$Signal,
        [bool]$Stop,
        [string]$Action,
        [string]$Message = '',
        [bool]$ContinuationRequest = $false
    )
    return [pscustomobject]@{
        Continue             = -not $Stop
        Signal               = $Signal
        Action               = $Action
        Message              = $Message
        ContinuationRequest  = $ContinuationRequest
        PoAck                = $false
    }
}

function Get-MagGuardSignalMeta {
    param($Contract, [string]$Signal)
    if ($null -eq $Contract -or -not $Contract.signals.PSObject.Properties[$Signal]) { return $null }
    return $Contract.signals.$Signal
}

function Evaluate-MagGuardPredicates {
    param($Plan, $HookInput, $Contract, [string]$HookName = 'beforeSubmitPrompt')
    $seg = Get-MagGuardCurrentSegment -Plan $Plan
    if ($null -eq $seg) {
        return [pscustomobject]@{ Signal = 'AUTHORITY_CONFLICT'; Block = $true; Reason = 'segment_missing' }
    }
    $declared = Get-MagGuardDeclaredSignal -Plan $Plan -Segment $seg
    $mapping = Read-MagGuardMapping
    $observed = Get-MagGuardObservedModelId -HookInput $HookInput
    $match = Test-MagGuardModelAllowed -ObservedModelId $observed -Segment $seg -Mapping $mapping

    $candidates = [System.Collections.Generic.List[object]]::new()
    if ($declared -eq 'AUTHORITY_CONFLICT') { $candidates.Add([pscustomobject]@{ Signal = 'AUTHORITY_CONFLICT'; Block = $true }) | Out-Null }
    if ($declared -eq 'REPLAN_REQUIRED') { $candidates.Add([pscustomobject]@{ Signal = 'REPLAN_REQUIRED'; Block = $true }) | Out-Null }

    $mappingUnknown = ($match.Reason -eq 'ROUTING_MAPPING_UNKNOWN')
    if ($declared -eq 'MODEL_ESCALATION_REQUIRED') {
        $bundle = Resolve-MagGuardRecommendation -Plan $Plan -Segment $seg -Signal 'MODEL_ESCALATION_REQUIRED' -Mapping $mapping
        if ($bundle.MappingUnknown) { $mappingUnknown = $true }
        else { $candidates.Add([pscustomobject]@{ Signal = 'MODEL_ESCALATION_REQUIRED'; Block = $true }) | Out-Null }
    }
    if ($declared -eq 'MODEL_BOUNDARY') {
        $bundle = Resolve-MagGuardRecommendation -Plan $Plan -Segment $seg -Signal 'MODEL_BOUNDARY' -Mapping $mapping
        if ($bundle.MappingUnknown) { $mappingUnknown = $true }
        else { $candidates.Add([pscustomobject]@{ Signal = 'MODEL_BOUNDARY'; Block = $true }) | Out-Null }
    }
    if ($declared -eq 'MODEL_DOWNGRADE_RECOMMENDED') {
        $bundle = Resolve-MagGuardRecommendation -Plan $Plan -Segment $seg -Signal 'MODEL_DOWNGRADE_RECOMMENDED' -Mapping $mapping
        if ($bundle.MappingUnknown) { $mappingUnknown = $true }
        else { $candidates.Add([pscustomobject]@{ Signal = 'MODEL_DOWNGRADE_RECOMMENDED'; Block = $false }) | Out-Null }
    }

    if ($mappingUnknown) { $candidates.Add([pscustomobject]@{ Signal = 'ROUTING_MAPPING_UNKNOWN'; Block = $true }) | Out-Null }
    if ($match.Reason -eq 'MODEL_MISMATCH') { $candidates.Add([pscustomobject]@{ Signal = 'MODEL_MISMATCH'; Block = $true }) | Out-Null }
    if ($match.Reason -eq 'MODEL_UNOBSERVED') { $candidates.Add([pscustomobject]@{ Signal = 'MODEL_OBSERVATION_UNKNOWN'; Block = $true }) | Out-Null }
    if ($declared -eq 'RUNTIME_CHALLENGE') {
        $meta = Get-MagGuardSignalMeta -Contract $Contract -Signal 'RUNTIME_CHALLENGE'
        $action = if ($meta) { [string]$meta.default_action } else { 'STOP_IF_BLOCKING_ELSE_WARN' }
        $block = ($action -ne 'WARN')
        $candidates.Add([pscustomobject]@{ Signal = 'RUNTIME_CHALLENGE'; Block = $block }) | Out-Null
    }
    if ($HookName -eq 'preCompact') {
        $candidates.Add([pscustomobject]@{ Signal = 'CONTEXT_WARNING'; Block = $false }) | Out-Null
    }

    foreach ($sig in @($Contract.precedence)) {
        foreach ($c in $candidates) {
            if ($c.Signal -eq $sig) { return $c }
        }
    }
    if ($match.Ok) {
        return [pscustomobject]@{ Signal = 'MODEL_MATCH'; Block = $false }
    }
    return [pscustomobject]@{ Signal = 'MODEL_MISMATCH'; Block = $true }
}

function Test-MagGuardPendingResolved {
    param($Pending, $Plan, $HookInput, $Contract)
    if ($null -eq $Pending) { return $true }
    $signal = [string]$Pending.signal
    $fpNow = Get-MagGuardPlanFingerprint
    $fpOld = if ($Pending.PSObject.Properties['plan_fingerprint']) { [string]$Pending.plan_fingerprint } else { '' }
    $planChanged = ($fpOld -and $fpNow -and ($fpOld -ne $fpNow))
    $eval = Evaluate-MagGuardPredicates -Plan $Plan -HookInput $HookInput -Contract $Contract
    $observed = Get-MagGuardObservedModelId -HookInput $HookInput
    $seg = Get-MagGuardCurrentSegment -Plan $Plan
    $mapping = Read-MagGuardMapping
    $match = Test-MagGuardModelAllowed -ObservedModelId $observed -Segment $seg -Mapping $mapping

    switch ($signal) {
        'AUTHORITY_CONFLICT' {
            return ($eval.Signal -ne 'AUTHORITY_CONFLICT')
        }
        'REPLAN_REQUIRED' {
            return ($planChanged -and $null -ne $Plan -and $eval.Signal -ne 'REPLAN_REQUIRED')
        }
        'ROUTING_MAPPING_UNKNOWN' {
            return ($match.Reason -ne 'ROUTING_MAPPING_UNKNOWN' -and $eval.Signal -ne 'ROUTING_MAPPING_UNKNOWN')
        }
        'MODEL_MISMATCH' {
            if ($planChanged -and $null -ne $Plan) { return ($eval.Signal -ne 'MODEL_MISMATCH') }
            return ($match.Ok -eq $true)
        }
        'MODEL_OBSERVATION_UNKNOWN' {
            if ([string]::IsNullOrWhiteSpace($observed)) { return $false }
            return ($match.Ok -eq $true -or $eval.Signal -eq 'MODEL_MATCH')
        }
        'MODEL_ESCALATION_REQUIRED' {
            if ($planChanged -and $null -ne $Plan) { return ($eval.Signal -ne 'MODEL_ESCALATION_REQUIRED') }
            return ($eval.Signal -ne 'MODEL_ESCALATION_REQUIRED' -and $match.Ok)
        }
        'MODEL_BOUNDARY' {
            return ($eval.Signal -ne 'MODEL_BOUNDARY' -and $match.Ok)
        }
        'RUNTIME_CHALLENGE' {
            if ($planChanged -and $null -ne $Plan) { return $true }
            return ($eval.Signal -ne 'RUNTIME_CHALLENGE' -or -not $eval.Block)
        }
        default {
            return ($eval.Signal -ne $signal -or -not $eval.Block)
        }
    }
}

function Resolve-MagGuardDecision {
    param(
        $Plan,
        $HookInput,
        [string]$HookName = 'beforeSubmitPrompt',
        [string]$PlanPath = ''
    )
    if ([string]::IsNullOrWhiteSpace($PlanPath)) { $PlanPath = Get-MagGuardPlanPath }

    try {
        $contract = Read-MagGuardContract
    }
    catch {
        return (New-MagGuardDecision 'CONTRACT_ERROR' $true 'STOP' ("MAG Model Routing Guard: enforcement contract unavailable/invalid ($($_.Exception.Message)). Fix tools/model-routing-guard/enforcement-contract.v1.json."))
    }
    $cv = [string]$contract.contract_version

    $modeCmd = Get-MagGuardModeCommand -HookInput $HookInput
    if ($modeCmd) {
        Save-MagGuardEnforcementState -State $modeCmd -Note 'prompt_command' | Out-Null
        return (New-MagGuardDecision ("MODE_$modeCmd") $false 'MODE_SET' '')
    }

    $enf = Read-MagGuardEnforcementState -Plan $Plan
    $observed = Get-MagGuardObservedModelId -HookInput $HookInput
    $pending = Read-MagGuardPending
    $isContinue = Test-MagGuardPromptContinue -Plan $Plan -HookInput $HookInput -Contract $contract

    if ($null -eq $Plan) {
        return (New-MagGuardDecision 'INERT' $false 'CONTINUE' '')
    }

    if ($enf.State -eq 'SUSPENDED') {
        $action = if ($enf.MaintenanceActive) { 'MAINTENANCE_ACTIVE' } else { 'ENFORCEMENT_SUSPENDED' }
        return (New-MagGuardDecision $action $false 'CONTINUE' '')
    }

    $seg = Get-MagGuardCurrentSegment -Plan $Plan
    $mapping = Read-MagGuardMapping

    # Continuation request: always recognized; success only after re-evaluation.
    if ($isContinue) {
        if ($null -eq $pending) {
            $eval = Evaluate-MagGuardPredicates -Plan $Plan -HookInput $HookInput -Contract $contract -HookName $HookName
            if ($eval.Block -and $enf.State -eq 'ENFORCED') {
                $meta = Get-MagGuardSignalMeta -Contract $contract -Signal $eval.Signal
                $req = @()
                if ($meta -and $meta.required_resolution) { $req = @($meta.required_resolution) }
                Save-MagGuardPending -Plan $Plan -Segment $seg -Signal $eval.Signal -RequiredResolution $req -ObservedModelId $observed
                $msg = Get-MagGuardProposalText -Plan $Plan -Segment $seg -Mapping $mapping -Signal $eval.Signal -RequiredResolution $req -ObservedModelId $observed
                return (New-MagGuardDecision $eval.Signal $true 'STOP' ("MAG Model Routing Guard: continuation requested but unresolved. $msg") $true)
            }
            return (New-MagGuardDecision 'MODEL_MATCH' $false 'CONTINUE' '' $true)
        }

        $resolved = Test-MagGuardPendingResolved -Pending $pending -Plan $Plan -HookInput $HookInput -Contract $contract
        if ($resolved) {
            $sig = [string]$pending.signal
            Clear-MagGuardPending
            return (New-MagGuardDecision $sig $false 'RESOLUTION_CONFIRMED' '' $true)
        }
        $meta = Get-MagGuardSignalMeta -Contract $contract -Signal ([string]$pending.signal)
        $req = @()
        if ($pending.PSObject.Properties['required_resolution']) { $req = @($pending.required_resolution) }
        elseif ($meta -and $meta.required_resolution) { $req = @($meta.required_resolution) }
        $msg = Get-MagGuardProposalText -Plan $Plan -Segment $seg -Mapping $mapping -Signal ([string]$pending.signal) -RequiredResolution $req -ObservedModelId $observed -Pending $pending
        if ($enf.State -eq 'ADVISORY') {
            return (New-MagGuardDecision ([string]$pending.signal) $false 'ENFORCEMENT_ADVISORY' ("ADVISORY: unresolved $($pending.signal). $msg Agent §24.4 still applies.") $true)
        }
        return (New-MagGuardDecision ([string]$pending.signal) $true 'STOP' ("MAG Model Routing Guard: + recognized; prerequisite not satisfied. $msg") $true)
    }

    # Existing pending STOP (without + this turn)
    if ($null -ne $pending -and $enf.State -eq 'ENFORCED') {
        $meta = Get-MagGuardSignalMeta -Contract $contract -Signal ([string]$pending.signal)
        $req = @()
        if ($pending.PSObject.Properties['required_resolution']) { $req = @($pending.required_resolution) }
        $msg = Get-MagGuardProposalText -Plan $Plan -Segment $seg -Mapping $mapping -Signal ([string]$pending.signal) -RequiredResolution $req -ObservedModelId $observed -Pending $pending
        return (New-MagGuardDecision ([string]$pending.signal) $true 'STOP' ("MAG Model Routing Guard: pending STOP $($pending.signal). $msg"))
    }
    if ($null -ne $pending -and $enf.State -eq 'ADVISORY') {
        return (New-MagGuardDecision ([string]$pending.signal) $false 'ENFORCEMENT_ADVISORY' ("ADVISORY pending $($pending.signal). Agent §24.4 still applies."))
    }

    $eval = Evaluate-MagGuardPredicates -Plan $Plan -HookInput $HookInput -Contract $contract -HookName $HookName
    $meta = Get-MagGuardSignalMeta -Contract $contract -Signal $eval.Signal
    $req = @()
    if ($meta -and $meta.required_resolution) { $req = @($meta.required_resolution) }
    $msg = Get-MagGuardProposalText -Plan $Plan -Segment $seg -Mapping $mapping -Signal $eval.Signal -RequiredResolution $req -ObservedModelId $observed

    if (-not $eval.Block) {
        if ($eval.Signal -in @('MODEL_DOWNGRADE_RECOMMENDED', 'CONTEXT_WARNING') -or ($eval.Signal -eq 'RUNTIME_CHALLENGE' -and -not $eval.Block)) {
            return (New-MagGuardDecision $eval.Signal $false 'WARN' $msg)
        }
        return (New-MagGuardDecision 'MODEL_MATCH' $false 'CONTINUE' '')
    }

    if ($enf.State -eq 'ADVISORY') {
        Save-MagGuardPending -Plan $Plan -Segment $seg -Signal $eval.Signal -RequiredResolution $req -ObservedModelId $observed
        return (New-MagGuardDecision $eval.Signal $false 'ENFORCEMENT_ADVISORY' ("ADVISORY: $msg Agent §24.4 still applies."))
    }

    # ENFORCED hard STOP
    Save-MagGuardPending -Plan $Plan -Segment $seg -Signal $eval.Signal -RequiredResolution $req -ObservedModelId $observed
    return (New-MagGuardDecision $eval.Signal $true 'STOP' ("MAG Model Routing Guard: $msg"))
}

function Emit-MagGuardHookResponse {
    param([bool]$Continue, [string]$UserMessage = '')
    $obj = [ordered]@{ continue = [bool]$Continue }
    if (-not $Continue -and -not [string]::IsNullOrWhiteSpace($UserMessage)) {
        $obj['user_message'] = $UserMessage
    }
    [Console]::Out.Write(($obj | ConvertTo-Json -Compress))
}

# Compatibility aliases for older scripts/tests
function Save-MagGuardMode {
    param([string]$Mode, [int]$DurationHours = -1, [string]$Note = '')
    $state = ConvertTo-MagGuardEnforcementState $Mode
    if (-not $state) { throw "unknown_mode:$Mode" }
    return Save-MagGuardEnforcementState -State $state -Note $Note
}
function Read-MagGuardMode {
    param($Plan = $null)
    if ($null -eq $Plan) { $Plan = Read-MagGuardPlan }
    $e = Read-MagGuardEnforcementState -Plan $Plan
    return [pscustomobject]@{
        Mode = $e.State.ToLowerInvariant()
        State = $e.State
        Source = $e.Source
        Expired = $false
        NeedsChoice = $false
        EnforceStops = $e.HardBlock
        MaintenanceActive = $e.MaintenanceActive
    }
}
function Clear-MagGuardPoContinueAck { param($PlanPath, $Plan, $Segment) Clear-MagGuardPending }
function Accept-MagGuardPoContinue { param($PlanPath, $Plan, $Segment, $AcceptedGate = 'model') Clear-MagGuardPending }
function Write-MagGuardObservationDiagnostic {
    param($HookInput, $Decision, [string]$HookName)
    $root = Join-Path (Get-MagGuardReposRoot) '.mag'
    if (-not (Test-Path -LiteralPath (Join-Path $root 'routing-observation-debug.enabled'))) { return }
    $event = [ordered]@{ hook_event = $HookName }
    foreach ($key in @('model', 'model_id', 'hook_event_name', 'cursor_version')) {
        $value = if ($null -ne $HookInput -and $HookInput.PSObject.Properties[$key]) { $HookInput.$key } else { $null }
        $event[$key] = if ($value -is [string] -and $value.Length -le 128) { $value } else { $null }
    }
    $event['model_params_present'] = ($null -ne $HookInput -and $null -ne $HookInput.PSObject.Properties['model_params'])
    $event['observation_source'] = (Get-MagGuardObservation -HookInput $HookInput).Source
    $event['signal'] = $Decision.Signal
    $event['action'] = $Decision.Action
    Add-Content -LiteralPath (Join-Path $root 'routing-observation-debug.jsonl') -Value ($event | ConvertTo-Json -Compress) -Encoding utf8
}
