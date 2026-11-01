#Requires -Version 7.0
<#
.SYNOPSIS
  Deploy MAG Model Routing Guard hooks into an explicitly configured Cursor workspace root.
.DESCRIPTION
  Source of truth: MAG-Ecosystem/tools/model-routing-guard/
  Deployed: <ReposRoot>\.cursor\hooks.json + <ReposRoot>\.cursor\hooks\model-routing-guard\*
  Root: explicit -ReposRoot wins over MAG_REPOS_ROOT; neither set, relative, volume root, or missing directory -> stop before writes.
  hooks.json commands carry the absolute hook path and -ReposRoot so hooks do not depend on process CWD.
  Direction: source → deployed only. Not documentation SYNC. Not authority.
#>
param(
    [string]$ReposRoot = '',
    [switch]$WhatIf
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# When script lives in tools/model-routing-guard/
$srcRoot = $PSScriptRoot
. (Join-Path $srcRoot 'lib\MagRoutingGuard.Common.ps1')
$ReposRoot = Resolve-MagGuardReposRoot -ReposRoot $ReposRoot
# The root is embedded in hooks.json commands; reject characters a hook shell could reinterpret.
if ($ReposRoot -match '["%$`]') { throw "repos_root_unsafe_for_hook_command:$ReposRoot" }

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
Write-Output "repos_root=$ReposRoot"
Write-Output "deploy_hooks_dir=$hooksDir"
Write-Output "deploy_hooks_json=$hooksJson"

# Validate targets and compute the merged hooks.json before any filesystem write.
foreach ($dir in @($cursorDir, (Join-Path $cursorDir 'hooks'), $hooksDir)) {
    if ((Test-Path -LiteralPath $dir) -and -not (Test-Path -LiteralPath $dir -PathType Container)) { throw "deploy_target_not_directory:$dir" }
}
if ((Test-Path -LiteralPath $hooksJson) -and -not (Test-Path -LiteralPath $hooksJson -PathType Leaf)) { throw "hooks_json_not_file:$hooksJson" }

$tpl = Get-Content -LiteralPath $template -Raw | ConvertFrom-Json
# Absolute hook path + explicit -ReposRoot: independent of the CWD Cursor launches hooks from.
foreach ($name in @('sessionStart', 'beforeSubmitPrompt', 'preCompact')) {
    $hookPath = Join-Path $hooksDir ("hooks\{0}.ps1" -f $name)
    $tpl.hooks.$name[0].command = ('pwsh -NoProfile -File "{0}" -ReposRoot "{1}"' -f $hookPath, $ReposRoot)
}

if (Test-Path -LiteralPath $hooksJson) {
    try { $existing = Get-Content -LiteralPath $hooksJson -Raw | ConvertFrom-Json }
    catch { throw "hooks_json_invalid:$hooksJson :: $($_.Exception.Message)" }
    if ($existing -isnot [pscustomobject]) { throw "hooks_json_not_object:$hooksJson" }
    if (-not $existing.PSObject.Properties['hooks']) {
        $existing | Add-Member -NotePropertyName hooks -NotePropertyValue ([pscustomobject]@{}) -Force
    }
    $h = $existing.hooks
    if ($h -isnot [pscustomobject]) { throw "hooks_json_hooks_not_object:$hooksJson" }
    foreach ($name in @('sessionStart', 'beforeSubmitPrompt', 'preCompact')) {
        $cmd = $tpl.hooks.$name[0].command
        $entry = [pscustomobject]@{ command = $cmd }
        # replace prior guard entries for this event; keep others
        $list = [System.Collections.Generic.List[object]]::new()
        if ($h.PSObject.Properties[$name] -and $h.$name) {
            foreach ($item in @($h.$name)) {
                $c = if ($item -is [pscustomobject] -and $item.PSObject.Properties['command']) { [string]$item.command } else { '' }
                if ($c -match 'model-routing-guard') { continue }
                $list.Add($item)
            }
        }
        $list.Add($entry)
        $h | Add-Member -NotePropertyName $name -NotePropertyValue $list.ToArray() -Force
    }
    $existing | Add-Member -NotePropertyName version -NotePropertyValue 1 -Force
    $out = $existing | ConvertTo-Json -Depth 10
}
else {
    $out = $tpl | ConvertTo-Json -Depth 10
}

if ($WhatIf) { exit 0 }

New-Item -ItemType Directory -Force -Path (Join-Path $hooksDir 'lib') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $hooksDir 'hooks') | Out-Null

Copy-Item -LiteralPath (Join-Path $srcRoot 'lib\MagRoutingGuard.Common.ps1') -Destination (Join-Path $hooksDir 'lib\MagRoutingGuard.Common.ps1') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'hooks\beforeSubmitPrompt.ps1') -Destination (Join-Path $hooksDir 'hooks\beforeSubmitPrompt.ps1') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'hooks\sessionStart.ps1') -Destination (Join-Path $hooksDir 'hooks\sessionStart.ps1') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'hooks\preCompact.ps1') -Destination (Join-Path $hooksDir 'hooks\preCompact.ps1') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'capability-mapping.json') -Destination (Join-Path $hooksDir 'capability-mapping.json') -Force
Copy-Item -LiteralPath (Join-Path $srcRoot 'enforcement-contract.v1.json') -Destination (Join-Path $hooksDir 'enforcement-contract.v1.json') -Force

$utf8 = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($hooksJson, $out + "`n", $utf8)
Write-Output 'DEPLOY_OK'
