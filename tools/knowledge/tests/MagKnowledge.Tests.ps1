#Requires -Version 7.0
# Dependency-free runner (Pester is not installed; do not install).
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$here = $PSScriptRoot
$lib = Join-Path (Split-Path $here -Parent) 'lib'
. (Join-Path $lib 'MarkdownHeadings.ps1')
. (Join-Path $lib 'MagKnowledge.Common.ps1')

$script:Failed = 0
$script:Passed = 0
$roots = Get-MagKnowledgeRoot
$pwsh = (Get-Process -Id $PID).Path
if ($pwsh -notmatch 'pwsh') {
    $pwsh = 'pwsh'
}

function Assert-True {
    param([bool]$Condition, [string]$Name, [string]$Detail = '')
    if ($Condition) {
        $script:Passed++
        Write-Host "PASS $Name"
    }
    else {
        $script:Failed++
        Write-Host "FAIL $Name $Detail"
    }
}

function Invoke-Gen {
    param($Manifest, $Output)
    $gen = Join-Path $roots.Knowledge 'Generate-MagKnowledgeIndex.ps1'
    $args = @('-NoProfile', '-File', $gen, '-Manifest', $Manifest)
    if ($Output) { $args += @('-Output', $Output) }
    & $pwsh @args 2>&1 | Out-Null
    return $LASTEXITCODE
}

function Invoke-Val {
    param($Index, $Manifest)
    $val = Join-Path $roots.Knowledge 'Validate-MagKnowledgeIndex.ps1'
    $args = @('-NoProfile', '-File', $val, '-Index', $Index)
    if ($Manifest) { $args += @('-Manifest', $Manifest) }
    & $pwsh @args 2>&1 | Out-Null
    return $LASTEXITCODE
}

function Invoke-Loc {
    param($Index, $Identity, $Intent, $Query, $Owner)
    $loc = Join-Path $roots.Knowledge 'Locate-MagKnowledge.ps1'
    $args = @('-NoProfile', '-File', $loc, '-Index', $Index, '-Identity', $Identity, '-Intent', $Intent, '-Query', $Query)
    if ($Owner) { $args += @('-Owner', $Owner) }
    $out = & $pwsh @args 2>$null
    $code = $LASTEXITCODE
    $json = $null
    try { $json = $out | Out-String | ConvertFrom-Json } catch { }
    return [pscustomobject]@{ Code = $code; Json = $json; Raw = $out }
}

function Invoke-Update {
    param($ManifestDirectory, [string[]]$ChangedFiles, [switch]$DryRun)
    return Invoke-MagKnowledgeRefresh -Roots $roots -ManifestDirectory $ManifestDirectory -ChangedFiles $ChangedFiles -DryRun:([bool]$DryRun)
}

$manG = Join-Path $roots.Knowledge 'manifests\global.json'
$man5 = Join-Path $roots.Knowledge 'manifests\global-5.json'
$idxG = Join-Path $roots.Ecosystem 'generated\knowledge\index-global.json'
$idx5 = Join-Path $roots.Ecosystem 'generated\knowledge\index-global-5.json'

# 1 Global generation
$c1 = Invoke-Gen $manG
Assert-True ($c1 -eq 0 -and (Test-Path $idxG)) '1-global-generation' "exit=$c1"

# 2 GLOBAL+#5
$c2 = Invoke-Gen $man5
Assert-True ($c2 -eq 0 -and (Test-Path $idx5)) '2-global-5-generation' "exit=$c2"

# 3 #5 cannot include #8
$idx5obj = Read-MagJsonFile $idx5
$blob5 = Get-Content -LiteralPath $idx5 -Raw
$no8 = ($blob5 -notmatch 'ACP-Enhancements' -and $blob5 -notmatch 'P08__' -and $blob5 -notmatch 'GLOBAL\+#8')
Assert-True $no8 '3-no-hash8-in-global-5'

# 4 Roadmap/pipeline rejected
$badDir = Join-Path $roots.Ecosystem '.mag-kn-test'
New-Item -ItemType Directory -Path $badDir -Force | Out-Null
$badMan = Join-Path $badDir 'bad-roadmap.json'
$good = Read-MagJsonFile $manG
$good.global_sources = @('MAG_KNOWLEDGE_CONTROL_ROADMAP.md')
($good | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath $badMan -Encoding utf8
$c4 = Invoke-Gen $badMan
Assert-True ($c4 -eq 3) '4-roadmap-rejected' "exit=$c4"

# 5 MAG_DEBUGGING is indexed with a SHA-256 (git tree_state may be untracked, committed, or modified)
$idxGobj = Read-MagJsonFile $idxG
$dbgSrc = @($idxGobj.sources | Where-Object { $_.owner -eq 'MAG_DEBUGGING.md' })
if ($dbgSrc.Count -ne 1) {
    Assert-True $false '5-debugging-indexed-revision' "count=$($dbgSrc.Count)"
}
else {
    $dbgTreeOk = $dbgSrc[0].tree_state -in @('untracked', 'committed', 'modified') -and $dbgSrc[0].content_sha256.Length -eq 64
    if ($dbgSrc[0].tree_state -eq 'untracked') {
        $dbgTreeOk = $dbgTreeOk -and ($null -eq $dbgSrc[0].git_blob -or "$($dbgSrc[0].git_blob)" -eq '')
    }
    Assert-True $dbgTreeOk '5-debugging-indexed-revision' "tree=$($dbgSrc[0].tree_state)"
}

# 6 Unstaged edit stale via fixture
$fx = Join-Path $badDir 'fx'
New-Item -ItemType Directory -Path $fx -Force | Out-Null
@"
# Fixture Eco

- MAG-Document-ID: ``MAG_ECOSYSTEM.md``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

## Alpha Unique Heading
text
"@ | Set-Content -LiteralPath (Join-Path $fx 'MAG_ECOSYSTEM.md') -Encoding utf8
$fxMan = [pscustomobject]@{
    schema_version = 1
    config_version = 1
    scope = 'GLOBAL'
    ecosystem_root = '.mag-kn-test/fx'
    global_sources = @('MAG_ECOSYSTEM.md')
    source_rules = 'config/source_rules.json'
    intent_owner_map = 'config/intent_owner_map.json'
    output = 'generated/knowledge/index-fx.json'
}
$fxManPath = Join-Path $badDir 'fx-man.json'
($fxMan | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath $fxManPath -Encoding utf8
$c6a = Invoke-Gen $fxManPath
$idxFx = Join-Path $roots.Ecosystem 'generated\knowledge\index-fx.json'
Add-Content -LiteralPath (Join-Path $fx 'MAG_ECOSYSTEM.md') -Value "`nedit`n" -Encoding utf8
$c6b = Invoke-Val $idxFx $fxManPath
Assert-True ($c6a -eq 0 -and $c6b -eq 3) '6-unstaged-edit-stale' "gen=$c6a val=$c6b"

# 7 Missing source
$fx2 = Join-Path $badDir 'fxmiss'
New-Item -ItemType Directory -Path $fx2 -Force | Out-Null
Copy-Item (Join-Path $fx 'MAG_ECOSYSTEM.md') (Join-Path $fx2 'MAG_ECOSYSTEM.md')
$fxMan2 = $fxMan.PSObject.Copy()
$fxMan2.ecosystem_root = '.mag-kn-test/fxmiss'
$fxMan2.output = 'generated/knowledge/index-fxmiss.json'
$fxMan2Path = Join-Path $badDir 'fx-miss.json'
($fxMan2 | ConvertTo-Json -Depth 8) | Set-Content $fxMan2Path -Encoding utf8
$c7a = Invoke-Gen $fxMan2Path
Remove-Item (Join-Path $fx2 'MAG_ECOSYSTEM.md') -Force
$c7b = Invoke-Val (Join-Path $roots.Ecosystem 'generated\knowledge\index-fxmiss.json')
Assert-True ($c7a -eq 0 -and $c7b -eq 3) '7-missing-source' "gen=$c7a val=$c7b"

# 8 Corrupt index
$cor = Join-Path $badDir 'corrupt.json'
Set-Content $cor '{ not json' -Encoding utf8
$c8 = Invoke-Val $cor
Assert-True ($c8 -eq 3) '8-corrupt-json'

# 9 Unknown schema
$idxCopy = Read-MagJsonFile $idxG
$idxCopy.schema_version = 2
$unk = Join-Path $badDir 'schema2.json'
($idxCopy | ConvertTo-Json -Depth 32) | Set-Content $unk -Encoding utf8
$c9 = Invoke-Val $unk
Assert-True ($c9 -eq 3) '9-unknown-schema'

# 10 Duplicate unit_id
$dup = Read-MagJsonFile $idxG
$u0 = $dup.units[0]
$dup.units += $u0
$dupPath = Join-Path $badDir 'dup-uid.json'
($dup | ConvertTo-Json -Depth 32) | Set-Content $dupPath -Encoding utf8
$c10 = Invoke-Val $dupPath
Assert-True ($c10 -eq 3) '10-duplicate-unit-id'

# 11 Duplicate headings
$fxd = Join-Path $badDir 'fxdup'
New-Item -ItemType Directory -Path $fxd -Force | Out-Null
@"
# Fixture Eco

- MAG-Document-ID: ``MAG_ECOSYSTEM.md``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

## Same Title
a
## Same Title
b
"@ | Set-Content (Join-Path $fxd 'MAG_ECOSYSTEM.md') -Encoding utf8
$manDupH = [pscustomobject]@{
    schema_version = 1; config_version = 1; scope = 'GLOBAL'
    ecosystem_root = '.mag-kn-test/fxdup'
    global_sources = @('MAG_ECOSYSTEM.md')
    source_rules = 'config/source_rules.json'
    intent_owner_map = 'config/intent_owner_map.json'
    output = 'generated/knowledge/index-duph.json'
}
$manDupHPath = Join-Path $badDir 'duph-man.json'
($manDupH | ConvertTo-Json -Depth 8) | Set-Content $manDupHPath -Encoding utf8
$c11 = Invoke-Gen $manDupHPath
Assert-True ($c11 -eq 3) '11-duplicate-headings' "exit=$c11"

# 12 Renamed heading
$fxr = Join-Path $badDir 'fxren'
New-Item -ItemType Directory -Path $fxr -Force | Out-Null
@"
# Fixture Eco

- MAG-Document-ID: ``MAG_ECOSYSTEM.md``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

## Original Name
x
"@ | Set-Content (Join-Path $fxr 'MAG_ECOSYSTEM.md') -Encoding utf8
$manRen = [pscustomobject]@{
    schema_version = 1; config_version = 1; scope = 'GLOBAL'
    ecosystem_root = '.mag-kn-test/fxren'
    global_sources = @('MAG_ECOSYSTEM.md')
    source_rules = 'config/source_rules.json'
    intent_owner_map = 'config/intent_owner_map.json'
    output = 'generated/knowledge/index-ren.json'
}
$manRenPath = Join-Path $badDir 'ren-man.json'
($manRen | ConvertTo-Json -Depth 8) | Set-Content $manRenPath -Encoding utf8
$c12a = Invoke-Gen $manRenPath
(Get-Content (Join-Path $fxr 'MAG_ECOSYSTEM.md') -Raw) -replace 'Original Name', 'Renamed Name' |
    Set-Content (Join-Path $fxr 'MAG_ECOSYSTEM.md') -Encoding utf8
$c12b = Invoke-Val (Join-Path $roots.Ecosystem 'generated\knowledge\index-ren.json')
Assert-True ($c12a -eq 0 -and $c12b -eq 3) '12-renamed-heading' "gen=$c12a val=$c12b"

# 13 Unknown intent
$l13 = Invoke-Loc $idxG 'GLOBAL' 'FOO' 'authority'
Assert-True ($l13.Code -eq 4 -and $l13.Json.reason -eq 'unknown_intent') '13-unknown-intent' "code=$($l13.Code)"

# 14 Unknown knowledge_class
$badc = Read-MagJsonFile $idxG
$badc.units[0].knowledge_class = 'not_a_class'
$badcPath = Join-Path $badDir 'badclass.json'
($badc | ConvertTo-Json -Depth 32) | Set-Content $badcPath -Encoding utf8
$c14 = Invoke-Val $badcPath
Assert-True ($c14 -eq 3) '14-unknown-class'

# 15 Empty aliases
$als = @($idxGobj.units | Where-Object { @($_.aliases).Count -ne 0 })
Assert-True ($als.Count -eq 0) '15-empty-aliases'

# 16 Exact title FOUND
$l16 = Invoke-Loc $idxG 'GLOBAL' 'GOVERN' 'Documentation authority model'
Assert-True ($l16.Code -eq 0 -and $l16.Json.state -eq 'FOUND' -and $null -eq $l16.Json.pointer.PSObject.Properties['body']) '16-exact-title-found' "code=$($l16.Code) state=$($l16.Json.state)"

# 17 AMBIGUOUS: clone unit same title
$amb = Read-MagJsonFile $idxG
$clone = $amb.units[0] | ConvertTo-Json -Depth 8 | ConvertFrom-Json
$clone.unit_id = $clone.unit_id + '-clone'
$amb.units += $clone
$ambPath = Join-Path $badDir 'amb.json'
($amb | ConvertTo-Json -Depth 32) | Set-Content $ambPath -Encoding utf8
$l17 = Invoke-Loc $ambPath 'GLOBAL' 'GOVERN' $clone.title
Assert-True ($l17.Code -eq 2 -and $l17.Json.state -eq 'AMBIGUOUS') '17-ambiguous' "code=$($l17.Code)"

# 18 Weak/single-token partial
$l18 = Invoke-Loc $idxG 'GLOBAL' 'GOVERN' 'the'
Assert-True ($l18.Code -eq 1 -and $l18.Json.state -eq 'NOT_FOUND') '18-weak-partial' "code=$($l18.Code) state=$($l18.Json.state)"

# 19 Foreign identity no leakage
$l19 = Invoke-Loc $idx5 'GLOBAL+#8' 'DEBUG' 'anything'
$leak = ($l19.Raw | Out-String) -match 'ACP-Enhancements|P08__'
Assert-True ($l19.Code -eq 4 -and $l19.Json.reason -eq 'foreign_identity' -and -not $leak -and (@($l19.Json.candidates).Count -eq 0)) '19-foreign-out-of-scope' "code=$($l19.Code)"

# 20 Missing index
$l20 = Invoke-Loc (Join-Path $roots.Ecosystem 'generated\knowledge\no-such.json') 'GLOBAL' 'GOVERN' 'x'
Assert-True ($l20.Code -eq 3 -and $l20.Json.reason -eq 'missing_index') '20-missing-index'

# 21 Generated artifact cannot be source
$genMan = Read-MagJsonFile $manG
$genMan.global_sources = @('generated/knowledge/index-global.json')
$genManPath = Join-Path $badDir 'gen-src.json'
($genMan | ConvertTo-Json -Depth 8) | Set-Content $genManPath -Encoding utf8
$c21 = Invoke-Gen $genManPath
Assert-True ($c21 -eq 3) '21-generated-not-source' "exit=$c21"

# 22 Pattern body absent
$rawG = Get-Content $idxG -Raw
$noBody = ($rawG -notmatch '"body"' -and $rawG -notmatch '"excerpt"' -and $rawG -notmatch '"verified_scope"' -and $rawG -notmatch 'enqueueUnique')
Assert-True $noBody '22-pattern-body-absent'

# 23 Development document body absent
$raw5 = Get-Content $idx5 -Raw
$noReq = ($raw5 -notmatch '"requirements"' -and $raw5 -notmatch '"body"')
$hasDev = @((Read-MagJsonFile $idx5).units | Where-Object { $_.knowledge_class -like 'development_*' }).Count -gt 0
Assert-True ($noReq -and $hasDev) '23-dev-body-absent'

# 24 Failed generation does not replace
$keep = Join-Path $roots.Ecosystem 'generated\knowledge\index-keep.json'
Copy-Item $idxFx $keep -Force
$before = Get-Content $keep -Raw
$c24 = Invoke-Gen $manDupHPath
# manDupH output is index-duph not keep - need generate targeting keep with failing manifest
$failKeep = [pscustomobject]@{
    schema_version = 1; config_version = 1; scope = 'GLOBAL'
    ecosystem_root = '.mag-kn-test/fxdup'
    global_sources = @('MAG_ECOSYSTEM.md')
    source_rules = 'config/source_rules.json'
    intent_owner_map = 'config/intent_owner_map.json'
    output = 'generated/knowledge/index-keep.json'
}
$failKeepPath = Join-Path $badDir 'fail-keep.json'
($failKeep | ConvertTo-Json -Depth 8) | Set-Content $failKeepPath -Encoding utf8
$c24 = Invoke-Gen $failKeepPath
$after = Get-Content $keep -Raw
$partials = @(Get-ChildItem (Join-Path $roots.Ecosystem 'generated\knowledge') -Filter 'index-partial-*.json' -ErrorAction SilentlyContinue)
Assert-True ($c24 -eq 3 -and $before -eq $after -and $partials.Count -eq 0) '24-failed-no-publish' "exit=$c24 partials=$($partials.Count)"

# 25 Successful regeneration atomic
$c25a = Invoke-Gen $fxManPath
$h1 = (Read-MagJsonFile $idxFx).generated_at
Start-Sleep -Milliseconds 1100
$c25b = Invoke-Gen $fxManPath
$h2 = (Read-MagJsonFile $idxFx).generated_at
Assert-True ($c25a -eq 0 -and $c25b -eq 0 -and $h1 -ne $h2) '25-atomic-regen' "t1=$h1 t2=$h2"

# extra: validate production indexes
$vg = Invoke-Val $idxG $manG
$v5 = Invoke-Val $idx5 $man5
Assert-True ($vg -eq 0 -and $v5 -eq 0) 'validate-production-indexes' "g=$vg 5=$v5"

# Orchestrator fixtures (isolated manifests; not production indexes)
$orchRoot = Join-Path $badDir 'orch'
$orchEco = Join-Path $orchRoot 'eco'
$orchDev = Join-Path $orchRoot 'dev\docs'
$orchManDir = Join-Path $orchRoot 'manifests'
New-Item -ItemType Directory -Path $orchEco, $orchDev, $orchManDir -Force | Out-Null
@"
# Fixture Eco

- MAG-Document-ID: ``MAG_ECOSYSTEM.md``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

## Orch Alpha
text
"@ | Set-Content -LiteralPath (Join-Path $orchEco 'MAG_ECOSYSTEM.md') -Encoding utf8
@"
# Fixture Debug

- MAG-Document-ID: ``MAG_DEBUGGING.md``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

## Orch Debug
text
"@ | Set-Content -LiteralPath (Join-Path $orchEco 'MAG_DEBUGGING.md') -Encoding utf8
@"
# Fixture TZ

- MAG-Document-ID: ``P05__3DR__TZ.md``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

## Orch Purpose
text
"@ | Set-Content -LiteralPath (Join-Path $orchDev 'P05__3DR__TZ.md') -Encoding utf8

$orchGMan = [pscustomobject]@{
    schema_version = 1; config_version = 1; scope = 'GLOBAL'
    ecosystem_root = '.mag-kn-test/orch/eco'
    global_sources = @('MAG_ECOSYSTEM.md', 'MAG_DEBUGGING.md')
    source_rules = 'config/source_rules.json'
    intent_owner_map = 'config/intent_owner_map.json'
    output = 'generated/knowledge/index-orch-g.json'
}
$orch5Man = [pscustomobject]@{
    schema_version = 1; config_version = 1; scope = 'GLOBAL+#5'
    ecosystem_root = '.mag-kn-test/orch/eco'
    global_sources = @('MAG_ECOSYSTEM.md', 'MAG_DEBUGGING.md')
    development = @{ identity = '#5'; repo_root = '../dev'; doc_files = @('docs/P05__3DR__TZ.md') }
    source_rules = 'config/source_rules.json'
    intent_owner_map = 'config/intent_owner_map.json'
    output = 'generated/knowledge/index-orch-5.json'
}
$orchGManPath = Join-Path $orchManDir 'orch-global.json'
$orch5ManPath = Join-Path $orchManDir 'orch-global-5.json'
($orchGMan | ConvertTo-Json -Depth 8) | Set-Content $orchGManPath -Encoding utf8
($orch5Man | ConvertTo-Json -Depth 8) | Set-Content $orch5ManPath -Encoding utf8
$idxOrchG = Join-Path $roots.Ecosystem 'generated\knowledge\index-orch-g.json'
$idxOrch5 = Join-Path $roots.Ecosystem 'generated\knowledge\index-orch-5.json'
$cOg = Invoke-Gen $orchGManPath
$cO5 = Invoke-Gen $orch5ManPath
Assert-True ($cOg -eq 0 -and $cO5 -eq 0) 'orch-fixture-gen' "g=$cOg 5=$cO5"

function Get-OrchAffectedScopes {
    param([string[]]$ChangedFiles = @())
    $d = @(Get-MagRefreshDecisions -Roots $roots -ManifestDirectory $orchManDir -ChangedFiles $ChangedFiles -CompareIndexHashes $true)
    return @($d | Where-Object { $_.Affected } | ForEach-Object { [string]$_.Scope })
}

$noopScopes = @(Get-OrchAffectedScopes)
$noopCli = Invoke-Update $orchManDir
Assert-True ($noopScopes.Count -eq 0 -and $noopCli.ExitCode -eq 0 -and $noopCli.State -eq 'NO_INDEXED_SOURCE_CHANGE') 'orch-noop' "scopes=$($noopScopes.Count) code=$($noopCli.ExitCode)"

$hG0 = (Get-FileHash -LiteralPath $idxOrchG -Algorithm SHA256).Hash
$h50 = (Get-FileHash -LiteralPath $idxOrch5 -Algorithm SHA256).Hash
Add-Content -LiteralPath (Join-Path $orchEco 'MAG_ECOSYSTEM.md') -Value "`nchanged-global`n" -Encoding utf8
$both = @(Get-OrchAffectedScopes)
$dryG = Invoke-Update $orchManDir -DryRun
$hG1 = (Get-FileHash -LiteralPath $idxOrchG -Algorithm SHA256).Hash
$h51 = (Get-FileHash -LiteralPath $idxOrch5 -Algorithm SHA256).Hash
Assert-True ($dryG.ExitCode -eq 0 -and $dryG.State -eq 'DRY_RUN' -and $hG0 -eq $hG1 -and $h50 -eq $h51 -and $both -contains 'GLOBAL' -and $both -contains 'GLOBAL+#5') 'orch-global-selects-both-dryrun' "scopes=$($both -join ',')"

@"
# Fixture Eco

- MAG-Document-ID: ``MAG_ECOSYSTEM.md``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

## Orch Alpha
text
"@ | Set-Content -LiteralPath (Join-Path $orchEco 'MAG_ECOSYSTEM.md') -Encoding utf8
$cOg2 = Invoke-Gen $orchGManPath
$cO52 = Invoke-Gen $orch5ManPath
$hG2 = (Get-FileHash -LiteralPath $idxOrchG -Algorithm SHA256).Hash
Add-Content -LiteralPath (Join-Path $orchDev 'P05__3DR__TZ.md') -Value "`nchanged-tz`n" -Encoding utf8
$s5 = @(Get-OrchAffectedScopes)
$sel5 = Invoke-Update $orchManDir -DryRun
$hG3 = (Get-FileHash -LiteralPath $idxOrchG -Algorithm SHA256).Hash
Assert-True ($sel5.ExitCode -eq 0 -and $s5.Count -eq 1 -and $s5[0] -eq 'GLOBAL+#5' -and $hG2 -eq $hG3) 'orch-5-only-selects-5' "scopes=$($s5 -join ',')"

$run5 = Invoke-Update $orchManDir
$hG4 = (Get-FileHash -LiteralPath $idxOrchG -Algorithm SHA256).Hash
Assert-True ($run5.ExitCode -eq 0 -and $run5.State -eq 'UPDATED' -and $hG2 -eq $hG4) 'orch-5-only-does-not-write-global' "code=$($run5.ExitCode) gChanged=$($hG2 -ne $hG4)"

$locWrong = Invoke-Loc $idxOrch5 'GLOBAL' 'GOVERN' 'Orch Alpha'
Assert-True ($locWrong.Code -eq 4) 'orch-global-never-uses-global5' "code=$($locWrong.Code)"

$noneScopes = @(Get-OrchAffectedScopes -ChangedFiles @('tools/knowledge/README.md', 'MAG_KNOWLEDGE_CONTROL_ROADMAP.md', 'docs/P08__AE__TZ.md'))
$noneCli = Invoke-Update $orchManDir @('tools/knowledge/README.md', 'MAG_KNOWLEDGE_CONTROL_ROADMAP.md', 'docs/P08__AE__TZ.md')
Assert-True ($noneCli.ExitCode -eq 0 -and $noneScopes.Count -eq 0) 'orch-nonindexed-selects-nothing' "scopes=$($noneScopes.Count) code=$($noneCli.ExitCode)"

# Missing fixture index selects only that manifest (DryRun; no generated write)
$orch5ManObj = Import-MagManifest -ManifestPath $orch5ManPath -Roots $roots
$null = Invoke-Gen $orchGManPath
$null = Invoke-Gen $orch5ManPath
Remove-Item -LiteralPath $idxOrch5 -Force
$miAbsentBefore = -not (Test-Path -LiteralPath $idxOrch5)
$miDecisions = @(Get-MagRefreshDecisions -Roots $roots -ManifestDirectory $orchManDir -ChangedFiles @() -CompareIndexHashes $true)
$miAffected = @($miDecisions | Where-Object { $_.Affected })
$miG5 = @($miAffected | Where-Object { $_.Scope -eq 'GLOBAL+#5' })
$miG = @($miAffected | Where-Object { $_.Scope -eq 'GLOBAL' })
$miDry = Invoke-Update $orchManDir -DryRun
$miReasonOk = ($miG5.Count -eq 1) -and (@($miG5[0].Reasons) -contains 'missing_index')
$miSelectOk = ($orch5ManObj.scope -eq 'GLOBAL+#5') -and ($miAffected.Count -eq 1) -and $miReasonOk -and ($miG.Count -eq 0)
$dryAff = @($miDry.Affected | Where-Object { $_.Scope -eq 'GLOBAL+#5' })
$miDryReasonOk = ($dryAff.Count -eq 1) -and (@($dryAff[0].Reasons) -contains 'missing_index')
$miDryOk = ($miDry.ExitCode -eq 0) -and ($miDry.State -eq 'DRY_RUN') -and (-not (Test-Path -LiteralPath $idxOrch5))
$cMiRestore = Invoke-Gen $orch5ManPath
$miRestoreOk = ($cMiRestore -eq 0) -and (Test-Path -LiteralPath $idxOrch5)
Assert-True ($miAbsentBefore -and $miSelectOk -and $miDryOk -and $miDryReasonOk -and (Test-Path -LiteralPath $idxOrchG) -and $miRestoreOk) 'orch-missing-index-selects-dryrun' "aff=$($miAffected.Count) dry=$($miDry.State)"

@"
# Fixture TZ

- MAG-Document-ID: ``P05__3DR__TZ.md``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

## Orch Purpose
text
"@ | Set-Content -LiteralPath (Join-Path $orchDev 'P05__3DR__TZ.md') -Encoding utf8
$null = Invoke-Gen $orchGManPath
$null = Invoke-Gen $orch5ManPath
Add-Content -LiteralPath (Join-Path $orchEco 'MAG_DEBUGGING.md') -Value "`nsha-untracked`n" -Encoding utf8
$sd = @(Get-OrchAffectedScopes)
Assert-True ($sd -contains 'GLOBAL' -and $sd -contains 'GLOBAL+#5') 'orch-untracked-global-via-sha' "scopes=$($sd -join ',')"

@"
# Fixture Debug

- MAG-Document-ID: ``MAG_DEBUGGING.md``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

## Orch Debug
text
"@ | Set-Content -LiteralPath (Join-Path $orchEco 'MAG_DEBUGGING.md') -Encoding utf8
$null = Invoke-Gen $orchGManPath
$keepFail = Get-Content -LiteralPath $idxOrchG -Raw
Add-Content -LiteralPath (Join-Path $orchEco 'MAG_ECOSYSTEM.md') -Value "`n## Orch Alpha`n" -Encoding utf8
$failU = Invoke-Update $orchManDir
$afterFail = Get-Content -LiteralPath $idxOrchG -Raw
Assert-True ($failU.ExitCode -eq 3 -and $keepFail -eq $afterFail) 'orch-fail-no-replace' "code=$($failU.ExitCode)"

# Stage 6 — working identity vs generated discovery (no A index recipe)
$wG = Get-MagWorkingIdentity 'GLOBAL'
$w5 = Get-MagWorkingIdentity 'GLOBAL+#5'
$wA1 = Get-MagWorkingIdentity 'GLOBAL+A1'
$wA5 = Get-MagWorkingIdentity 'GLOBAL+A5'
$wB1 = Get-MagWorkingIdentity 'GLOBAL+B1'
$wBbare = Get-MagWorkingIdentity 'B1'
$wDesk = Get-MagWorkingIdentity 'Desktop'
$wAnd = Get-MagWorkingIdentity 'Android'
Assert-True ($wG.Assignable -and $wG.Kind -eq 'GLOBAL') 's6-global-assignable'
Assert-True ($w5.Assignable -and $w5.Kind -eq 'HASH_N' -and $w5.Number -eq '5') 's6-global-hash5-assignable'
Assert-True ($wA1.Assignable -and $wA1.Kind -eq 'A_N' -and (Test-MagAssignableWorkingIdentity 'GLOBAL+A1')) 's6-a1-plan-identity-valid'
Assert-True ($wA1.Assignable -and $wA1.Status -eq 'assignable') 's6-a1-debug-identity-valid'
Assert-True (-not $wB1.Assignable -and $wB1.Status -eq 'reserved' -and -not $wBbare.Assignable) 's6-b1-reserved'
Assert-True ($w5.Input -ne $wA5.Input -and $wA5.Assignable -and $wA5.Namespace -eq 'A' -and $w5.Namespace -eq '#') 's6-hash5-not-a5'
Assert-True (-not $wDesk.Assignable -and -not $wAnd.Assignable -and $wDesk.Status -eq 'invalid') 's6-surface-not-identity'

$lA1miss = Invoke-Loc (Join-Path $roots.Ecosystem 'generated\knowledge\no-such-a1.json') 'GLOBAL+A1' 'PLAN' 'x'
Assert-True ($lA1miss.Code -eq 3 -and $lA1miss.Json.reason -eq 'missing_index' -and $lA1miss.Json.working_identity_status -eq 'assignable' -and (Get-MagWorkingIdentity 'GLOBAL+A1').Assignable) 's6-missing-a-index-identity-valid' "code=$($lA1miss.Code) st=$($lA1miss.Json.working_identity_status)"

$lBmiss = Invoke-Loc (Join-Path $roots.Ecosystem 'generated\knowledge\no-such-b1.json') 'GLOBAL+B1' 'PLAN' 'x'
$lBidx = Invoke-Loc $idxG 'GLOBAL+B1' 'GOVERN' 'Documentation authority model'
Assert-True ($lBmiss.Code -eq 4 -and $lBmiss.Json.reason -eq 'reserved_identity' -and $lBidx.Code -eq 4) 's6-b-reserved-before-index' "miss=$($lBmiss.Code) idx=$($lBidx.Code)"

$lAonG = Invoke-Loc $idxG 'GLOBAL+A1' 'GOVERN' 'Documentation authority model'
$lAon5 = Invoke-Loc $idx5 'GLOBAL+A1' 'DEBUG' 'anything'
$aWhatLeak = (($lAon5.Raw | Out-String) -match 'ACP-Enhancements|P08__|P05__3DR')
Assert-True ($lAonG.Code -eq 4 -and $lAonG.Json.reason -eq 'foreign_identity') 's6-global-index-not-for-a1' "code=$($lAonG.Code)"
Assert-True ($lAon5.Code -eq 4 -and $lAon5.Json.reason -eq 'foreign_identity' -and -not $aWhatLeak -and (@($lAon5.Json.candidates).Count -eq 0)) 's6-hash5-index-out-of-scope-for-a1' "code=$($lAon5.Code)"

$lA5on5 = Invoke-Loc $idx5 'GLOBAL+A5' 'IMPLEMENT' 'anything'
Assert-True ($lA5on5.Code -eq 4) 's6-a5-not-hash5-scope' "code=$($lA5on5.Code)"

$manNames = @(Get-ChildItem -LiteralPath (Join-Path $roots.Knowledge 'manifests') -Filter '*.json' | ForEach-Object { $_.Name } | Sort-Object)
$manOk = ($manNames.Count -eq 2 -and $manNames -contains 'global.json' -and $manNames -contains 'global-5.json')
$schemaRaw = Get-Content -LiteralPath (Join-Path $roots.Knowledge 'schema\index.v1.schema.json') -Raw
$schemaKeepsHash = $schemaRaw.Contains('^GLOBAL(\\+#[0-9A-Za-z]+)?$')
$schemaNoAScope = -not $schemaRaw.Contains('GLOBAL+A')
Assert-True ($manOk -and $schemaKeepsHash -and $schemaNoAScope) 's6-no-a-index-recipe' "mans=$($manNames -join ',') hash=$schemaKeepsHash noA=$schemaNoAScope"

try {
    $null = Import-MagManifest -ManifestPath (Join-Path $roots.Knowledge 'manifests\global.json') -Roots $roots
    $importGOk = $true
} catch { $importGOk = $false }
$aManPath = Join-Path $badDir 's6-a-man.json'
(@{
    schema_version = 1; config_version = 1; scope = 'GLOBAL+A1'
    global_sources = @('MAG_ECOSYSTEM.md')
    development = @{ identity = 'A1'; repo_root = '../x'; doc_files = @('docs/x.md') }
    source_rules = 'config/source_rules.json'
    intent_owner_map = 'config/intent_owner_map.json'
    output = 'generated/knowledge/index-global-a1.json'
} | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath $aManPath -Encoding utf8
$importAThrew = $false
try {
    $null = Import-MagManifest -ManifestPath $aManPath -Roots $roots
} catch {
    $importAThrew = ([string]$_.Exception.Message -match 'invalid_scope')
}
Assert-True ($importGOk -and $importAThrew) 's6-manifest-scope-not-widened-to-a'

$lGov = Invoke-Loc $idxG 'GLOBAL' 'GOVERN' 'Documentation authority model'
Assert-True ($lGov.Code -eq 0 -and $lGov.Json.state -eq 'FOUND') 's6-global-govern-unchanged' "code=$($lGov.Code)"

$idx5objS6 = Read-MagJsonFile $idx5
$implUnit = @($idx5objS6.units | Where-Object { $_.knowledge_class -in @('development_architecture', 'development_class_map', 'reusable_pattern_unit') } | Select-Object -First 1)
$lImpl5 = if ($implUnit) { Invoke-Loc $idx5 'GLOBAL+#5' 'IMPLEMENT' $implUnit.title } else { $null }
Assert-True ($null -ne $implUnit -and $lImpl5.Code -eq 0 -and $lImpl5.Json.state -eq 'FOUND') 's6-hash5-implement-candidate' "code=$($lImpl5.Code)"

$patUnit = @((Read-MagJsonFile $idxG).units | Where-Object { $_.knowledge_class -eq 'reusable_pattern_unit' } | Select-Object -First 1)
$lPatG = Invoke-Loc $idxG 'GLOBAL' 'IMPLEMENT' $patUnit.title
$lPatA = Invoke-Loc $idxG 'GLOBAL+A1' 'LEARN' $patUnit.title
$lPat5 = Invoke-Loc $idx5 'GLOBAL+#5' 'IMPLEMENT' $patUnit.title
# Locator has no applicability engine. A cannot obtain a Pattern pointer via GLOBAL/#5 indexes (OUT_OF_SCOPE).
# Matching #N may still FOUND a Pattern candidate on the #5 index. Selection of applicability_class N as A HOW is canonical/agent, not Locator.
Assert-True ($lPatG.Code -eq 0 -and $lPatA.Code -eq 4 -and $lPat5.Code -eq 0 -and $patUnit.knowledge_class -eq 'reusable_pattern_unit') 's6-pattern-candidate-not-a-selection' "g=$($lPatG.Code) a=$($lPatA.Code) h5=$($lPat5.Code)"

$lNf = Invoke-Loc $idxG 'GLOBAL' 'GOVERN' 'the'
Assert-True ($lNf.Code -eq 1 -and $lNf.Json.state -eq 'NOT_FOUND' -and [bool]$lNf.Json.index_miss) 's6-not-found-is-index-miss'

$lOos = Invoke-Loc $idx5 'GLOBAL+#8' 'DEBUG' 'anything'
Assert-True ($lOos.Code -eq 4 -and $lOos.Json.reason -eq 'foreign_identity' -and (@($lOos.Json.candidates).Count -eq 0)) 's6-oos-no-broaden'

$lStale = Invoke-Loc (Join-Path $roots.Ecosystem 'generated\knowledge\no-such.json') 'GLOBAL' 'GOVERN' 'x'
Assert-True ($lStale.Code -eq 3 -and $lStale.Json.reason -eq 'missing_index' -and $lStale.Json.working_identity_status -eq 'assignable') 's6-stale-missing-index-not-last-good'

Assert-True (@($script:MagKnownIntents).Count -eq 6 -and ($script:MagKnownIntents -join ',') -eq 'GOVERN,PLAN,IMPLEMENT,DEBUG,VERIFY,LEARN') 's6-six-intents-only'
$lFoo = Invoke-Loc $idxG 'GLOBAL' 'FOO' 'authority'
Assert-True ($lFoo.Code -eq 4 -and $lFoo.Json.reason -eq 'unknown_intent') 's6-unknown-intent'

Get-ChildItem (Join-Path $roots.Ecosystem 'generated\knowledge') -Filter 'index-orch*.json' -ErrorAction SilentlyContinue | Remove-Item -Force

Remove-Item -LiteralPath $badDir -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem (Join-Path $roots.Ecosystem 'generated\knowledge') -Filter 'index-fx*.json' -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem (Join-Path $roots.Ecosystem 'generated\knowledge') -Filter 'index-ren.json' -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem (Join-Path $roots.Ecosystem 'generated\knowledge') -Filter 'index-keep.json' -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem (Join-Path $roots.Ecosystem 'generated\knowledge') -Filter 'index-duph.json' -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem (Join-Path $roots.Ecosystem 'generated\knowledge') -Filter 'index-fxmiss.json' -ErrorAction SilentlyContinue | Remove-Item -Force

Write-Host ""
Write-Host "Passed=$script:Passed Failed=$script:Failed"
if ($script:Failed -gt 0) { exit 1 }
exit 0
