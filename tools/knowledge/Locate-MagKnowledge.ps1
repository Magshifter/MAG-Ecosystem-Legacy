#Requires -Version 7.0
param(
    [Parameter(Mandatory)]
    [string]$Index,
    [Parameter(Mandatory)]
    [string]$Identity,
    [Parameter(Mandatory)]
    [string]$Intent,
    [Parameter(Mandatory)]
    [string]$Query,
    [string]$Owner
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lib = Join-Path $PSScriptRoot 'lib'
. (Join-Path $lib 'MarkdownHeadings.ps1')
. (Join-Path $lib 'MagKnowledge.Common.ps1')

try {
    foreach ($n in @('Index', 'Identity', 'Intent', 'Query')) {
        if ([string]::IsNullOrWhiteSpace((Get-Variable $n).Value)) {
            [Console]::Error.WriteLine("usage: -$n is required")
            exit 5
        }
    }
    $result = Invoke-MagKnowledgeLocate -IndexPath $Index -Identity $Identity -Intent $Intent -Query $Query -Owner $Owner
    Write-MagLocatorOutput $result
    exit $result.ExitCode
}
catch {
    [Console]::Error.WriteLine([string]$_.Exception.Message)
    exit 5
}
