#Requires -Version 7.0
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$here = $PSScriptRoot
$ecosystem = (Get-Item -LiteralPath $here).Parent.Parent.FullName
$source = Join-Path $here 'mag-knowledge-control.mdc'
$deployed = 'C:\laragon\repos\.cursor\rules\mag-knowledge-control.mdc'

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
    Write-Error "missing_source:$source"
    exit 2
}
if (-not (Test-Path -LiteralPath $deployed)) {
    Write-Output 'MISSING_DEPLOYED'
    Write-Error "missing_deployed:$deployed"
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
