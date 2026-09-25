#Requires -Version 7.0
Set-StrictMode -Version Latest

$script:MagKnowledgeGeneratorVersion = '1.0.0'
$script:MagKnownIntents = @('GOVERN', 'PLAN', 'IMPLEMENT', 'DEBUG', 'VERIFY', 'LEARN')
$script:MagDevelopmentClasses = @(
    'development_tz', 'development_roadmap', 'development_architecture', 'development_class_map',
    'development_changelog', 'development_readme', 'development_idea', 'development_audit'
)
$script:MagForbiddenContentKeys = @(
    'body', 'excerpt', 'conclusion', 'requirements', 'pattern_body', 'pattern', 'status',
    'verified_scope', 'observed_behavior', 'source_context'
)

function Get-MagKnowledgeRoot {
    $libDir = $PSScriptRoot
    $knowledgeDir = Split-Path -Parent $libDir
    $toolsDir = Split-Path -Parent $knowledgeDir
    return [pscustomobject]@{
        Lib        = $libDir
        Knowledge  = $knowledgeDir
        Tools      = $toolsDir
        Ecosystem  = (Split-Path -Parent $toolsDir)
        SchemaPath = (Join-Path $knowledgeDir 'schema\index.v1.schema.json')
    }
}

function Get-MagFullPath {
    param([Parameter(Mandatory)][string]$Path)
    return [System.IO.Path]::GetFullPath($Path)
}

function Test-MagPathUnderRoot {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Root
    )
    $full = (Get-MagFullPath $Path).TrimEnd('\', '/')
    $rootFull = (Get-MagFullPath $Root).TrimEnd('\', '/')
    if ($full.Equals($rootFull, [StringComparison]::OrdinalIgnoreCase)) {
        return $true
    }
    $prefix = $rootFull + [IO.Path]::DirectorySeparatorChar
    return $full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)
}

function Get-MagSha256Hex {
    param([Parameter(Mandatory)][byte[]]$Bytes)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $hash = $sha.ComputeHash($Bytes)
        return ([BitConverter]::ToString($hash) -replace '-', '').ToLowerInvariant()
    }
    finally {
        $sha.Dispose()
    }
}

function Get-MagSha256Utf8 {
    param([Parameter(Mandatory)][string]$Text)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    return Get-MagSha256Hex $bytes
}

function ConvertTo-MagNormalizedText {
    param([AllowNull()][string]$Text)
    if ([string]::IsNullOrWhiteSpace($Text)) {
        return ''
    }
    $n = $Text.Normalize([Text.NormalizationForm]::FormKC).ToLowerInvariant()
    $chars = foreach ($ch in $n.ToCharArray()) {
        if ([char]::IsLetterOrDigit($ch)) {
            $ch
        }
        else {
            [char]' '
        }
    }
    $joined = -join $chars
    return [regex]::Replace($joined, '\s+', ' ').Trim()
}

function Get-MagTokens {
    param([AllowNull()][string]$Text)
    $norm = ConvertTo-MagNormalizedText $Text
    if ([string]::IsNullOrWhiteSpace($norm)) {
        return @()
    }
    return @($norm.Split(' ') | Where-Object { $_.Length -ge 2 })
}

function Get-MagSlug {
    param([Parameter(Mandatory)][string]$Text)
    $norm = $Text.Normalize([Text.NormalizationForm]::FormKC).ToLowerInvariant()
    $sb = [System.Text.StringBuilder]::new()
    foreach ($ch in $norm.ToCharArray()) {
        if ($ch -match '[a-z0-9]') {
            [void]$sb.Append($ch)
        }
        else {
            if ($sb.Length -gt 0 -and $sb[$sb.Length - 1] -ne '-') {
                [void]$sb.Append('-')
            }
        }
    }
    $slug = $sb.ToString().Trim('-')
    if ([string]::IsNullOrWhiteSpace($slug)) {
        $hash = Get-MagSha256Utf8 $Text
        return "u-$($hash.Substring(0, 12))"
    }
    return $slug
}

function Get-MagUnitId {
    param(
        [Parameter(Mandatory)][string]$OwnerStem,
        [Parameter(Mandatory)][string]$HeadingPath,
        [AllowEmptyCollection()]
        [AllowNull()]
        [string[]]$Existing = @()
    )
    if ($null -eq $Existing) { $Existing = @() }
    $slug = Get-MagSlug $HeadingPath
    $candidate = "$OwnerStem#$slug"
    if ($Existing -contains $candidate) {
        $hash = Get-MagSha256Utf8 $HeadingPath
        $candidate = "$OwnerStem#u-$($hash.Substring(0, 12))"
    }
    if ($Existing -contains $candidate) {
        throw "unit_id collision: $candidate"
    }
    return $candidate
}

function ConvertFrom-MagJsonElement {
    param([System.Text.Json.JsonElement]$Element)
    switch ($Element.ValueKind) {
        'Object' {
            $o = [ordered]@{}
            foreach ($p in $Element.EnumerateObject()) {
                $o[$p.Name] = ConvertFrom-MagJsonElement $p.Value
            }
            return [pscustomobject]$o
        }
        'Array' {
            $list = [System.Collections.Generic.List[object]]::new()
            foreach ($i in $Element.EnumerateArray()) {
                $list.Add((ConvertFrom-MagJsonElement $i)) | Out-Null
            }
            return , $list.ToArray()
        }
        'String' { return $Element.GetString() }
        'Number' {
            $n = 0
            if ($Element.TryGetInt32([ref]$n)) { return $n }
            return $Element.GetDouble()
        }
        'True' { return $true }
        'False' { return $false }
        'Null' { return $null }
        default { return $null }
    }
}

function Read-MagJsonFile {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "missing_file:$Path"
    }
    $raw = [System.IO.File]::ReadAllText((Get-MagFullPath $Path))
    $doc = [System.Text.Json.JsonDocument]::Parse($raw)
    try {
        return ConvertFrom-MagJsonElement $doc.RootElement
    }
    finally {
        $doc.Dispose()
    }
}

function Get-MagMetadataField {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Name
    )
    $m = [regex]::Match($Content, "(?m)^-\s*$([regex]::Escape($Name)):\s*`?([^`\r\n]+)`?\s*$")
    if ($m.Success) {
        return $m.Groups[1].Value.Trim().Trim('`')
    }
    return $null
}

function Get-MagGitState {
    param(
        [Parameter(Mandatory)][string]$RepoRoot,
        [Parameter(Mandatory)][string]$FullPath
    )
    $result = [pscustomobject]@{ GitBlob = $null; TreeState = 'untracked' }
    if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot '.git'))) {
        return $result
    }
    $rel = [System.IO.Path]::GetRelativePath((Get-MagFullPath $RepoRoot), (Get-MagFullPath $FullPath))
    $relGit = $rel.Replace('\', '/')
    $status = & git -C $RepoRoot status --porcelain=v1 --untracked-files=all -- $relGit 2>$null
    if ($LASTEXITCODE -ne 0) {
        return $result
    }
    $line = if ($status) { [string]$status } else { '' }
    if ([string]::IsNullOrWhiteSpace($line)) {
        $blob = & git -C $RepoRoot hash-object -- $relGit 2>$null
        $result.TreeState = 'committed'
        $result.GitBlob = if ($blob) { [string]$blob.Trim() } else { $null }
        return $result
    }
    $xy = $line.Substring(0, [Math]::Min(2, $line.Length))
    if ($xy -eq '??') {
        $result.TreeState = 'untracked'
        $result.GitBlob = $null
        return $result
    }
    $blob = & git -C $RepoRoot hash-object -- $relGit 2>$null
    $result.TreeState = 'modified'
    $result.GitBlob = if ($blob) { [string]$blob.Trim() } else { $null }
    return $result
}

function Test-MagForbiddenPath {
    param(
        [Parameter(Mandatory)][string]$RelativeOrFull,
        [Parameter(Mandatory)]$Rules
    )
    $norm = $RelativeOrFull.Replace('\', '/').ToLowerInvariant()
    foreach ($seg in @($Rules.forbidden_path_segments)) {
        if ($norm -match "/$([regex]::Escape($seg.ToLowerInvariant()))/" -or $norm.StartsWith("$($seg.ToLowerInvariant())/")) {
            return $true
        }
    }
    $base = [IO.Path]::GetFileName($RelativeOrFull)
    foreach ($b in @($Rules.forbidden_global_basenames)) {
        if ($base.Equals($b, [StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }
    return $false
}

function Resolve-MagDevelopmentClass {
    param(
        [Parameter(Mandatory)][string]$FileName,
        [Parameter(Mandatory)]$Rules
    )
    foreach ($prop in $Rules.development_suffixes.PSObject.Properties) {
        if ($FileName.EndsWith($prop.Name, [StringComparison]::OrdinalIgnoreCase)) {
            return [string]$prop.Value
        }
    }
    return $null
}

function Get-MagGlobalFileRule {
    param(
        [Parameter(Mandatory)]$Rules,
        [Parameter(Mandatory)][string]$FileName
    )
    $prop = $Rules.global_files.PSObject.Properties[$FileName]
    if ($null -eq $prop) { return $null }
    return $prop.Value
}

function Get-MagKnowledgeClass {
    param(
        [Parameter(Mandatory)][string]$FileName,
        [Parameter(Mandatory)][string]$HeadingTitle,
        [Parameter(Mandatory)]$Rules,
        [Parameter(Mandatory)][string]$Kind
    )
    if ($Kind -eq 'development') {
        $cls = Resolve-MagDevelopmentClass -FileName $FileName -Rules $Rules
        if (-not $cls) {
            throw "unknown_source_type:$FileName"
        }
        return $cls
    }
    $gf = Get-MagGlobalFileRule -Rules $Rules -FileName $FileName
    if ($null -eq $gf) {
        throw "unknown_source_type:$FileName"
    }
    if ($gf.source_type -eq 'mip') {
        $exclude = @($Rules.mip.exclude_h2)
        if ($exclude -contains $HeadingTitle) {
            return $null
        }
        $proc = @($Rules.mip.procedure_h2)
        if ($proc -contains $HeadingTitle) {
            return 'reusable_knowledge_procedure'
        }
        return 'reusable_pattern_unit'
    }
    return [string]$gf.knowledge_class
}

function Test-MagHasProp {
    param($Object, [string]$Name)
    return $null -ne $Object -and $null -ne $Object.PSObject.Properties[$Name]
}

function Test-MagJsonSchemaValue {
    param($Value, $Schema, $Defs, [string]$Path)

    $errors = [System.Collections.Generic.List[string]]::new()
    if (Test-MagHasProp $Schema '$ref') {
        $refName = ($Schema.'$ref' -split '/')[-1]
        return Test-MagJsonSchemaValue -Value $Value -Schema $Defs.$refName -Defs $Defs -Path $Path
    }

    $type = $null
    if (Test-MagHasProp $Schema 'type') { $type = $Schema.type }
    $types = @()
    if ($type -is [System.Array]) { $types = @($type) }
    elseif ($type) { $types = @($type) }

    $isNull = $null -eq $Value
    $okType = $false
    foreach ($t in $types) {
        switch ($t) {
            'object' { if ($Value -is [System.Management.Automation.PSCustomObject] -or $Value -is [hashtable]) { $okType = $true } }
            'array' { if ($Value -is [System.Array] -or $Value -is [System.Collections.IList]) { $okType = $true } }
            'string' { if ($Value -is [string]) { $okType = $true } }
            'integer' { if ($Value -is [int] -or $Value -is [long] -or ($Value -is [double] -and [math]::Floor($Value) -eq $Value)) { $okType = $true } }
            'null' { if ($isNull) { $okType = $true } }
        }
    }
    if ($types.Count -gt 0 -and -not $okType) {
        $errors.Add("${Path}: type") | Out-Null
        return $errors
    }
    if ($isNull) {
        return $errors
    }
    if ((Test-MagHasProp $Schema 'const') -and "$($Schema.const)" -ne "$Value") {
        $errors.Add("${Path}: const") | Out-Null
    }
    if ((Test-MagHasProp $Schema 'enum') -and ($Schema.enum -notcontains $Value)) {
        $errors.Add("${Path}: enum") | Out-Null
    }
    if ((Test-MagHasProp $Schema 'pattern') -and $Value -is [string] -and $Value -notmatch $Schema.pattern) {
        $errors.Add("${Path}: pattern") | Out-Null
    }
    if ((Test-MagHasProp $Schema 'minLength') -and $Value -is [string] -and $Value.Length -lt $Schema.minLength) {
        $errors.Add("${Path}: minLength") | Out-Null
    }
    if ((Test-MagHasProp $Schema 'maxItems') -and ($Value -is [System.Array] -or $Value -is [System.Collections.IList]) -and (@($Value).Count -gt $Schema.maxItems)) {
        $errors.Add("${Path}: maxItems") | Out-Null
    }

    if ($types -contains 'object') {
        $props = @($Value.PSObject.Properties.Name)
        $allowed = @()
        if (Test-MagHasProp $Schema 'properties') {
            $allowed = @($Schema.properties.PSObject.Properties.Name)
        }
        if ((Test-MagHasProp $Schema 'additionalProperties') -and $Schema.additionalProperties -eq $false) {
            foreach ($p in $props) {
                if ($allowed -notcontains $p) {
                    $errors.Add("${Path}: additionalProperty $p") | Out-Null
                }
            }
        }
        foreach ($req in @($(if (Test-MagHasProp $Schema 'required') { $Schema.required } else { @() }))) {
            if ($props -notcontains $req) {
                $errors.Add("${Path}: missing $req") | Out-Null
            }
        }
        foreach ($p in $allowed) {
            if ($props -contains $p) {
                $child = @(Test-MagJsonSchemaValue -Value $Value.$p -Schema $Schema.properties.$p -Defs $Defs -Path "$Path.$p")
                foreach ($e in $child) { $errors.Add([string]$e) | Out-Null }
            }
        }
    }

    if ($types -contains 'array' -and (Test-MagHasProp $Schema 'items')) {
        $i = 0
        foreach ($item in @($Value)) {
            $child = @(Test-MagJsonSchemaValue -Value $item -Schema $Schema.items -Defs $Defs -Path "$Path[$i]")
            foreach ($e in $child) { $errors.Add([string]$e) | Out-Null }
            $i++
        }
    }
    return $errors
}

function Test-MagIndexSchema {
    param([Parameter(Mandatory)]$IndexObject, [Parameter(Mandatory)][string]$SchemaPath)
    $schema = Read-MagJsonFile $SchemaPath
    $errs = Test-MagJsonSchemaValue -Value $IndexObject -Schema $schema -Defs $schema.'$defs' -Path '$'
    return @($errs)
}

function ConvertTo-MagIndexHashtable {
    param($Index)
    $sources = @()
    foreach ($s in @($Index.sources)) {
        $gitBlob = $null
        if ($null -ne $s.git_blob -and "$($s.git_blob)" -ne '') {
            $gitBlob = [string]$s.git_blob
        }
        $sources += [ordered]@{
            source_id            = [string]$s.source_id
            owner                = [string]$s.owner
            path                 = [string]$s.path
            identity_scope       = [string]$s.identity_scope
            mag_content_updated  = $(if ($null -eq $s.mag_content_updated) { $null } else { [string]$s.mag_content_updated })
            content_sha256       = [string]$s.content_sha256
            git_blob             = $gitBlob
            tree_state           = [string]$s.tree_state
        }
    }
    $units = @()
    foreach ($u in @($Index.units)) {
        $units += [ordered]@{
            unit_id         = [string]$u.unit_id
            source_id       = [string]$u.source_id
            owner           = [string]$u.owner
            section         = [string]$u.section
            heading_path    = [string]$u.heading_path
            heading_level   = [int]$u.heading_level
            identity_scope  = [string]$u.identity_scope
            knowledge_class = [string]$u.knowledge_class
            title           = [string]$u.title
            aliases         = @()
        }
    }
    return [ordered]@{
        schema_version    = [int]$Index.schema_version
        generator_version = [string]$Index.generator_version
        config_version    = [int]$Index.config_version
        generated_at      = [string]$Index.generated_at
        scope             = [string]$Index.scope
        manifest          = [string]$Index.manifest
        sources           = $sources
        units             = $units
    }
}

function Write-MagJson {
    param(
        [Parameter(Mandatory)]$Object,
        [Parameter(Mandatory)][string]$Path
    )
    $json = $Object | ConvertTo-Json -Depth 32
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText((Get-MagFullPath $Path), $json + "`n", $utf8)
}

function Import-MagManifest {
    param(
        [Parameter(Mandatory)][string]$ManifestPath,
        [Parameter(Mandatory)]$Roots
    )
    $full = Get-MagFullPath $ManifestPath
    if (-not (Test-MagPathUnderRoot -Path $full -Root $Roots.Ecosystem)) {
        throw 'path_outside_ecosystem'
    }
    $m = Read-MagJsonFile $full
    if ([int]$m.schema_version -ne 1) { throw 'unknown_schema_version' }
    if ([int]$m.config_version -ne 1) { throw 'config_version_mismatch' }
    $scope = [string]$m.scope
    if ($scope -ne 'GLOBAL' -and $scope -notmatch '^GLOBAL\+#.+$') { throw 'invalid_scope' }
    $hasDev = $null -ne $m.PSObject.Properties['development'] -and $null -ne $m.development
    if ($scope -eq 'GLOBAL' -and $hasDev) { throw 'development_on_global' }
    if ($scope -ne 'GLOBAL' -and -not $hasDev) { throw 'missing_development' }
    if ($hasDev) {
        $id = [string]$m.development.identity
        $scopeId = $scope.Substring('GLOBAL+'.Length)
        if ($id -ne $scopeId) { throw 'scope_identity_mismatch' }
    }
    return $m
}

function Get-MagEffectiveGlobalRoot {
    param(
        [Parameter(Mandatory)]$Manifest,
        [Parameter(Mandatory)]$Roots
    )
    if ($Manifest.PSObject.Properties['ecosystem_root'] -and $Manifest.ecosystem_root) {
        $candidate = Get-MagFullPath (Join-Path $Roots.Ecosystem ([string]$Manifest.ecosystem_root))
        if (-not (Test-MagPathUnderRoot -Path $candidate -Root $Roots.Ecosystem)) {
            throw 'ecosystem_root_outside_repo'
        }
        if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
            throw 'missing_ecosystem_root'
        }
        return $candidate
    }
    return $Roots.Ecosystem
}

function Get-MagApprovedSources {
    param(
        [Parameter(Mandatory)]$Manifest,
        [Parameter(Mandatory)]$Rules,
        [Parameter(Mandatory)]$Roots
    )
    $eco = Get-MagEffectiveGlobalRoot -Manifest $Manifest -Roots $Roots
    $items = [System.Collections.Generic.List[object]]::new()
    foreach ($base in @($Manifest.global_sources)) {
        $name = [string]$base
        if (Test-MagForbiddenPath -RelativeOrFull $name -Rules $Rules) {
            throw "forbidden_source:$name"
        }
        if ($null -eq (Get-MagGlobalFileRule -Rules $Rules -FileName $name)) {
            throw "unknown_source_type:$name"
        }
        $path = Join-Path $eco $name
        $full = Get-MagFullPath $path
        if (-not (Test-MagPathUnderRoot -Path $full -Root $eco)) {
            throw "path_outside_ecosystem:$name"
        }
        if (-not (Test-Path -LiteralPath $full)) {
            throw "missing_source:$name"
        }
        $rel = [IO.Path]::GetRelativePath($Roots.Ecosystem, $full).Replace('\', '/')
        $items.Add([pscustomobject]@{
            Kind           = 'global'
            Owner          = $name
            FullPath       = $full
            RelPath        = $rel
            IdentityScope  = 'GLOBAL'
            GitRoot        = $Roots.Ecosystem
        }) | Out-Null
    }

    if ($Manifest.scope -ne 'GLOBAL') {
        $devRoot = Get-MagFullPath (Join-Path $eco $Manifest.development.repo_root)
        if (-not (Test-Path -LiteralPath $devRoot -PathType Container)) {
            throw "missing_development_root:$devRoot"
        }
        if (Test-MagPathUnderRoot -Path $devRoot -Root $eco) {
            throw 'development_root_inside_ecosystem'
        }
        $workspace = Split-Path -Parent $eco
        if (-not (Test-MagPathUnderRoot -Path $devRoot -Root $workspace)) {
            throw 'development_root_outside_workspace'
        }
        foreach ($rel in @($Manifest.development.doc_files)) {
            $r = [string]$rel
            if ($r.Contains('..')) { throw "path_traversal:$r" }
            $full = Get-MagFullPath (Join-Path $devRoot $r)
            if (-not (Test-MagPathUnderRoot -Path $full -Root $devRoot)) {
                throw "path_outside_development:$r"
            }
            if (Test-MagForbiddenPath -RelativeOrFull $r -Rules $Rules) {
                throw "forbidden_source:$r"
            }
            $fn = [IO.Path]::GetFileName($r)
            if (-not (Resolve-MagDevelopmentClass -FileName $fn -Rules $Rules)) {
                throw "unknown_source_type:$fn"
            }
            if ($fn -match 'P08__' -or $full -match 'ACP-Enhancements') {
                throw "foreign_development:$fn"
            }
            if (-not (Test-Path -LiteralPath $full)) {
                throw "missing_source:$r"
            }
            $items.Add([pscustomobject]@{
                Kind          = 'development'
                Owner         = $fn
                FullPath      = $full
                RelPath       = $r.Replace('\', '/')
                IdentityScope = [string]$Manifest.scope
                GitRoot       = $devRoot
            }) | Out-Null
        }
    }
    return $items
}

function New-MagSourceUnits {
    param(
        [Parameter(Mandatory)]$SourceItem,
        [Parameter(Mandatory)]$Rules,
        [Parameter(Mandatory)][string]$SourceId,
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.List[string]]$UsedIds
    )
    $bytes = [System.IO.File]::ReadAllBytes($SourceItem.FullPath)
    $sha = Get-MagSha256Hex $bytes
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    $docId = Get-MagMetadataField -Content $text -Name 'MAG-Document-ID'
    if ($docId -and $docId -ne $SourceItem.Owner) {
        throw "document_id_mismatch:$($SourceItem.Owner)"
    }
    $updated = Get-MagMetadataField -Content $text -Name 'MAG-Content-Updated'
    $git = Get-MagGitState -RepoRoot $SourceItem.GitRoot -FullPath $SourceItem.FullPath
    $allHeadings = Get-MagMarkdownHeadings -Content $text
    $h2 = [System.Collections.Generic.List[object]]::new()
    foreach ($item in @($allHeadings)) {
        if ([int]$item.Level -eq 2) {
            $h2.Add($item) | Out-Null
        }
    }
    $paths = @{}
    foreach ($h in $h2) {
        $key = [string]$h.Title
        if ($paths.ContainsKey($key)) {
            throw "duplicate_heading_path:$($SourceItem.Owner)#$key"
        }
        $paths[$key] = $true
    }

    $units = [System.Collections.Generic.List[object]]::new()
    foreach ($h in $h2) {
        $headingTitle = [string]$h.Title
        $cls = Get-MagKnowledgeClass -FileName $SourceItem.Owner -HeadingTitle $headingTitle -Rules $Rules -Kind $SourceItem.Kind
        if ($null -eq $cls) { continue }
        $stem = [IO.Path]::GetFileNameWithoutExtension($SourceItem.Owner)
        $uid = Get-MagUnitId -OwnerStem $stem -HeadingPath $headingTitle -Existing @($UsedIds.ToArray())
        $UsedIds.Add($uid) | Out-Null
        $units.Add([pscustomobject]@{
            unit_id         = $uid
            source_id       = $SourceId
            owner           = $SourceItem.Owner
            section         = $headingTitle
            heading_path    = $headingTitle
            heading_level   = 2
            identity_scope  = $SourceItem.IdentityScope
            knowledge_class = $cls
            title           = $headingTitle
            aliases         = @()
        }) | Out-Null
    }

    $source = [pscustomobject]@{
        source_id           = $SourceId
        owner               = $SourceItem.Owner
        path                = $SourceItem.RelPath
        identity_scope      = $SourceItem.IdentityScope
        mag_content_updated = $updated
        content_sha256      = $sha
        git_blob            = $git.GitBlob
        tree_state          = $git.TreeState
    }
    return [pscustomobject]@{ Source = $source; Units = $units }
}

function Test-MagIndexSemantics {
    param(
        [Parameter(Mandatory)]$Index,
        [Parameter(Mandatory)]$Rules,
        $Manifest,
        [Parameter(Mandatory)]$Roots
    )
    $errors = [System.Collections.Generic.List[string]]::new()
    if ([int]$Index.schema_version -ne 1) { $errors.Add('unknown_schema_version') | Out-Null }

    foreach ($key in $script:MagForbiddenContentKeys) {
        if ($Index.PSObject.Properties.Name -contains $key) { $errors.Add("forbidden_key:$key") | Out-Null }
    }

    $sourceIds = @()
    $owners = @()
    foreach ($s in @($Index.sources)) {
        if ($sourceIds -contains $s.source_id) { $errors.Add("duplicate_source_id:$($s.source_id)") | Out-Null }
        $sourceIds += $s.source_id
        $owners += $s.owner
        if (Test-MagForbiddenPath -RelativeOrFull $s.path -Rules $Rules) {
            $errors.Add("forbidden_source:$($s.path)") | Out-Null
        }
        foreach ($fk in $script:MagForbiddenContentKeys) {
            if ($s.PSObject.Properties.Name -contains $fk) { $errors.Add("forbidden_key:$fk") | Out-Null }
        }
        $full = if ([IO.Path]::IsPathRooted($s.path) -or $s.path -match '^\.\.') {
            Get-MagFullPath (Join-Path $Roots.Ecosystem $s.path)
        }
        else {
            if ($s.identity_scope -eq 'GLOBAL') {
                Get-MagFullPath (Join-Path $Roots.Ecosystem $s.path)
            }
            else {
                $null
            }
        }
        if ($s.identity_scope -eq 'GLOBAL') {
            $full = Get-MagFullPath (Join-Path $Roots.Ecosystem $s.path)
            if (-not (Test-MagPathUnderRoot -Path $full -Root $Roots.Ecosystem)) {
                $errors.Add("path_outside_ecosystem:$($s.path)") | Out-Null
            }
        }
        elseif ($Manifest -and $Manifest.scope -ne 'GLOBAL') {
            $ecoRoot = Get-MagEffectiveGlobalRoot -Manifest $Manifest -Roots $Roots
            $devRoot = Get-MagFullPath (Join-Path $ecoRoot $Manifest.development.repo_root)
            $full = Get-MagFullPath (Join-Path $devRoot $s.path)
            if (-not (Test-MagPathUnderRoot -Path $full -Root $devRoot)) {
                $errors.Add("path_outside_development:$($s.path)") | Out-Null
            }
            if ($s.path -match 'P08__' -or $full -match 'ACP-Enhancements') {
                $errors.Add("foreign_development:$($s.path)") | Out-Null
            }
        }
        if ($full -and (Test-Path -LiteralPath $full)) {
            $bytes = [IO.File]::ReadAllBytes($full)
            $sha = Get-MagSha256Hex $bytes
            if ($sha -ne $s.content_sha256) {
                $errors.Add("stale_hash:$($s.owner)") | Out-Null
            }
            $text = [Text.Encoding]::UTF8.GetString($bytes)
            $heads = Get-MagMarkdownHeadings -Content $text
            $titles = [System.Collections.Generic.List[string]]::new()
            foreach ($hd in @($heads)) {
                if ([int]$hd.Level -eq 2) { $titles.Add([string]$hd.Title) | Out-Null }
            }
            foreach ($u in @($Index.units | Where-Object { $_.source_id -eq $s.source_id })) {
                if ($titles -notcontains [string]$u.heading_path) {
                    $errors.Add("unresolved_heading:$($u.unit_id)") | Out-Null
                }
            }
        }
        elseif ($full) {
            $errors.Add("missing_source:$($s.path)") | Out-Null
        }
    }

    if ($Index.scope -eq 'GLOBAL') {
        foreach ($u in @($Index.units)) {
            if ($script:MagDevelopmentClasses -contains $u.knowledge_class) {
                $errors.Add("development_unit_in_global:$($u.unit_id)") | Out-Null
            }
        }
    }

    $unitIds = @()
    $knownClasses = @(
        'global_authority_section', 'global_operational_section', 'reusable_pattern_unit',
        'reusable_knowledge_procedure', 'global_process_section'
    ) + $script:MagDevelopmentClasses

    foreach ($u in @($Index.units)) {
        if ($unitIds -contains $u.unit_id) { $errors.Add("duplicate_unit_id:$($u.unit_id)") | Out-Null }
        $unitIds += $u.unit_id
        if ($knownClasses -notcontains $u.knowledge_class) { $errors.Add("unknown_knowledge_class:$($u.knowledge_class)") | Out-Null }
        if ($sourceIds -notcontains $u.source_id) { $errors.Add("orphan_unit:$($u.unit_id)") | Out-Null }
        $aliases = @($u.aliases)
        if ($aliases.Count -ne 0) { $errors.Add("aliases_not_empty:$($u.unit_id)") | Out-Null }
        foreach ($fk in $script:MagForbiddenContentKeys) {
            if ($u.PSObject.Properties.Name -contains $fk) { $errors.Add("forbidden_key:$fk") | Out-Null }
        }
        if ($Index.scope -eq 'GLOBAL' -and $u.identity_scope -ne 'GLOBAL') {
            $errors.Add("identity_scope_mismatch:$($u.unit_id)") | Out-Null
        }
    }

    if ($Manifest) {
        if ([string]$Index.scope -ne [string]$Manifest.scope) {
            $errors.Add('manifest_scope_mismatch') | Out-Null
        }
        $allowed = @($Manifest.global_sources)
        if ($Manifest.scope -ne 'GLOBAL') {
            foreach ($df in @($Manifest.development.doc_files)) {
                $allowed += [IO.Path]::GetFileName($df)
            }
        }
        foreach ($s in @($Index.sources)) {
            if ($allowed -notcontains $s.owner -and $allowed -notcontains $s.path) {
                # owner is basename; global sources are basenames
                $ok = $false
                foreach ($a in $allowed) {
                    if ([IO.Path]::GetFileName($a) -eq $s.owner) { $ok = $true }
                }
                if (-not $ok) { $errors.Add("source_not_in_manifest:$($s.owner)") | Out-Null }
            }
        }
    }
    return @($errors)
}

function Invoke-MagKnowledgeValidate {
    param(
        [Parameter(Mandatory)][string]$IndexPath,
        [string]$ManifestPath
    )
    $roots = Get-MagKnowledgeRoot
    if (-not (Test-Path -LiteralPath $IndexPath)) {
        return [pscustomobject]@{ ExitCode = 3; Reason = 'missing_index'; Errors = @('missing_index') }
    }
    try {
        $idx = Read-MagJsonFile $IndexPath
    }
    catch {
        return [pscustomobject]@{ ExitCode = 3; Reason = 'corrupt_json'; Errors = @('corrupt_json') }
    }
    $rules = Read-MagJsonFile (Join-Path $roots.Knowledge 'config\source_rules.json')
    $schemaErrs = Test-MagIndexSchema -IndexObject $idx -SchemaPath $roots.SchemaPath
    $manifest = $null
    if ($ManifestPath) {
        $manifest = Import-MagManifest -ManifestPath $ManifestPath -Roots $roots
    }
    $semErrs = Test-MagIndexSemantics -Index $idx -Rules $rules -Manifest $manifest -Roots $roots
    $all = @($schemaErrs) + @($semErrs)
    if ($all.Count -gt 0) {
        return [pscustomobject]@{ ExitCode = 3; Reason = 'invalid_index'; Errors = $all }
    }
    return [pscustomobject]@{ ExitCode = 0; Reason = 'valid'; Errors = @() }
}

function Invoke-MagKnowledgeGenerate {
    param(
        [Parameter(Mandatory)][string]$ManifestPath,
        [string]$OutputPath
    )
    $roots = Get-MagKnowledgeRoot
    $rules = Read-MagJsonFile (Join-Path $roots.Knowledge 'config\source_rules.json')
    $imap = Read-MagJsonFile (Join-Path $roots.Knowledge 'config\intent_owner_map.json')
    if ([int]$rules.version -ne 1 -or [int]$imap.version -ne 1) {
        throw 'config_version_mismatch'
    }
    $manifest = Import-MagManifest -ManifestPath $ManifestPath -Roots $roots
    if ([int]$manifest.config_version -ne [int]$rules.version) {
        throw 'config_version_mismatch'
    }
    $sources = @(Get-MagApprovedSources -Manifest $manifest -Rules $rules -Roots $roots)
    $usedIds = [System.Collections.Generic.List[string]]::new()
    $srcObjs = [System.Collections.Generic.List[object]]::new()
    $unitObjs = [System.Collections.Generic.List[object]]::new()
    $n = 0
    foreach ($item in $sources) {
        $n++
        $sid = 'src{0:d2}' -f $n
        $built = New-MagSourceUnits -SourceItem $item -Rules $rules -SourceId $sid -UsedIds $usedIds
        $srcObjs.Add($built.Source) | Out-Null
        foreach ($u in @($built.Units)) { $unitObjs.Add($u) | Out-Null }
    }

    $relManifest = [IO.Path]::GetRelativePath($roots.Ecosystem, (Get-MagFullPath $ManifestPath)).Replace('\', '/')
    $index = [pscustomobject]@{
        schema_version    = 1
        generator_version = $script:MagKnowledgeGeneratorVersion
        config_version    = 1
        generated_at      = (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz')
        scope             = [string]$manifest.scope
        manifest          = $relManifest
        sources           = @($srcObjs)
        units             = @($unitObjs)
    }

    $outRel = if ($OutputPath) { $OutputPath } else { [string]$manifest.output }
    $outFull = if ([IO.Path]::IsPathRooted($outRel)) { Get-MagFullPath $outRel } else { Get-MagFullPath (Join-Path $roots.Ecosystem $outRel) }
    $genRoot = Join-Path $roots.Ecosystem 'generated'
    if (-not (Test-MagPathUnderRoot -Path $outFull -Root $genRoot)) {
        throw 'output_outside_generated'
    }
    $outDir = Split-Path -Parent $outFull
    if (-not (Test-Path -LiteralPath $outDir)) {
        New-Item -ItemType Directory -Path $outDir -Force | Out-Null
    }

    $schemaErrs = Test-MagIndexSchema -IndexObject $index -SchemaPath $roots.SchemaPath
    $semErrs = Test-MagIndexSemantics -Index $index -Rules $rules -Manifest $manifest -Roots $roots
    if ((@($schemaErrs) + @($semErrs)).Count -gt 0) {
        throw ((@($schemaErrs) + @($semErrs)) -join '; ')
    }

    $tmp = Join-Path $outDir ('index-partial-{0}.json' -f [guid]::NewGuid().ToString('N'))
    try {
        $ordered = ConvertTo-MagIndexHashtable $index
        Write-MagJson -Object $ordered -Path $tmp
        $check = Read-MagJsonFile $tmp
        $e1 = @(Test-MagIndexSchema -IndexObject $check -SchemaPath $roots.SchemaPath)
        $e2 = @(Test-MagIndexSemantics -Index $check -Rules $rules -Manifest $manifest -Roots $roots)
        if (($e1 + $e2).Count -gt 0) {
            throw ('temp_artifact_invalid:' + (($e1 + $e2) -join '; '))
        }
        Move-Item -LiteralPath $tmp -Destination $outFull -Force
    }
    catch {
        if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }
        throw
    }
    return [pscustomobject]@{ ExitCode = 0; Output = $outFull; UnitCount = $unitObjs.Count; SourceCount = $srcObjs.Count }
}

function Test-MagIdentityMatchesScope {
    param([string]$Identity, [string]$Scope)
    $id = $Identity.Trim()
    if ($id -eq 'GLOBAL' -and $Scope -eq 'GLOBAL') { return $true }
    if ($id -eq $Scope) { return $true }
    return $false
}

function Invoke-MagKnowledgeLocate {
    param(
        [Parameter(Mandatory)][string]$IndexPath,
        [Parameter(Mandatory)][string]$Identity,
        [Parameter(Mandatory)][string]$Intent,
        [Parameter(Mandatory)][string]$Query,
        [string]$Owner
    )
    $roots = Get-MagKnowledgeRoot
    $emit = {
        param($State, $Reason, $Pointer, $Candidates, $IndexMiss, $Exit)
        $obj = [ordered]@{
            state      = $State
            reason     = $Reason
            scope      = $null
            identity   = $Identity
            intent     = $Intent
            query      = $Query
            pointer    = $Pointer
            candidates = @($Candidates)
            index_miss = [bool]$IndexMiss
        }
        return [pscustomobject]@{ ExitCode = $Exit; Object = [pscustomobject]$obj }
    }

    if (-not (Test-Path -LiteralPath $IndexPath)) {
        $r = & $emit 'STALE/CONFLICT' 'missing_index' $null @() $false 3
        $r.Object.scope = $null
        return $r
    }
    try {
        $idx = Read-MagJsonFile $IndexPath
    }
    catch {
        return & $emit 'STALE/CONFLICT' 'corrupt_json' $null @() $false 3
    }

    $r0 = Invoke-MagKnowledgeValidate -IndexPath $IndexPath
    if ($r0.ExitCode -ne 0) {
        $reason = if ($r0.Errors -match 'stale_hash') { 'stale_hash' } else { [string]$r0.Reason }
        $x = & $emit 'STALE/CONFLICT' $reason $null @() $false 3
        if ($idx.scope) { $x.Object.scope = [string]$idx.scope }
        return $x
    }

    $xscope = [string]$idx.scope
    if (-not (Test-MagIdentityMatchesScope -Identity $Identity -Scope $xscope)) {
        $x = & $emit 'OUT_OF_SCOPE' 'foreign_identity' $null @() $false 4
        $x.Object.scope = $xscope
        return $x
    }

    $imap = Read-MagJsonFile (Join-Path $roots.Knowledge 'config\intent_owner_map.json')
    $intentName = $Intent.Trim().ToUpperInvariant()
    if ($script:MagKnownIntents -notcontains $intentName) {
        $x = & $emit 'OUT_OF_SCOPE' 'unknown_intent' $null @() $false 4
        $x.Object.scope = $xscope
        return $x
    }
    $allowed = @($imap.intents.$intentName)
    $units = @($idx.units | Where-Object { $allowed -contains $_.knowledge_class })
    if ($Owner) {
        $own = [IO.Path]::GetFileName($Owner)
        if (@($idx.sources | ForEach-Object { $_.owner }) -notcontains $own) {
            $x = & $emit 'OUT_OF_SCOPE' 'owner_not_in_scope' $null @() $false 4
            $x.Object.scope = $xscope
            return $x
        }
        $units = @($units | Where-Object { $_.owner -eq $own })
    }

    $qNorm = ConvertTo-MagNormalizedText $Query
    $qTokens = @(Get-MagTokens $Query)
    $exact = @()
    $allTok = @()
    foreach ($u in $units) {
        $tNorm = ConvertTo-MagNormalizedText $u.title
        if ($qNorm -eq $tNorm -and $qNorm -ne '') {
            $exact += $u
        }
        elseif ($qTokens.Count -ge 2) {
            $hay = Get-MagTokens ($u.title + ' ' + $u.heading_path)
            $ok = $true
            foreach ($tok in $qTokens) {
                if ($hay -notcontains $tok) { $ok = $false; break }
            }
            if ($ok) { $allTok += $u }
        }
    }

    $strong = @($exact)
    if ($strong.Count -eq 0) { $strong = @($allTok) }
    # unique by unit_id
    $map = @{}
    foreach ($u in $strong) { $map[$u.unit_id] = $u }
    $strong = @($map.Values)

    $toPointer = {
        param($u)
        [ordered]@{
            owner           = [string]$u.owner
            section         = [string]$u.section
            heading_path    = [string]$u.heading_path
            unit_id         = [string]$u.unit_id
            identity_scope  = [string]$u.identity_scope
            knowledge_class = [string]$u.knowledge_class
            source_id       = [string]$u.source_id
        }
    }

    if ($strong.Count -eq 0) {
        $x = & $emit 'NOT_FOUND' 'no_match' $null @() $true 1
        $x.Object.scope = $xscope
        return $x
    }
    if ($strong.Count -gt 1) {
        $cands = @($strong | Select-Object -First 5 | ForEach-Object { & $toPointer $_ })
        $x = & $emit 'AMBIGUOUS' 'multiple_candidates' $null $cands $false 2
        $x.Object.scope = $xscope
        return $x
    }
    $one = $strong[0]
    $ptr = & $toPointer $one
    $x = & $emit 'FOUND' 'exact_or_all_tokens' ([pscustomobject]$ptr) @() $false 0
    $x.Object.scope = $xscope
    return $x
}

function Write-MagLocatorOutput {
    param($Result)
    $json = $Result.Object | ConvertTo-Json -Depth 8
    Write-Output $json
    $o = $Result.Object
    $extra = ''
    if ($o.state -eq 'FOUND' -and $o.pointer) {
        $extra = " $($o.pointer.owner)#$($o.pointer.section)"
    }
    [Console]::Error.WriteLine("$($o.state) $($o.reason)$extra")
}

function Get-MagKnowledgeManifestFiles {
    param(
        [Parameter(Mandatory)]$Roots,
        [string]$ManifestDirectory
    )
    $dir = if ([string]::IsNullOrWhiteSpace($ManifestDirectory)) {
        Join-Path $Roots.Knowledge 'manifests'
    }
    else {
        Get-MagFullPath $ManifestDirectory
    }
    if (-not (Test-MagPathUnderRoot -Path $dir -Root $Roots.Ecosystem)) {
        throw 'path_outside_ecosystem'
    }
    if (-not (Test-Path -LiteralPath $dir -PathType Container)) {
        throw "missing_manifest_directory:$dir"
    }
    return @(Get-ChildItem -LiteralPath $dir -Filter '*.json' -File | Sort-Object Name)
}

function Test-MagPathEquals {
    param([string]$A, [string]$B)
    if ([string]::IsNullOrWhiteSpace($A) -or [string]::IsNullOrWhiteSpace($B)) {
        return $false
    }
    $fa = (Get-MagFullPath $A).TrimEnd('\', '/')
    $fb = (Get-MagFullPath $B).TrimEnd('\', '/')
    return $fa.Equals($fb, [StringComparison]::OrdinalIgnoreCase)
}

function Test-MagChangedFileHitsSource {
    param(
        [Parameter(Mandatory)]$SourceItem,
        [AllowEmptyCollection()][string[]]$ChangedFullPaths
    )
    foreach ($c in @($ChangedFullPaths)) {
        if ([string]::IsNullOrWhiteSpace($c)) { continue }
        if (Test-MagPathEquals $c $SourceItem.FullPath) { return $true }
        $cn = $c.Trim().Replace('/', '\')
        if (-not [IO.Path]::IsPathRooted($cn)) {
            if ([IO.Path]::GetFileName($cn).Equals($SourceItem.Owner, [StringComparison]::OrdinalIgnoreCase)) {
                return $true
            }
            $rel = ([string]$SourceItem.RelPath).Replace('/', '\')
            if ($cn.Equals($rel, [StringComparison]::OrdinalIgnoreCase)) { return $true }
        }
    }
    return $false
}

function Get-MagRefreshDecisions {
    param(
        [Parameter(Mandatory)]$Roots,
        [string]$ManifestDirectory,
        [AllowEmptyCollection()][string[]]$ChangedFiles,
        [bool]$CompareIndexHashes = $true
    )
    $rules = Read-MagJsonFile (Join-Path $Roots.Knowledge 'config\source_rules.json')
    $changedFull = [System.Collections.Generic.List[string]]::new()
    foreach ($c in @($ChangedFiles)) {
        if ([string]::IsNullOrWhiteSpace($c)) { continue }
        $t = $c.Trim()
        if (Test-Path -LiteralPath $t) {
            $changedFull.Add((Get-MagFullPath $t)) | Out-Null
        }
        elseif (Test-Path -LiteralPath (Join-Path $Roots.Ecosystem $t)) {
            $changedFull.Add((Get-MagFullPath (Join-Path $Roots.Ecosystem $t))) | Out-Null
        }
        else {
            $changedFull.Add($t) | Out-Null
        }
    }
    $decisions = [System.Collections.Generic.List[object]]::new()
    foreach ($mf in @(Get-MagKnowledgeManifestFiles -Roots $Roots -ManifestDirectory $ManifestDirectory)) {
        $manifest = Import-MagManifest -ManifestPath $mf.FullName -Roots $Roots
        $outRel = [string]$manifest.output
        $outFull = if ([IO.Path]::IsPathRooted($outRel)) { Get-MagFullPath $outRel } else { Get-MagFullPath (Join-Path $Roots.Ecosystem $outRel) }
        $reasons = [System.Collections.Generic.List[string]]::new()
        $sources = $null
        try {
            $sources = @(Get-MagApprovedSources -Manifest $manifest -Rules $rules -Roots $Roots)
        }
        catch {
            $reasons.Add([string]$_.Exception.Message)
        }
        if (-not (Test-Path -LiteralPath $outFull)) {
            $reasons.Add('missing_index')
        }
        elseif ($CompareIndexHashes -and $sources) {
            $idx = $null
            try { $idx = Read-MagJsonFile $outFull } catch { $reasons.Add('unreadable_index') }
            if ($idx) {
                foreach ($item in $sources) {
                    $entry = @($idx.sources | Where-Object { [string]$_.owner -eq [string]$item.Owner })
                    if ($entry.Count -eq 0) {
                        $reasons.Add("missing_index_source:$($item.Owner)")
                        continue
                    }
                    $bytes = [IO.File]::ReadAllBytes($item.FullPath)
                    $sha = Get-MagSha256Hex $bytes
                    if ($sha -ne [string]$entry[0].content_sha256) {
                        $reasons.Add("sha_mismatch:$($item.Owner)")
                    }
                }
            }
        }
        if ($sources -and $changedFull.Count -gt 0) {
            foreach ($item in $sources) {
                if (Test-MagChangedFileHitsSource -SourceItem $item -ChangedFullPaths @($changedFull)) {
                    $reasons.Add("changed_file:$($item.Owner)")
                }
            }
        }
        $uniq = @($reasons | Select-Object -Unique)
        $decisions.Add([pscustomobject]@{
            ManifestPath = $mf.FullName
            Scope        = [string]$manifest.scope
            Output       = $outFull
            Affected     = ($uniq.Count -gt 0)
            Reasons      = $uniq
        }) | Out-Null
    }
    return @($decisions)
}

function Invoke-MagKnowledgeRefresh {
    param(
        [Parameter(Mandatory)]$Roots,
        [string]$ManifestDirectory,
        [AllowEmptyCollection()][string[]]$ChangedFiles = @(),
        [bool]$DryRun = $false
    )
    $decisions = @(Get-MagRefreshDecisions -Roots $Roots -ManifestDirectory $ManifestDirectory -ChangedFiles $ChangedFiles -CompareIndexHashes $true)
    $affected = @($decisions | Where-Object { $_.Affected })
    if ($affected.Count -eq 0) {
        return [pscustomobject]@{
            ExitCode = 0
            State    = 'NO_INDEXED_SOURCE_CHANGE'
            Affected = @()
            Detail   = 'NOOP: no supported manifest selected; indexes were not regenerated or re-certified'
        }
    }
    if ($DryRun) {
        return [pscustomobject]@{
            ExitCode = 0
            State    = 'DRY_RUN'
            Affected = $affected
            Detail   = 'no generated writes'
        }
    }
    $generated = [System.Collections.Generic.List[string]]::new()
    foreach ($item in $affected) {
        try {
            $null = Invoke-MagKnowledgeGenerate -ManifestPath $item.ManifestPath
            $val = Invoke-MagKnowledgeValidate -IndexPath $item.Output -ManifestPath $item.ManifestPath
            if ($val.ExitCode -ne 0) {
                throw ('validate_failed:' + ($val.Errors -join '; '))
            }
            $generated.Add([string]$item.Scope) | Out-Null
        }
        catch {
            $msg = [string]$_.Exception.Message
            $code = 3
            if ($msg -match '^(usage|path_outside)') { $code = 5 }
            return [pscustomobject]@{
                ExitCode = $code
                State    = 'FAILED'
                Affected = $affected
                Detail   = "generate_failed:$($item.Scope):$msg"
            }
        }
    }
    return [pscustomobject]@{
        ExitCode = 0
        State    = 'UPDATED'
        Affected = $affected
        Detail   = ('regenerated:' + ($generated -join ','))
    }
}
