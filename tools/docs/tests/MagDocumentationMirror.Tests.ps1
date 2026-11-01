#Requires -Version 7.0
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$here = $PSScriptRoot
$docsRoot = Split-Path -Parent $here
. (Join-Path $docsRoot 'lib\MagDocumentationMirror.Common.ps1')

$script:Passed = 0
$script:Failed = 0
function Assert-True($cond, $name, $detail = '') {
    if ($cond) {
        Write-Host "PASS $name"
        $script:Passed++
    }
    else {
        Write-Host "FAIL $name $detail"
        $script:Failed++
    }
}

# W5: disposable fixtures live outside the repository and outside the Laragon layout (path contains spaces).
$fx = Join-Path ([IO.Path]::GetTempPath()) ('mag mirror fx ' + [guid]::NewGuid().ToString('N').Substring(0, 8))
if (Test-Path $fx) { Remove-Item $fx -Recurse -Force }
New-Item -ItemType Directory -Path $fx -Force | Out-Null

function New-MiniInv {
    param($Root, $Mirror, $Entries)
    $repo = Join-Path $Root 'MiniRepo'
    New-Item -ItemType Directory -Path $repo, $Mirror -Force | Out-Null
    $repos = [pscustomobject]@{ MiniRepo = (Join-Path $Root 'MiniRepo') }
    $invObj = [pscustomobject]@{
        schema_version = 1
        mirror_root    = $Mirror
        repos_root     = $Root
        repositories   = @{ MiniRepo = (Join-Path $Root 'MiniRepo') }
        entries        = $Entries
    }
    $ip = Join-Path $Root 'inv.json'
    ($invObj | ConvertTo-Json -Depth 8) | Set-Content $ip -Encoding utf8
    return $ip
}

function Write-Doc($path, $name, $body) {
    $dir = Split-Path $path -Parent
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    @"
# $name

- MAG-Document-ID: ``$name``
- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00``

$body
"@ | Set-Content -LiteralPath $path -Encoding utf8
}

# equal pair without baseline
$c1 = Join-Path $fx 'c1'
$m1 = Join-Path $fx 'm1'
New-Item $c1, $m1 -ItemType Directory -Force | Out-Null
Write-Doc (Join-Path $c1 'MiniRepo\a.md') 'a.md' 'same'
Write-Doc (Join-Path $m1 'MiniRepo\a.md') 'a.md' 'same'
$inv1 = New-MiniInv $c1 $m1 @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loaded1 = Import-MagMirrorInventory -InventoryPath $inv1 -ReposRootOverride $c1 -MirrorRootOverride $m1
$r1 = Invoke-MagMirrorCheck -Loaded $loaded1 -BaselineMap @{}
Assert-True ($r1.Pairs[0].classification -eq 'IDENTICAL' -and $r1.Pairs[0].proposed_direction -eq 'NONE') 'equal-no-baseline'

# divergent without baseline
$c2 = Join-Path $fx 'c2'; $m2 = Join-Path $fx 'm2'
Write-Doc (Join-Path $c2 'MiniRepo\a.md') 'a.md' 'L'
Write-Doc (Join-Path $m2 'MiniRepo\a.md') 'a.md' 'M'
$inv2 = New-MiniInv $c2 $m2 @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loaded2 = Import-MagMirrorInventory -InventoryPath $inv2 -ReposRootOverride $c2 -MirrorRootOverride $m2
$r2 = Invoke-MagMirrorCheck -Loaded $loaded2 -BaselineMap @{}
Assert-True ($r2.Pairs[0].classification -eq 'CONFLICT') 'divergent-no-baseline'

# Local only
$c3 = Join-Path $fx 'c3'; $m3 = Join-Path $fx 'm3'
Write-Doc (Join-Path $c3 'MiniRepo\a.md') 'a.md' 'L'
New-Item $m3 -ItemType Directory -Force | Out-Null
$inv3 = New-MiniInv $c3 $m3 @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loaded3 = Import-MagMirrorInventory -InventoryPath $inv3 -ReposRootOverride $c3 -MirrorRootOverride $m3
$r3 = Invoke-MagMirrorCheck -Loaded $loaded3 -BaselineMap @{}
Assert-True ($r3.Pairs[0].classification -eq 'MISSING_TARGET') 'local-only'

# Mirror only
$c4 = Join-Path $fx 'c4'; $m4 = Join-Path $fx 'm4'
New-Item (Join-Path $c4 'MiniRepo') -ItemType Directory -Force | Out-Null
Write-Doc (Join-Path $m4 'MiniRepo\a.md') 'a.md' 'M'
$inv4 = New-MiniInv $c4 $m4 @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loaded4 = Import-MagMirrorInventory -InventoryPath $inv4 -ReposRootOverride $c4 -MirrorRootOverride $m4
$r4 = Invoke-MagMirrorCheck -Loaded $loaded4 -BaselineMap @{}
Assert-True ($r4.Pairs[0].classification -eq 'MISSING_SOURCE') 'mirror-only'

# equal baseline
$hEq = $r1.Pairs[0].local_sha256
$r5 = Invoke-MagMirrorCheck -Loaded $loaded1 -BaselineMap @{ 'minirepo|a.md' = $hEq }
Assert-True ($r5.Pairs[0].classification -eq 'IDENTICAL') 'equal-baseline'

# NEWER_LOCAL
$c6 = Join-Path $fx 'c6'; $m6 = Join-Path $fx 'm6'
Write-Doc (Join-Path $c6 'MiniRepo\a.md') 'a.md' 'newL'
Write-Doc (Join-Path $m6 'MiniRepo\a.md') 'a.md' 'old'
$inv6 = New-MiniInv $c6 $m6 @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loaded6 = Import-MagMirrorInventory -InventoryPath $inv6 -ReposRootOverride $c6 -MirrorRootOverride $m6
$mh6 = Get-MagMirrorSha256File (Join-Path $m6 'MiniRepo\a.md')
$r6 = Invoke-MagMirrorCheck -Loaded $loaded6 -BaselineMap @{ 'minirepo|a.md' = $mh6 }
Assert-True ($r6.Pairs[0].classification -eq 'NEWER_LOCAL' -and $r6.Pairs[0].proposed_direction -eq 'LOCAL_TO_MIRROR') 'newer-local'

# NEWER_DRIVE
$c7 = Join-Path $fx 'c7'; $m7 = Join-Path $fx 'm7'
Write-Doc (Join-Path $c7 'MiniRepo\a.md') 'a.md' 'old'
Write-Doc (Join-Path $m7 'MiniRepo\a.md') 'a.md' 'newM'
$inv7 = New-MiniInv $c7 $m7 @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loaded7 = Import-MagMirrorInventory -InventoryPath $inv7 -ReposRootOverride $c7 -MirrorRootOverride $m7
$lh7 = Get-MagMirrorSha256File (Join-Path $c7 'MiniRepo\a.md')
$r7 = Invoke-MagMirrorCheck -Loaded $loaded7 -BaselineMap @{ 'minirepo|a.md' = $lh7 }
Assert-True ($r7.Pairs[0].classification -eq 'NEWER_DRIVE' -and $r7.Pairs[0].authoritative_write -eq $true) 'newer-drive'

# both changed identically
$c8 = Join-Path $fx 'c8'; $m8 = Join-Path $fx 'm8'
Write-Doc (Join-Path $c8 'MiniRepo\a.md') 'a.md' 'bothnew'
Write-Doc (Join-Path $m8 'MiniRepo\a.md') 'a.md' 'bothnew'
$inv8 = New-MiniInv $c8 $m8 @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loaded8 = Import-MagMirrorInventory -InventoryPath $inv8 -ReposRootOverride $c8 -MirrorRootOverride $m8
$r8 = Invoke-MagMirrorCheck -Loaded $loaded8 -BaselineMap @{ 'minirepo|a.md' = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' }
Assert-True ($r8.Pairs[0].classification -eq 'IDENTICAL') 'both-changed-identically'

# both changed differently
$r9 = Invoke-MagMirrorCheck -Loaded $loaded6 -BaselineMap @{ 'minirepo|a.md' = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' }
Assert-True ($r9.Pairs[0].classification -eq 'CONFLICT') 'both-changed-differently'

# tool without metadata
$cT = Join-Path $fx 'ct'; $mT = Join-Path $fx 'mt'
New-Item (Join-Path $cT 'MiniRepo'), (Join-Path $mT 'MiniRepo') -ItemType Directory -Force | Out-Null
'say hi' | Set-Content (Join-Path $cT 'MiniRepo\t.ps1')
'say hi' | Set-Content (Join-Path $mT 'MiniRepo\t.ps1')
$invT = New-MiniInv $cT $mT @(@{ repo = 'MiniRepo'; path = 't.ps1'; category = 'tool'; require_metadata = $false })
$loadedT = Import-MagMirrorInventory -InventoryPath $invT -ReposRootOverride $cT -MirrorRootOverride $mT
$rT = Invoke-MagMirrorCheck -Loaded $loadedT -BaselineMap @{}
Assert-True ($rT.Pairs[0].category -eq 'tool' -and $rT.Pairs[0].classification -eq 'IDENTICAL') 'tool-no-metadata'

# malformed baseline
$badB = Join-Path $fx 'bad-baseline.json'
'{not json' | Set-Content $badB
$threw = $false
try { $null = Import-MagMirrorBaseline $badB } catch { $threw = $true }
Assert-True $threw 'malformed-baseline'

# malformed inventory
$badI = Join-Path $fx 'bad-inv.json'
'{}' | Set-Content $badI
$threwI = $false
try { $null = Import-MagMirrorInventory -InventoryPath $badI } catch { if ([string]$_.Exception.Message -match 'malformed_inventory') { $threwI = $true } }
Assert-True $threwI 'malformed-inventory'

# duplicate mapping
$cD = Join-Path $fx 'cd'; $mD = Join-Path $fx 'md'
New-Item (Join-Path $cD 'MiniRepo') -ItemType Directory -Force | Out-Null
$dup = @(
    @{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $false }
    @{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $false }
)
$invD = New-MiniInv $cD $mD $dup
$threwD = $false
try { $null = Import-MagMirrorInventory -InventoryPath $invD -ReposRootOverride $cD -MirrorRootOverride $mD } catch { if ([string]$_.Exception.Message -match 'duplicate_mapping') { $threwD = $true } }
Assert-True $threwD 'duplicate-mapping'

# traversal
$cTr = Join-Path $fx 'ctr'; $mTr = Join-Path $fx 'mtr'
New-Item (Join-Path $cTr 'MiniRepo') -ItemType Directory -Force | Out-Null
$invTr = New-MiniInv $cTr $mTr @(@{ repo = 'MiniRepo'; path = '../escape.md'; category = 'document'; require_metadata = $false })
$threwTr = $false
try { $null = Import-MagMirrorInventory -InventoryPath $invTr -ReposRootOverride $cTr -MirrorRootOverride $mTr } catch { if ([string]$_.Exception.Message -match 'path_traversal') { $threwTr = $true } }
Assert-True $threwTr 'path-traversal'

# unmanaged extra
'extra' | Set-Content (Join-Path $m1 'extra.md')
$rEx = Invoke-MagMirrorCheck -Loaded $loaded1 -BaselineMap @{}
Assert-True ($rEx.Extras.Count -ge 1) 'unmanaged-extra'

# CHECK read-only: hashes of fixture files unchanged
$hBefore = Get-MagMirrorSha256File (Join-Path $c1 'MiniRepo\a.md')
$null = Invoke-MagMirrorCheck -Loaded $loaded1 -BaselineMap @{}
$hAfter = Get-MagMirrorSha256File (Join-Path $c1 'MiniRepo\a.md')
Assert-True ($hBefore -eq $hAfter) 'check-read-only-local'

# bootstrap refuses invalid inventory
$threwBootInv = $false
try {
    $loadedBad = Import-MagMirrorInventory -InventoryPath $badI
    $null = Invoke-MagMirrorBootstrapClean -Loaded $loadedBad -BaselinePath (Join-Path $fx 'x.json')
} catch { $threwBootInv = $true }
Assert-True $threwBootInv 'bootstrap-refuses-invalid-inventory'

# bootstrap target-boundary: mirror root equals fixture repos root
$cB = Join-Path $fx 'cb'
$invB = New-MiniInv $cB $cB @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'tool'; require_metadata = $false })
Write-Doc (Join-Path $cB 'MiniRepo\a.md') 'a.md' 'x'
$loadedB = Import-MagMirrorInventory -InventoryPath $invB -ReposRootOverride $cB -MirrorRootOverride $cB
$threwBound = $false
try { $null = Invoke-MagMirrorBootstrapClean -Loaded $loadedB -BaselinePath (Join-Path $fx 'bb.json') } catch { if ([string]$_.Exception.Message -match 'mirror_root_is_repos_root|mirror_root_is_canonical') { $threwBound = $true } }
Assert-True $threwBound 'bootstrap-target-boundary'

# bootstrap verified equality + partial failure
$cP = Join-Path $fx 'cp'; $mP = Join-Path $fx 'mp'
Write-Doc (Join-Path $cP 'MiniRepo\ok.md') 'ok.md' 'ok'
$invP = New-MiniInv $cP $mP @(
    @{ repo = 'MiniRepo'; path = 'ok.md'; category = 'document'; require_metadata = $true }
    @{ repo = 'MiniRepo'; path = 'missing.md'; category = 'document'; require_metadata = $true }
)
$loadedP = Import-MagMirrorInventory -InventoryPath $invP -ReposRootOverride $cP -MirrorRootOverride $mP
$baseP = Join-Path $fx 'base-partial.json'
$bootP = Invoke-MagMirrorBootstrapClean -Loaded $loadedP -BaselinePath $baseP
$baseObj = Get-Content $baseP -Raw | ConvertFrom-Json
$onlyOk = ($baseObj.pairs.Count -eq 1 -and $baseObj.pairs[0].path -eq 'ok.md')
$mhOk = Get-MagMirrorSha256File (Join-Path $mP 'MiniRepo\ok.md')
$lhOk = Get-MagMirrorSha256File (Join-Path $cP 'MiniRepo\ok.md')
Assert-True ($bootP.Failed.Count -eq 1 -and $onlyOk -and $mhOk -eq $lhOk) 'partial-bootstrap-baseline'

# production paths untouched: MAG_ECOSYSTEM hash stable through tests
$prod = 'C:\laragon\repos\MAG-Ecosystem\MAG_ECOSYSTEM.md'
$ph = Get-MagMirrorSha256File $prod
Assert-True ($ph.Length -eq 64) 'production-path-exists'
$ph2 = Get-MagMirrorSha256File $prod
Assert-True ($ph -eq $ph2) 'production-untouched-by-tests'

# FORMAT_ONLY no write
$cF = Join-Path $fx 'cf'; $mF = Join-Path $fx 'mf'
$pL = Join-Path $cF 'MiniRepo\a.md'
$pM = Join-Path $mF 'MiniRepo\a.md'
New-Item (Split-Path $pL), (Split-Path $pM) -ItemType Directory -Force | Out-Null
$lf = "# a.md`n`n- MAG-Document-ID: ``a.md```n- MAG-Content-Updated: ``2026-01-01T00:00:00+00:00```n`nbody`n"
[IO.File]::WriteAllBytes($pL, [Text.Encoding]::UTF8.GetBytes($lf))
$crlf = $lf.Replace("`n", "`r`n")
[IO.File]::WriteAllBytes($pM, [Text.Encoding]::UTF8.GetBytes($crlf))
$invF = New-MiniInv $cF $mF @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedF = Import-MagMirrorInventory -InventoryPath $invF -ReposRootOverride $cF -MirrorRootOverride $mF
$rF = Invoke-MagMirrorCheck -Loaded $loadedF -BaselineMap @{}
Assert-True ($rF.Pairs[0].classification -eq 'FORMAT_ONLY' -and $rF.Pairs[0].proposed_direction -eq 'NONE') 'format-only-no-write'

function Save-FxReceipt($loaded, $check, $invPath, $basePath, $receiptPath) {
    $rec = New-MagMirrorCheckReceipt -Loaded $loaded -CheckResult $check -InventoryPath $invPath -BaselinePath $basePath
    return Save-MagMirrorCheckReceipt -Receipt $rec -ReceiptPath $receiptPath
}

$prodEco = 'C:\laragon\repos\MAG-Ecosystem\MAG_ECOSYSTEM.md'
$prodMir = 'C:\laragon\repos\Mirror\MAG-Ecosystem\MAG_ECOSYSTEM.md'
$hProdL0 = Get-MagMirrorSha256File $prodEco
$hProdM0 = Get-MagMirrorSha256File $prodMir

# receipt generated without mutating pair files
$cR = Join-Path $fx 'cr'; $mR = Join-Path $fx 'mr'
Write-Doc (Join-Path $cR 'MiniRepo\a.md') 'a.md' 'r0'
Write-Doc (Join-Path $mR 'MiniRepo\a.md') 'a.md' 'r0'
$invR = New-MiniInv $cR $mR @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedR = Import-MagMirrorInventory -InventoryPath $invR -ReposRootOverride $cR -MirrorRootOverride $mR
$hLbefore = Get-MagMirrorSha256File (Join-Path $cR 'MiniRepo\a.md')
$chkR = Invoke-MagMirrorCheck -Loaded $loadedR -BaselineMap @{}
$rpR = Join-Path $fx 'receipt-r.json'
$savedR = Save-FxReceipt $loadedR $chkR $invR $null $rpR
$hLafter = Get-MagMirrorSha256File (Join-Path $cR 'MiniRepo\a.md')
$hMafter = Get-MagMirrorSha256File (Join-Path $mR 'MiniRepo\a.md')
$recObj = Get-Content $rpR -Raw | ConvertFrom-Json
Assert-True ($hLbefore -eq $hLafter -and $hLbefore -eq $hMafter -and $savedR.Sha256.Length -eq 64 -and $recObj.pairs.Count -eq 1 -and $recObj.inventory_sha256 -eq (Get-MagMirrorSha256File $invR)) 'receipt-readonly-and-bound'

# NEWER_LOCAL authorized
$cNL = Join-Path $fx 'cnl'; $mNL = Join-Path $fx 'mnl'
Write-Doc (Join-Path $cNL 'MiniRepo\a.md') 'a.md' 'old'
Write-Doc (Join-Path $mNL 'MiniRepo\a.md') 'a.md' 'old'
$invNL = New-MiniInv $cNL $mNL @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedNL = Import-MagMirrorInventory -InventoryPath $invNL -ReposRootOverride $cNL -MirrorRootOverride $mNL
$baseNL = Join-Path $fx 'base-nl.json'
$null = Invoke-MagMirrorBootstrapClean -Loaded $loadedNL -BaselinePath $baseNL
Write-Doc (Join-Path $cNL 'MiniRepo\a.md') 'a.md' 'newL'
$loadedNL = Import-MagMirrorInventory -InventoryPath $invNL -ReposRootOverride $cNL -MirrorRootOverride $mNL
$bmapNL = Import-MagMirrorBaseline $baseNL
$chkNL = Invoke-MagMirrorCheck -Loaded $loadedNL -BaselineMap $bmapNL
$rpNL = Join-Path $fx 'receipt-nl.json'
$svNL = Save-FxReceipt $loadedNL $chkNL $invNL $baseNL $rpNL
$recNL = Invoke-MagMirrorReconcile -ReceiptPath $rpNL -AuthorizationSha256 $svNL.Sha256 -InventoryPath $invNL -BaselinePath $baseNL -ReposRootOverride $cNL -MirrorRootOverride $mNL
$hNLl = Get-MagMirrorSha256File (Join-Path $cNL 'MiniRepo\a.md')
$hNLm = Get-MagMirrorSha256File (Join-Path $mNL 'MiniRepo\a.md')
$bNL = Import-MagMirrorBaseline $baseNL
Assert-True ($recNL.WrittenCount -eq 1 -and $hNLl -eq $hNLm -and $bNL['minirepo|a.md'] -eq $hNLl) 'reconcile-newer-local'

# NEWER_DRIVE authorized
$cND = Join-Path $fx 'cnd'; $mND = Join-Path $fx 'mnd'
Write-Doc (Join-Path $cND 'MiniRepo\a.md') 'a.md' 'oldD'
Write-Doc (Join-Path $mND 'MiniRepo\a.md') 'a.md' 'oldD'
$invND = New-MiniInv $cND $mND @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedND = Import-MagMirrorInventory -InventoryPath $invND -ReposRootOverride $cND -MirrorRootOverride $mND
$baseND = Join-Path $fx 'base-nd.json'
$null = Invoke-MagMirrorBootstrapClean -Loaded $loadedND -BaselinePath $baseND
Write-Doc (Join-Path $mND 'MiniRepo\a.md') 'a.md' 'newD'
$loadedND = Import-MagMirrorInventory -InventoryPath $invND -ReposRootOverride $cND -MirrorRootOverride $mND
$chkND = Invoke-MagMirrorCheck -Loaded $loadedND -BaselineMap (Import-MagMirrorBaseline $baseND)
$rpND = Join-Path $fx 'receipt-nd.json'
$svND = Save-FxReceipt $loadedND $chkND $invND $baseND $rpND
$recND = Invoke-MagMirrorReconcile -ReceiptPath $rpND -AuthorizationSha256 $svND.Sha256 -InventoryPath $invND -BaselinePath $baseND -ReposRootOverride $cND -MirrorRootOverride $mND
$hNDl = Get-MagMirrorSha256File (Join-Path $cND 'MiniRepo\a.md')
$hNDm = Get-MagMirrorSha256File (Join-Path $mND 'MiniRepo\a.md')
Assert-True ($recND.WrittenCount -eq 1 -and $hNDl -eq $hNDm) 'reconcile-newer-drive'

# mixed batch
$cX = Join-Path $fx 'cx'; $mX = Join-Path $fx 'mx'
Write-Doc (Join-Path $cX 'MiniRepo\a.md') 'a.md' 'xold'
Write-Doc (Join-Path $mX 'MiniRepo\a.md') 'a.md' 'xold'
Write-Doc (Join-Path $cX 'MiniRepo\b.md') 'b.md' 'yold'
Write-Doc (Join-Path $mX 'MiniRepo\b.md') 'b.md' 'yold'
$invX = New-MiniInv $cX $mX @(
    @{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true }
    @{ repo = 'MiniRepo'; path = 'b.md'; category = 'document'; require_metadata = $true }
)
$loadedX = Import-MagMirrorInventory -InventoryPath $invX -ReposRootOverride $cX -MirrorRootOverride $mX
$baseX = Join-Path $fx 'base-x.json'
$null = Invoke-MagMirrorBootstrapClean -Loaded $loadedX -BaselinePath $baseX
Write-Doc (Join-Path $cX 'MiniRepo\a.md') 'a.md' 'xnewL'
Write-Doc (Join-Path $mX 'MiniRepo\b.md') 'b.md' 'ynewM'
$loadedX = Import-MagMirrorInventory -InventoryPath $invX -ReposRootOverride $cX -MirrorRootOverride $mX
$chkX = Invoke-MagMirrorCheck -Loaded $loadedX -BaselineMap (Import-MagMirrorBaseline $baseX)
$rpX = Join-Path $fx 'receipt-x.json'
$svX = Save-FxReceipt $loadedX $chkX $invX $baseX $rpX
$recX = Invoke-MagMirrorReconcile -ReceiptPath $rpX -AuthorizationSha256 $svX.Sha256 -InventoryPath $invX -BaselinePath $baseX -ReposRootOverride $cX -MirrorRootOverride $mX
$eqA = (Get-MagMirrorSha256File (Join-Path $cX 'MiniRepo\a.md')) -eq (Get-MagMirrorSha256File (Join-Path $mX 'MiniRepo\a.md'))
$eqB = (Get-MagMirrorSha256File (Join-Path $cX 'MiniRepo\b.md')) -eq (Get-MagMirrorSha256File (Join-Path $mX 'MiniRepo\b.md'))
Assert-True ($recX.WrittenCount -eq 2 -and $eqA -and $eqB) 'reconcile-mixed-batch'

# CONFLICT blocked, independent NEWER_LOCAL succeeds
$cC = Join-Path $fx 'ccf'; $mC = Join-Path $fx 'mcf'
Write-Doc (Join-Path $cC 'MiniRepo\safe.md') 'safe.md' 's0'
Write-Doc (Join-Path $mC 'MiniRepo\safe.md') 'safe.md' 's0'
Write-Doc (Join-Path $cC 'MiniRepo\bad.md') 'bad.md' 'L'
Write-Doc (Join-Path $mC 'MiniRepo\bad.md') 'bad.md' 'M'
$invC = New-MiniInv $cC $mC @(
    @{ repo = 'MiniRepo'; path = 'safe.md'; category = 'document'; require_metadata = $true }
    @{ repo = 'MiniRepo'; path = 'bad.md'; category = 'document'; require_metadata = $true }
)
$loadedC = Import-MagMirrorInventory -InventoryPath $invC -ReposRootOverride $cC -MirrorRootOverride $mC
$baseC = Join-Path $fx 'base-c.json'
# bootstrap only safe (both sides equal); leave bad divergent without baseline entry
Copy-Item (Join-Path $cC 'MiniRepo\safe.md') (Join-Path $mC 'MiniRepo\safe.md') -Force
$hSafe = Get-MagMirrorSha256File (Join-Path $cC 'MiniRepo\safe.md')
Write-MagMirrorBaseline -BaselinePath $baseC -Pairs @(@{ repo = 'MiniRepo'; path = 'safe.md'; category = 'document'; baseline_sha256 = $hSafe; confirmed_at = '2026-01-01T00:00:00Z' })
Write-Doc (Join-Path $cC 'MiniRepo\safe.md') 'safe.md' 's1'
$loadedC = Import-MagMirrorInventory -InventoryPath $invC -ReposRootOverride $cC -MirrorRootOverride $mC
$chkC = Invoke-MagMirrorCheck -Loaded $loadedC -BaselineMap (Import-MagMirrorBaseline $baseC)
$rpC = Join-Path $fx 'receipt-c.json'
$svC = Save-FxReceipt $loadedC $chkC $invC $baseC $rpC
$hBadM0 = Get-MagMirrorSha256File (Join-Path $mC 'MiniRepo\bad.md')
$recC = Invoke-MagMirrorReconcile -ReceiptPath $rpC -AuthorizationSha256 $svC.Sha256 -InventoryPath $invC -BaselinePath $baseC -ReposRootOverride $cC -MirrorRootOverride $mC
$hBadM1 = Get-MagMirrorSha256File (Join-Path $mC 'MiniRepo\bad.md')
$safeEq = (Get-MagMirrorSha256File (Join-Path $cC 'MiniRepo\safe.md')) -eq (Get-MagMirrorSha256File (Join-Path $mC 'MiniRepo\safe.md'))
Assert-True ($recC.WrittenCount -eq 1 -and $recC.BlockedCount -eq 1 -and $hBadM0 -eq $hBadM1 -and $safeEq) 'conflict-blocks-only-that-pair'

# stale Local after CHECK
$cS = Join-Path $fx 'cs'; $mS = Join-Path $fx 'ms'
Write-Doc (Join-Path $cS 'MiniRepo\a.md') 'a.md' 't0'
Write-Doc (Join-Path $mS 'MiniRepo\a.md') 'a.md' 't0'
$invS = New-MiniInv $cS $mS @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedS = Import-MagMirrorInventory -InventoryPath $invS -ReposRootOverride $cS -MirrorRootOverride $mS
$baseS = Join-Path $fx 'base-s.json'
$null = Invoke-MagMirrorBootstrapClean -Loaded $loadedS -BaselinePath $baseS
Write-Doc (Join-Path $cS 'MiniRepo\a.md') 'a.md' 't1'
$loadedS = Import-MagMirrorInventory -InventoryPath $invS -ReposRootOverride $cS -MirrorRootOverride $mS
$chkS = Invoke-MagMirrorCheck -Loaded $loadedS -BaselineMap (Import-MagMirrorBaseline $baseS)
$rpS = Join-Path $fx 'receipt-s.json'
$svS = Save-FxReceipt $loadedS $chkS $invS $baseS $rpS
Write-Doc (Join-Path $cS 'MiniRepo\a.md') 'a.md' 't2'
$hM0 = Get-MagMirrorSha256File (Join-Path $mS 'MiniRepo\a.md')
$recS = Invoke-MagMirrorReconcile -ReceiptPath $rpS -AuthorizationSha256 $svS.Sha256 -InventoryPath $invS -BaselinePath $baseS -ReposRootOverride $cS -MirrorRootOverride $mS
$hM1 = Get-MagMirrorSha256File (Join-Path $mS 'MiniRepo\a.md')
Assert-True ($recS.StaleCount -eq 1 -and $hM0 -eq $hM1) 'stale-local-no-write'

# stale Mirror after CHECK
Write-Doc (Join-Path $cS 'MiniRepo\a.md') 'a.md' 't1'
$loadedS = Import-MagMirrorInventory -InventoryPath $invS -ReposRootOverride $cS -MirrorRootOverride $mS
$chkS2 = Invoke-MagMirrorCheck -Loaded $loadedS -BaselineMap (Import-MagMirrorBaseline $baseS)
$rpS2 = Join-Path $fx 'receipt-s2.json'
$svS2 = Save-FxReceipt $loadedS $chkS2 $invS $baseS $rpS2
Write-Doc (Join-Path $mS 'MiniRepo\a.md') 'a.md' 'mX'
$hL0 = Get-MagMirrorSha256File (Join-Path $cS 'MiniRepo\a.md')
$recS2 = Invoke-MagMirrorReconcile -ReceiptPath $rpS2 -AuthorizationSha256 $svS2.Sha256 -InventoryPath $invS -BaselinePath $baseS -ReposRootOverride $cS -MirrorRootOverride $mS
$hL1 = Get-MagMirrorSha256File (Join-Path $cS 'MiniRepo\a.md')
Assert-True ($recS2.StaleCount -eq 1 -and $hL0 -eq $hL1) 'stale-mirror-no-write'

# baseline changed after CHECK → whole fail
$cB2 = Join-Path $fx 'cb2'; $mB2 = Join-Path $fx 'mb2'
Write-Doc (Join-Path $cB2 'MiniRepo\a.md') 'a.md' 'b0'
Write-Doc (Join-Path $mB2 'MiniRepo\a.md') 'a.md' 'b0'
$invB2 = New-MiniInv $cB2 $mB2 @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedB2 = Import-MagMirrorInventory -InventoryPath $invB2 -ReposRootOverride $cB2 -MirrorRootOverride $mB2
$baseB2 = Join-Path $fx 'base-b2.json'
$null = Invoke-MagMirrorBootstrapClean -Loaded $loadedB2 -BaselinePath $baseB2
Write-Doc (Join-Path $cB2 'MiniRepo\a.md') 'a.md' 'b1'
$loadedB2 = Import-MagMirrorInventory -InventoryPath $invB2 -ReposRootOverride $cB2 -MirrorRootOverride $mB2
$chkB2 = Invoke-MagMirrorCheck -Loaded $loadedB2 -BaselineMap (Import-MagMirrorBaseline $baseB2)
$rpB2 = Join-Path $fx 'receipt-b2.json'
$svB2 = Save-FxReceipt $loadedB2 $chkB2 $invB2 $baseB2 $rpB2
Write-MagMirrorBaseline -BaselinePath $baseB2 -Pairs @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; baseline_sha256 = ('b' * 64); confirmed_at = '2026-01-01T00:00:00Z' })
$threwBase = $false
try {
    $null = Invoke-MagMirrorReconcile -ReceiptPath $rpB2 -AuthorizationSha256 $svB2.Sha256 -InventoryPath $invB2 -BaselinePath $baseB2 -ReposRootOverride $cB2 -MirrorRootOverride $mB2
}
catch { if ([string]$_.Exception.Message -match 'baseline_changed') { $threwBase = $true } }
Assert-True $threwBase 'baseline-changed-fail-closed'

# inventory changed after CHECK
$cI = Join-Path $fx 'ci'; $mI = Join-Path $fx 'mi'
Write-Doc (Join-Path $cI 'MiniRepo\a.md') 'a.md' 'i0'
Write-Doc (Join-Path $mI 'MiniRepo\a.md') 'a.md' 'i0'
$invI = New-MiniInv $cI $mI @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedI = Import-MagMirrorInventory -InventoryPath $invI -ReposRootOverride $cI -MirrorRootOverride $mI
$baseI = Join-Path $fx 'base-i.json'
$null = Invoke-MagMirrorBootstrapClean -Loaded $loadedI -BaselinePath $baseI
Write-Doc (Join-Path $cI 'MiniRepo\a.md') 'a.md' 'i1'
$loadedI = Import-MagMirrorInventory -InventoryPath $invI -ReposRootOverride $cI -MirrorRootOverride $mI
$chkI = Invoke-MagMirrorCheck -Loaded $loadedI -BaselineMap (Import-MagMirrorBaseline $baseI)
$rpI = Join-Path $fx 'receipt-i.json'
$svI = Save-FxReceipt $loadedI $chkI $invI $baseI $rpI
Add-Content $invI -Value ' '
$threwInv = $false
try {
    $null = Invoke-MagMirrorReconcile -ReceiptPath $rpI -AuthorizationSha256 $svI.Sha256 -InventoryPath $invI -BaselinePath $baseI -ReposRootOverride $cI -MirrorRootOverride $mI
}
catch { if ([string]$_.Exception.Message -match 'inventory_changed') { $threwInv = $true } }
Assert-True $threwInv 'inventory-changed-fail-closed'

# malformed receipt / wrong auth
$threwMal = $false
'{bad' | Set-Content (Join-Path $fx 'bad-rec.json')
try { $null = Invoke-MagMirrorReconcile -ReceiptPath (Join-Path $fx 'bad-rec.json') -AuthorizationSha256 ('a' * 64) -InventoryPath $invNL -BaselinePath $baseNL } catch { $threwMal = $true }
$threwAuth = $false
try { $null = Invoke-MagMirrorReconcile -ReceiptPath $rpNL -AuthorizationSha256 ('0' * 64) -InventoryPath $invNL -BaselinePath $baseNL } catch { if ([string]$_.Exception.Message -match 'authorization_mismatch') { $threwAuth = $true } }
$raw = Get-Content $rpNL -Raw
$raw2 = $raw -replace 'NEWER_LOCAL', 'CONFLICT'
Set-Content $rpNL ($raw2) -Encoding utf8
$threwTamp = $false
try { $null = Invoke-MagMirrorReconcile -ReceiptPath $rpNL -AuthorizationSha256 $svNL.Sha256 -InventoryPath $invNL -BaselinePath $baseNL } catch { if ([string]$_.Exception.Message -match 'authorization_mismatch') { $threwTamp = $true } }
Assert-True ($threwMal -and $threwAuth -and $threwTamp) 'receipt-tamper-and-auth-fail-closed'

# unsafe MirrorRoot for reconcile
$cU = Join-Path $fx 'cu'; $mU = Join-Path $fx 'mu'
Write-Doc (Join-Path $cU 'MiniRepo\a.md') 'a.md' 'u0'
Write-Doc (Join-Path $mU 'MiniRepo\a.md') 'a.md' 'u0'
$invU = New-MiniInv $cU $mU @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedU = Import-MagMirrorInventory -InventoryPath $invU -ReposRootOverride $cU -MirrorRootOverride $mU
$baseU = Join-Path $fx 'base-u.json'
$null = Invoke-MagMirrorBootstrapClean -Loaded $loadedU -BaselinePath $baseU
Write-Doc (Join-Path $cU 'MiniRepo\a.md') 'a.md' 'u1'
$loadedU = Import-MagMirrorInventory -InventoryPath $invU -ReposRootOverride $cU -MirrorRootOverride $mU
$chkU = Invoke-MagMirrorCheck -Loaded $loadedU -BaselineMap (Import-MagMirrorBaseline $baseU)
$rpU = Join-Path $fx 'receipt-u.json'
$svU = Save-FxReceipt $loadedU $chkU $invU $baseU $rpU
$threwUnsafe = $false
try {
    $null = Invoke-MagMirrorReconcile -ReceiptPath $rpU -AuthorizationSha256 $svU.Sha256 -InventoryPath $invU -BaselinePath $baseU -ReposRootOverride $cU -MirrorRootOverride $cU
}
catch { if ([string]$_.Exception.Message -match 'mirror_root') { $threwUnsafe = $true } }
Assert-True $threwUnsafe 'reconcile-unsafe-root-fail-closed'

# failed target verification: dest is a directory
$cV = Join-Path $fx 'cv'; $mV = Join-Path $fx 'mv'
Write-Doc (Join-Path $cV 'MiniRepo\a.md') 'a.md' 'v0'
Write-Doc (Join-Path $mV 'MiniRepo\a.md') 'a.md' 'v0'
$invV = New-MiniInv $cV $mV @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedV = Import-MagMirrorInventory -InventoryPath $invV -ReposRootOverride $cV -MirrorRootOverride $mV
$baseV = Join-Path $fx 'base-v.json'
$null = Invoke-MagMirrorBootstrapClean -Loaded $loadedV -BaselinePath $baseV
Write-Doc (Join-Path $cV 'MiniRepo\a.md') 'a.md' 'v1'
$loadedV = Import-MagMirrorInventory -InventoryPath $invV -ReposRootOverride $cV -MirrorRootOverride $mV
$chkV = Invoke-MagMirrorCheck -Loaded $loadedV -BaselineMap (Import-MagMirrorBaseline $baseV)
$rpV = Join-Path $fx 'receipt-v.json'
$svV = Save-FxReceipt $loadedV $chkV $invV $baseV $rpV
Remove-Item (Join-Path $mV 'MiniRepo\a.md') -Force
New-Item -ItemType Directory -Path (Join-Path $mV 'MiniRepo\a.md') -Force | Out-Null
$recV = Invoke-MagMirrorReconcile -ReceiptPath $rpV -AuthorizationSha256 $svV.Sha256 -InventoryPath $invV -BaselinePath $baseV -ReposRootOverride $cV -MirrorRootOverride $mV
$bV = Import-MagMirrorBaseline $baseV
$hV0 = Get-MagMirrorSha256File (Join-Path $cV 'MiniRepo\a.md')
Assert-True (($recV.FailedCount -eq 1 -or $recV.StaleCount -eq 1) -and -not $recV.Results[0].wrote -and $bV['minirepo|a.md'] -ne $hV0) 'failed-verify-no-baseline-advance'

# partial failure truthful baseline: ok pair writes, fail pair does not
$cPf = Join-Path $fx 'cpf'; $mPf = Join-Path $fx 'mpf'
Write-Doc (Join-Path $cPf 'MiniRepo\ok.md') 'ok.md' 'p0'
Write-Doc (Join-Path $mPf 'MiniRepo\ok.md') 'ok.md' 'p0'
Write-Doc (Join-Path $cPf 'MiniRepo\fail.md') 'fail.md' 'p0'
Write-Doc (Join-Path $mPf 'MiniRepo\fail.md') 'fail.md' 'p0'
$invPf = New-MiniInv $cPf $mPf @(
    @{ repo = 'MiniRepo'; path = 'ok.md'; category = 'document'; require_metadata = $true }
    @{ repo = 'MiniRepo'; path = 'fail.md'; category = 'document'; require_metadata = $true }
)
$loadedPf = Import-MagMirrorInventory -InventoryPath $invPf -ReposRootOverride $cPf -MirrorRootOverride $mPf
$basePf = Join-Path $fx 'base-pf.json'
$null = Invoke-MagMirrorBootstrapClean -Loaded $loadedPf -BaselinePath $basePf
Write-Doc (Join-Path $cPf 'MiniRepo\ok.md') 'ok.md' 'p1'
Write-Doc (Join-Path $cPf 'MiniRepo\fail.md') 'fail.md' 'p1'
$loadedPf = Import-MagMirrorInventory -InventoryPath $invPf -ReposRootOverride $cPf -MirrorRootOverride $mPf
$chkPf = Invoke-MagMirrorCheck -Loaded $loadedPf -BaselineMap (Import-MagMirrorBaseline $basePf)
$rpPf = Join-Path $fx 'receipt-pf.json'
$svPf = Save-FxReceipt $loadedPf $chkPf $invPf $basePf $rpPf
Remove-Item (Join-Path $mPf 'MiniRepo\fail.md') -Force
New-Item -ItemType Directory -Path (Join-Path $mPf 'MiniRepo\fail.md') -Force | Out-Null
$hFailBase = (Import-MagMirrorBaseline $basePf)['minirepo|fail.md']
$recPf = Invoke-MagMirrorReconcile -ReceiptPath $rpPf -AuthorizationSha256 $svPf.Sha256 -InventoryPath $invPf -BaselinePath $basePf -ReposRootOverride $cPf -MirrorRootOverride $mPf
$bPf = Import-MagMirrorBaseline $basePf
$okHash = Get-MagMirrorSha256File (Join-Path $cPf 'MiniRepo\ok.md')
Assert-True ($recPf.WrittenCount -eq 1 -and ($recPf.FailedCount -eq 1 -or $recPf.StaleCount -eq 1) -and $bPf['minirepo|ok.md'] -eq $okHash -and $bPf['minirepo|fail.md'] -eq $hFailBase) 'partial-failure-truthful-baseline'

# post-CHECK IDENTICAL after successful pair + obsolete receipt cannot rewrite
$chkAfter = Invoke-MagMirrorCheck -Loaded $loadedNL -BaselineMap (Import-MagMirrorBaseline $baseNL)
$hBeforeRepeat = Get-MagMirrorSha256File (Join-Path $cND 'MiniRepo\a.md')
$repeatClosed = $false
try {
    $null = Invoke-MagMirrorReconcile -ReceiptPath $rpND -AuthorizationSha256 $svND.Sha256 -InventoryPath $invND -BaselinePath $baseND -ReposRootOverride $cND -MirrorRootOverride $mND
}
catch { if ([string]$_.Exception.Message -match 'baseline_changed_since_check') { $repeatClosed = $true } }
$hAfterRepeat = Get-MagMirrorSha256File (Join-Path $cND 'MiniRepo\a.md')
Assert-True ($repeatClosed -and $hBeforeRepeat -eq $hAfterRepeat) 'obsolete-receipt-no-rewrite'
Assert-True ($chkAfter.Pairs[0].classification -eq 'IDENTICAL') 'post-success-check-identical'

# --- MPO-003 Publish-Affected matrix ---
function New-PubFx($name) {
    $c = Join-Path $fx $name
    $m = Join-Path $fx ($name + '-m')
    New-Item $c, $m -ItemType Directory -Force | Out-Null
    return [pscustomobject]@{ C = $c; M = $m }
}
function Invoke-Pub {
    param($Loaded, [string[]]$Tokens, [string]$BaselinePath)
    if ($null -eq $Tokens) { $Tokens = [string[]]@() }
    $splat = @{
        Loaded                 = $Loaded
        AffectedTokens         = $Tokens
        BaselinePath           = $BaselinePath
    }
    return Invoke-MagMirrorPublishAffected @splat
}

# A empty → NOT_APPLICABLE, no mutation
$pa = New-PubFx 'pa'
Write-Doc (Join-Path $pa.C 'MiniRepo\a.md') 'a.md' 'A'
Write-Doc (Join-Path $pa.M 'MiniRepo\a.md') 'a.md' 'A'
$invA = New-MiniInv $pa.C $pa.M @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedA = Import-MagMirrorInventory -InventoryPath $invA -ReposRootOverride $pa.C -MirrorRootOverride $pa.M
$baseA = Join-Path $pa.C 'base.json'
$hA0 = Get-MagMirrorSha256File (Join-Path $pa.M 'MiniRepo\a.md')
$pubA = Invoke-Pub -Loaded $loadedA -Tokens $null -BaselinePath $baseA
$hA1 = Get-MagMirrorSha256File (Join-Path $pa.M 'MiniRepo\a.md')
Assert-True ($pubA.PublicationStatus -eq 'NOT_APPLICABLE' -and $pubA.WrittenCount -eq 0 -and $hA0 -eq $hA1 -and $pubA.google_drive_status -eq 'UNKNOWN' -and $pubA.drive_sync_claimed -eq $false) 'pub-A-empty-not-applicable'

# B NEWER_LOCAL publish + baseline
$pb = New-PubFx 'pb'
Write-Doc (Join-Path $pb.C 'MiniRepo\a.md') 'a.md' 'OLD'
Write-Doc (Join-Path $pb.M 'MiniRepo\a.md') 'a.md' 'OLD'
$invB = New-MiniInv $pb.C $pb.M @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedB = Import-MagMirrorInventory -InventoryPath $invB -ReposRootOverride $pb.C -MirrorRootOverride $pb.M
$baseB = Join-Path $pb.C 'base.json'
$hOld = Get-MagMirrorSha256File (Join-Path $pb.C 'MiniRepo\a.md')
Merge-MagMirrorBaselinePair -BaselinePath $baseB -Repo MiniRepo -RelPath 'a.md' -Category document -Sha256 $hOld | Out-Null
Write-Doc (Join-Path $pb.C 'MiniRepo\a.md') 'a.md' 'NEW'
$tB = [string[]]('MiniRepo/a.md')
$pubB = Invoke-Pub -Loaded $loadedB -Tokens $tB -BaselinePath $baseB
$hLocB = Get-MagMirrorSha256File (Join-Path $pb.C 'MiniRepo\a.md')
$hMirB = Get-MagMirrorSha256File (Join-Path $pb.M 'MiniRepo\a.md')
$bB = Import-MagMirrorBaseline $baseB
Assert-True ($pubB.PublicationStatus -eq 'PUBLISHED' -and $pubB.WrittenCount -eq 1 -and $hLocB -eq $hMirB -and $bB['minirepo|a.md'] -eq $hLocB) 'pub-B-newer-local-publish'

# C two files, only listed one publishes
$pc = New-PubFx 'pc'
Write-Doc (Join-Path $pc.C 'MiniRepo\a.md') 'a.md' 'A0'
Write-Doc (Join-Path $pc.M 'MiniRepo\a.md') 'a.md' 'A0'
Write-Doc (Join-Path $pc.C 'MiniRepo\b.md') 'b.md' 'B0'
Write-Doc (Join-Path $pc.M 'MiniRepo\b.md') 'b.md' 'B0'
$invC = New-MiniInv $pc.C $pc.M @(
    @{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true },
    @{ repo = 'MiniRepo'; path = 'b.md'; category = 'document'; require_metadata = $true }
)
$loadedC = Import-MagMirrorInventory -InventoryPath $invC -ReposRootOverride $pc.C -MirrorRootOverride $pc.M
$baseC = Join-Path $pc.C 'base.json'
Merge-MagMirrorBaselinePair -BaselinePath $baseC -Repo MiniRepo -RelPath 'a.md' -Category document -Sha256 (Get-MagMirrorSha256File (Join-Path $pc.C 'MiniRepo\a.md')) | Out-Null
Merge-MagMirrorBaselinePair -BaselinePath $baseC -Repo MiniRepo -RelPath 'b.md' -Category document -Sha256 (Get-MagMirrorSha256File (Join-Path $pc.C 'MiniRepo\b.md')) | Out-Null
Write-Doc (Join-Path $pc.C 'MiniRepo\a.md') 'a.md' 'A1'
Write-Doc (Join-Path $pc.C 'MiniRepo\b.md') 'b.md' 'B1'
$hB0m = Get-MagMirrorSha256File (Join-Path $pc.M 'MiniRepo\b.md')
$tC = [string[]]('MiniRepo/a.md')
$pubC = Invoke-Pub -Loaded $loadedC -Tokens $tC -BaselinePath $baseC
$hB1m = Get-MagMirrorSha256File (Join-Path $pc.M 'MiniRepo\b.md')
Assert-True ($pubC.WrittenCount -eq 1 -and $pubC.Results[0].path -eq 'a.md' -and $hB0m -eq $hB1m) 'pub-C-only-listed-file'

# D source-only token → NOT_APPLICABLE, no write
$pd = New-PubFx 'pd'
Write-Doc (Join-Path $pd.C 'MiniRepo\a.md') 'a.md' 'X'
Write-Doc (Join-Path $pd.M 'MiniRepo\a.md') 'a.md' 'X'
New-Item (Join-Path $pd.C 'MiniRepo') -ItemType Directory -Force | Out-Null
Set-Content (Join-Path $pd.C 'MiniRepo\app.php') '<?php echo 1;'
$invD = New-MiniInv $pd.C $pd.M @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedD = Import-MagMirrorInventory -InventoryPath $invD -ReposRootOverride $pd.C -MirrorRootOverride $pd.M
$hD0 = Get-MagMirrorSha256File (Join-Path $pd.M 'MiniRepo\a.md')
$tD = [string[]]('MiniRepo/app.php')
$pubD = Invoke-Pub -Loaded $loadedD -Tokens $tD -BaselinePath (Join-Path $pd.C 'base.json')
$hD1 = Get-MagMirrorSha256File (Join-Path $pd.M 'MiniRepo\a.md')
Assert-True ($pubD.PublicationStatus -eq 'NOT_APPLICABLE' -and $pubD.SkippedUnmanaged -eq 1 -and $hD0 -eq $hD1) 'pub-D-source-not-applicable'

# E unmanaged markdown
$pe = New-PubFx 'pe'
Write-Doc (Join-Path $pe.C 'MiniRepo\a.md') 'a.md' 'M'
Write-Doc (Join-Path $pe.M 'MiniRepo\a.md') 'a.md' 'M'
Write-Doc (Join-Path $pe.C 'MiniRepo\notes.md') 'notes.md' 'N'
$invE = New-MiniInv $pe.C $pe.M @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedE = Import-MagMirrorInventory -InventoryPath $invE -ReposRootOverride $pe.C -MirrorRootOverride $pe.M
$tE = [string[]]('MiniRepo/notes.md')
$pubE = Invoke-Pub -Loaded $loadedE -Tokens $tE -BaselinePath (Join-Path $pe.C 'base.json')
Assert-True ($pubE.PublicationStatus -eq 'NOT_APPLICABLE' -and $pubE.SkippedUnmanaged -eq 1 -and -not (Test-Path (Join-Path $pe.M 'MiniRepo\notes.md'))) 'pub-E-unmanaged-not-adopted'

# F already identical
$pf = New-PubFx 'pf'
Write-Doc (Join-Path $pf.C 'MiniRepo\a.md') 'a.md' 'SAME'
Write-Doc (Join-Path $pf.M 'MiniRepo\a.md') 'a.md' 'SAME'
$invF = New-MiniInv $pf.C $pf.M @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedF = Import-MagMirrorInventory -InventoryPath $invF -ReposRootOverride $pf.C -MirrorRootOverride $pf.M
$tF = [string[]]('MiniRepo/a.md')
$pubF = Invoke-Pub -Loaded $loadedF -Tokens $tF -BaselinePath (Join-Path $pf.C 'base.json')
Assert-True ($pubF.PublicationStatus -eq 'IDENTICAL' -and $pubF.WrittenCount -eq 0) 'pub-F-identical-no-write'

# G unexplained divergence / no baseline
$pg = New-PubFx 'pg'
Write-Doc (Join-Path $pg.C 'MiniRepo\a.md') 'a.md' 'Lnew'
Write-Doc (Join-Path $pg.M 'MiniRepo\a.md') 'a.md' 'Mindep'
$invG = New-MiniInv $pg.C $pg.M @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedG = Import-MagMirrorInventory -InventoryPath $invG -ReposRootOverride $pg.C -MirrorRootOverride $pg.M
$hG0 = Get-MagMirrorSha256File (Join-Path $pg.M 'MiniRepo\a.md')
$tG = [string[]]('MiniRepo/a.md')
$pubG = Invoke-Pub -Loaded $loadedG -Tokens $tG -BaselinePath (Join-Path $pg.C 'base.json')
$hG1 = Get-MagMirrorSha256File (Join-Path $pg.M 'MiniRepo\a.md')
Assert-True ($pubG.PublicationStatus -eq 'BLOCKED' -and $pubG.WrittenCount -eq 0 -and $hG0 -eq $hG1) 'pub-G-conflict-no-overwrite'

# H missing Mirror target
$ph = New-PubFx 'ph'
Write-Doc (Join-Path $ph.C 'MiniRepo\a.md') 'a.md' 'ONLYL'
New-Item $ph.M -ItemType Directory -Force | Out-Null
$invH = New-MiniInv $ph.C $ph.M @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedH = Import-MagMirrorInventory -InventoryPath $invH -ReposRootOverride $ph.C -MirrorRootOverride $ph.M
$tH = [string[]]('MiniRepo/a.md')
$pubH = Invoke-Pub -Loaded $loadedH -Tokens $tH -BaselinePath (Join-Path $ph.C 'base.json')
Assert-True ($pubH.PublicationStatus -eq 'BLOCKED' -and $pubH.Results[0].reason -eq 'missing_mirror_target' -and -not (Test-Path (Join-Path $ph.M 'MiniRepo\a.md'))) 'pub-H-missing-target-blocked'

# I path escape
$pi = New-PubFx 'pi'
Write-Doc (Join-Path $pi.C 'MiniRepo\a.md') 'a.md' 'Z'
Write-Doc (Join-Path $pi.M 'MiniRepo\a.md') 'a.md' 'Z'
$invI = New-MiniInv $pi.C $pi.M @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedI = Import-MagMirrorInventory -InventoryPath $invI -ReposRootOverride $pi.C -MirrorRootOverride $pi.M
$hI0 = Get-MagMirrorSha256File (Join-Path $pi.M 'MiniRepo\a.md')
$tI = [string[]]('..\..\Windows\x.md')
$pubI = Invoke-Pub -Loaded $loadedI -Tokens $tI -BaselinePath (Join-Path $pi.C 'base.json')
$hI1 = Get-MagMirrorSha256File (Join-Path $pi.M 'MiniRepo\a.md')
Assert-True ($pubI.PublicationStatus -eq 'BLOCKED' -and $pubI.Results[0].outcome -eq 'PATH_ESCAPE' -and $hI0 -eq $hI1) 'pub-I-path-escape'

# J partial: one publish, one conflict
$pj = New-PubFx 'pj'
Write-Doc (Join-Path $pj.C 'MiniRepo\ok.md') 'ok.md' 'O0'
Write-Doc (Join-Path $pj.M 'MiniRepo\ok.md') 'ok.md' 'O0'
Write-Doc (Join-Path $pj.C 'MiniRepo\bad.md') 'bad.md' 'L'
Write-Doc (Join-Path $pj.M 'MiniRepo\bad.md') 'bad.md' 'M'
$invJ = New-MiniInv $pj.C $pj.M @(
    @{ repo = 'MiniRepo'; path = 'ok.md'; category = 'document'; require_metadata = $true },
    @{ repo = 'MiniRepo'; path = 'bad.md'; category = 'document'; require_metadata = $true }
)
$loadedJ = Import-MagMirrorInventory -InventoryPath $invJ -ReposRootOverride $pj.C -MirrorRootOverride $pj.M
$baseJ = Join-Path $pj.C 'base.json'
Merge-MagMirrorBaselinePair -BaselinePath $baseJ -Repo MiniRepo -RelPath 'ok.md' -Category document -Sha256 (Get-MagMirrorSha256File (Join-Path $pj.C 'MiniRepo\ok.md')) | Out-Null
Write-Doc (Join-Path $pj.C 'MiniRepo\ok.md') 'ok.md' 'O1'
$hBad0 = Get-MagMirrorSha256File (Join-Path $pj.M 'MiniRepo\bad.md')
$tJ = [string[]]@('MiniRepo/ok.md', 'MiniRepo/bad.md')
$pubJ = Invoke-Pub -Loaded $loadedJ -Tokens $tJ -BaselinePath $baseJ
$hBad1 = Get-MagMirrorSha256File (Join-Path $pj.M 'MiniRepo\bad.md')
Assert-True ($pubJ.PublicationStatus -eq 'PARTIAL' -and $pubJ.WrittenCount -eq 1 -and $hBad0 -eq $hBad1) 'pub-J-partial-batch'

# K drive claim always UNKNOWN
Assert-True ($pubB.google_drive_status -eq 'UNKNOWN' -and $pubB.drive_sync_claimed -eq $false) 'pub-K-drive-unknown'

# NEWER_DRIVE must not overwrite
$pkd = New-PubFx 'pkd'
Write-Doc (Join-Path $pkd.C 'MiniRepo\a.md') 'a.md' 'BASE'
Write-Doc (Join-Path $pkd.M 'MiniRepo\a.md') 'a.md' 'BASE'
$invKd = New-MiniInv $pkd.C $pkd.M @(@{ repo = 'MiniRepo'; path = 'a.md'; category = 'document'; require_metadata = $true })
$loadedKd = Import-MagMirrorInventory -InventoryPath $invKd -ReposRootOverride $pkd.C -MirrorRootOverride $pkd.M
$baseKd = Join-Path $pkd.C 'base.json'
Merge-MagMirrorBaselinePair -BaselinePath $baseKd -Repo MiniRepo -RelPath 'a.md' -Category document -Sha256 (Get-MagMirrorSha256File (Join-Path $pkd.C 'MiniRepo\a.md')) | Out-Null
Write-Doc (Join-Path $pkd.M 'MiniRepo\a.md') 'a.md' 'MIRRORNEWER'
$hKd0 = Get-MagMirrorSha256File (Join-Path $pkd.M 'MiniRepo\a.md')
$tKd = [string[]]('MiniRepo/a.md')
$pubKd = Invoke-Pub -Loaded $loadedKd -Tokens $tKd -BaselinePath $baseKd
$hKd1 = Get-MagMirrorSha256File (Join-Path $pkd.M 'MiniRepo\a.md')
Assert-True ($pubKd.PublicationStatus -eq 'BLOCKED' -and $hKd0 -eq $hKd1) 'pub-newer-drive-no-overwrite'

$hProdL1 = Get-MagMirrorSha256File $prodEco
$hProdM1 = Get-MagMirrorSha256File $prodMir
Assert-True ($hProdL0 -eq $hProdL1 -and $hProdM0 -eq $hProdM1) 'production-local-mirror-untouched-by-reconcile-tests'

Remove-Item $fx -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Passed=$script:Passed Failed=$script:Failed"
if ($script:Failed -gt 0) { exit 1 }
exit 0
