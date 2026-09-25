#Requires -Version 7.0
param(
    [string]$ManifestDirectory,
    [AllowEmptyCollection()]
    [string[]]$ChangedFiles = @(),
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lib = Join-Path $PSScriptRoot 'lib'
. (Join-Path $lib 'MarkdownHeadings.ps1')
. (Join-Path $lib 'MagKnowledge.Common.ps1')

try {
    $roots = Get-MagKnowledgeRoot
    $result = Invoke-MagKnowledgeRefresh -Roots $roots -ManifestDirectory $ManifestDirectory -ChangedFiles $ChangedFiles -DryRun:([bool]$DryRun)
    $scopes = @($result.Affected | ForEach-Object { [string]$_.Scope })
    $rows = @($result.Affected | ForEach-Object {
            [pscustomobject]@{
                scope    = [string]$_.Scope
                manifest = [string]$_.ManifestPath
                output   = [string]$_.Output
                reasons  = @($_.Reasons)
            }
        })
    $obj = [pscustomobject]@{
        state                   = [string]$result.State
        exit_code               = [int]$result.ExitCode
        affected_scopes         = @($scopes)
        affected                = @($rows)
        detail                  = [string]$result.Detail
        last_good_not_knowledge = $true
        canonical_fallback      = 'same-scope section-oriented canonical retrieval remains required; generated discovery for failed or stale scopes is unusable'
    }
    Write-Output ($obj | ConvertTo-Json -Depth 8 -Compress)
    exit [int]$result.ExitCode
}
catch {
    $msg = [string]$_.Exception.Message
    $code = 3
    if ($msg -match '^usage') { $code = 5 }
    [Console]::Error.WriteLine($msg)
    exit $code
}
