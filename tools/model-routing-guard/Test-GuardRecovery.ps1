#Requires -Version 7.0
param([Parameter(Mandatory)][string]$GuardRoot)
$ErrorActionPreference = 'Stop'
. (Join-Path $GuardRoot 'lib\MagRoutingGuard.Common.ps1')
$env:MAG_REPOS_ROOT = Join-Path ([IO.Path]::GetTempPath()) ('mag-recovery-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path (Join-Path $env:MAG_REPOS_ROOT '.mag') -Force | Out-Null
$planPath = Get-MagGuardPlanPath
# Enforcement tests require Pro mode (default/missing mode is Auto = no STOP proposals).
Save-MagGuardMode -Mode pro -DurationHours 24 -Note 'test' | Out-Null
$plan = Get-Content (Join-Path $GuardRoot 'examples\routing-plan.example.json') -Raw | ConvertFrom-Json
function Assert-Decision($name, $p, $inputData, $signal, $allow) {
    $d = Resolve-MagGuardDecision -Plan $p -HookInput ([pscustomobject]$inputData) -PlanPath $planPath
    if ($d.Signal -ne $signal -or $d.Continue -ne $allow) {
        throw "$name failed: $($d | ConvertTo-Json -Compress)"
    }
    Write-Output "PASS $name"
}
Assert-Decision 'no plan' $null @{} 'INERT' $true
Assert-Decision 'model only' $plan @{ model = 'composer-2.5' } 'MODEL_MATCH' $true
Assert-Decision 'default ID concrete model' $plan @{ model_id = 'default'; model = 'composer-2.5' } 'MODEL_MATCH' $true
Assert-Decision 'concrete ID' $plan @{ model_id = 'composer-2.5' } 'MODEL_MATCH' $true
Assert-Decision 'mismatch stop+propose' $plan @{ model = 'grok-4.7-high' } 'MODEL_MISMATCH' $false
foreach ($value in @('', 'default', 'auto', 'unknown')) {
    Assert-Decision "unknown stop+propose [$value]" $plan @{ model_id = $value; model = $value } 'MODEL_OBSERVATION_UNKNOWN' $false
}

Assert-Decision 'plus continues' $plan @{ model = 'grok-4.7-high'; prompt = '+' } 'PO_CONTINUE' $true
Assert-Decision 'after plus no re-nag mismatch' $plan @{ model = 'grok-4.7-high' } 'MODEL_PO_ACCEPTED' $true
Assert-Decision 'after plus no re-nag unobserved' $plan @{} 'MODEL_PO_ACCEPTED' $true

# Same session: further gates still STOP+propose ( + does not disable Guard )
$plan | Add-Member -NotePropertyName signal -NotePropertyValue 'MODEL_BOUNDARY' -Force
Assert-Decision 'later boundary still proposes' $plan @{ model = 'composer-2.5' } 'MODEL_BOUNDARY' $false
Assert-Decision 'boundary plus accepts gate' $plan @{ model = 'composer-2.5'; prompt = '+' } 'PO_CONTINUE' $true
$plan | Add-Member -NotePropertyName signal -NotePropertyValue 'MODEL_ESCALATION_REQUIRED' -Force
Assert-Decision 'later escalation still proposes' $plan @{ model = 'composer-2.5' } 'MODEL_ESCALATION_REQUIRED' $false
Assert-Decision 'escalation plus accepts gate' $plan @{ model = 'composer-2.5'; prompt = '+' } 'PO_CONTINUE' $true

# Fresh copies for isolated boundary/escalation cases below
$plan = Get-Content (Join-Path $GuardRoot 'examples\routing-plan.example.json') -Raw | ConvertFrom-Json
$plan | Add-Member -NotePropertyName signal -NotePropertyValue 'MODEL_BOUNDARY' -Force
Assert-Decision 'boundary stop+propose' $plan @{ model = 'composer-2.5' } 'MODEL_BOUNDARY' $false
Assert-Decision 'boundary plus accepts' $plan @{ model = 'composer-2.5'; prompt = '+' } 'PO_CONTINUE' $true
$plan.signal = 'MODEL_ESCALATION_REQUIRED'
# after plus, signal cleared in Accept — re-set for escalation case on fresh copy
$plan2 = Get-Content (Join-Path $GuardRoot 'examples\routing-plan.example.json') -Raw | ConvertFrom-Json
$plan2 | Add-Member -NotePropertyName signal -NotePropertyValue 'MODEL_ESCALATION_REQUIRED' -Force
Assert-Decision 'escalation stop+propose' $plan2 @{ model = 'composer-2.5' } 'MODEL_ESCALATION_REQUIRED' $false
Assert-Decision 'escalation plus accepts' $plan2 @{ model = 'composer-2.5'; prompt = '+' } 'PO_CONTINUE' $true

# Operating modes: Auto/Off suppress STOP proposals; prompt commands switch mode
$planMode = Get-Content (Join-Path $GuardRoot 'examples\routing-plan.example.json') -Raw | ConvertFrom-Json
Save-MagGuardMode -Mode auto -DurationHours 24 | Out-Null
Assert-Decision 'auto suppresses mismatch' $planMode @{ model = 'grok-4.7-high' } 'MODE_AUTO' $true
Save-MagGuardMode -Mode off -DurationHours 0 | Out-Null
Assert-Decision 'off suppresses mismatch' $planMode @{ model = 'grok-4.7-high' } 'MODE_OFF' $true
Assert-Decision 'prompt enables pro' $planMode @{ model = 'grok-4.7-high'; prompt = 'Guard Pro' } 'MODE_PRO' $true
Assert-Decision 'pro mismatch after enable' $planMode @{ model = 'grok-4.7-high' } 'MODEL_MISMATCH' $false
Assert-Decision 'prompt auto' $planMode @{ prompt = 'Guard Auto' } 'MODE_AUTO' $true
Assert-Decision 'prompt off' $planMode @{ prompt = 'Вимкни Guard' } 'MODE_OFF' $true

# Auto expiry → must ask mode before continuing
$expiredPath = Get-MagGuardModePath
$expiredObj = [ordered]@{
    version = 1
    mode = 'auto'
    set_at = '2020-01-01T00:00:00Z'
    expires_at = '2020-01-02T00:00:00Z'
    duration_hours = 24
    note = 'expired-fixture'
}
[System.IO.File]::WriteAllText($expiredPath, (($expiredObj | ConvertTo-Json) + "`n"), [System.Text.UTF8Encoding]::new($false))
Assert-Decision 'expired auto asks mode' $planMode @{ model = 'composer-2.5' } 'MODE_EXPIRED' $false
Assert-Decision 'expired answered with auto' $planMode @{ prompt = 'Guard Auto' } 'MODE_AUTO' $true

Save-MagGuardMode -Mode pro -DurationHours 0 | Out-Null

$plan3 = Get-Content (Join-Path $GuardRoot 'examples\routing-plan.example.json') -Raw | ConvertFrom-Json
$plan3 | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $planPath -Encoding utf8
& (Join-Path $GuardRoot 'Set-MagGuardMaintenance.ps1') -Action Suspend -ReposRoot $env:MAG_REPOS_ROOT -ProductOwnerApproved
Assert-Decision 'maintenance' (Read-MagGuardPlan) @{} 'INERT' $true
& (Join-Path $GuardRoot 'Set-MagGuardMaintenance.ps1') -Action Resume -ReposRoot $env:MAG_REPOS_ROOT -ProductOwnerApproved
Assert-Decision 'restored enforcement' (Read-MagGuardPlan) @{} 'MODEL_OBSERVATION_UNKNOWN' $false
Assert-Decision 'restored plus unlocks' (Read-MagGuardPlan) @{ prompt = '+' } 'PO_CONTINUE' $true

$plan4 = Get-Content (Join-Path $GuardRoot 'examples\routing-plan.example.json') -Raw | ConvertFrom-Json
$plan4 | Add-Member -NotePropertyName accepted -NotePropertyValue $false -Force
$plan4 | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $planPath -Encoding utf8
Assert-Decision 'unaccepted plan' (Read-MagGuardPlan) @{} 'INERT' $true
'{"routing_plan_version":1}' | Set-Content -LiteralPath $planPath -Encoding utf8
Assert-Decision 'invalid plan' (Read-MagGuardPlan) @{} 'INERT' $true

New-Item -ItemType File (Join-Path $env:MAG_REPOS_ROOT '.mag\routing-observation-debug.enabled') -Force | Out-Null
$inputData = [pscustomobject]@{
    model_id         = 'default'
    model            = 'composer-2.5'
    prompt           = 'DO_NOT_LOG'
    model_params     = @{ secret = 'DO_NOT_LOG' }
    hook_event_name  = 'beforeSubmitPrompt'
    cursor_version   = 'test'
}
Write-MagGuardObservationDiagnostic $inputData ([pscustomobject]@{ Signal = 'INERT'; Action = 'CONTINUE' }) 'beforeSubmitPrompt'
$log = Get-Content (Join-Path $env:MAG_REPOS_ROOT '.mag\routing-observation-debug.jsonl') -Raw
if ($log.Contains('DO_NOT_LOG') -or ($log | ConvertFrom-Json).observation_source -ne 'model') {
    throw 'Diagnostic privacy/source failed'
}
Write-Output 'PASS diagnostic privacy and source'
'{}' | & pwsh -NoProfile -File (Join-Path $GuardRoot 'hooks\beforeSubmitPrompt.ps1')
if ($LASTEXITCODE -ne 0) { throw 'Hook failed' }
Write-Output 'ALL_RECOVERY_OK'
