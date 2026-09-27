#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path $PSScriptRoot -Parent) 'lib\MagRoutingGuard.Common.ps1')

Ensure-MagGuardMagDir | Out-Null
$plan = Read-MagGuardPlan
$enf = Read-MagGuardEnforcementState -Plan $plan
$cv = ''
try { $cv = [string](Read-MagGuardContract).contract_version } catch { $cv = 'unavailable' }
$note = ("sessionStart state={0} source={1} maintenance={2} contract={3}" -f $enf.State, $enf.Source, $enf.MaintenanceActive, $cv)
Write-MagGuardEvidence -Plan $plan -ObservedModelId '' -Signal 'SESSION_START' -Action 'CONTINUE' -Note $note -ContractVersion $cv

$ctx = $null
if ($enf.MaintenanceActive) {
    $ctx = 'MAG Model Routing Guard: MAINTENANCE active (tool SUSPENDED). Pending STOP preserved. Does NOT certify MODEL_MATCH. §24.4 agent obligations remain. Resume via Set-MagGuardMaintenance.ps1 -Action Resume.'
}
elseif ($null -ne $plan -and $enf.State -eq 'ENFORCED') {
    $ctx = 'MAG Model Routing Guard: ENFORCED (accepted plan). STOP/WARN per AI_GUIDELINES.md §24.4 Runtime Routing Enforcement.'
}
elseif ($enf.State -eq 'ADVISORY') {
    $ctx = 'MAG Model Routing Guard: ADVISORY — reports predicates without normal hard blocking. Agents must still follow §24.4.'
}
elseif ($null -eq $plan) {
    $ctx = 'MAG Model Routing Guard: no accepted Routing Plan → INERT hooks. Agents still follow §24.4 when a plan is required.'
}

if ($ctx) {
    Write-Output (([ordered]@{ additional_context = $ctx } | ConvertTo-Json -Compress))
}
else {
    Write-Output '{}'
}
exit 0
