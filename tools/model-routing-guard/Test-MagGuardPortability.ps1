#Requires -Version 7.0
# W4 portability matrix for Model Routing Guard: explicit workspace root contract, deploy, hooks.json merge,
# hook execution from an unrelated CWD, mode/maintenance state. Isolated TEMP fixtures only (path with spaces);
# never touches a production Cursor workspace. Decision algorithm coverage stays in Test-GuardRecovery.ps1.
param([string]$GuardRoot = $PSScriptRoot)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$GuardRoot = (Resolve-Path -LiteralPath $GuardRoot).Path
$base = Join-Path ([IO.Path]::GetTempPath()) ('mag-w4 guard ' + [guid]::NewGuid().ToString('N'))
$rootA = Join-Path $base 'work space A'      # arbitrary root without Laragon, contains spaces
$rootEnv = Join-Path $base 'env root'        # root supplied only through MAG_REPOS_ROOT
$decoy = Join-Path $base 'decoy root'        # MAG_REPOS_ROOT decoy when -ReposRoot is explicit
$rootBad = Join-Path $base 'bad json root'
$cwd = Join-Path $base 'unrelated cwd'
foreach ($d in @($rootA, $rootEnv, $decoy, $rootBad, $cwd)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
$deploy = Join-Path $GuardRoot 'Deploy-MagModelRoutingGuard.ps1'
$setMode = Join-Path $GuardRoot 'Set-MagGuardMode.ps1'
$setMaint = Join-Path $GuardRoot 'Set-MagGuardMaintenance.ps1'
$pwshExe = (Get-Process -Id $PID).Path

function Invoke-Proc {
    param([string]$File, [string]$Arguments, [AllowNull()][string]$EnvRoot, [string]$WorkDir = $cwd, [string]$StdIn = '')
    $psi = [Diagnostics.ProcessStartInfo]::new($File, $Arguments)
    $psi.WorkingDirectory = $WorkDir
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    if ($null -eq $EnvRoot) { [void]$psi.Environment.Remove('MAG_REPOS_ROOT') } else { $psi.Environment['MAG_REPOS_ROOT'] = $EnvRoot }
    $p = [Diagnostics.Process]::Start($psi)
    $p.StandardInput.Write($StdIn); $p.StandardInput.Close()
    $out = $p.StandardOutput.ReadToEnd(); $err = $p.StandardError.ReadToEnd(); $p.WaitForExit()
    [pscustomobject]@{ Exit = $p.ExitCode; Out = $out; Err = $err }
}
function Invoke-Script([string]$Script, [string]$ScriptArgs, [AllowNull()][string]$EnvRoot, [string]$WorkDir = $cwd, [string]$StdIn = '') {
    Invoke-Proc -File $pwshExe -Arguments ('-NoProfile -NonInteractive -File "{0}" {1}' -f $Script, $ScriptArgs) -EnvRoot $EnvRoot -WorkDir $WorkDir -StdIn $StdIn
}
function Invoke-HookCommand([string]$Command, [AllowNull()][string]$EnvRoot, [string]$StdIn) {
    # Run the exact hooks.json command line through cmd.exe from the unrelated CWD.
    Invoke-Proc -File 'cmd.exe' -Arguments ('/d /s /c "{0}"' -f $Command) -EnvRoot $EnvRoot -WorkDir $cwd -StdIn $StdIn
}
function Get-Snapshot([string]$Path) {
    @(Get-ChildItem -LiteralPath $Path -Recurse -Force | ForEach-Object {
        if ($_.PSIsContainer) { "D $($_.FullName)" } else { "F $($_.FullName) $((Get-FileHash -LiteralPath $_.FullName).Hash)" }
    }) -join "`n"
}
function Assert-True([bool]$Cond, [string]$Name, [string]$Detail = '') {
    if (-not $Cond) { throw "FAIL $Name $Detail" }
    Write-Output "PASS $Name"
}
function Get-Hooks([string]$Root) { Get-Content -LiteralPath (Join-Path $Root '.cursor\hooks.json') -Raw | ConvertFrom-Json }
function Get-GuardCount($Hooks, [string]$Event) { @(@($Hooks.hooks.$Event) | Where-Object { [string]$_.command -match 'model-routing-guard' }).Count }

try {
    # ---- T5: missing / invalid root fails before any write
    $snap = Get-Snapshot $base
    $r = Invoke-Script $deploy '' $null
    Assert-True ($r.Exit -ne 0 -and $r.Err -match 'repos_root_not_configured') 'T5 deploy no root rejected' $r.Err
    $r = Invoke-Script $deploy '-ReposRoot "relative root"' $null
    Assert-True ($r.Exit -ne 0 -and $r.Err -match 'repos_root_not_absolute') 'T5 deploy relative root rejected' $r.Err
    $r = Invoke-Script $deploy ('-ReposRoot "{0}"' -f (Join-Path $base 'missing root')) $null
    Assert-True ($r.Exit -ne 0 -and $r.Err -match 'repos_root_not_found') 'T5 deploy missing directory rejected' $r.Err
    $r = Invoke-Script $setMode '-Mode Enforced -ProductOwnerApproved' $null
    Assert-True ($r.Exit -ne 0 -and $r.Err -match 'repos_root_not_configured') 'T5 mode no root rejected' $r.Err
    $r = Invoke-Script $setMaint '-Action Suspend -ProductOwnerApproved' $null
    Assert-True ($r.Exit -ne 0 -and $r.Err -match 'repos_root_not_configured') 'T5 maintenance no root rejected' $r.Err
    $r = Invoke-Script (Join-Path $GuardRoot 'hooks\sessionStart.ps1') '' $null -StdIn '{}'
    Assert-True ($r.Exit -ne 0 -and $r.Err -match 'repos_root_not_configured') 'T5 hook no root rejected' $r.Err
    Assert-True ((Get-Snapshot $base) -eq $snap) 'T5 no filesystem writes on missing/invalid root'
    New-Item -ItemType Directory -Force -Path (Join-Path $rootBad '.cursor') | Out-Null
    [IO.File]::WriteAllText((Join-Path $rootBad '.cursor\hooks.json'), '{ not json')
    $snap = Get-Snapshot $base
    $r = Invoke-Script $deploy ('-ReposRoot "{0}"' -f $rootBad) $null
    Assert-True ($r.Exit -ne 0 -and $r.Err -match 'hooks_json_invalid') 'T5 invalid hooks.json rejected' $r.Err
    [IO.File]::WriteAllText((Join-Path $rootBad '.cursor\hooks.json'), '{ "version": 1, "hooks": [] }')
    $snap = Get-Snapshot $base
    $r = Invoke-Script $deploy ('-ReposRoot "{0}"' -f $rootBad) $null
    Assert-True ($r.Exit -ne 0 -and $r.Err -match 'hooks_json_hooks_not_object') 'T5 non-object hooks rejected' $r.Err
    Assert-True ((Get-Snapshot $base) -eq $snap) 'T5 no filesystem writes on rejection'
    $r = Invoke-Script $setMode ('-Mode Enforced -ReposRoot "{0}"' -f $rootA) $null
    Assert-True ($r.Exit -ne 0 -and -not (Test-Path -LiteralPath (Join-Path $rootA '.mag'))) 'T12 mode requires -ProductOwnerApproved (no write)'

    # ---- T9 seed: unrelated hooks + settings + legacy relative Guard entry
    New-Item -ItemType Directory -Force -Path (Join-Path $rootA '.cursor') | Out-Null
    $seed = @'
{
  "version": 1,
  "someSetting": { "keep": true, "n": 7 },
  "hooks": {
    "sessionStart": [ { "command": "echo other-start" } ],
    "beforeSubmitPrompt": [
      { "command": "echo other-submit", "timeout": 5 },
      { "command": "pwsh -NoProfile -File \"./.cursor/hooks/model-routing-guard/hooks/beforeSubmitPrompt.ps1\"" }
    ],
    "afterFileEdit": [ { "command": "echo edit" } ]
  }
}
'@
    [IO.File]::WriteAllText((Join-Path $rootA '.cursor\hooks.json'), $seed)

    # ---- T1/T2/T3/T7: explicit -ReposRoot (spaces, no Laragon) wins over MAG_REPOS_ROOT decoy
    $decoySnap = Get-Snapshot $decoy
    $r = Invoke-Script $deploy ('-ReposRoot "{0}"' -f $rootA) $decoy
    Assert-True ($r.Exit -eq 0 -and $r.Out -match 'DEPLOY_OK') 'T3 deploy with explicit -ReposRoot' $r.Err
    Assert-True ((Get-Snapshot $decoy) -eq $decoySnap) 'T3 MAG_REPOS_ROOT decoy untouched (explicit wins)'
    Assert-True ($rootA -match ' ' -and $rootA -notmatch 'laragon') 'T1/T2 root has spaces and no Laragon'
    $dep = Join-Path $rootA '.cursor\hooks\model-routing-guard'
    foreach ($f in @('lib\MagRoutingGuard.Common.ps1', 'hooks\beforeSubmitPrompt.ps1', 'hooks\sessionStart.ps1', 'hooks\preCompact.ps1', 'capability-mapping.json', 'enforcement-contract.v1.json')) {
        $same = (Get-FileHash -LiteralPath (Join-Path $GuardRoot $f)).Hash -eq (Get-FileHash -LiteralPath (Join-Path $dep $f)).Hash
        Assert-True $same "T7 deployed $f equals source"
    }
    $hk = Get-Hooks $rootA
    foreach ($ev in @('sessionStart', 'beforeSubmitPrompt', 'preCompact')) {
        $g = @(@($hk.hooks.$ev) | Where-Object { [string]$_.command -match 'model-routing-guard' })
        $expected = 'pwsh -NoProfile -File "{0}" -ReposRoot "{1}"' -f (Join-Path $dep "hooks\$ev.ps1"), $rootA
        Assert-True ($g.Count -eq 1 -and [string]$g[0].command -eq $expected) "T7 $ev command absolute with -ReposRoot" ([string]($g | ConvertTo-Json -Compress))
    }

    # ---- T9: unrelated entries / settings preserved
    Assert-True ($hk.someSetting.keep -eq $true -and $hk.someSetting.n -eq 7) 'T9 unrelated top-level setting preserved'
    Assert-True (@($hk.hooks.afterFileEdit).Count -eq 1 -and $hk.hooks.afterFileEdit[0].command -eq 'echo edit') 'T9 unrelated event preserved'
    Assert-True ($hk.hooks.sessionStart[0].command -eq 'echo other-start') 'T9 unrelated sessionStart entry preserved'
    Assert-True ($hk.hooks.beforeSubmitPrompt[0].command -eq 'echo other-submit' -and $hk.hooks.beforeSubmitPrompt[0].timeout -eq 5) 'T9 unrelated beforeSubmitPrompt entry preserved'

    # ---- T10: legacy Guard entry replaced; re-deploy idempotent, no duplicates
    $first = Get-Content -LiteralPath (Join-Path $rootA '.cursor\hooks.json') -Raw
    $r = Invoke-Script $deploy ('-ReposRoot "{0}"' -f $rootA) $null
    Assert-True ($r.Exit -eq 0) 'T10 redeploy ok' $r.Err
    $second = Get-Content -LiteralPath (Join-Path $rootA '.cursor\hooks.json') -Raw
    $hk = Get-Hooks $rootA
    foreach ($ev in @('sessionStart', 'beforeSubmitPrompt', 'preCompact')) { Assert-True ((Get-GuardCount $hk $ev) -eq 1) "T10 $ev single Guard entry" }
    Assert-True (@($hk.hooks.beforeSubmitPrompt).Count -eq 2) 'T10 legacy relative Guard entry replaced'
    Assert-True ($first -eq $second) 'T10 redeploy idempotent'

    # ---- T4: MAG_REPOS_ROOT only
    $r = Invoke-Script $deploy '' $rootEnv
    Assert-True ($r.Exit -eq 0 -and (Test-Path -LiteralPath (Join-Path $rootEnv '.cursor\hooks\model-routing-guard\hooks\sessionStart.ps1'))) 'T4 deploy via MAG_REPOS_ROOT' $r.Err
    Assert-True ((Get-Hooks $rootEnv).hooks.sessionStart[0].command -match [regex]::Escape("-ReposRoot `"$rootEnv`"")) 'T4 hooks.json pins env root'
    $r = Invoke-Script $deploy '-WhatIf' $rootEnv
    Assert-True ($r.Exit -eq 0 -and $r.Out -match [regex]::Escape("repos_root=$rootEnv")) 'T4 WhatIf resolves env root'

    # ---- T8: exact hooks.json command from unrelated CWD, decoy MAG_REPOS_ROOT
    $hk = Get-Hooks $rootA
    $cmdStart = [string](@($hk.hooks.sessionStart) | Where-Object { $_.command -match 'model-routing-guard' })[0].command
    $cmdSubmit = [string](@($hk.hooks.beforeSubmitPrompt) | Where-Object { $_.command -match 'model-routing-guard' })[0].command
    $cmdCompact = [string](@($hk.hooks.preCompact) | Where-Object { $_.command -match 'model-routing-guard' })[0].command
    $decoySnap = Get-Snapshot $decoy
    $r = Invoke-HookCommand $cmdStart $decoy '{}'
    Assert-True ($r.Exit -eq 0 -and $r.Out -match 'INERT') 'T8 sessionStart from unrelated CWD (no plan -> INERT)' ($r.Out + $r.Err)
    $ev = Join-Path $rootA '.mag\routing-evidence.jsonl'
    Assert-True (Test-Path -LiteralPath $ev) 'T8 evidence written under configured root'
    Assert-True ((Get-Snapshot $decoy) -eq $decoySnap -and @(Get-ChildItem -LiteralPath $cwd -Force).Count -eq 0) 'T8 decoy root and CWD untouched'
    $r = Invoke-HookCommand $cmdSubmit $null '{"model":"composer-2.5"}'
    Assert-True ($r.Exit -eq 0 -and ($r.Out | ConvertFrom-Json).continue -eq $true) 'T11 inert hook continue (no plan)' $r.Out
    $r = Invoke-HookCommand $cmdCompact $null '{}'
    Assert-True ($r.Exit -eq 0 -and $r.Out.Trim() -eq '{}') 'T8 preCompact observational'

    # ---- T11: match / mismatch through the deployed hook (decision algorithm unchanged)
    Copy-Item -LiteralPath (Join-Path $GuardRoot 'examples\routing-plan.example.json') -Destination (Join-Path $rootA '.mag\routing-plan.json')
    $r = Invoke-HookCommand $cmdSubmit $decoy '{"model":"composer-2.5"}'
    Assert-True ($r.Exit -eq 0 -and ($r.Out | ConvertFrom-Json).continue -eq $true) 'T11 deployed hook MODEL_MATCH continue' $r.Out
    $r = Invoke-HookCommand $cmdSubmit $decoy '{"model":"grok-4.7-high"}'
    Assert-True ($r.Exit -eq 0 -and ($r.Out | ConvertFrom-Json).continue -eq $false) 'T11 deployed hook MODEL_MISMATCH stop' $r.Out
    $pending = Join-Path $rootA '.mag\routing-pending.json'
    Assert-True (Test-Path -LiteralPath $pending) 'T11 pending STOP recorded under configured root'
    Assert-True ((Get-Snapshot $decoy) -eq $decoySnap) 'T11 decoy root untouched'

    # ---- T12: mode + maintenance under explicit root; plan and pending preserved
    $planHash = (Get-FileHash -LiteralPath (Join-Path $rootA '.mag\routing-plan.json')).Hash
    $pendHash = (Get-FileHash -LiteralPath $pending).Hash
    $r = Invoke-Script $setMode ('-Mode Advisory -ReposRoot "{0}" -ProductOwnerApproved' -f $rootA) $decoy
    $state = Get-Content -LiteralPath (Join-Path $rootA '.mag\routing-enforcement-state.json') -Raw | ConvertFrom-Json
    Assert-True ($r.Exit -eq 0 -and $state.state -eq 'ADVISORY') 'T12 mode ADVISORY written to explicit root' $r.Err
    $r = Invoke-Script $setMaint ('-Action Suspend -ReposRoot "{0}" -ProductOwnerApproved' -f $rootA) $decoy
    Assert-True ($r.Exit -eq 0 -and (Test-Path -LiteralPath (Join-Path $rootA '.mag\routing-maintenance.json'))) 'T12 maintenance suspend under explicit root' $r.Err
    $r = Invoke-HookCommand $cmdStart $null '{}'
    Assert-True ($r.Out -match 'MAINTENANCE active') 'T12 hook sees maintenance' $r.Out
    $r = Invoke-Script $setMaint '-Action Resume -ProductOwnerApproved' $rootA
    $state = Get-Content -LiteralPath (Join-Path $rootA '.mag\routing-enforcement-state.json') -Raw | ConvertFrom-Json
    Assert-True ($r.Exit -eq 0 -and $state.state -eq 'ADVISORY' -and -not (Test-Path -LiteralPath (Join-Path $rootA '.mag\routing-maintenance.json'))) 'T12 resume via MAG_REPOS_ROOT restores ADVISORY' $r.Err
    Assert-True ((Get-FileHash -LiteralPath (Join-Path $rootA '.mag\routing-plan.json')).Hash -eq $planHash -and (Get-FileHash -LiteralPath $pending).Hash -eq $pendHash) 'T12 plan and pending STOP preserved'
    Assert-True ((Get-Snapshot $decoy) -eq $decoySnap) 'T12 decoy root untouched'

    Write-Output 'ALL_PORTABILITY_OK'
}
finally {
    if (Test-Path -LiteralPath $base) { Remove-Item -LiteralPath $base -Recurse -Force }
}
