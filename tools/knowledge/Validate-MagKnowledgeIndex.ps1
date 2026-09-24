#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Index,
    [string]$Manifest
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lib = Join-Path $PSScriptRoot 'lib'
. (Join-Path $lib 'MarkdownHeadings.ps1')
. (Join-Path $lib 'MagKnowledge.Common.ps1')

try {
    if ([string]::IsNullOrWhiteSpace($Index)) {
        [Console]::Error.WriteLine('usage: -Index is required')
        exit 5
    }
    $result = Invoke-MagKnowledgeValidate -IndexPath $Index -ManifestPath $Manifest
    if ($result.ExitCode -eq 0) {
        Write-Output 'VALID'
        exit 0
    }
    [Console]::Error.WriteLine(($result.Errors -join "`n"))
    exit $result.ExitCode
}
catch {
    $msg = [string]$_.Exception.Message
    if ($msg -match '^usage') {
        [Console]::Error.WriteLine($msg)
        exit 5
    }
    [Console]::Error.WriteLine($msg)
    exit 3
}
