#Requires -Version 7.0
# Parity / recovery matrix for §24.4 Runtime Routing Enforcement (isolated temp workspace).
param([Parameter(Mandatory)][string]$GuardRoot)
$ErrorActionPreference = 'Stop'
. (Join-Path $GuardRoot 'lib\MagRoutingGuard.Common.ps1')
$script:DefaultMappingPath = Join-Path $GuardRoot 'capability-mapping.json'
$script:DefaultContractPath = Join-Path $GuardRoot 'enforcement-contract.v1.json'
$script:LoadedContract = $null

$env:MAG_REPOS_ROOT = Join-Path ([IO.Path]::GetTempPath()) ('mag-rre-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path (Join-Path $env:MAG_REPOS_ROOT '.mag') -Force | Out-Null
$planPath = Get-MagGuardPlanPath
$example = Get-Content (Join-Path $GuardRoot 'examples\routing-plan.example.json') -Raw | ConvertFrom-Json

function Assert-Decision($name, $p, $inputData, $signal, $allow, $action = $null) {
    $d = Resolve-MagGuardDecision -Plan $p -HookInput ([pscustomobject]$inputData) -PlanPath $planPath
    if ($d.Signal -ne $signal -or $d.Continue -ne $allow) {
        throw "$name failed: $($d | ConvertTo-Json -Compress)"
    }
    if ($null -ne $action -and $d.Action -ne $action) {
        throw "$name action failed: expected $action got $($d.Action) :: $($d | ConvertTo-Json -Compress)"
    }
    Write-Output "PASS $name"
}

function Write-Plan($obj) {
    ($obj | ConvertTo-Json -Depth 20) | Set-Content -LiteralPath $planPath -Encoding utf8
}

# 1 contract loads (canonical §24.4; no ACTIVE overlay dependency)
$c = Read-MagGuardContract
if ([string]$c.canonical_owner -ne 'AI_GUIDELINES.md' -or [string]$c.canonical_section -ne '24.4') { throw 'contract canonical metadata' }
if ($c.PSObject.Properties['active_overlay'] -and $c.active_overlay) { throw 'contract must not require active_overlay' }
Write-Output 'PASS contract parse/metadata'

# 5 no plan → INERT
Assert-Decision 'no plan inert' $null @{} 'INERT' $true

# 6 accepted plan + missing state → ENFORCED (mismatch stops)
$plan = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
Write-Plan $plan
$plan = Read-MagGuardPlan
Assert-Decision 'missing state enforced mismatch' $plan @{ model = 'grok-4.7-high' } 'MODEL_MISMATCH' $false 'STOP'
Clear-MagGuardPending

# 7 match
Assert-Decision 'model match' $plan @{ model = 'composer-2.5' } 'MODEL_MATCH' $true

# 8/9 mismatch + bare + unresolved
Assert-Decision 'mismatch stop' $plan @{ model = 'grok-4.7-high' } 'MODEL_MISMATCH' $false 'STOP'
Assert-Decision 'bare plus unresolved' $plan @{ model = 'grok-4.7-high'; prompt = '+' } 'MODEL_MISMATCH' $false 'STOP'

# 10 correct switch + +
Assert-Decision 'switch plus resolves' $plan @{ model = 'composer-2.5'; prompt = '+' } 'MODEL_MISMATCH' $true 'RESOLUTION_CONFIRMED'

# 11 observation unknown
Clear-MagGuardPending
Assert-Decision 'observation unknown' $plan @{} 'MODEL_OBSERVATION_UNKNOWN' $false 'STOP'
Assert-Decision 'unknown plus unresolved' $plan @{ prompt = '+' } 'MODEL_OBSERVATION_UNKNOWN' $false 'STOP'
Clear-MagGuardPending

# 12 boundary (explicit recommended target)
$planB = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planB | Add-Member -NotePropertyName signal -NotePropertyValue 'MODEL_BOUNDARY' -Force
$planB | Add-Member -NotePropertyName recommended_routing_class -NotePropertyValue 'EXECUTION' -Force
Write-Plan $planB
$planB = Read-MagGuardPlan
Assert-Decision 'boundary stop' $planB @{ model = 'composer-2.5' } 'MODEL_BOUNDARY' $false
# clear signal + match then +
$planB.signal = $null
$planB.recommended_routing_class = $null
Write-Plan $planB
$planB = Read-MagGuardPlan
# pending still boundary from before — + with match and no boundary signal
Assert-Decision 'boundary plus after clear' $planB @{ model = 'composer-2.5'; prompt = '+' } 'MODEL_BOUNDARY' $true 'RESOLUTION_CONFIRMED'

# 13 escalation (explicit DEEP target)
$planE = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planE | Add-Member signal MODEL_ESCALATION_REQUIRED -Force
$planE | Add-Member recommended_routing_class DEEP_REASONING -Force
Write-Plan $planE
Assert-Decision 'escalation stop' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'MODEL_ESCALATION_REQUIRED' $false
Clear-MagGuardPending

# 14 downgrade warn
$planD = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planD | Add-Member signal MODEL_DOWNGRADE_RECOMMENDED -Force
Write-Plan $planD
Assert-Decision 'downgrade warn' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'MODEL_DOWNGRADE_RECOMMENDED' $true 'WARN'

# 15/16 challenge
$planC = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planC | Add-Member signal RUNTIME_CHALLENGE -Force
Write-Plan $planC
Assert-Decision 'challenge stop' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'RUNTIME_CHALLENGE' $false
Clear-MagGuardPending

# 17/18 replan: pending REPLAN, same plan + does not continue; new plan fingerprint resolves
$planR = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planR | Add-Member signal REPLAN_REQUIRED -Force
Write-Plan $planR
Assert-Decision 'replan stop' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'REPLAN_REQUIRED' $false
Assert-Decision 'replan bare plus' (Read-MagGuardPlan) @{ model = 'composer-2.5'; prompt = '+' } 'REPLAN_REQUIRED' $false
$planR2 = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planR2.procedure_id = 'replanned-execution'
Write-Plan $planR2
Assert-Decision 'replan new plan plus' (Read-MagGuardPlan) @{ model = 'composer-2.5'; prompt = '+' } 'REPLAN_REQUIRED' $true 'RESOLUTION_CONFIRMED'

# 19 authority + bare +
$planA = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planA | Add-Member signal AUTHORITY_CONFLICT -Force
Write-Plan $planA
Assert-Decision 'authority stop' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'AUTHORITY_CONFLICT' $false
Assert-Decision 'authority bare plus' (Read-MagGuardPlan) @{ model = 'composer-2.5'; prompt = '+' } 'AUTHORITY_CONFLICT' $false
Clear-MagGuardPending

# 21 ADVISORY no hard block
Write-Plan $example
Save-MagGuardEnforcementState -State ADVISORY -Note test | Out-Null
Assert-Decision 'advisory mismatch' (Read-MagGuardPlan) @{ model = 'grok-4.7-high' } 'MODEL_MISMATCH' $true 'ENFORCEMENT_ADVISORY'
Clear-MagGuardPending

# 22 SUSPENDED inert, not MATCH from suspension alone
Save-MagGuardEnforcementState -State SUSPENDED -Note test | Out-Null
Assert-Decision 'suspended' (Read-MagGuardPlan) @{ model = 'grok-4.7-high' } 'ENFORCEMENT_SUSPENDED' $true
# signal is ENFORCEMENT_SUSPENDED not MODEL_MATCH

# 23/24 maintenance
Save-MagGuardEnforcementState -State ENFORCED -Note test | Out-Null
Write-Plan $example
Assert-Decision 'seed mismatch pending' (Read-MagGuardPlan) @{ model = 'grok-4.7-high' } 'MODEL_MISMATCH' $false
$pendingBefore = Read-MagGuardPending
if ($null -eq $pendingBefore) { throw 'pending missing before maintenance' }
& (Join-Path $GuardRoot 'Set-MagGuardMaintenance.ps1') -Action Suspend -ReposRoot $env:MAG_REPOS_ROOT -ProductOwnerApproved
Assert-Decision 'maintenance continue' (Read-MagGuardPlan) @{ model = 'grok-4.7-high' } 'MAINTENANCE_ACTIVE' $true
if ($null -eq (Read-MagGuardPending)) { throw 'pending cleared during maintenance' }
& (Join-Path $GuardRoot 'Set-MagGuardMaintenance.ps1') -Action Resume -ReposRoot $env:MAG_REPOS_ROOT -ProductOwnerApproved
Assert-Decision 'after resume pending stop' (Read-MagGuardPlan) @{ model = 'grok-4.7-high' } 'MODEL_MISMATCH' $false
Clear-MagGuardPending

# 26 legacy alias Auto → ADVISORY
Assert-Decision 'legacy auto cmd' (Read-MagGuardPlan) @{ prompt = 'Guard Auto' } 'MODE_ADVISORY' $true
Assert-Decision 'legacy pro cmd' (Read-MagGuardPlan) @{ prompt = 'Guard Pro' } 'MODE_ENFORCED' $true
Assert-Decision 'primary enforced cmd' (Read-MagGuardPlan) @{ prompt = 'Guard Enforced' } 'MODE_ENFORCED' $true

# 27-29 smoke: contract prohibits flags present
$c2 = Read-MagGuardContract
foreach ($p in @('automatic_model_switching', 'llm_router', 'token_dollar_telemetry')) {
    if ($c2.prohibited_automation -notcontains $p) { throw "missing prohibited $p" }
}
Write-Output 'PASS prohibited automation flags'

# --- Recommendation / Capability Mapping matrix (A–N) ---
function Assert-Msg($name, $p, $inputData, $signal, $allow, [string[]]$mustContain, [string[]]$mustNotContain = @()) {
    $d = Resolve-MagGuardDecision -Plan $p -HookInput ([pscustomobject]$inputData) -PlanPath $planPath
    if ($d.Signal -ne $signal -or $d.Continue -ne $allow) {
        throw "$name decision failed: $($d | ConvertTo-Json -Compress)"
    }
    foreach ($s in $mustContain) {
        if ($null -eq $d.Message -or -not $d.Message.Contains($s)) { throw "$name missing '$s' in: $($d.Message)" }
    }
    foreach ($s in $mustNotContain) {
        if ($null -ne $d.Message -and $d.Message.Contains($s)) { throw "$name must not contain '$s' in: $($d.Message)" }
    }
    Write-Output "PASS $name"
}

# A mapping preferred integrity
$mapping = Read-MagGuardMapping
$expectedEffort = @{
    EXECUTION             = $null
    LIGHT_REASONING       = 'low'
    NORMAL_REASONING      = 'medium'
    DEEP_REASONING        = 'high'
    EXCEPTIONAL_REASONING = 'xhigh'
}
foreach ($cls in @('EXECUTION', 'LIGHT_REASONING', 'NORMAL_REASONING', 'DEEP_REASONING', 'EXCEPTIONAL_REASONING')) {
    if (-not (Test-MagGuardMappingClassValid -RoutingClass $cls -Mapping $mapping)) { throw "mapping invalid for $cls" }
    $pref = [string]$mapping.classes.$cls.preferred_model_id
    if (-not (Test-MagGuardModelIdCompatibleWithClass -ModelId $pref -RoutingClass $cls -Mapping $mapping)) {
        throw "preferred $pref not in prefixes for $cls"
    }
    $eff = $mapping.classes.$cls.preferred_effort
    $want = $expectedEffort[$cls]
    if ($null -eq $want) {
        if ($null -ne $eff -and [string]$eff -ne '') { throw "EXECUTION effort should be null" }
    }
    elseif ([string]$eff -ne $want) { throw "$cls effort expected $want got $eff" }
}
Write-Output 'PASS mapping preferred integrity'

# B EXECUTION mismatch → composer-2.5, not prefix list
Clear-MagGuardPending
Write-Plan $example
Assert-Msg 'exec mismatch recommends composer' (Read-MagGuardPlan) @{ model = 'grok-4.7-high' } 'MODEL_MISMATCH' $false @(
    'recommended model=Composer 2.5 (`composer-2.5`)',
    'required class=EXECUTION'
) @('suggested model(s)=', 'gpt-5.6-luna, gemini-3.8-flash')
Clear-MagGuardPending

# C NORMAL mismatch → grok-4.7 / medium
$planN = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planN.segments[0].routing_class = 'NORMAL_REASONING'
Write-Plan $planN
Assert-Msg 'normal mismatch recommends grok medium' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'MODEL_MISMATCH' $false @(
    'recommended model=Grok 4.7 (`grok-4.7`)',
    'effort=medium',
    'required class=NORMAL_REASONING'
)
Clear-MagGuardPending

# D escalation EXECUTION → DEEP recommends grok high, NOT composer
$planEsc = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planEsc | Add-Member signal MODEL_ESCALATION_REQUIRED -Force
$planEsc | Add-Member recommended_routing_class DEEP_REASONING -Force
$planEsc | Add-Member recommendation_reason 'material complexity increase' -Force
Write-Plan $planEsc
Assert-Msg 'escalation recommends deep grok' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'MODEL_ESCALATION_REQUIRED' $false @(
    'recommended class=DEEP_REASONING',
    'recommended model=Grok 4.7 (`grok-4.7`)',
    'effort=high'
) @('recommended model=Composer 2.5')
Clear-MagGuardPending

# E escalation target missing → ROUTING_MAPPING_UNKNOWN
$planEscMiss = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planEscMiss | Add-Member signal MODEL_ESCALATION_REQUIRED -Force
Write-Plan $planEscMiss
Assert-Decision 'escalation missing target unknown' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'ROUTING_MAPPING_UNKNOWN' $false 'STOP'
Clear-MagGuardPending

# F boundary next Segment NORMAL → grok medium
$planBound = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planBound.segments = @(
    [pscustomobject]@{
        segment_id = 'seg-1'; purpose = 'a'; routing_class = 'EXECUTION'; required_model_ids = @()
        boundary_condition = 'none'; next_segment_id = 'seg-2'
    },
    [pscustomobject]@{
        segment_id = 'seg-2'; purpose = 'b'; routing_class = 'NORMAL_REASONING'; required_model_ids = @()
        boundary_condition = 'none'
    }
)
$planBound | Add-Member signal MODEL_BOUNDARY -Force
Write-Plan $planBound
Assert-Msg 'boundary next normal recommends grok' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'MODEL_BOUNDARY' $false @(
    'recommended class=NORMAL_REASONING',
    'recommended model=Grok 4.7 (`grok-4.7`)',
    'effort=medium'
)
Clear-MagGuardPending

# G boundary missing target → ROUTING_MAPPING_UNKNOWN
$planBoundMiss = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planBoundMiss | Add-Member signal MODEL_BOUNDARY -Force
Write-Plan $planBoundMiss
Assert-Decision 'boundary missing target unknown' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'ROUTING_MAPPING_UNKNOWN' $false 'STOP'
Clear-MagGuardPending

# H downgrade with explicit EXECUTION target
$planDown = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planDown.segments[0].routing_class = 'DEEP_REASONING'
$planDown | Add-Member signal MODEL_DOWNGRADE_RECOMMENDED -Force
$planDown | Add-Member recommended_routing_class EXECUTION -Force
Write-Plan $planDown
Assert-Msg 'downgrade recommends composer' (Read-MagGuardPlan) @{ model = 'grok-4.7' } 'MODEL_DOWNGRADE_RECOMMENDED' $true @(
    'recommended class=EXECUTION',
    'recommended model=Composer 2.5 (`composer-2.5`)'
)
# WARN action
$dDown = Resolve-MagGuardDecision -Plan (Read-MagGuardPlan) -HookInput ([pscustomobject]@{ model = 'grok-4.7' }) -PlanPath $planPath
if ($dDown.Action -ne 'WARN') { throw "downgrade action expected WARN got $($dDown.Action)" }
Write-Output 'PASS downgrade warn action'
Clear-MagGuardPending

# I downgrade without target — WARN, no concrete recommendation
$planDown2 = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planDown2.segments[0].routing_class = 'DEEP_REASONING'
$planDown2 | Add-Member signal MODEL_DOWNGRADE_RECOMMENDED -Force
Write-Plan $planDown2
Assert-Msg 'downgrade no target no concrete' (Read-MagGuardPlan) @{ model = 'grok-4.7' } 'MODEL_DOWNGRADE_RECOMMENDED' $true @(
    'recommended class=(none supplied)',
    'no concrete model recommendation'
) @('recommended model=Composer', 'recommended model=Grok')
Clear-MagGuardPending

# J compatible override gpt-5.6-sol for DEEP escalation
$planOv = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planOv | Add-Member signal MODEL_ESCALATION_REQUIRED -Force
$planOv | Add-Member recommended_routing_class DEEP_REASONING -Force
$planOv | Add-Member recommended_model_id_override 'gpt-5.6-sol' -Force
Write-Plan $planOv
Assert-Msg 'override deep sol' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'MODEL_ESCALATION_REQUIRED' $false @(
    'recommended model=gpt-5.6-sol (`gpt-5.6-sol`)'
)
Clear-MagGuardPending

# K incompatible override EXECUTION + gpt-5.6-sol
$planBad = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planBad | Add-Member signal MODEL_ESCALATION_REQUIRED -Force
$planBad | Add-Member recommended_routing_class EXECUTION -Force
$planBad | Add-Member recommended_model_id_override 'gpt-5.6-sol' -Force
Write-Plan $planBad
Assert-Decision 'incompatible override unknown' (Read-MagGuardPlan) @{ model = 'composer-2.5' } 'ROUTING_MAPPING_UNKNOWN' $false 'STOP'
Clear-MagGuardPending

# L compatible alternative MATCH
function Assert-Match($name, $class, $model) {
    $p = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
    $p.segments[0].routing_class = $class
    Write-Plan $p
    Assert-Decision $name (Read-MagGuardPlan) @{ model = $model } 'MODEL_MATCH' $true
    Clear-MagGuardPending
}
Assert-Match 'match normal terra' 'NORMAL_REASONING' 'gpt-5.6-terra'
Assert-Match 'match normal sonnet' 'NORMAL_REASONING' 'claude-sonnet-5'
Assert-Match 'match deep sol' 'DEEP_REASONING' 'gpt-5.6-sol'
Assert-Match 'match exec luna' 'EXECUTION' 'gpt-5.6-luna'

# M effort UNKNOWN still MATCH for grok-4.7 on NORMAL
$planM = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
$planM.segments[0].routing_class = 'NORMAL_REASONING'
Write-Plan $planM
Assert-Decision 'effort unknown still match' (Read-MagGuardPlan) @{ model = 'grok-4.7' } 'MODEL_MATCH' $true
Clear-MagGuardPending

# N second opinion never auto-selected for EXCEPTIONAL preferred
$ex = $mapping.classes.EXCEPTIONAL_REASONING
if (-not $ex.PSObject.Properties['second_opinion_model_ids']) { throw 'missing second_opinion_model_ids' }
$rec = Resolve-MagGuardConcreteRecommendation -TargetClass 'EXCEPTIONAL_REASONING' -OverrideModelId '' -Mapping $mapping
if ($rec.ModelId -ne 'grok-4.7') { throw "second opinion leaked into preferred: $($rec.ModelId)" }
if ($rec.ModelId -in @($ex.second_opinion_model_ids) -and $rec.ModelId -ne 'grok-4.7') { throw 'auto second opinion' }
Write-Output 'PASS second opinion not auto-selected'

# pending does not store resolved preferred model id as policy
$planPend = $example | ConvertTo-Json -Depth 20 | ConvertFrom-Json
Write-Plan $planPend
Assert-Decision 'seed pending mismatch' (Read-MagGuardPlan) @{ model = 'grok-4.7' } 'MODEL_MISMATCH' $false
$pend = Read-MagGuardPending
if ($pend.PSObject.Properties['preferred_model_id'] -or $pend.PSObject.Properties['resolved_model_id']) {
    throw 'pending must not persist dynamically resolved preferred model'
}
Clear-MagGuardPending
Write-Output 'PASS pending omits resolved preferred'

Write-Output 'ALL_RECOVERY_OK'
