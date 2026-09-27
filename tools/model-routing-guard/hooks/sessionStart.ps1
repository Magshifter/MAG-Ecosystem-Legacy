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
$mode = Read-MagGuardMode
$observed = ''
$note = ("sessionStart mode={0} source={1} enforce={2} expired={3}" -f $mode.Mode, $mode.Source, $mode.EnforceStops, $mode.Expired)
$signal = if ($mode.Expired) { 'MODE_EXPIRED' } elseif ($mode.EnforceStops) { 'SESSION_START' } else { $mode.Mode.ToUpperInvariant() }
Write-MagGuardEvidence -Plan $plan -ObservedModelId $observed -Signal $signal -Action 'CONTINUE' -Note $note

$ctx = $null
if ($mode.Expired -or $mode.NeedsChoice) {
    $ctx = 'MAG Model Routing Guard: Auto 24h window ended. FIRST ask Product Owner which mode to continue: Guard Pro (STOP+propose on), Guard Auto (another 24h, no proposals), or Guard Off (off until explicit enable). Do not continue substantive work until they answer.'
}
elseif ($mode.Source -eq 'default') {
    $ctx = 'MAG Model Routing Guard: mode unset → treating as Auto (no STOP proposals). Prefer asking Product Owner: Guard Pro / Guard Auto / Guard Off.'
}
elseif ($mode.Mode -eq 'auto') {
    $ctx = 'MAG Model Routing Guard: Auto mode — STOP+propose disabled (no model picker). Window 24h; after expiry you must ask mode again.'
}
elseif ($mode.Mode -eq 'off') {
    $ctx = 'MAG Model Routing Guard: Off — STOP+propose disabled until Product Owner enables Pro or Auto.'
}

if ($ctx) {
    $out = [ordered]@{ additional_context = $ctx }
    Write-Output (($out | ConvertTo-Json -Compress))
}
else {
    Write-Output '{}'
}
exit 0
