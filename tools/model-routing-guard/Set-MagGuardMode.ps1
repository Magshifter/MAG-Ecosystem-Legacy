#Requires -Version 7.0
<#
.SYNOPSIS
  Set Runtime Enforcement State: ENFORCED | ADVISORY | SUSPENDED (§24.4).
  Legacy aliases: Pro→ENFORCED, Auto→ADVISORY, Off→SUSPENDED.
#>
param(
    [Parameter(Mandatory)]
    [ValidateSet('Enforced', 'Advisory', 'Suspended', 'Pro', 'Auto', 'Off', 'ENFORCED', 'ADVISORY', 'SUSPENDED')]
    [string]$Mode,
    [string]$ReposRoot = 'C:\laragon\repos',
    [string]$Note = '',
    [Parameter(Mandatory)][switch]$ProductOwnerApproved
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not $ProductOwnerApproved) { throw 'Explicit Product Owner authorization required.' }
$env:MAG_REPOS_ROOT = $ReposRoot.TrimEnd('\', '/')
. (Join-Path $PSScriptRoot 'lib\MagRoutingGuard.Common.ps1')
$state = ConvertTo-MagGuardEnforcementState $Mode
if (-not $state) { throw "unknown_state:$Mode" }
$info = Save-MagGuardEnforcementState -State $state -Note $Note
Write-Output ("ENFORCEMENT_STATE_SET state={0} source={1} path={2}" -f $info.State, $info.Source, (Get-MagGuardModePath))
