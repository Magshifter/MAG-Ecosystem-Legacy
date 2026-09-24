#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Manifest,
    [string]$Output
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lib = Join-Path $PSScriptRoot 'lib'
. (Join-Path $lib 'MarkdownHeadings.ps1')
. (Join-Path $lib 'MagKnowledge.Common.ps1')

try {
    if ([string]::IsNullOrWhiteSpace($Manifest)) {
        Write-Error 'usage: -Manifest is required'
        exit 5
    }
    $result = Invoke-MagKnowledgeGenerate -ManifestPath $Manifest -OutputPath $Output
    Write-Output "OK units=$($result.UnitCount) sources=$($result.SourceCount) output=$($result.Output)"
    exit 0
}
catch {
    $msg = [string]$_.Exception.Message
    if ($msg -match '^(usage|path_outside)') {
        [Console]::Error.WriteLine($msg)
        exit 5
    }
    [Console]::Error.WriteLine($msg)
    exit 3
}
