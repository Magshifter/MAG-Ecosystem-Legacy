#Requires -Version 7.0
# -ReposRoot is written into hooks.json by Deploy-MagModelRoutingGuard.ps1 so the hook does not depend on process CWD.
param([string]$ReposRoot = '')
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path $PSScriptRoot -Parent) 'lib\MagRoutingGuard.Common.ps1')
$null = Resolve-MagGuardReposRoot -ReposRoot $ReposRoot

$inputObj = Read-MagGuardStdinJson
$plan = Read-MagGuardPlan
$decision = Resolve-MagGuardDecision -Plan $plan -HookInput $inputObj -HookName 'preCompact'
$observed = Get-MagGuardObservedModelId -HookInput $inputObj
Write-MagGuardEvidence -Plan $plan -ObservedModelId $observed -Signal 'CONTEXT_WARNING' -Action 'WARN' -Note 'preCompact'
# preCompact is observational in v1 — do not block
Write-Output '{}'
exit 0
