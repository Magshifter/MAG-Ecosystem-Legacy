#Requires -Version 7.0
param(
    [Parameter(Mandatory)][ValidateSet('Suspend','Resume')][string]$Action,
    [string]$ReposRoot = 'C:\laragon\repos',
    [Parameter(Mandatory)][switch]$ProductOwnerApproved
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not $ProductOwnerApproved) { throw 'Explicit Product Owner authorization required.' }
$plan = Join-Path $ReposRoot '.mag\routing-plan.json'
$saved = Join-Path $ReposRoot '.mag\routing-plan.maintenance.json'
if ($Action -eq 'Suspend') {
    if (Test-Path -LiteralPath $saved) { throw 'Saved plan already exists; do not overwrite evidence.' }
    if (-not (Test-Path -LiteralPath $plan -PathType Leaf)) { throw 'No active plan to suspend.' }
    Move-Item -LiteralPath $plan -Destination $saved
    Write-Output 'MAINTENANCE: plan preserved; Guard INERT. Routing is not authorized during repair.'
} else {
    if (Test-Path -LiteralPath $plan) { throw 'Active plan already exists; do not overwrite it.' }
    if (-not (Test-Path -LiteralPath $saved -PathType Leaf)) { throw 'No maintenance plan to restore.' }
    Move-Item -LiteralPath $saved -Destination $plan
    Write-Output 'NORMAL: plan restored; normal fail-closed enforcement applies.'
}
