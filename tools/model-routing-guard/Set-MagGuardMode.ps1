#Requires -Version 7.0
<#
.SYNOPSIS
  Set MAG Model Routing Guard operating mode: Pro (STOP+propose), Auto (no proposals), Off (forced off).
#>
param(
    [Parameter(Mandatory)][ValidateSet('Pro', 'Auto', 'Off')][string]$Mode,
    [int]$DurationHours = -1,
    [string]$ReposRoot = 'C:\laragon\repos',
    [string]$Note = '',
    [Parameter(Mandatory)][switch]$ProductOwnerApproved
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not $ProductOwnerApproved) { throw 'Explicit Product Owner authorization required.' }

$env:MAG_REPOS_ROOT = $ReposRoot.TrimEnd('\', '/')
. (Join-Path $PSScriptRoot 'lib\MagRoutingGuard.Common.ps1')

$normalized = $Mode.ToLowerInvariant()
if ($DurationHours -lt 0) {
    # Pro permanent; Auto 24h then must re-ask; Off until explicit change.
    $DurationHours = if ($normalized -eq 'auto') { 24 } else { 0 }
}
$info = Save-MagGuardMode -Mode $normalized -DurationHours $DurationHours -Note $Note
$exp = if ($info.ExpiresAt) { $info.ExpiresAt.ToString('u') } else { 'never' }
Write-Output ("MODE_SET mode={0} enforce_stops={1} expires={2} path={3}" -f $info.Mode, $info.EnforceStops, $exp, (Get-MagGuardModePath))
