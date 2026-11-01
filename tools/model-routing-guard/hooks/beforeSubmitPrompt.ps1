#Requires -Version 7.0
# -ReposRoot is written into hooks.json by Deploy-MagModelRoutingGuard.ps1 so the hook does not depend on process CWD.
param([string]$ReposRoot = '')
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path $PSScriptRoot -Parent) 'lib\MagRoutingGuard.Common.ps1')
$null = Resolve-MagGuardReposRoot -ReposRoot $ReposRoot

$inputObj = Read-MagGuardStdinJson
$planPath = Get-MagGuardPlanPath
$plan = Read-MagGuardPlan -Path $planPath
$decision = Resolve-MagGuardDecision -Plan $plan -HookInput $inputObj -HookName 'beforeSubmitPrompt' -PlanPath $planPath
try { Write-MagGuardObservationDiagnostic -HookInput $inputObj -Decision $decision -HookName 'beforeSubmitPrompt' } catch { }
$observed = Get-MagGuardObservedModelId -HookInput $inputObj
$cv = ''
try { $cv = [string](Read-MagGuardContract).contract_version } catch { }
try {
    Write-MagGuardEvidence -Plan $plan -ObservedModelId $observed -Signal $decision.Signal -Action $decision.Action -Note $decision.Message -ContractVersion $cv
} catch { }

Emit-MagGuardHookResponse -Continue:([bool]$decision.Continue) -UserMessage ([string]$decision.Message)
exit 0
