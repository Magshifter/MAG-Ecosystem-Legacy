#Requires -Version 7.0
# MAG-LEGACY-PUBLISH-W5 portability tests (T1-T18).
# All writes happen in a disposable fixture under the system temp directory (outside the repository
# and outside any Laragon layout). The fixture path contains spaces and removes itself.
# The only production paths touched are read-only (T18b: explicit author inventory resolution).
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$here = $PSScriptRoot
$docsRoot = Split-Path -Parent $here
. (Join-Path $docsRoot 'lib\MagDocumentationMirror.Common.ps1')
$script:Cli = Join-Path $docsRoot 'Update-MagDocumentationMirror.ps1'
$script:Example = Join-Path $docsRoot 'mirror-inventory.example.json'
$script:AuthorInv = Join-Path $docsRoot 'mirror-inventory.json'

$script:Passed = 0
$script:Failed = 0
function Assert-True($cond, $name, $detail = '') {
    if ($cond) { Write-Host "PASS $name"; $script:Passed++ }
    else { Write-Host "FAIL $name $detail"; $script:Failed++ }
}

$fx = Join-Path ([IO.Path]::GetTempPath()) ('mag w5 portability ' + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Path $fx -Force | Out-Null
trap { Remove-Item -LiteralPath $fx -Recurse -Force -ErrorAction SilentlyContinue; break }

function Get-Err([scriptblock]$Block) {
    try { $null = & $Block; return '' } catch { return [string]$_.Exception.Message }
}

function Invoke-Cli([string[]]$CliArgs) {
    $ErrorActionPreference = 'Continue'
    $out = @(& pwsh -NoProfile -NonInteractive -File $script:Cli @CliArgs 2>&1)
    $code = $LASTEXITCODE
    $json = $null
    foreach ($line in $out) {
        $s = [string]$line
        if ($s.StartsWith('{')) { try { $json = $s | ConvertFrom-Json } catch { } }
    }
    return [pscustomobject]@{ Code = $code; Text = (($out | ForEach-Object { [string]$_ }) -join "`n"); Json = $json }
}

function Get-TreeHash([string]$Dir) {
    if (-not (Test-Path -LiteralPath $Dir)) { return 'ABSENT' }
    $rows = Get-ChildItem -LiteralPath $Dir -Recurse -File -Force | Sort-Object FullName | ForEach-Object {
        $_.FullName.Substring($Dir.Length) + '|' + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    }
    return (@($rows) -join "`n")
}

function Write-Text([string]$Path, [string]$Text) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $Path) -Force | Out-Null
    [IO.File]::WriteAllText($Path, $Text, [Text.UTF8Encoding]::new($false))
}

function New-UserInventory([string]$Path, [string]$ReposRoot, [string]$MirrorRoot) {
    $inv = Get-Content -LiteralPath $script:Example -Raw | ConvertFrom-Json
    $inv.repos_root = $ReposRoot
    $inv.mirror_root = $MirrorRoot
    Write-Text $Path ($inv | ConvertTo-Json -Depth 8)
    return $Path
}

# A user-specific layout with spaces: <fx>\<name>\Dev Projects\{my-app,my-library}, mirror <fx>\<name>\Docs Mirror
function New-UserLayout([string]$Name) {
    $base = Join-Path $fx $Name
    $repos = Join-Path $base 'Dev Projects'
    $mirror = Join-Path $base 'Docs Mirror'
    $state = Join-Path $base 'state'
    Write-Text (Join-Path $repos 'my-app\README.md') "# my-app`n"
    Write-Text (Join-Path $repos 'my-app\docs\ARCHITECTURE.md') "# Architecture`n"
    Write-Text (Join-Path $repos 'my-app\tools\build.ps1') "Write-Output 'build'`n"
    Write-Text (Join-Path $repos 'my-library\README.md') "# my-library`n"
    New-Item -ItemType Directory -Path $state -Force | Out-Null
    $inv = New-UserInventory (Join-Path $state 'my-inventory.json') $repos $mirror
    return [pscustomobject]@{
        Base = $base; Repos = $repos; Mirror = $mirror; State = $state; Inv = $inv
        Baseline = (Join-Path $state 'baseline.json'); Receipt = (Join-Path $state 'check-receipt.json')
    }
}

function Get-StateArgs($L) { return @('-InventoryPath', $L.Inv, '-BaselinePath', $L.Baseline, '-ReceiptPath', $L.Receipt) }

# ---------------- T1 arbitrary roots ----------------
$L1 = New-UserLayout 'layout one'
$r = Invoke-Cli (@('-Check') + (Get-StateArgs $L1))
Assert-True ($r.Code -eq 0 -and $null -ne $r.Json -and $r.Json.pair_count -eq 4 -and $r.Json.mirror_root -eq $L1.Mirror) 'T1-arbitrary-roots-check' $r.Text
$ld1 = Import-MagMirrorInventory -InventoryPath $L1.Inv
Assert-True ($ld1.ReposRoot -eq $L1.Repos -and $ld1.MirrorRoot -eq $L1.Mirror -and $ld1.RepoMap.Count -eq 2) 'T1-arbitrary-roots-resolved'
Assert-True ((Get-Err { Assert-MagMirrorRootSafe -MirrorRoot $ld1.MirrorRoot -ReposRoot $ld1.ReposRoot -CanonicalRepoRoots @($ld1.CanonicalRoots) }) -eq '') 'T1-arbitrary-root-validated'

# ---------------- T2 spaces ----------------
$r = Invoke-Cli (@('-BootstrapClean') + (Get-StateArgs $L1))
$spaced = ($L1.Repos.Contains(' ') -and $L1.Mirror.Contains(' ') -and $L1.Inv.Contains(' '))
$copied = (Get-FileHash -LiteralPath (Join-Path $L1.Mirror 'my-app\docs\ARCHITECTURE.md')).Hash -eq (Get-FileHash -LiteralPath (Join-Path $L1.Repos 'my-app\docs\ARCHITECTURE.md')).Hash
Assert-True ($spaced -and $r.Code -eq 0 -and $r.Json.populated_count -eq 4 -and $copied) 'T2-paths-with-spaces-bootstrap' $r.Text

# ---------------- T3 inventory overrides ----------------
$blankInv = New-UserInventory (Join-Path $L1.State 'blank-roots.json') '' ''
$r = Invoke-Cli @('-Check', '-InventoryPath', $blankInv, '-ReposRoot', $L1.Repos, '-MirrorRoot', $L1.Mirror, '-BaselinePath', $L1.Baseline, '-ReceiptPath', (Join-Path $L1.State 'r3.json'))
Assert-True ($r.Code -eq 0 -and $r.Json.mirror_root -eq $L1.Mirror -and $r.Json.pair_count -eq 4) 'T3-cli-overrides-blank-inventory-roots' $r.Text
$alt = Join-Path $L1.Base 'Alternate Mirror'
$r = Invoke-Cli @('-Check', '-InventoryPath', $L1.Inv, '-MirrorRoot', $alt, '-BaselinePath', (Join-Path $L1.State 'none.json'), '-ReceiptPath', (Join-Path $L1.State 'r3b.json'))
Assert-True ($r.Code -eq 0 -and $r.Json.mirror_root -eq $alt -and -not (Test-Path -LiteralPath $alt)) 'T3-cli-mirror-override-wins-check-does-not-create-mirror' $r.Text

# ---------------- T4 missing / malformed config ----------------
$rc4 = Join-Path $L1.State 'r4.json'
$r = Invoke-Cli @('-Check', '-BaselinePath', $L1.Baseline, '-ReceiptPath', $rc4)
Assert-True ($r.Code -eq 5 -and $r.Text -match 'InventoryPath is required') 'T4-no-default-inventory' $r.Text
$r = Invoke-Cli @('-Check', '-InventoryPath', $blankInv, '-BaselinePath', $L1.Baseline, '-ReceiptPath', $rc4)
Assert-True ($r.Code -eq 5 -and $r.Text -match 'repos_root_missing') 'T4-missing-roots-rejected' $r.Text
$r = Invoke-Cli @('-Check', '-InventoryPath', $L1.Inv, '-MirrorRoot', 'Docs Mirror', '-BaselinePath', $L1.Baseline, '-ReceiptPath', $rc4)
Assert-True ($r.Code -eq 5 -and $r.Text -match 'mirror_root_relative') 'T4-relative-mirror-root-rejected-not-cwd' $r.Text
$drv = ([IO.Path]::GetPathRoot($fx)).Substring(0, 2)
$cases = @(
    @{ P = ($drv + 'Docs'); M = 'mirror_root_relative' },
    @{ P = ($L1.Base + '\x\..\Docs Mirror'); M = 'mirror_root_ambiguous:dot_segment' },
    @{ P = ($L1.Base + '\DOCSMI~1'); M = 'mirror_root_ambiguous:short_name' },
    @{ P = ($L1.Base + '\Docs Mirror '); M = 'mirror_root_ambiguous' },
    @{ P = ($L1.Base + '\Docs|Mirror'); M = 'mirror_root_malformed' },
    @{ P = ('\\?\' + $L1.Mirror); M = 'mirror_root_malformed:device_path' },
    @{ P = ($L1.Mirror + ':ads'); M = 'mirror_root_malformed:colon' }
)
$allBad = $true; $badDetail = ''
foreach ($cs in $cases) {
    $e = Get-Err { Resolve-MagMirrorConfiguredRoot -Path $cs.P -Kind 'mirror_root' }
    if (-not $e.StartsWith($cs.M)) { $allBad = $false; $badDetail += "[$($cs.P) => $e]" }
}
Assert-True $allBad 'T4-malformed-ambiguous-roots-rejected' $badDetail
$r = Invoke-Cli @('-Check', '-InventoryPath', $L1.Inv, '-ReposRoot', (Join-Path $L1.Base 'No Such Repos'), '-BaselinePath', $L1.Baseline, '-ReceiptPath', $rc4)
Assert-True ($r.Code -eq 5 -and $r.Text -match 'repos_root_not_found') 'T4-nonexistent-repos-root-rejected' $r.Text
$badJson = Join-Path $L1.State 'malformed.json'
Write-Text $badJson '{ "schema_version": 1, "entries": [ '
$r = Invoke-Cli @('-Check', '-InventoryPath', $badJson, '-BaselinePath', $L1.Baseline, '-ReceiptPath', $rc4)
Assert-True ($r.Code -ne 0) 'T4-malformed-inventory-json-rejected' $r.Text
Assert-True (-not (Test-Path -LiteralPath $rc4)) 'T4-no-receipt-written-on-rejected-config'

# ---------------- T5 duplicate / traversal ----------------
$invObj = Get-Content -LiteralPath $L1.Inv -Raw | ConvertFrom-Json
$dupe = $invObj.PSObject.Copy(); $dupe.entries = @($invObj.entries) + @($invObj.entries[0])
$dupeP = Join-Path $L1.State 'dupe.json'; Write-Text $dupeP ($dupe | ConvertTo-Json -Depth 8)
$r = Invoke-Cli @('-Check', '-InventoryPath', $dupeP, '-BaselinePath', $L1.Baseline, '-ReceiptPath', $rc4)
Assert-True ($r.Code -eq 5 -and $r.Text -match 'duplicate_mapping') 'T5-duplicate-mapping-rejected' $r.Text
$trav = $invObj.PSObject.Copy(); $trav.entries = @([pscustomobject]@{ repo = 'my-app'; path = '..\my-library\README.md'; category = 'document'; require_metadata = $false })
$travP = Join-Path $L1.State 'trav.json'; Write-Text $travP ($trav | ConvertTo-Json -Depth 8)
$r = Invoke-Cli @('-Check', '-InventoryPath', $travP, '-BaselinePath', $L1.Baseline, '-ReceiptPath', $rc4)
Assert-True ($r.Code -eq 5 -and $r.Text -match 'path_traversal') 'T5-path-traversal-rejected' $r.Text
$nameP = Join-Path $L1.State 'badname.json'
Write-Text $nameP ('{ "schema_version": 1, "repos_root": ' + ($L1.Repos | ConvertTo-Json) + ', "mirror_root": ' + ($L1.Mirror | ConvertTo-Json) + ', "repositories": { "..": "" }, "entries": [] }')
$r = Invoke-Cli @('-Check', '-InventoryPath', $nameP, '-BaselinePath', $L1.Baseline, '-ReceiptPath', $rc4)
Assert-True ($r.Code -eq 5 -and $r.Text -match 'malformed_inventory:repository_name') 'T5-repository-name-traversal-rejected' $r.Text
Assert-True (-not (Test-Path -LiteralPath $rc4)) 'T5-no-receipt-written'

# ---------------- T6 Mirror == Repos ----------------
$reposHash0 = Get-TreeHash $L1.Repos
$r = Invoke-Cli (@('-BootstrapClean', '-MirrorRoot', $L1.Repos) + (Get-StateArgs $L1))
Assert-True ($r.Code -eq 5 -and $r.Text -match 'mirror_root_is_repos_root' -and (Get-TreeHash $L1.Repos) -eq $reposHash0) 'T6-mirror-equals-repos-rejected-no-deletion' $r.Text
Assert-True ((Get-Err { Assert-MagMirrorRootSafe -MirrorRoot ($L1.Repos + '\') -ReposRoot $L1.Repos }) -eq 'mirror_root_is_repos_root') 'T6-trailing-separator-normalized'

# ---------------- T7 Mirror inside repo / checkout / git worktree ----------------
$inside = Join-Path $L1.Repos 'my-app\mirror'
$r = Invoke-Cli (@('-BootstrapClean', '-MirrorRoot', $inside) + (Get-StateArgs $L1))
Assert-True ($r.Code -eq 5 -and $r.Text -match 'mirror_root_inside_canonical_repo' -and -not (Test-Path -LiteralPath $inside)) 'T7-mirror-inside-canonical-repo-rejected' $r.Text
$ecoInside = Join-Path $script:MagEcosystemCheckoutRoot 'generated\w5-never-created-mirror'
$e = Get-Err { Assert-MagMirrorRootSafe -MirrorRoot $ecoInside -ReposRoot $L1.Repos }
Assert-True ($e -match '^mirror_root_overlaps_ecosystem_checkout' -and -not (Test-Path -LiteralPath $ecoInside)) 'T7-mirror-inside-active-checkout-rejected' $e
$e = Get-Err { Assert-MagMirrorRootSafe -MirrorRoot (Split-Path -Parent $script:MagEcosystemCheckoutRoot) -ReposRoot $L1.Repos }
Assert-True ($e -match '^mirror_root_overlaps_ecosystem_checkout') 'T7-mirror-containing-active-checkout-rejected' $e
$foreign = Join-Path $L1.Base 'Other Git Repo'
New-Item -ItemType Directory -Path (Join-Path $foreign '.git') -Force | Out-Null
$e = Get-Err { Assert-MagMirrorRootSafe -MirrorRoot (Join-Path $foreign 'docs') -ReposRoot $L1.Repos }
Assert-True ($e -match '^mirror_root_inside_git_worktree') 'T7-mirror-inside-non-inventory-git-worktree-rejected' $e

# ---------------- T8 Mirror contains repo ----------------
$r = Invoke-Cli (@('-BootstrapClean', '-MirrorRoot', $L1.Base) + (Get-StateArgs $L1))
Assert-True ($r.Code -eq 5 -and $r.Text -match 'mirror_root_contains_repos_root' -and (Get-TreeHash $L1.Repos) -eq $reposHash0) 'T8-mirror-ancestor-of-repos-rejected-no-deletion' $r.Text
$elsewhere = Join-Path $L1.Base 'Shelf\canonical-x'
New-Item -ItemType Directory -Path $elsewhere -Force | Out-Null
$e = Get-Err { Assert-MagMirrorRootSafe -MirrorRoot (Join-Path $L1.Base 'Shelf') -ReposRoot $L1.Repos -CanonicalRepoRoots @($elsewhere) }
Assert-True ($e -match '^mirror_root_contains_canonical_repo') 'T8-mirror-ancestor-of-canonical-repo-rejected' $e

# ---------------- T9 drive root ----------------
$driveRoot = [IO.Path]::GetPathRoot($fx)
$e = Get-Err { Assert-MagMirrorRootSafe -MirrorRoot $driveRoot -ReposRoot $L1.Repos }
Assert-True ($e -match '^mirror_root_is_filesystem_root') 'T9-drive-root-rejected' $e
$r = Invoke-Cli @('-Check', '-InventoryPath', $L1.Inv, '-MirrorRoot', $driveRoot, '-BaselinePath', $L1.Baseline, '-ReceiptPath', $rc4)
Assert-True ($r.Code -eq 5 -and $r.Text -match 'mirror_root_is_filesystem_root' -and -not (Test-Path -LiteralPath $rc4)) 'T9-drive-root-cli-check-rejected-before-receipt' $r.Text

# ---------------- T10 symlink / junction / reparse escape ----------------
$L10 = New-UserLayout 'layout reparse'
$victim = Join-Path $L10.Base 'Victim Dir'
Write-Text (Join-Path $victim 'victim.txt') 'do not delete'
$realTarget = Join-Path $L10.Base 'Real Target'
New-Item -ItemType Directory -Path $realTarget -Force | Out-Null
$jRoot = Join-Path $L10.Base 'Mirror Link'
New-Item -ItemType Junction -Path $jRoot -Target $realTarget | Out-Null
$e = Get-Err { Assert-MagMirrorRootSafe -MirrorRoot $jRoot -ReposRoot $L10.Repos }
Assert-True ($e -match '^mirror_root_reparse') 'T10-junction-mirror-root-rejected' $e
$jParent = Join-Path $L10.Base 'Linked Parent'
New-Item -ItemType Junction -Path $jParent -Target $realTarget | Out-Null
$e = Get-Err { Assert-MagMirrorRootSafe -MirrorRoot (Join-Path $jParent 'Docs Mirror') -ReposRoot $L10.Repos }
Assert-True ($e -match '^mirror_root_reparse') 'T10-junction-ancestor-rejected' $e
Write-Text (Join-Path $L10.Mirror 'keep.txt') 'keep'
New-Item -ItemType Junction -Path (Join-Path $L10.Mirror 'escape') -Target $victim | Out-Null
$r = Invoke-Cli (@('-BootstrapClean') + (Get-StateArgs $L10))
$victimOk = (Test-Path -LiteralPath (Join-Path $victim 'victim.txt')) -and (Test-Path -LiteralPath (Join-Path $L10.Mirror 'keep.txt'))
Assert-True ($r.Code -ne 0 -and $r.Text -match 'reparse_point' -and $victimOk -and -not (Test-Path -LiteralPath $L10.Baseline)) 'T10-junction-inside-mirror-blocks-bootstrap-zero-deletions' $r.Text
$escDir = Join-Path $L10.Repos 'my-app\linked docs'
New-Item -ItemType Junction -Path $escDir -Target $victim | Out-Null
$src10 = Join-Path $L10.Base 'src.md'; Write-Text $src10 'payload'
$e = Get-Err { Copy-MagMirrorFileVerified -Source $src10 -Dest (Join-Path $escDir 'planted.md') -DestRoot (Join-Path $L10.Repos 'my-app') }
Assert-True ($e -match '^reparse_destination' -and -not (Test-Path -LiteralPath (Join-Path $victim 'planted.md'))) 'T10-junction-in-destination-path-rejected' $e
Remove-Item -LiteralPath $escDir -Force
Remove-Item -LiteralPath (Join-Path $L10.Mirror 'escape') -Force

# ---------------- T11 CHECK classification + receipt ----------------
$L11 = New-UserLayout 'layout check'
Write-Text (Join-Path $L11.Mirror 'my-app\README.md') "# my-app`n"
Write-Text (Join-Path $L11.Mirror 'my-library\README.md') "# drive edit`n"
Write-Text (Join-Path $L11.Mirror 'unmanaged.txt') 'extra'
$m11 = Get-TreeHash $L11.Mirror; $repos11 = Get-TreeHash $L11.Repos
$r = Invoke-Cli (@('-Check') + (Get-StateArgs $L11))
$cls = @{}; foreach ($pp in @($r.Json.pairs)) { $cls["$($pp.repo)/$($pp.relative_path)"] = [string]$pp.classification }
$clsOk = ($cls['my-app/README.md'] -eq 'IDENTICAL' -and $cls['my-library/README.md'] -eq 'CONFLICT' -and $cls['my-app/docs/ARCHITECTURE.md'] -eq 'MISSING_TARGET')
Assert-True ($r.Code -eq 0 -and $clsOk -and $r.Json.extra_count -eq 1) 'T11-check-classification' (($cls.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ',')
$recOk = (Test-Path -LiteralPath $L11.Receipt) -and ((Get-FileHash -LiteralPath $L11.Receipt -Algorithm SHA256).Hash.ToLowerInvariant() -eq $r.Json.receipt_sha256) -and $r.Json.receipt_written -eq $true
Assert-True $recOk 'T11-check-writes-bound-receipt'
Assert-True ((Get-TreeHash $L11.Mirror) -eq $m11 -and (Get-TreeHash $L11.Repos) -eq $repos11 -and -not (Test-Path -LiteralPath $L11.Baseline) -and $r.Json.baseline_modified -eq $false) 'T11-check-no-mirror-local-baseline-writes'

# ---------------- T12 BootstrapClean disposable fixture ----------------
$L12 = New-UserLayout 'layout bootstrap'
Write-Text (Join-Path $L12.Mirror 'stale\old.md') 'stale transport'
[IO.File]::WriteAllBytes((Join-Path $L12.Repos 'my-app\tools\build.ps1'), [byte[]](@(0xEF, 0xBB, 0xBF) + [Text.Encoding]::UTF8.GetBytes("Write-Output '`u{041F}`u{0440}`u{0438}`u{0432}`u{0456}`u{0442}'`r`n# crlf, no final newline")))
$r = Invoke-Cli (@('-BootstrapClean') + (Get-StateArgs $L12))
$staleGone = -not (Test-Path -LiteralPath (Join-Path $L12.Mirror 'stale'))
Assert-True ($r.Code -eq 0 -and $r.Json.deleted_files -eq 1 -and $r.Json.populated_count -eq 4 -and $staleGone -and (Test-Path -LiteralPath $L12.Baseline)) 'T12-bootstrap-clean-disposable-fixture' $r.Text
$r = Invoke-Cli (@('-Check') + (Get-StateArgs $L12))
Assert-True ($r.Code -eq 0 -and @($r.Json.pairs | Where-Object { $_.classification -ne 'IDENTICAL' }).Count -eq 0) 'T12-check-after-bootstrap-all-identical' $r.Text

# ---------------- T13 invalid BootstrapClean targets: zero deletions ----------------
$L13 = New-UserLayout 'layout invalid bootstrap'
$keep13 = Join-Path $L13.Mirror 'keep.md'; Write-Text $keep13 'keep'
$all0 = Get-TreeHash $L13.Base
$bad13 = @($L13.Repos, (Join-Path $L13.Repos 'my-app'), $L13.Base, $driveRoot, (Join-Path $L13.Repos 'my-library\docs mirror'))
$allRejected = $true; $d13 = ''
foreach ($b in $bad13) {
    $r = Invoke-Cli (@('-BootstrapClean', '-MirrorRoot', $b) + (Get-StateArgs $L13))
    if ($r.Code -ne 5) { $allRejected = $false; $d13 += "[$b => $($r.Code) $($r.Text)]" }
}
Assert-True ($allRejected -and (Get-TreeHash $L13.Base) -eq $all0 -and -not (Test-Path -LiteralPath $L13.Baseline)) 'T13-invalid-bootstrap-targets-zero-deletions' $d13
$r = Invoke-Cli (@('-BootstrapClean', '-MirrorRoot', (Join-Path $L13.Base 'missing parent\Docs Mirror')) + (Get-StateArgs $L13))
Assert-True ($r.Code -eq 5 -and $r.Text -match 'mirror_root_parent_missing' -and -not (Test-Path -LiteralPath (Join-Path $L13.Base 'missing parent'))) 'T13-bootstrap-missing-parent-not-created' $r.Text

# ---------------- T14 Reconcile authorization binding ----------------
Write-Text (Join-Path $L12.Repos 'my-app\README.md') "# my-app v2`n"
$r = Invoke-Cli (@('-Check') + (Get-StateArgs $L12))
$auth = [string]$r.Json.receipt_sha256
$m14 = Get-TreeHash $L12.Mirror
$r = Invoke-Cli (@('-Reconcile') + (Get-StateArgs $L12))
Assert-True ($r.Code -eq 5 -and (Get-TreeHash $L12.Mirror) -eq $m14) 'T14-reconcile-requires-authorization' $r.Text
$r = Invoke-Cli (@('-Reconcile', '-AuthorizationSha256', ('0' * 64)) + (Get-StateArgs $L12))
Assert-True ($r.Code -eq 5 -and $r.Text -match 'authorization_mismatch' -and (Get-TreeHash $L12.Mirror) -eq $m14) 'T14-reconcile-wrong-binding-rejected' $r.Text
$otherM = Join-Path $L12.Base 'Other Mirror'
$r = Invoke-Cli (@('-Reconcile', '-AuthorizationSha256', $auth, '-MirrorRoot', $otherM) + (Get-StateArgs $L12))
Assert-True ($r.Code -eq 5 -and $r.Text -match 'mirror_root_mismatch' -and -not (Test-Path -LiteralPath $otherM)) 'T14-reconcile-root-bound-to-receipt' $r.Text
$r = Invoke-Cli (@('-Reconcile', '-AuthorizationSha256', $auth) + (Get-StateArgs $L12))
$eq14 = (Get-FileHash -LiteralPath (Join-Path $L12.Mirror 'my-app\README.md')).Hash -eq (Get-FileHash -LiteralPath (Join-Path $L12.Repos 'my-app\README.md')).Hash
Assert-True ($r.Code -eq 0 -and $r.Json.written_count -eq 1 -and $eq14) 'T14-reconcile-bound-receipt-applies' $r.Text
$r = Invoke-Cli (@('-Reconcile', '-AuthorizationSha256', $auth) + (Get-StateArgs $L12))
Assert-True ($r.Code -eq 5 -and $r.Text -match 'baseline_changed_since_check') 'T14-receipt-replay-rejected' $r.Text

# ---------------- T15 PublishAffected authorization ----------------
Write-Text (Join-Path $L12.Repos 'my-library\README.md') "# my-library v2`n"
$m15 = Get-TreeHash $L12.Mirror
$r = Invoke-Cli (@('-PublishAffected', '-Affected', 'my-library/README.md') + (Get-StateArgs $L12))
Assert-True ($r.Code -eq 5 -and $r.Text -match 'ProductOwnerApproved' -and (Get-TreeHash $L12.Mirror) -eq $m15) 'T15-publish-requires-product-owner-approved' $r.Text
$r = Invoke-Cli (@('-PublishAffected', '-ProductOwnerApproved', '-Affected', 'my-library/README.md') + (Get-StateArgs $L12))
$eq15 = (Get-FileHash -LiteralPath (Join-Path $L12.Mirror 'my-library\README.md')).Hash -eq (Get-FileHash -LiteralPath (Join-Path $L12.Repos 'my-library\README.md')).Hash
Assert-True ($r.Code -eq 0 -and $r.Json.publication_status -eq 'PUBLISHED' -and $r.Json.written_count -eq 1 -and $eq15 -and $r.Json.google_drive_status -eq 'UNKNOWN') 'T15-publish-approved-newer-local-only' $r.Text

# ---------------- T16 SHA-256 preservation ----------------
$shaOk = $true
foreach ($rel in @('my-app\README.md', 'my-app\docs\ARCHITECTURE.md', 'my-app\tools\build.ps1', 'my-library\README.md')) {
    $a = Get-MagMirrorSha256File (Join-Path $L12.Repos $rel); $b = Get-MagMirrorSha256File (Join-Path $L12.Mirror $rel)
    if ($a -ne $b -or $a -eq 'ABSENT') { $shaOk = $false }
}
$bytesEq = [Linq.Enumerable]::SequenceEqual([IO.File]::ReadAllBytes((Join-Path $L12.Repos 'my-app\tools\build.ps1')), [IO.File]::ReadAllBytes((Join-Path $L12.Mirror 'my-app\tools\build.ps1')))
$baseObj = Get-Content -LiteralPath $L12.Baseline -Raw | ConvertFrom-Json
$bl = @($baseObj.pairs | Where-Object { $_.repo -eq 'my-app' -and $_.path -eq 'tools/build.ps1' })[0].baseline_sha256
Assert-True ($shaOk -and $bytesEq -and $bl -eq (Get-MagMirrorSha256File (Join-Path $L12.Repos 'my-app\tools\build.ps1'))) 'T16-sha256-byte-exact-bom-crlf-preserved'
Assert-True (@(Get-ChildItem -LiteralPath $L12.Mirror -Recurse -Force -Filter '*.mag-mirror-tmp').Count -eq 0) 'T16-no-temp-copies-left'

# ---------------- T17 shipped example inventory ----------------
$exRaw = Get-Content -LiteralPath $script:Example -Raw
Assert-True ($exRaw -notmatch '(?i)laragon|magshifter|MAG-|donatello|telegram|xenforo' -and $exRaw -notmatch '[A-Za-z]:\\\\') 'T17-example-has-no-private-or-author-paths'
$L17 = New-UserLayout 'layout example'
$exState = Join-Path $L17.State 'shipped'
$r = Invoke-Cli @('-Check', '-InventoryPath', $script:Example, '-BaselinePath', (Join-Path $exState 'b.json'), '-ReceiptPath', (Join-Path $exState 'r.json'))
Assert-True ($r.Code -eq 5 -and $r.Text -match 'repos_root_missing' -and -not (Test-Path -LiteralPath $exState)) 'T17-unconfigured-example-fails-closed' $r.Text
$r = Invoke-Cli @('-Check', '-InventoryPath', $script:Example, '-ReposRoot', $L17.Repos, '-MirrorRoot', $L17.Mirror, '-BaselinePath', $L17.Baseline, '-ReceiptPath', $L17.Receipt)
Assert-True ($r.Code -eq 0 -and $r.Json.pair_count -eq 4) 'T17-example-works-with-cli-roots' $r.Text
$r = Invoke-Cli (@('-BootstrapClean') + (Get-StateArgs $L17))
$r2 = Invoke-Cli (@('-Check') + (Get-StateArgs $L17))
Assert-True ($r.Code -eq 0 -and $r2.Code -eq 0 -and @($r2.Json.pairs | Where-Object { $_.classification -ne 'IDENTICAL' }).Count -eq 0) 'T17-example-user-config-bootstrap-and-verify' ($r.Text + $r2.Text)

# ---------------- T18 explicit legacy Laragon layout ----------------
$lg = Join-Path $fx 'legacy\laragon\repos'
foreach ($n in 'my-app', 'my-library') { Write-Text (Join-Path $lg "$n\README.md") "# $n`n" }
Write-Text (Join-Path $lg 'my-app\docs\ARCHITECTURE.md') "# a`n"
Write-Text (Join-Path $lg 'my-app\tools\build.ps1') "# b`n"
$lgState = Join-Path $fx 'legacy\state'
$lgInv = New-UserInventory (Join-Path $lgState 'inv.json') $lg (Join-Path $lg 'Mirror')
$r = Invoke-Cli @('-BootstrapClean', '-InventoryPath', $lgInv, '-BaselinePath', (Join-Path $lgState 'b.json'), '-ReceiptPath', (Join-Path $lgState 'r.json'))
$r2 = Invoke-Cli @('-Check', '-InventoryPath', $lgInv, '-BaselinePath', (Join-Path $lgState 'b.json'), '-ReceiptPath', (Join-Path $lgState 'r.json'))
Assert-True ($r.Code -eq 0 -and $r2.Code -eq 0 -and @($r2.Json.pairs | Where-Object { $_.classification -ne 'IDENTICAL' }).Count -eq 0) 'T18a-legacy-shape-mirror-inside-repos-root' ($r.Text + $r2.Text)
if (Test-Path -LiteralPath 'C:\laragon\repos\Mirror' -PathType Container) {
    # Read-only: resolve and validate the explicitly selected author inventory; nothing is written.
    $la = Import-MagMirrorInventory -InventoryPath $script:AuthorInv
    $e = Get-Err { Assert-MagMirrorRootSafe -MirrorRoot $la.MirrorRoot -ReposRoot $la.ReposRoot -CanonicalRepoRoots @($la.CanonicalRoots) }
    Assert-True ($la.ReposRoot -eq 'C:\laragon\repos' -and $la.MirrorRoot -eq 'C:\laragon\repos\Mirror' -and $la.RepoMap.Count -eq 12 -and @($la.Entries).Count -eq 138 -and $e -eq '') 'T18b-explicit-author-laragon-inventory-resolves-and-validates' $e
}
else {
    Write-Host 'NOT VERIFIED T18b-explicit-author-laragon-inventory (no C:\laragon\repos\Mirror on this machine)'
}

Remove-Item -LiteralPath $fx -Recurse -Force -ErrorAction SilentlyContinue
Assert-True (-not (Test-Path -LiteralPath $fx)) 'fixture-removed'

Write-Host ""
Write-Host "Passed=$script:Passed Failed=$script:Failed"
if ($script:Failed -gt 0) { exit 1 }
exit 0