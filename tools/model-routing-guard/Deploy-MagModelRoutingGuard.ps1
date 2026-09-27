#Requires -Version 7.0
<#
.SYNOPSIS
  Deploy MAG Model Routing Guard hooks into the Laragon multi-repo workspace Cursor config.
.DESCRIPTION
  Source of truth: MAG-Ecosystem/tools/model-routing-guard/
  Deployed: C:\laragon\repos\.cursor\hooks.json + hooks/model-routing-guard/*
  Direction: source → deployed only. Not documentation SYNC. Not authority.
#>
param(
    [string]$ReposRoot = 'C:\laragon\repos',
    [switch]$WhatIf
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# When script lives in tools/model-routing-guard/
$srcRoot = $PSScriptRoot

$cursorDir = Join-Path $ReposRoot '.cursor'
$hooksDir = Join-Path $cursorDir 'hooks\model-routing-guard'
$hooksJson = Join-Path $cursorDir 'hooks.json'
$template = Join-Path $srcRoot 'hooks.json.template'

$files = @(
    'lib\MagRoutingGuard.Common.ps1',
    'hooks\beforeSubmitPrompt.ps1',
    'hooks\sessionStart.ps1',
    'hooks\preCompact.ps1',
    'capability-mapping.json',
    'enforcement-contract.v1.json'
)

Write-Output "source=$srcRoot"
Write-Output "deploy_hooks_dir=$hooksDir"
Write-Output "deploy_hooks_json=$hooksJson"

if ($WhatIf) { exit 0 }

New-Item -ItemType Directory -Force -Path (Join-Path $hooksDir 'lib') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $hooksDir 'hooks') | Out-Null

Copy-Item -LiteralPath (Join-Path $srcRoot 'lib\MagRoutingGuard.Common.ps1') -Destination (Join-Path $hooksDir 'lib\MagRoutingGuard.Common.ps1') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'hooks\beforeSubmitPrompt.ps1') -Destination (Join-Path $hooksDir 'hooks\beforeSubmitPrompt.ps1') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'hooks\sessionStart.ps1') -Destination (Join-Path $hooksDir 'hooks\sessionStart.ps1') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'hooks\preCompact.ps1') -Destination (Join-Path $hooksDir 'hooks\preCompact.ps1') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'capability-mapping.json') -Destination (Join-Path $hooksDir 'capability-mapping.json') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'enforcement-contract.v1.json') -Destination (Join-Path $hooksDir 'enforcement-contract.v1.json') -Force

$tpl = Get-Content -LiteralPath $template -Raw | ConvertFrom-Json
# Rewrite commands to absolute-ish workspace-relative paths from repos root
$tpl.hooks.sessionStart[0].command = 'pwsh -NoProfile -File "./.cursor/hooks/model-routing-guard/hooks/sessionStart.ps1"'
$tpl.hooks.beforeSubmitPrompt[0].command = 'pwsh -NoProfile -File "./.cursor/hooks/model-routing-guard/hooks/beforeSubmitPrompt.ps1"'
$tpl.hooks.preCompact[0].command = 'pwsh -NoProfile -File "./.cursor/hooks/model-routing-guard/hooks/preCompact.ps1"'

if (Test-Path -LiteralPath $hooksJson) {
    $existing = Get-Content -LiteralPath $hooksJson -Raw | ConvertFrom-Json
    if (-not $existing.PSObject.Properties['hooks']) {
        $existing | Add-Member -NotePropertyName hooks -NotePropertyValue ([pscustomobject]@{}) -Force
    }
    $h = $existing.hooks
    foreach ($name in @('sessionStart', 'beforeSubmitPrompt', 'preCompact')) {
        $cmd = $tpl.hooks.$name[0].command
        $entry = [pscustomobject]@{ command = $cmd }
        # replace prior guard entries for this event; keep others
        $list = [System.Collections.Generic.List[object]]::new()
        if ($h.PSObject.Properties[$name] -and $h.$name) {
            foreach ($item in @($h.$name)) {
                $c = [string]$item.command
                if ($c -match 'model-routing-guard') { continue }
                $list.Add($item)
            }
        }
        $list.Add($entry)
        $h | Add-Member -NotePropertyName $name -NotePropertyValue $list.ToArray() -Force
    }
    $existing.version = 1
    $out = $existing | ConvertTo-Json -Depth 10
}
else {
    $out = $tpl | ConvertTo-Json -Depth 10
}

$utf8 = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($hooksJson, $out + "`n", $utf8)
Write-Output 'DEPLOY_OK'
