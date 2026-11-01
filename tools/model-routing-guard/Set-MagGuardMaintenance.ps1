#Requires -Version 7.0
<#
.SYNOPSIS
  Explicit Product Owner maintenance recovery (separate from Runtime Enforcement State).
  Suspend: effective tool enforcement SUSPENDED; preserves plan + pending STOP.
  Resume: clears maintenance; restores previous state or ENFORCED when plan exists.
#>
param(
    [Parameter(Mandatory)][ValidateSet('Suspend', 'Resume')][string]$Action,
    [string]$ReposRoot = '',
    [Parameter(Mandatory)][switch]$ProductOwnerApproved
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not $ProductOwnerApproved) { throw 'Explicit Product Owner authorization required.' }
. (Join-Path $PSScriptRoot 'lib\MagRoutingGuard.Common.ps1')
# Explicit -ReposRoot wins over MAG_REPOS_ROOT; missing/invalid root stops before any write.
$null = Resolve-MagGuardReposRoot -ReposRoot $ReposRoot

$maintPath = Get-MagGuardMaintenancePath
$planPath = Get-MagGuardPlanPath
Ensure-MagGuardMagDir | Out-Null

if ($Action -eq 'Suspend') {
    if ((Read-MagGuardMaintenance).Active) { throw 'Maintenance already active.' }
    $plan = Read-MagGuardPlan
    $enf = Read-MagGuardEnforcementState -Plan $plan
    $prev = $enf.State
    if ($enf.Source -eq 'maintenance') { $prev = 'ENFORCED' }
    $obj = [ordered]@{
        version                     = 1
        maintenance_active          = $true
        previous_enforcement_state  = $prev
        suspended_at                = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        note                        = 'PO maintenance recovery; does not certify MODEL_MATCH; pending STOP preserved'
    }
    Write-MagGuardUtf8File -Path $maintPath -Content ($obj | ConvertTo-Json -Depth 5)
    # Preserve plan in place (do not move). Pending file untouched.
    Write-Output 'MAINTENANCE_ENTER: tool enforcement effectively SUSPENDED; plan and pending STOP preserved; section 24 agent obligations remain; no MODEL_MATCH asserted.'
}
else {
    $m = Read-MagGuardMaintenance
    if (-not $m.Active) { throw 'No active maintenance to resume.' }
    $plan = Read-MagGuardPlan
    $restore = $m.PreviousState
    if (-not $restore) {
        $restore = if ($null -ne $plan) { 'ENFORCED' } else { 'SUSPENDED' }
    }
    if (Test-Path -LiteralPath $maintPath) { Remove-Item -LiteralPath $maintPath -Force }
    Save-MagGuardEnforcementState -State $restore -Note 'maintenance_exit' | Out-Null
    Write-Output ("MAINTENANCE_EXIT: restored enforcement state={0}; pending STOP unchanged if present." -f $restore)
}
