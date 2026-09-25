#Requires -Version 7.0
param(
    [switch]$Check,
    [switch]$BootstrapClean,
    [switch]$Reconcile,
    [string]$InventoryPath,
    [string]$MirrorRoot,
    [string]$ReposRoot,
    [string]$BaselinePath,
    [string]$ReceiptPath,
    [string]$AuthorizationSha256
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lib = Join-Path $PSScriptRoot 'lib\MagDocumentationMirror.Common.ps1'
. $lib

$modeCount = @($Check, $BootstrapClean, $Reconcile | Where-Object { $_ }).Count
if ($modeCount -eq 0) { $Check = $true }
if ($modeCount -gt 1) {
    [Console]::Error.WriteLine('usage: specify only one of -Check, -BootstrapClean, or -Reconcile')
    exit 5
}

$eco = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ([string]::IsNullOrWhiteSpace($InventoryPath)) {
    $InventoryPath = Join-Path $PSScriptRoot 'mirror-inventory.json'
}
if ([string]::IsNullOrWhiteSpace($BaselinePath)) {
    $BaselinePath = Join-Path $eco 'generated\docs-mirror\baseline.json'
}
if ([string]::IsNullOrWhiteSpace($ReceiptPath)) {
    $ReceiptPath = Join-Path $eco 'generated\docs-mirror\check-receipt.json'
}

try {
    $loaded = Import-MagMirrorInventory -InventoryPath $InventoryPath -ReposRootOverride $ReposRoot -MirrorRootOverride $MirrorRoot
    if ($Check) {
        $base = @{}
        try {
            $base = Import-MagMirrorBaseline -BaselinePath $BaselinePath
        }
        catch {
            $msg = [string]$_.Exception.Message
            $obj = [pscustomobject]@{
                operation = 'CHECK'
                error     = $msg
                pairs     = @()
                extras    = @()
            }
            Write-Output ($obj | ConvertTo-Json -Depth 8 -Compress)
            if ($msg -match '^malformed_baseline') { exit 3 }
            throw
        }
        $result = Invoke-MagMirrorCheck -Loaded $loaded -BaselineMap $base
        $receipt = New-MagMirrorCheckReceipt -Loaded $loaded -CheckResult $result -InventoryPath $InventoryPath -BaselinePath $BaselinePath
        $saved = Save-MagMirrorCheckReceipt -Receipt $receipt -ReceiptPath $ReceiptPath
        $out = [pscustomobject]@{
            operation            = 'CHECK'
            mirror_root          = $loaded.MirrorRoot
            pair_count           = $result.Pairs.Count
            extra_count          = $result.Extras.Count
            pairs                = $result.Pairs
            unmanaged_extras     = $result.Extras
            receipt_path         = $saved.Path
            receipt_sha256       = $saved.Sha256
            drive_sync_claimed   = $false
            knowledge_control    = $false
            baseline_modified    = $false
        }
        Write-Output ($out | ConvertTo-Json -Depth 8 -Compress)
        exit 0
    }

    if ($BootstrapClean) {
        $boot = Invoke-MagMirrorBootstrapClean -Loaded $loaded -BaselinePath $BaselinePath
        $out = [pscustomobject]@{
            operation          = 'BOOTSTRAP_CLEAN'
            mirror_root        = $loaded.MirrorRoot
            deleted_files      = $boot.DeletedCount
            populated_count    = $boot.Populated.Count
            failed_count       = $boot.Failed.Count
            populated          = $boot.Populated
            failed             = $boot.Failed
            baseline_path      = $BaselinePath
            drive_sync_claimed = $false
        }
        Write-Output ($out | ConvertTo-Json -Depth 10 -Compress)
        if ($boot.Failed.Count -gt 0) { exit 3 }
        exit 0
    }

    if ($Reconcile) {
        if ([string]::IsNullOrWhiteSpace($AuthorizationSha256)) {
            [Console]::Error.WriteLine('usage: -Reconcile requires -AuthorizationSha256 bound to the receipt file SHA-256')
            exit 5
        }
        $rec = Invoke-MagMirrorReconcile -ReceiptPath $ReceiptPath -AuthorizationSha256 $AuthorizationSha256 -InventoryPath $InventoryPath -BaselinePath $BaselinePath -ReposRootOverride $ReposRoot -MirrorRootOverride $MirrorRoot
        $out = [pscustomobject]@{
            operation          = 'RECONCILE'
            receipt_path       = (Get-MagMirrorFullPath $ReceiptPath)
            results            = $rec.Results
            written_count      = $rec.WrittenCount
            blocked_count      = $rec.BlockedCount
            stale_count        = $rec.StaleCount
            failed_count       = $rec.FailedCount
            drive_sync_claimed = $false
            knowledge_control  = $false
        }
        Write-Output ($out | ConvertTo-Json -Depth 10 -Compress)
        if ($rec.FailedCount -gt 0) { exit 3 }
        exit 0
    }
}
catch {
    $msg = [string]$_.Exception.Message
    [Console]::Error.WriteLine($msg)
    $code = 3
    if ($msg -match '^usage') { $code = 5 }
    if ($msg -match 'malformed_inventory|duplicate_|path_traversal|path_outside|unknown_repository|unresolved_repository|mirror_root_|authorization_|malformed_receipt|inventory_changed|baseline_changed') { $code = 5 }
    exit $code
}
