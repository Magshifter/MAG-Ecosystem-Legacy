#Requires -Version 7.0
# Smoke-test Guard decisions without Cursor (stdin JSON fixture).
param(
    [ValidateSet('match', 'mismatch', 'boundary', 'inert')]
    [string]$Scenario = 'mismatch'
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
. (Join-Path $root 'lib\MagRoutingGuard.Common.ps1')

$env:MAG_REPOS_ROOT = Join-Path ([IO.Path]::GetTempPath()) ('mag-guard-test-' + [guid]::NewGuid().ToString('N'))
$mag = Join-Path (Get-MagGuardReposRoot) '.mag'
New-Item -ItemType Directory -Force -Path $mag | Out-Null
$planPath = Get-MagGuardPlanPath

switch ($Scenario) {
    'inert' {
        if (Test-Path $planPath) { Remove-Item -LiteralPath $planPath -Force }
        $hook = @{ model_id = 'composer-2.5' } | ConvertTo-Json
        $plan = $null
    }
    'match' {
        Copy-Item (Join-Path $root 'examples\routing-plan.example.json') $planPath -Force
        $plan = Read-MagGuardPlan
        $hook = @{ model_id = 'composer-2.5' } | ConvertTo-Json | ConvertFrom-Json
    }
    'mismatch' {
        Copy-Item (Join-Path $root 'examples\routing-plan.example.json') $planPath -Force
        $plan = Read-MagGuardPlan
        $hook = @{ model_id = 'grok-4.7-high' } | ConvertTo-Json | ConvertFrom-Json
    }
    'boundary' {
        Copy-Item (Join-Path $root 'examples\routing-plan.example.json') $planPath -Force
        $plan = Read-MagGuardPlan
        $plan | Add-Member -NotePropertyName signal -NotePropertyValue 'MODEL_BOUNDARY' -Force
        if (-not $plan.PSObject.Properties['runtime']) {
            $plan | Add-Member -NotePropertyName runtime -NotePropertyValue ([pscustomobject]@{ po_continue_ack = $false }) -Force
        }
        $plan.runtime | Add-Member -NotePropertyName po_continue_ack -NotePropertyValue $false -Force
        ($plan | ConvertTo-Json -Depth 20) | Set-Content -LiteralPath $planPath -Encoding utf8
        $plan = Read-MagGuardPlan
        $hook = @{ model_id = 'composer-2.5' } | ConvertTo-Json | ConvertFrom-Json
    }
}

if ($Scenario -eq 'inert') {
    $hookObj = @{ model_id = 'composer-2.5' } | ConvertTo-Json | ConvertFrom-Json
    $decision = Resolve-MagGuardDecision -Plan $null -HookInput $hookObj
}
else {
    $decision = Resolve-MagGuardDecision -Plan $plan -HookInput $hook
}

Write-Output ("scenario={0} signal={1} action={2} continue={3}" -f $Scenario, $decision.Signal, $decision.Action, $decision.Continue)
if ($decision.Message) { Write-Output ("message={0}" -f $decision.Message) }
if ($Scenario -eq 'mismatch' -and $decision.Continue) { throw 'expected_stop_on_mismatch' }
if ($Scenario -eq 'match' -and -not $decision.Continue) { throw 'expected_continue_on_match' }
if ($Scenario -eq 'boundary' -and $decision.Continue) { throw 'expected_stop_on_boundary' }
if ($Scenario -eq 'inert' -and -not $decision.Continue) { throw 'expected_inert_continue' }
Write-Output 'SMOKE_OK'
