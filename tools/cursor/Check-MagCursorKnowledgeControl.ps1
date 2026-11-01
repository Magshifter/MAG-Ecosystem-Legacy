#Requires -Version 7.0
# Read-only drift check: tracked source -> deployed copy under <ReposRoot>\.cursor\rules\.
# Workspace root: explicit -ReposRoot wins over MAG_REPOS_ROOT; no silent default (W4).
param(
    [string]$ReposRoot = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
# Diagnostics go to stderr directly: Write-Error under 'Stop' would terminate with exit 1 and mask exit codes 2/3/4.

$here = $PSScriptRoot
$ecosystem = (Get-Item -LiteralPath $here).Parent.Parent.FullName
$source = Join-Path $here 'mag-knowledge-control.mdc'

$rootCandidate = if (-not [string]::IsNullOrWhiteSpace($ReposRoot)) { $ReposRoot }
    elseif (-not [string]::IsNullOrWhiteSpace($env:MAG_REPOS_ROOT)) { $env:MAG_REPOS_ROOT }
    else { $null }
if ($null -eq $rootCandidate) {
    Write-Output 'INVALID_ROOT'
    [Console]::Error.WriteLine('repos_root_not_configured: pass -ReposRoot or set MAG_REPOS_ROOT')
    exit 4
}
$rootCandidate = $rootCandidate.Trim()
if (-not [System.IO.Path]::IsPathFullyQualified($rootCandidate) -or -not (Test-Path -LiteralPath $rootCandidate -PathType Container)) {
    Write-Output 'INVALID_ROOT'
    [Console]::Error.WriteLine("repos_root_invalid:$rootCandidate")
    exit 4
}
$deployed = Join-Path ([System.IO.Path]::GetFullPath($rootCandidate)) '.cursor\rules\mag-knowledge-control.mdc'

function Get-Sha256Hex {
    param([Parameter(Mandatory)][string]$Path)
    $bytes = [IO.File]::ReadAllBytes($Path)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        return ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '').ToLowerInvariant()
    }
    finally {
        $sha.Dispose()
    }
}

if (-not (Test-Path -LiteralPath $source)) {
    Write-Output 'MISSING_SOURCE'
    [Console]::Error.WriteLine("missing_source:$source")
    exit 2
}
if (-not (Test-Path -LiteralPath $deployed)) {
    Write-Output 'MISSING_DEPLOYED'
    [Console]::Error.WriteLine("missing_deployed:$deployed")
    exit 3
}

$srcBytes = [IO.File]::ReadAllBytes($source)
$depBytes = [IO.File]::ReadAllBytes($deployed)
$srcSha = Get-Sha256Hex -Path $source
$depSha = Get-Sha256Hex -Path $deployed

if ($srcBytes.Length -eq $depBytes.Length -and $srcSha -eq $depSha) {
    $identical = $true
    for ($i = 0; $i -lt $srcBytes.Length; $i++) {
        if ($srcBytes[$i] -ne $depBytes[$i]) {
            $identical = $false
            break
        }
    }
    if ($identical) {
        Write-Output "IDENTICAL sha256=$srcSha"
        exit 0
    }
}

Write-Output "DRIFT source_sha256=$srcSha deployed_sha256=$depSha"
exit 1
