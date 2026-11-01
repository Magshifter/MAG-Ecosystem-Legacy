#Requires -Version 7.0
# W4 matrix for Check-MagCursorKnowledgeControl.ps1: explicit root contract and IDENTICAL/DRIFT/MISSING exit codes.
# Isolated TEMP fixtures only (path with spaces); the check is read-only and never touches production Cursor config.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$check = Join-Path $PSScriptRoot 'Check-MagCursorKnowledgeControl.ps1'
$source = Join-Path $PSScriptRoot 'mag-knowledge-control.mdc'
$sourceHash = (Get-FileHash -LiteralPath $source).Hash
$pwshExe = (Get-Process -Id $PID).Path
$base = Join-Path ([IO.Path]::GetTempPath()) ('mag-w4 cursor ' + [guid]::NewGuid().ToString('N'))
$root = Join-Path $base 'work space'
$envRoot = Join-Path $base 'env root'
$cwd = Join-Path $base 'unrelated cwd'
foreach ($d in @($root, $envRoot, $cwd)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

function Invoke-Check([string]$CheckArgs, [AllowNull()][string]$EnvRoot) {
    $psi = [Diagnostics.ProcessStartInfo]::new($pwshExe, ('-NoProfile -NonInteractive -File "{0}" {1}' -f $check, $CheckArgs))
    $psi.WorkingDirectory = $cwd
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    if ($null -eq $EnvRoot) { [void]$psi.Environment.Remove('MAG_REPOS_ROOT') } else { $psi.Environment['MAG_REPOS_ROOT'] = $EnvRoot }
    $p = [Diagnostics.Process]::Start($psi)
    $out = $p.StandardOutput.ReadToEnd(); $err = $p.StandardError.ReadToEnd(); $p.WaitForExit()
    [pscustomobject]@{ Exit = $p.ExitCode; Out = $out; Err = $err }
}
function Assert-Result($R, [int]$Code, [string]$Word, [string]$Name) {
    if ($R.Exit -ne $Code -or $R.Out -notmatch "(?m)^$Word") { throw "FAIL $Name exit=$($R.Exit) out=$($R.Out) err=$($R.Err)" }
    Write-Output "PASS $Name"
}

try {
    $rootArg = '-ReposRoot "{0}"' -f $root
    Assert-Result (Invoke-Check '' $null) 4 'INVALID_ROOT' 'T5 no root configured -> INVALID_ROOT exit 4'
    Assert-Result (Invoke-Check '-ReposRoot "relative"' $null) 4 'INVALID_ROOT' 'T5 relative root -> exit 4'
    Assert-Result (Invoke-Check ('-ReposRoot "{0}"' -f (Join-Path $base 'missing')) $null) 4 'INVALID_ROOT' 'T5 missing root -> exit 4'
    Assert-Result (Invoke-Check $rootArg $null) 3 'MISSING_DEPLOYED' 'T6 MISSING_DEPLOYED exit 3'
    $rules = Join-Path $root '.cursor\rules'
    New-Item -ItemType Directory -Force -Path $rules | Out-Null
    Copy-Item -LiteralPath $source -Destination (Join-Path $rules 'mag-knowledge-control.mdc')
    Assert-Result (Invoke-Check $rootArg $null) 0 'IDENTICAL' 'T6 IDENTICAL exit 0 (root with spaces)'
    Assert-Result (Invoke-Check $rootArg $envRoot) 0 'IDENTICAL' 'T3 explicit -ReposRoot wins over MAG_REPOS_ROOT'
    Assert-Result (Invoke-Check '' $root) 0 'IDENTICAL' 'T4 MAG_REPOS_ROOT only'
    Assert-Result (Invoke-Check '' $envRoot) 3 'MISSING_DEPLOYED' 'T4 MAG_REPOS_ROOT selects its own root'
    [IO.File]::AppendAllText((Join-Path $rules 'mag-knowledge-control.mdc'), "`n# drift")
    Assert-Result (Invoke-Check $rootArg $null) 1 'DRIFT' 'T6 DRIFT exit 1'
    if ((Get-FileHash -LiteralPath $source).Hash -ne $sourceHash) { throw 'FAIL source modified by check' }
    if (@(Get-ChildItem -LiteralPath $cwd -Force).Count -ne 0) { throw 'FAIL check wrote into CWD' }
    Write-Output 'PASS T6 read-only (source and CWD unchanged)'
    Write-Output 'ALL_CURSOR_CHECK_OK'
}
finally {
    if (Test-Path -LiteralPath $base) { Remove-Item -LiteralPath $base -Recurse -Force }
}
