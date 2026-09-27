#Requires -Version 7.0
Set-StrictMode -Version Latest

$script:MagMirrorApprovedRoot = 'C:\laragon\repos\Mirror'
$script:MagReposRootDefault = 'C:\laragon\repos'
$script:MagForbiddenMirrorEquals = @(
    'C:\laragon\repos',
    'C:\laragon\repos\MAG-Ecosystem'
)

function Get-MagMirrorFullPath {
    param([Parameter(Mandatory)][string]$Path)
    return [IO.Path]::GetFullPath($Path)
}

function Test-MagMirrorPathUnderRoot {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Root
    )
    $full = (Get-MagMirrorFullPath $Path).TrimEnd('\', '/')
    $rootFull = (Get-MagMirrorFullPath $Root).TrimEnd('\', '/')
    if ($full.Equals($rootFull, [StringComparison]::OrdinalIgnoreCase)) {
        return $true
    }
    $prefix = $rootFull + [IO.Path]::DirectorySeparatorChar
    return $full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)
}

function Get-MagMirrorSha256File {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path) -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return 'ABSENT'
    }
    $bytes = [IO.File]::ReadAllBytes((Get-MagMirrorFullPath $Path))
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        $hash = $sha.ComputeHash($bytes)
        return ([BitConverter]::ToString($hash) -replace '-', '').ToLowerInvariant()
    }
    finally {
        $sha.Dispose()
    }
}

function Test-MagMirrorRelPathSafe {
    param([Parameter(Mandatory)][string]$RelPath)
    if ([string]::IsNullOrWhiteSpace($RelPath)) { return $false }
    $n = $RelPath.Replace('/', '\').Trim()
    if ($n.StartsWith('\') -or $n.Contains(':')) { return $false }
    if ($n -match '(^|[\\/])\.\.([\\/]|$)') { return $false }
    return $true
}

function Test-MagMirrorReparsePoint {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $item = Get-Item -LiteralPath $Path -Force
    return [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function Assert-MagMirrorRootSafe {
    param(
        [Parameter(Mandatory)][string]$MirrorRoot,
        [string[]]$CanonicalRepoRoots = @()
    )
    $full = Get-MagMirrorFullPath $MirrorRoot
    $approved = Get-MagMirrorFullPath $script:MagMirrorApprovedRoot
    if (-not $full.Equals($approved, [StringComparison]::OrdinalIgnoreCase)) {
        throw "mirror_root_not_approved:$full"
    }
    if (Test-MagMirrorReparsePoint $full) {
        throw "mirror_root_reparse:$full"
    }
    foreach ($banned in $script:MagForbiddenMirrorEquals) {
        $b = Get-MagMirrorFullPath $banned
        if ($full.Equals($b, [StringComparison]::OrdinalIgnoreCase)) {
            throw "mirror_root_forbidden:$full"
        }
    }
    foreach ($repo in @($CanonicalRepoRoots)) {
        if ([string]::IsNullOrWhiteSpace($repo)) { continue }
        $r = Get-MagMirrorFullPath $repo
        if ($full.Equals($r, [StringComparison]::OrdinalIgnoreCase)) {
            throw "mirror_root_is_canonical_repo:$full"
        }
        if (Test-MagMirrorPathUnderRoot -Path $full -Root $r) {
            throw "mirror_root_inside_canonical_repo:$full"
        }
    }
    $reposRoot = Get-MagMirrorFullPath $script:MagReposRootDefault
    if ($full.Equals($reposRoot, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'mirror_root_is_repos_root'
    }
    return $full
}

function Read-MagMirrorJsonFile {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "missing_json:$Path"
    }
    $raw = [IO.File]::ReadAllText((Get-MagMirrorFullPath $Path))
    return $raw | ConvertFrom-Json -Depth 32
}

function Test-MagDocumentMetadata {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$ExpectedFileName
    )
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $true
    }
    $text = [IO.File]::ReadAllText((Get-MagMirrorFullPath $Path))
    if ($text -notmatch '(?m)^- MAG-Document-ID:\s+`([^`]+)`') {
        return $false
    }
    $id = $Matches[1]
    if ($id -ne $ExpectedFileName) {
        return $false
    }
    if ($text -notmatch '(?m)^- MAG-Content-Updated:\s+`([^`]+)`') {
        return $false
    }
    return $true
}

function Test-MagMirrorFormatOnly {
    param(
        [string]$LocalPath,
        [string]$MirrorPath
    )
    if (-not (Test-Path -LiteralPath $LocalPath -PathType Leaf)) { return $false }
    if (-not (Test-Path -LiteralPath $MirrorPath -PathType Leaf)) { return $false }
    $a = [IO.File]::ReadAllBytes((Get-MagMirrorFullPath $LocalPath))
    $b = [IO.File]::ReadAllBytes((Get-MagMirrorFullPath $MirrorPath))
    if ((Get-MagMirrorSha256File $LocalPath) -eq (Get-MagMirrorSha256File $MirrorPath)) {
        return $false
    }
    function Strip-BomCrlf([byte[]]$bytes) {
        $start = 0
        if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
            $start = 3
        }
        $text = [Text.Encoding]::UTF8.GetString($bytes, $start, $bytes.Length - $start)
        return ($text -replace "`r`n", "`n" -replace "`r", "`n")
    }
    return ((Strip-BomCrlf $a) -eq (Strip-BomCrlf $b))
}

function Import-MagMirrorInventory {
    param(
        [Parameter(Mandatory)][string]$InventoryPath,
        [string]$ReposRootOverride,
        [string]$MirrorRootOverride
    )
    $inv = Read-MagMirrorJsonFile $InventoryPath
    if (-not $inv.PSObject.Properties['schema_version'] -or [int]$inv.schema_version -ne 1) {
        throw 'malformed_inventory:schema_version'
    }
    if (-not $inv.PSObject.Properties['entries'] -or $null -eq $inv.entries) {
        throw 'malformed_inventory:entries'
    }
    $reposRoot = if ($ReposRootOverride) { Get-MagMirrorFullPath $ReposRootOverride } else { Get-MagMirrorFullPath ([string]$inv.repos_root) }
    $mirrorRoot = if ($MirrorRootOverride) { Get-MagMirrorFullPath $MirrorRootOverride } else { Get-MagMirrorFullPath ([string]$inv.mirror_root) }
    if (-not $inv.PSObject.Properties['repositories']) {
        throw 'malformed_inventory:repositories'
    }
    $repoMap = @{}
    foreach ($p in $inv.repositories.PSObject.Properties) {
        $repoMap[$p.Name] = Get-MagMirrorFullPath (Join-Path $reposRoot $p.Name)
        $declared = [string]$p.Value
        if ($declared -and -not $ReposRootOverride) {
            $dFull = Get-MagMirrorFullPath $declared
            $expected = Get-MagMirrorFullPath (Join-Path $reposRoot $p.Name)
            if (-not $dFull.Equals($expected, [StringComparison]::OrdinalIgnoreCase)) {
                throw "unknown_repository_path:$($p.Name)"
            }
        }
        if (-not (Test-Path -LiteralPath $repoMap[$p.Name] -PathType Container)) {
            throw "unresolved_repository:$($p.Name)"
        }
    }
    $seenKey = @{}
    $seenLocal = @{}
    $seenMirror = @{}
    $resolved = [System.Collections.Generic.List[object]]::new()
    foreach ($e in @($inv.entries)) {
        $repo = [string]$e.repo
        $rel = [string]$e.path
        $cat = [string]$e.category
        if (-not $repoMap.ContainsKey($repo)) {
            throw "unknown_repository:$repo"
        }
        if (-not (Test-MagMirrorRelPathSafe $rel)) {
            throw "path_traversal:$rel"
        }
        $key = "$repo|$rel".ToLowerInvariant()
        if ($seenKey.ContainsKey($key)) {
            throw "duplicate_mapping:$key"
        }
        $seenKey[$key] = $true
        $local = Get-MagMirrorFullPath (Join-Path $repoMap[$repo] ($rel.Replace('/', '\')))
        $mirror = Get-MagMirrorFullPath (Join-Path $mirrorRoot (Join-Path $repo ($rel.Replace('/', '\'))))
        if (-not (Test-MagMirrorPathUnderRoot -Path $local -Root $repoMap[$repo])) {
            throw "path_outside_repo:$local"
        }
        if (-not (Test-MagMirrorPathUnderRoot -Path $mirror -Root $mirrorRoot)) {
            throw "path_outside_mirror:$mirror"
        }
        $lk = $local.ToLowerInvariant()
        $mk = $mirror.ToLowerInvariant()
        if ($seenLocal.ContainsKey($lk)) { throw "duplicate_local:$local" }
        if ($seenMirror.ContainsKey($mk)) { throw "duplicate_mirror:$mirror" }
        $seenLocal[$lk] = $true
        $seenMirror[$mk] = $true
        $requireMeta = $false
        if ($e.PSObject.Properties['require_metadata']) {
            $requireMeta = [bool]$e.require_metadata
        }
        $resolved.Add([pscustomobject]@{
                Repo             = $repo
                RelPath          = $rel.Replace('\', '/')
                Category         = $cat
                RequireMetadata  = $requireMeta
                LocalPath        = $local
                MirrorPath       = $mirror
                LocalRepoRoot    = $repoMap[$repo]
            }) | Out-Null
    }
    return [pscustomobject]@{
        ReposRoot     = $reposRoot
        MirrorRoot    = $mirrorRoot
        RepoMap       = $repoMap
        Entries       = @($resolved)
        CanonicalRoots = @($repoMap.Values)
    }
}

function Import-MagMirrorBaseline {
    param([string]$BaselinePath)
    if ([string]::IsNullOrWhiteSpace($BaselinePath) -or -not (Test-Path -LiteralPath $BaselinePath -PathType Leaf)) {
        return @{}
    }
    try {
        $obj = Read-MagMirrorJsonFile $BaselinePath
    }
    catch {
        throw "malformed_baseline:$BaselinePath"
    }
    if (-not $obj.PSObject.Properties['pairs']) {
        throw 'malformed_baseline:pairs'
    }
    $map = @{}
    foreach ($p in @($obj.pairs)) {
        if (-not $p.PSObject.Properties['repo'] -or -not $p.PSObject.Properties['path'] -or -not $p.PSObject.Properties['baseline_sha256']) {
            throw 'malformed_baseline:entry'
        }
        $k = ("{0}|{1}" -f [string]$p.repo, ([string]$p.path).Replace('\', '/')).ToLowerInvariant()
        $map[$k] = [string]$p.baseline_sha256
    }
    return $map
}

function Get-MagMirrorClassification {
    param(
        [string]$LocalHash,
        [string]$MirrorHash,
        [string]$BaselineHash,
        [bool]$FormatOnly,
        [bool]$RequireMetadata,
        [bool]$MetadataOk,
        [bool]$IsTool
    )
    $lAbs = ($LocalHash -eq 'ABSENT')
    $mAbs = ($MirrorHash -eq 'ABSENT')
    $hasBase = -not [string]::IsNullOrWhiteSpace($BaselineHash) -and $BaselineHash -ne 'NONE'

    $cls = $null
    if ($FormatOnly) {
        $cls = [pscustomobject]@{ Classification = 'FORMAT_ONLY'; Direction = 'NONE'; Blocking = 'format_only_no_write' }
    }
    elseif ($lAbs -and $mAbs) {
        $cls = [pscustomobject]@{ Classification = 'MISSING_SOURCE'; Direction = 'NONE'; Blocking = 'both_absent' }
    }
    elseif ($lAbs -and -not $mAbs) {
        $cls = [pscustomobject]@{ Classification = 'MISSING_SOURCE'; Direction = 'NONE'; Blocking = 'local_absent' }
    }
    elseif (-not $lAbs -and $mAbs) {
        $cls = [pscustomobject]@{ Classification = 'MISSING_TARGET'; Direction = 'NONE'; Blocking = 'mirror_absent' }
    }
    elseif ($LocalHash -eq $MirrorHash) {
        $cls = [pscustomobject]@{ Classification = 'IDENTICAL'; Direction = 'NONE'; Blocking = '' }
    }
    elseif (-not $hasBase) {
        $cls = [pscustomobject]@{ Classification = 'CONFLICT'; Direction = 'STOP'; Blocking = 'ambiguous_no_baseline' }
    }
    else {
        $lEq = ($LocalHash -eq $BaselineHash)
        $mEq = ($MirrorHash -eq $BaselineHash)
        if ($lEq -and $mEq) {
            $cls = [pscustomobject]@{ Classification = 'IDENTICAL'; Direction = 'NONE'; Blocking = '' }
        }
        elseif (-not $lEq -and $mEq) {
            $cls = [pscustomobject]@{ Classification = 'NEWER_LOCAL'; Direction = 'LOCAL_TO_MIRROR'; Blocking = '' }
        }
        elseif ($lEq -and -not $mEq) {
            $cls = [pscustomobject]@{ Classification = 'NEWER_DRIVE'; Direction = 'MIRROR_TO_LOCAL'; Blocking = '' }
        }
        else {
            $cls = [pscustomobject]@{ Classification = 'CONFLICT'; Direction = 'STOP'; Blocking = 'both_changed_differently' }
        }
    }

    if ($RequireMetadata -and -not $IsTool -and $LocalHash -ne 'ABSENT' -and -not $MetadataOk) {
        if ($cls.Direction -ne 'NONE') {
            return [pscustomobject]@{
                Classification = 'INVALID_METADATA'
                Direction      = 'STOP'
                Blocking       = 'invalid_metadata'
            }
        }
        if ($cls.Classification -notin @('IDENTICAL', 'FORMAT_ONLY')) {
            return [pscustomobject]@{
                Classification = 'INVALID_METADATA'
                Direction      = 'STOP'
                Blocking       = 'invalid_metadata'
            }
        }
    }
    return $cls
}

function Get-MagMirrorUnmanagedExtras {
    param(
        [Parameter(Mandatory)][string]$MirrorRoot,
        [Parameter(Mandatory)][object[]]$Entries
    )
    $managed = @{}
    foreach ($e in $Entries) {
        $managed[(Get-MagMirrorFullPath $e.MirrorPath).ToLowerInvariant()] = $true
    }
    if (-not (Test-Path -LiteralPath $MirrorRoot -PathType Container)) {
        return @()
    }
    $extras = [System.Collections.Generic.List[string]]::new()
    Get-ChildItem -LiteralPath $MirrorRoot -Recurse -File -Force | ForEach-Object {
        $fp = Get-MagMirrorFullPath $_.FullName
        if (-not $managed.ContainsKey($fp.ToLowerInvariant())) {
            $extras.Add($fp) | Out-Null
        }
    }
    return @($extras)
}

function Invoke-MagMirrorCheck {
    param(
        [Parameter(Mandatory)]$Loaded,
        [hashtable]$BaselineMap = @{}
    )
    $rows = [System.Collections.Generic.List[object]]::new()
    foreach ($e in $Loaded.Entries) {
        $lh = Get-MagMirrorSha256File $e.LocalPath
        $mh = Get-MagMirrorSha256File $e.MirrorPath
        $k = ("{0}|{1}" -f $e.Repo, $e.RelPath).ToLowerInvariant()
        $bh = if ($BaselineMap.ContainsKey($k)) { [string]$BaselineMap[$k] } else { 'NONE' }
        $isTool = ($e.Category -eq 'tool')
        $metaOk = $true
        if ($e.RequireMetadata -and $lh -ne 'ABSENT') {
            $metaOk = Test-MagDocumentMetadata -Path $e.LocalPath -ExpectedFileName ([IO.Path]::GetFileName($e.RelPath))
        }
        $fmt = $false
        if ($lh -ne 'ABSENT' -and $mh -ne 'ABSENT' -and $lh -ne $mh) {
            $fmt = Test-MagMirrorFormatOnly -LocalPath $e.LocalPath -MirrorPath $e.MirrorPath
        }
        $cls = Get-MagMirrorClassification -LocalHash $lh -MirrorHash $mh -BaselineHash $bh -FormatOnly $fmt -RequireMetadata $e.RequireMetadata -MetadataOk $metaOk -IsTool $isTool
        $authWrite = ($cls.Direction -eq 'MIRROR_TO_LOCAL')
        $approval = ($cls.Direction -eq 'LOCAL_TO_MIRROR' -or $cls.Direction -eq 'MIRROR_TO_LOCAL')
        $rows.Add([pscustomobject]@{
                repo                = $e.Repo
                relative_path       = $e.RelPath
                category            = $e.Category
                local_path          = $e.LocalPath
                mirror_path         = $e.MirrorPath
                local_sha256        = $lh
                mirror_sha256       = $mh
                baseline_sha256     = $bh
                classification      = $cls.Classification
                proposed_direction  = $cls.Direction
                authoritative_write = $authWrite
                approval_required   = $approval
                blocking_reason     = $cls.Blocking
            }) | Out-Null
    }
    $extras = @(Get-MagMirrorUnmanagedExtras -MirrorRoot $Loaded.MirrorRoot -Entries $Loaded.Entries)
    return [pscustomobject]@{
        Pairs  = @($rows)
        Extras = $extras
    }
}

function Assert-MagMirrorTreeContained {
    param(
        [Parameter(Mandatory)][string]$MirrorRoot
    )
    $root = Get-MagMirrorFullPath $MirrorRoot
    if (-not (Test-Path -LiteralPath $root -PathType Container)) {
        return
    }
    $stack = [System.Collections.Generic.Stack[string]]::new()
    $stack.Push($root)
    while ($stack.Count -gt 0) {
        $dir = $stack.Pop()
        if (-not (Test-MagMirrorPathUnderRoot -Path $dir -Root $root)) {
            throw "path_escape:$dir"
        }
        if (-not $dir.Equals($root, [StringComparison]::OrdinalIgnoreCase) -and (Test-MagMirrorReparsePoint $dir)) {
            throw "reparse_point:$dir"
        }
        Get-ChildItem -LiteralPath $dir -Force | ForEach-Object {
            $fp = Get-MagMirrorFullPath $_.FullName
            if (-not (Test-MagMirrorPathUnderRoot -Path $fp -Root $root)) {
                throw "path_escape:$fp"
            }
            if ($_.PSIsContainer) {
                $stack.Push($fp)
            }
            elseif (Test-MagMirrorReparsePoint $fp) {
                throw "reparse_file:$fp"
            }
        }
    }
}

function Clear-MagMirrorTransportFiles {
    param([Parameter(Mandatory)][string]$MirrorRoot)
    $root = Get-MagMirrorFullPath $MirrorRoot
    Assert-MagMirrorTreeContained -MirrorRoot $root
    $files = @(Get-ChildItem -LiteralPath $root -Recurse -File -Force)
    foreach ($f in $files) {
        $fp = Get-MagMirrorFullPath $f.FullName
        if (-not (Test-MagMirrorPathUnderRoot -Path $fp -Root $root)) {
            throw "delete_escape:$fp"
        }
        Remove-Item -LiteralPath $fp -Force
    }
    $dirs = @(Get-ChildItem -LiteralPath $root -Recurse -Directory -Force | Sort-Object { $_.FullName.Length } -Descending)
    foreach ($d in $dirs) {
        $dp = Get-MagMirrorFullPath $d.FullName
        if (-not (Test-MagMirrorPathUnderRoot -Path $dp -Root $root)) {
            throw "delete_escape:$dp"
        }
        if ($dp.Equals($root, [StringComparison]::OrdinalIgnoreCase)) { continue }
        if (@(Get-ChildItem -LiteralPath $dp -Force).Count -eq 0) {
            Remove-Item -LiteralPath $dp -Force
        }
    }
}

function Copy-MagMirrorFileVerified {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Dest,
        [Parameter(Mandatory)][string]$DestRoot
    )
    $srcFull = Get-MagMirrorFullPath $Source
    if (Test-MagMirrorReparsePoint $srcFull) {
        throw "reparse_source:$srcFull"
    }
    $destFull = Get-MagMirrorFullPath $Dest
    if (-not (Test-MagMirrorPathUnderRoot -Path $destFull -Root $DestRoot)) {
        throw "copy_escape:$destFull"
    }
    $dir = Split-Path -Parent $destFull
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $tmp = Join-Path $dir ('.' + [IO.Path]::GetFileName($destFull) + '.mag-mirror-tmp')
    Copy-Item -LiteralPath $Source -Destination $tmp -Force
    $srcHash = Get-MagMirrorSha256File $Source
    $tmpHash = Get-MagMirrorSha256File $tmp
    if ($srcHash -eq 'ABSENT' -or $srcHash -ne $tmpHash) {
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
        throw "temp_hash_mismatch:$Source"
    }
    Move-Item -LiteralPath $tmp -Destination $destFull -Force
    $destHash = Get-MagMirrorSha256File $destFull
    if ($destHash -ne $srcHash) {
        throw "verify_hash_mismatch:$destFull"
    }
    return $destHash
}

function Write-MagMirrorBaseline {
    param(
        [Parameter(Mandatory)][string]$BaselinePath,
        [Parameter(Mandatory)][object[]]$Pairs
    )
    $dir = Split-Path -Parent $BaselinePath
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $obj = [pscustomobject]@{
        schema_version = 1
        kind           = 'mag-docs-mirror-baseline'
        generated_at   = [datetime]::UtcNow.ToString('o')
        pairs          = @($Pairs)
    }
    $json = $obj | ConvertTo-Json -Depth 8
    [IO.File]::WriteAllText((Get-MagMirrorFullPath $BaselinePath), $json)
}

function Invoke-MagMirrorBootstrapClean {
    param(
        [Parameter(Mandatory)]$Loaded,
        [Parameter(Mandatory)][string]$BaselinePath,
        [switch]$SkipApprovedRootCheck
    )
    if (-not $SkipApprovedRootCheck) {
        $null = Assert-MagMirrorRootSafe -MirrorRoot $Loaded.MirrorRoot -CanonicalRepoRoots @($Loaded.CanonicalRoots)
    }
    else {
        $mr = Get-MagMirrorFullPath $Loaded.MirrorRoot
        $reposRoot = Get-MagMirrorFullPath $Loaded.ReposRoot
        if ($mr.Equals($reposRoot, [StringComparison]::OrdinalIgnoreCase)) {
            throw 'mirror_root_is_repos_root'
        }
        foreach ($r in @($Loaded.CanonicalRoots)) {
            if ($mr.Equals((Get-MagMirrorFullPath $r), [StringComparison]::OrdinalIgnoreCase)) {
                throw "mirror_root_is_canonical_repo:$mr"
            }
        }
        Assert-MagMirrorTreeContained -MirrorRoot $mr
    }
    if (-not (Test-Path -LiteralPath $Loaded.MirrorRoot -PathType Container)) {
        New-Item -ItemType Directory -Path $Loaded.MirrorRoot -Force | Out-Null
    }
    $deleted = @(Get-ChildItem -LiteralPath $Loaded.MirrorRoot -Recurse -File -Force -ErrorAction SilentlyContinue)
    Clear-MagMirrorTransportFiles -MirrorRoot $Loaded.MirrorRoot
    $ok = [System.Collections.Generic.List[object]]::new()
    $failed = [System.Collections.Generic.List[object]]::new()
    foreach ($e in $Loaded.Entries) {
        if (-not (Test-Path -LiteralPath $e.LocalPath -PathType Leaf)) {
            $failed.Add([pscustomobject]@{ repo = $e.Repo; path = $e.RelPath; reason = 'missing_canonical_source' }) | Out-Null
            continue
        }
        try {
            $h = Copy-MagMirrorFileVerified -Source $e.LocalPath -Dest $e.MirrorPath -DestRoot $Loaded.MirrorRoot
            $ok.Add([pscustomobject]@{
                    repo            = $e.Repo
                    path            = $e.RelPath
                    category        = $e.Category
                    baseline_sha256 = $h
                    confirmed_at    = [datetime]::UtcNow.ToString('o')
                }) | Out-Null
        }
        catch {
            $failed.Add([pscustomobject]@{ repo = $e.Repo; path = $e.RelPath; reason = [string]$_.Exception.Message }) | Out-Null
        }
    }
    if ($ok.Count -gt 0) {
        Write-MagMirrorBaseline -BaselinePath $BaselinePath -Pairs @($ok)
    }
    return [pscustomobject]@{
        DeletedCount = $deleted.Count
        Populated    = @($ok)
        Failed       = @($failed)
    }
}

function Get-MagMirrorFileShaOrNone {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path) -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return 'NONE'
    }
    return Get-MagMirrorSha256File $Path
}

function New-MagMirrorCheckReceipt {
    param(
        [Parameter(Mandatory)]$Loaded,
        [Parameter(Mandatory)]$CheckResult,
        [Parameter(Mandatory)][string]$InventoryPath,
        [string]$BaselinePath
    )
    $byClass = @{}
    foreach ($p in @($CheckResult.Pairs)) {
        $c = [string]$p.classification
        if (-not $byClass.ContainsKey($c)) { $byClass[$c] = 0 }
        $byClass[$c]++
    }
    $writeable = @($CheckResult.Pairs | Where-Object { $_.proposed_direction -in @('LOCAL_TO_MIRROR', 'MIRROR_TO_LOCAL') }).Count
    $blocked = @($CheckResult.Pairs | Where-Object { $_.proposed_direction -eq 'STOP' -or ($_.blocking_reason -and $_.blocking_reason -ne '') }).Count
    return [pscustomobject]@{
        schema_version           = 1
        kind                     = 'mag-docs-mirror-check-receipt'
        generated_at             = [datetime]::UtcNow.ToString('o')
        timestamp_not_authority  = $true
        mirror_root              = $Loaded.MirrorRoot
        inventory_path           = (Get-MagMirrorFullPath $InventoryPath)
        inventory_sha256         = (Get-MagMirrorSha256File $InventoryPath)
        baseline_path            = $(if ($BaselinePath) { Get-MagMirrorFullPath $BaselinePath } else { '' })
        baseline_file_sha256     = (Get-MagMirrorFileShaOrNone $BaselinePath)
        pair_count               = $CheckResult.Pairs.Count
        extra_count              = $CheckResult.Extras.Count
        write_candidate_count    = $writeable
        blocked_count            = $blocked
        classification_counts    = $byClass
        unmanaged_extras         = @($CheckResult.Extras)
        pairs                    = @($CheckResult.Pairs)
        drive_sync_claimed       = $false
        knowledge_control        = $false
    }
}

function Save-MagMirrorCheckReceipt {
    param(
        [Parameter(Mandatory)]$Receipt,
        [Parameter(Mandatory)][string]$ReceiptPath
    )
    $dir = Split-Path -Parent $ReceiptPath
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $json = $Receipt | ConvertTo-Json -Depth 10
    $full = Get-MagMirrorFullPath $ReceiptPath
    [IO.File]::WriteAllText($full, $json)
    return [pscustomobject]@{
        Path   = $full
        Sha256 = (Get-MagMirrorSha256File $full)
    }
}

function Merge-MagMirrorBaselinePair {
    param(
        [Parameter(Mandatory)][string]$BaselinePath,
        [Parameter(Mandatory)][string]$Repo,
        [Parameter(Mandatory)][string]$RelPath,
        [Parameter(Mandatory)][string]$Category,
        [Parameter(Mandatory)][string]$Sha256
    )
    $existing = @()
    if (Test-Path -LiteralPath $BaselinePath -PathType Leaf) {
        $obj = Read-MagMirrorJsonFile $BaselinePath
        $existing = @($obj.pairs)
    }
    $k = ("{0}|{1}" -f $Repo, $RelPath.Replace('\', '/')).ToLowerInvariant()
    $next = [System.Collections.Generic.List[object]]::new()
    $replaced = $false
    foreach ($p in $existing) {
        $pk = ("{0}|{1}" -f [string]$p.repo, ([string]$p.path).Replace('\', '/')).ToLowerInvariant()
        if ($pk -eq $k) {
            $next.Add([pscustomobject]@{
                    repo            = $Repo
                    path            = $RelPath.Replace('\', '/')
                    category        = $Category
                    baseline_sha256 = $Sha256
                    confirmed_at    = [datetime]::UtcNow.ToString('o')
                }) | Out-Null
            $replaced = $true
        }
        else {
            $next.Add($p) | Out-Null
        }
    }
    if (-not $replaced) {
        $next.Add([pscustomobject]@{
                repo            = $Repo
                path            = $RelPath.Replace('\', '/')
                category        = $Category
                baseline_sha256 = $Sha256
                confirmed_at    = [datetime]::UtcNow.ToString('o')
            }) | Out-Null
    }
    $tmp = $BaselinePath + '.mag-mirror-tmp'
    Write-MagMirrorBaseline -BaselinePath $tmp -Pairs @($next)
    Move-Item -LiteralPath $tmp -Destination (Get-MagMirrorFullPath $BaselinePath) -Force
}

function Invoke-MagMirrorReconcile {
    param(
        [Parameter(Mandatory)][string]$ReceiptPath,
        [Parameter(Mandatory)][string]$AuthorizationSha256,
        [Parameter(Mandatory)][string]$InventoryPath,
        [string]$BaselinePath,
        [string]$ReposRootOverride,
        [string]$MirrorRootOverride,
        [switch]$SkipApprovedRootCheck
    )
    $auth = ([string]$AuthorizationSha256).Trim().ToLowerInvariant()
    if ($auth.Length -ne 64 -or $auth -notmatch '^[0-9a-f]{64}$') {
        throw 'authorization_binding_invalid'
    }
    $rp = Get-MagMirrorFullPath $ReceiptPath
    if (-not (Test-Path -LiteralPath $rp -PathType Leaf)) {
        throw "missing_receipt:$rp"
    }
    $fileHash = Get-MagMirrorSha256File $rp
    if ($fileHash -ne $auth) {
        throw 'authorization_mismatch'
    }
    try {
        $receipt = Read-MagMirrorJsonFile $rp
    }
    catch {
        throw 'malformed_receipt'
    }
    if (-not $receipt.PSObject.Properties['schema_version'] -or [int]$receipt.schema_version -ne 1) {
        throw 'malformed_receipt:schema_version'
    }
    if ([string]$receipt.kind -ne 'mag-docs-mirror-check-receipt') {
        throw 'malformed_receipt:kind'
    }
    $invHash = Get-MagMirrorSha256File $InventoryPath
    if ($invHash -ne [string]$receipt.inventory_sha256) {
        throw 'inventory_changed_since_check'
    }
    $baseFileHash = Get-MagMirrorFileShaOrNone $BaselinePath
    if ($baseFileHash -ne [string]$receipt.baseline_file_sha256) {
        throw 'baseline_changed_since_check'
    }
    $loaded = Import-MagMirrorInventory -InventoryPath $InventoryPath -ReposRootOverride $ReposRootOverride -MirrorRootOverride $MirrorRootOverride
    $receiptRoot = Get-MagMirrorFullPath ([string]$receipt.mirror_root)
    $liveRoot = Get-MagMirrorFullPath $loaded.MirrorRoot
    if (-not $receiptRoot.Equals($liveRoot, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'mirror_root_mismatch'
    }
    if (-not $SkipApprovedRootCheck) {
        $null = Assert-MagMirrorRootSafe -MirrorRoot $loaded.MirrorRoot -CanonicalRepoRoots @($loaded.CanonicalRoots)
    }
    else {
        $mr = $liveRoot
        $reposRoot = Get-MagMirrorFullPath $loaded.ReposRoot
        if ($mr.Equals($reposRoot, [StringComparison]::OrdinalIgnoreCase)) {
            throw 'mirror_root_is_repos_root'
        }
        foreach ($r in @($loaded.CanonicalRoots)) {
            if ($mr.Equals((Get-MagMirrorFullPath $r), [StringComparison]::OrdinalIgnoreCase)) {
                throw "mirror_root_is_canonical_repo:$mr"
            }
        }
        Assert-MagMirrorTreeContained -MirrorRoot $mr
    }

    $byKey = @{}
    foreach ($e in $loaded.Entries) {
        $byKey[("{0}|{1}" -f $e.Repo, $e.RelPath).ToLowerInvariant()] = $e
    }
    $baseMap = Import-MagMirrorBaseline -BaselinePath $BaselinePath
    $results = [System.Collections.Generic.List[object]]::new()
    foreach ($p in @($receipt.pairs)) {
        $key = ("{0}|{1}" -f [string]$p.repo, [string]$p.relative_path).ToLowerInvariant()
        $row = [pscustomobject]@{
            repo       = [string]$p.repo
            path       = [string]$p.relative_path
            outcome    = 'SKIPPED'
            reason     = ''
            wrote      = $false
        }
        $dir = [string]$p.proposed_direction
        if ($dir -notin @('LOCAL_TO_MIRROR', 'MIRROR_TO_LOCAL')) {
            $row.outcome = 'BLOCKED'
            $row.reason = $(if ($p.blocking_reason) { [string]$p.blocking_reason } else { [string]$p.classification })
            $results.Add($row) | Out-Null
            continue
        }
        if ([string]$p.classification -notin @('NEWER_LOCAL', 'NEWER_DRIVE')) {
            $row.outcome = 'BLOCKED'
            $row.reason = 'classification_not_writable'
            $results.Add($row) | Out-Null
            continue
        }
        if (-not $byKey.ContainsKey($key)) {
            $row.outcome = 'STALE'
            $row.reason = 'pair_not_in_inventory'
            $results.Add($row) | Out-Null
            continue
        }
        $e = $byKey[$key]
        $lp = Get-MagMirrorFullPath $e.LocalPath
        $mp = Get-MagMirrorFullPath $e.MirrorPath
        if (-not $lp.Equals((Get-MagMirrorFullPath ([string]$p.local_path)), [StringComparison]::OrdinalIgnoreCase)) {
            $row.outcome = 'STALE'; $row.reason = 'local_path_mismatch'; $results.Add($row) | Out-Null; continue
        }
        if (-not $mp.Equals((Get-MagMirrorFullPath ([string]$p.mirror_path)), [StringComparison]::OrdinalIgnoreCase)) {
            $row.outcome = 'STALE'; $row.reason = 'mirror_path_mismatch'; $results.Add($row) | Out-Null; continue
        }
        if (-not (Test-MagMirrorPathUnderRoot -Path $lp -Root $e.LocalRepoRoot)) {
            throw "path_outside_repo:$lp"
        }
        if (-not (Test-MagMirrorPathUnderRoot -Path $mp -Root $loaded.MirrorRoot)) {
            throw "path_outside_mirror:$mp"
        }
        $lh = Get-MagMirrorSha256File $lp
        $mh = Get-MagMirrorSha256File $mp
        $bk = $key
        $bh = if ($baseMap.ContainsKey($bk)) { [string]$baseMap[$bk] } else { 'NONE' }
        if ($lh -ne [string]$p.local_sha256 -or $mh -ne [string]$p.mirror_sha256 -or $bh -ne [string]$p.baseline_sha256) {
            $row.outcome = 'STALE'
            $row.reason = 'state_changed_since_check'
            $results.Add($row) | Out-Null
            continue
        }
        $isTool = ($e.Category -eq 'tool')
        $metaOk = $true
        if ($e.RequireMetadata -and $lh -ne 'ABSENT') {
            $metaOk = Test-MagDocumentMetadata -Path $lp -ExpectedFileName ([IO.Path]::GetFileName($e.RelPath))
        }
        $fmt = $false
        if ($lh -ne 'ABSENT' -and $mh -ne 'ABSENT' -and $lh -ne $mh) {
            $fmt = Test-MagMirrorFormatOnly -LocalPath $lp -MirrorPath $mp
        }
        $cls = Get-MagMirrorClassification -LocalHash $lh -MirrorHash $mh -BaselineHash $bh -FormatOnly $fmt -RequireMetadata $e.RequireMetadata -MetadataOk $metaOk -IsTool $isTool
        if ([string]$cls.Classification -ne [string]$p.classification -or [string]$cls.Direction -ne $dir) {
            $row.outcome = 'STALE'
            $row.reason = 'classification_changed_since_check'
            $results.Add($row) | Out-Null
            continue
        }
        try {
            if ($dir -eq 'LOCAL_TO_MIRROR') {
                $h = Copy-MagMirrorFileVerified -Source $lp -Dest $mp -DestRoot $loaded.MirrorRoot
            }
            else {
                $h = Copy-MagMirrorFileVerified -Source $mp -Dest $lp -DestRoot $e.LocalRepoRoot
            }
            $lh2 = Get-MagMirrorSha256File $lp
            $mh2 = Get-MagMirrorSha256File $mp
            if ($lh2 -ne $mh2 -or $lh2 -ne $h) {
                throw 'post_write_hash_mismatch'
            }
            Merge-MagMirrorBaselinePair -BaselinePath $BaselinePath -Repo $e.Repo -RelPath $e.RelPath -Category $e.Category -Sha256 $h
            $row.outcome = 'WRITTEN'
            $row.wrote = $true
            $row.reason = $dir
        }
        catch {
            $row.outcome = 'FAILED'
            $row.reason = [string]$_.Exception.Message
            $row.wrote = $false
        }
        $results.Add($row) | Out-Null
    }
    return [pscustomobject]@{
        Results            = @($results)
        WrittenCount       = @($results | Where-Object { $_.wrote }).Count
        BlockedCount       = @($results | Where-Object { $_.outcome -eq 'BLOCKED' }).Count
        StaleCount         = @($results | Where-Object { $_.outcome -eq 'STALE' }).Count
        FailedCount        = @($results | Where-Object { $_.outcome -eq 'FAILED' }).Count
        drive_sync_claimed = $false
    }
}

function Resolve-MagMirrorAffectedToken {
    param(
        [Parameter(Mandatory)]$Loaded,
        [Parameter(Mandatory)][string]$Token
    )
    $raw = $Token.Trim().Trim('"')
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return [pscustomobject]@{ Ok = $false; Reason = 'empty_token'; Entry = $null }
    }
    $rooted = $false
    try { $rooted = [IO.Path]::IsPathRooted($raw) } catch { $rooted = $false }
    if ($rooted) {
        $full = Get-MagMirrorFullPath $raw
        if (-not (Test-MagMirrorPathUnderRoot -Path $full -Root $Loaded.ReposRoot)) {
            return [pscustomobject]@{ Ok = $false; Reason = 'path_escape'; Entry = $null }
        }
        foreach ($e in @($Loaded.Entries)) {
            if ($full.Equals((Get-MagMirrorFullPath $e.LocalPath), [StringComparison]::OrdinalIgnoreCase)) {
                return [pscustomobject]@{ Ok = $true; Reason = ''; Entry = $e }
            }
        }
        return [pscustomobject]@{ Ok = $false; Reason = 'not_in_inventory'; Entry = $null }
    }
    if (-not (Test-MagMirrorRelPathSafe $raw)) {
        return [pscustomobject]@{ Ok = $false; Reason = 'path_escape'; Entry = $null }
    }
    $norm = $raw.Replace('\', '/')
    $slash = $norm.IndexOf('/')
    if ($slash -gt 0) {
        $maybeRepo = $norm.Substring(0, $slash)
        $rel = $norm.Substring($slash + 1)
        if ($Loaded.RepoMap.ContainsKey($maybeRepo)) {
            foreach ($e in @($Loaded.Entries)) {
                if ($e.Repo -eq $maybeRepo -and $e.RelPath -eq $rel) {
                    return [pscustomobject]@{ Ok = $true; Reason = ''; Entry = $e }
                }
            }
            return [pscustomobject]@{ Ok = $false; Reason = 'not_in_inventory'; Entry = $null }
        }
    }
    $hits = @($Loaded.Entries | Where-Object { $_.RelPath -eq $norm })
    if ($hits.Count -eq 1) {
        return [pscustomobject]@{ Ok = $true; Reason = ''; Entry = $hits[0] }
    }
    if ($hits.Count -gt 1) {
        return [pscustomobject]@{ Ok = $false; Reason = 'ambiguous_relative_path'; Entry = $null }
    }
    return [pscustomobject]@{ Ok = $false; Reason = 'not_in_inventory'; Entry = $null }
}

function Get-MagMirrorPublishStatus {
    param([object[]]$Results)
    $rows = @($Results)
    if ($rows.Count -lt 1) { return 'NOT_APPLICABLE' }
    $escapes = @($rows | Where-Object { $_.outcome -eq 'PATH_ESCAPE' })
    $written = @($rows | Where-Object { $_.wrote }).Count
    if ($escapes.Count -gt 0) {
        $blocked = @($rows | Where-Object { $_.outcome -eq 'BLOCKED' -or $_.outcome -eq 'FAILED' -or $_.outcome -eq 'PATH_ESCAPE' }).Count
        if ($written -gt 0) {
            if ($blocked -gt 0) { return 'PARTIAL' }
        }
        return 'BLOCKED'
    }
    $inventoryRows = @($rows | Where-Object { $_.outcome -ne 'SKIPPED_UNMANAGED' })
    if ($inventoryRows.Count -lt 1) { return 'NOT_APPLICABLE' }
    $writtenInv = @($inventoryRows | Where-Object { $_.wrote }).Count
    $identical = @($inventoryRows | Where-Object { $_.outcome -eq 'IDENTICAL' }).Count
    $blockedInv = @($inventoryRows | Where-Object { $_.outcome -eq 'BLOCKED' -or $_.outcome -eq 'FAILED' }).Count
    if ($blockedInv -gt 0) {
        if ($writtenInv -gt 0) { return 'PARTIAL' }
        return 'BLOCKED'
    }
    if ($writtenInv -gt 0) { return 'PUBLISHED' }
    if ($identical -eq $inventoryRows.Count) { return 'IDENTICAL' }
    return 'BLOCKED'
}

function Invoke-MagMirrorPublishAffected {
    param(
        [Parameter(Mandatory)]$Loaded,
        [string[]]$AffectedTokens = @(),
        [Parameter(Mandatory)][string]$BaselinePath,
        [switch]$SkipApprovedRootCheck
    )
    if (-not $SkipApprovedRootCheck) {
        $null = Assert-MagMirrorRootSafe -MirrorRoot $Loaded.MirrorRoot -CanonicalRepoRoots @($Loaded.CanonicalRoots)
    }
    else {
        $mr = Get-MagMirrorFullPath $Loaded.MirrorRoot
        $reposRoot = Get-MagMirrorFullPath $Loaded.ReposRoot
        if ($mr.Equals($reposRoot, [StringComparison]::OrdinalIgnoreCase)) {
            throw 'mirror_root_is_repos_root'
        }
        foreach ($r in @($Loaded.CanonicalRoots)) {
            if ($mr.Equals((Get-MagMirrorFullPath $r), [StringComparison]::OrdinalIgnoreCase)) {
                throw "mirror_root_is_canonical_repo:$mr"
            }
        }
        Assert-MagMirrorTreeContained -MirrorRoot $mr
    }

    $tokens = @()
    if ($null -ne $AffectedTokens) {
        $tokens = @($AffectedTokens | ForEach-Object { [string]$_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    }
    $results = [System.Collections.Generic.List[object]]::new()
    if ($tokens.Count -lt 1) {
        return [pscustomobject]@{
            Results            = @()
            PublicationStatus  = 'NOT_APPLICABLE'
            WrittenCount       = 0
            IdenticalCount     = 0
            BlockedCount       = 0
            FailedCount        = 0
            SkippedUnmanaged   = 0
            drive_sync_claimed = $false
            google_drive_status = 'UNKNOWN'
        }
    }

    $baseMap = @{}
    try {
        $baseMap = Import-MagMirrorBaseline -BaselinePath $BaselinePath
    }
    catch {
        $msg = [string]$_.Exception.Message
        if ($msg -match '^malformed_baseline') { throw }
        $baseMap = @{}
    }

    $seen = @{}
    foreach ($tok in $tokens) {
        $row = [pscustomobject]@{
            repo       = ''
            path       = $tok
            outcome    = 'BLOCKED'
            reason     = ''
            wrote      = $false
        }
        $resolved = Resolve-MagMirrorAffectedToken -Loaded $Loaded -Token $tok
        if (-not $resolved.Ok) {
            if ($resolved.Reason -eq 'path_escape') {
                $row.outcome = 'PATH_ESCAPE'
                $row.reason = 'path_escape'
            }
            elseif ($resolved.Reason -eq 'not_in_inventory') {
                $row.outcome = 'SKIPPED_UNMANAGED'
                $row.reason = 'not_in_inventory'
            }
            else {
                $row.outcome = 'BLOCKED'
                $row.reason = $resolved.Reason
            }
            $results.Add($row) | Out-Null
            continue
        }
        $e = $resolved.Entry
        $row.repo = $e.Repo
        $row.path = $e.RelPath
        $key = ("{0}|{1}" -f $e.Repo, $e.RelPath).ToLowerInvariant()
        if ($seen.ContainsKey($key)) {
            $row.outcome = 'IDENTICAL'
            $row.reason = 'duplicate_token_ignored'
            $results.Add($row) | Out-Null
            continue
        }
        $seen[$key] = $true

        $lp = Get-MagMirrorFullPath $e.LocalPath
        $mp = Get-MagMirrorFullPath $e.MirrorPath
        if (-not (Test-MagMirrorPathUnderRoot -Path $lp -Root $e.LocalRepoRoot)) {
            $row.outcome = 'PATH_ESCAPE'
            $row.reason = 'path_outside_repo'
            $results.Add($row) | Out-Null
            continue
        }
        if (-not (Test-MagMirrorPathUnderRoot -Path $mp -Root $Loaded.MirrorRoot)) {
            $row.outcome = 'PATH_ESCAPE'
            $row.reason = 'path_outside_mirror'
            $results.Add($row) | Out-Null
            continue
        }
        if ((Test-MagMirrorReparsePoint $lp) -or ((Test-Path -LiteralPath $mp) -and (Test-MagMirrorReparsePoint $mp))) {
            $row.outcome = 'BLOCKED'
            $row.reason = 'reparse_not_allowed'
            $results.Add($row) | Out-Null
            continue
        }
        $lh = Get-MagMirrorSha256File $lp
        $mh = Get-MagMirrorSha256File $mp
        if ($lh -eq 'ABSENT') {
            $row.outcome = 'BLOCKED'
            $row.reason = 'missing_local_source'
            $results.Add($row) | Out-Null
            continue
        }
        if ($mh -eq 'ABSENT') {
            $row.outcome = 'BLOCKED'
            $row.reason = 'missing_mirror_target'
            $results.Add($row) | Out-Null
            continue
        }
        $bh = if ($baseMap.ContainsKey($key)) { [string]$baseMap[$key] } else { 'NONE' }
        $isTool = ($e.Category -eq 'tool')
        $metaOk = $true
        if ($e.RequireMetadata) {
            $metaOk = Test-MagDocumentMetadata -Path $lp -ExpectedFileName ([IO.Path]::GetFileName($e.RelPath))
        }
        $fmt = $false
        if ($lh -ne $mh) {
            $fmt = Test-MagMirrorFormatOnly -LocalPath $lp -MirrorPath $mp
        }
        $cls = Get-MagMirrorClassification -LocalHash $lh -MirrorHash $mh -BaselineHash $bh -FormatOnly $fmt -RequireMetadata $e.RequireMetadata -MetadataOk $metaOk -IsTool $isTool
        if ([string]$cls.Classification -eq 'IDENTICAL') {
            $row.outcome = 'IDENTICAL'
            $row.reason = 'already_equal'
            $results.Add($row) | Out-Null
            continue
        }
        if ([string]$cls.Direction -ne 'LOCAL_TO_MIRROR' -or [string]$cls.Classification -ne 'NEWER_LOCAL') {
            $row.outcome = 'BLOCKED'
            $row.reason = $(if ($cls.Blocking) { [string]$cls.Blocking } else { [string]$cls.Classification })
            $results.Add($row) | Out-Null
            continue
        }
        try {
            $h = Copy-MagMirrorFileVerified -Source $lp -Dest $mp -DestRoot $Loaded.MirrorRoot
            $lh2 = Get-MagMirrorSha256File $lp
            $mh2 = Get-MagMirrorSha256File $mp
            if ($lh2 -ne $mh2 -or $lh2 -ne $h) {
                throw 'post_write_hash_mismatch'
            }
            Merge-MagMirrorBaselinePair -BaselinePath $BaselinePath -Repo $e.Repo -RelPath $e.RelPath -Category $e.Category -Sha256 $h
            $row.outcome = 'WRITTEN'
            $row.wrote = $true
            $row.reason = 'LOCAL_TO_MIRROR'
        }
        catch {
            $row.outcome = 'FAILED'
            $row.reason = [string]$_.Exception.Message
            $row.wrote = $false
        }
        $results.Add($row) | Out-Null
    }

    $arr = @($results)
    return [pscustomobject]@{
        Results             = $arr
        PublicationStatus   = (Get-MagMirrorPublishStatus -Results $arr)
        WrittenCount        = @($arr | Where-Object { $_.wrote }).Count
        IdenticalCount      = @($arr | Where-Object { $_.outcome -eq 'IDENTICAL' }).Count
        BlockedCount        = @($arr | Where-Object { $_.outcome -in @('BLOCKED', 'PATH_ESCAPE') }).Count
        FailedCount         = @($arr | Where-Object { $_.outcome -eq 'FAILED' }).Count
        SkippedUnmanaged    = @($arr | Where-Object { $_.outcome -eq 'SKIPPED_UNMANAGED' }).Count
        drive_sync_claimed  = $false
        google_drive_status = 'UNKNOWN'
    }
}
