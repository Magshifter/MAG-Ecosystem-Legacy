#Requires -Version 7.0
Set-StrictMode -Version Latest

function Get-MagMarkdownHeadings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Content
    )

    $headings = [System.Collections.Generic.List[object]]::new()
    $inFence = $false
    $fenceChar = [char]0
    $fenceLen = 0
    $ancestors = New-Object 'System.Collections.Generic.List[string]'
    $lineNo = 0

    foreach ($rawLine in ($Content -split "`r?`n")) {
        $lineNo++
        $line = $rawLine.TrimEnd("`r")

        $fenceMatch = [regex]::Match($line, '^( {0,3})(`{3,}|~{3,})(.*)$')
        if ($fenceMatch.Success) {
            $marker = $fenceMatch.Groups[2].Value
            $ch = $marker[0]
            $len = $marker.Length
            if (-not $inFence) {
                $inFence = $true
                $fenceChar = $ch
                $fenceLen = $len
                continue
            }
            if ($ch -eq $fenceChar -and $len -ge $fenceLen) {
                $inFence = $false
                $fenceChar = [char]0
                $fenceLen = 0
                continue
            }
        }

        if ($inFence) {
            continue
        }

        $atx = [regex]::Match($line, '^( {0,3})(#{1,6})(?:[ \t]+|$)(.*)$')
        if (-not $atx.Success) {
            continue
        }

        $level = $atx.Groups[2].Value.Length
        $text = $atx.Groups[3].Value
        $text = [regex]::Replace($text, '[ \t]+#+\s*$', '')
        $text = [regex]::Replace($text, '\s*\{#[^}]+\}\s*$', '')
        $text = $text.Trim()
        if ([string]::IsNullOrWhiteSpace($text) -and $level -eq 1) {
            continue
        }
        if ([string]::IsNullOrWhiteSpace($text)) {
            continue
        }

        while ($ancestors.Count -ge $level) {
            $ancestors.RemoveAt($ancestors.Count - 1)
        }
        while ($ancestors.Count -lt ($level - 1)) {
            $ancestors.Add('')
        }
        if ($ancestors.Count -eq ($level - 1)) {
            $ancestors.Add($text)
        }
        else {
            $ancestors[$level - 1] = $text
        }

        $pathParts = [System.Collections.Generic.List[string]]::new()
        for ($i = 0; $i -lt $level; $i++) {
            if ($i -lt $ancestors.Count -and -not [string]::IsNullOrWhiteSpace($ancestors[$i])) {
                $pathParts.Add($ancestors[$i]) | Out-Null
            }
        }
        $headingPath = [string]::Join(' > ', $pathParts)

        $headings.Add([pscustomobject]@{
            Level        = $level
            Title        = $text
            HeadingPath  = $headingPath
            Line         = $lineNo
        }) | Out-Null
    }

    return $headings
}
