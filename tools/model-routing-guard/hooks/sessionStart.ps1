#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path $PSScriptRoot -Parent) 'lib\MagRoutingGuard.Common.ps1')

# sessionStart: ensure .mag exists; load plan if present; evidence breadcrumb only.
$root = Get-MagGuardReposRoot
$magDir = Join-Path $root '.mag'
if (-not (Test-Path -LiteralPath $magDir)) {
    New-Item -ItemType Directory -Force -Path $magDir | Out-Null
}
$plan = Read-MagGuardPlan
$observed = ''
Write-MagGuardEvidence -Plan $plan -ObservedModelId $observed -Signal $(if ($plan) { 'SESSION_START' } else { 'INERT' }) -Action 'CONTINUE' -Note 'sessionStart'
# sessionStart typically expects empty / permissive output
Write-Output '{}'
exit 0
