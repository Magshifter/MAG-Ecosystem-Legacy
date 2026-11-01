# MAG Ecosystem — Installation (Windows)

Target environment for this guide: **Windows + PowerShell 7 (`pwsh`) + Cursor**.

Clean-machine installation by an unrelated developer is **not verified**. Commands below match the scripts that exist in this repository today. Cursor rule check and Model Routing Guard take an explicit workspace root (**W4**, implemented). Documentation Mirror takes an explicitly selected inventory and explicit, validated roots with no Laragon default (**W5**, implemented and verified with isolated TEMP fixtures only).

## Prerequisites

| Requirement | Notes |
| --- | --- |
| Windows | Initial supported platform for evaluation |
| PowerShell 7 | Scripts use `#Requires -Version 7.0`. Confirm with `pwsh -NoProfile -Command '$PSVersionTable.PSVersion'` |
| Git | To clone or update the repository |
| Cursor | Needed only if you use the Cursor rule or Model Routing Guard |
| No extra PowerShell packages | Knowledge tooling has no NuGet/module dependencies |

Optional siblings (only if you intentionally enable those scopes):

- `Beyond3DViewer` next to this repo for Knowledge **GLOBAL+#5**
- Your own product checkouts, listed in your copy of `tools/docs/mirror-inventory.example.json`, if you use the Documentation Mirror

## Obtaining the repository

Clone or copy this repository to a directory you control, for example:

```text
git clone <repository-url> MAG-Ecosystem
cd MAG-Ecosystem
```

Use the URL of the private Magshifter repository you already have access to, or of a future public **MAG-Ecosystem-Legacy** copy once that copy exists. Do not treat a public Legacy URL as available until publication (**W8**) completes.

Expected working directory for the commands in this document: the **repository root** (the folder that contains `MAG_ECOSYSTEM.md` and `tools/`).

## Directory layout expectations

```text
MAG-Ecosystem/                 ← repository root (run commands here)
  AI_*.md, MAG_*.md            ← governance documentation
  templates/                   ← XenForo addon document templates
  tools/
    knowledge/                 ← Knowledge Index / Locator (standalone GLOBAL)
    cursor/                    ← Cursor rule source + drift check
    model-routing-guard/       ← optional Guard
    docs/                      ← optional Documentation Mirror tooling
  generated/                   ← derived outputs (gitignored); created by tools
```

Author environment often places this repo under `C:\laragon\repos\MAG-Ecosystem` beside sibling product repos and a `Mirror` transport folder. That layout is **author-local** and is not a default anywhere. Knowledge **GLOBAL** does not require siblings. Cursor Check and Guard use the workspace root you configure. Documentation Mirror uses the repos root, Mirror root, and inventory you select explicitly (see below).

## Environment and configuration

| Variable / setting | Status |
| --- | --- |
| `-ReposRoot` / `MAG_REPOS_ROOT` | Workspace root for the Cursor rule check and all Guard scripts/hooks. Explicit `-ReposRoot` wins; otherwise `MAG_REPOS_ROOT`; otherwise the script stops before any write (no current-directory fallback, no built-in default). Must be an absolute path to an existing directory; spaces allowed; a drive root is rejected by Guard. `C:\laragon\repos` works only when passed or configured explicitly. Guard scripts do not persist the variable; installed hooks carry `-ReposRoot` in their `hooks.json` command. |
| Cursor workspace folder | Cursor loads `.cursor/rules` and `hooks.json` from the **opened workspace root** (`<ReposRoot>`). Opening only `MAG-Ecosystem` will not load a rule deployed under its parent folder. |
| Mirror inventory / roots | `-InventoryPath` is required (no default inventory). Start from `tools/docs/mirror-inventory.example.json` (generic, no private repositories). `repos_root` / `mirror_root` come from `-ReposRoot` / `-MirrorRoot` when passed, otherwise from the inventory; if neither is set the tool stops before any write. Roots must be absolute; they are never inferred from the current directory; spaces are allowed. `tools/docs/mirror-inventory.json` is the author-specific Magshifter Laragon inventory and is used only when selected explicitly. |

## Setup — Knowledge GLOBAL (initial supported scope)

1. Confirm PowerShell 7.
2. From the repository root, generate the GLOBAL index:

```text
pwsh ./tools/knowledge/Generate-MagKnowledgeIndex.ps1 `
  -Manifest ./tools/knowledge/manifests/global.json
```

3. Validate:

```text
pwsh ./tools/knowledge/Validate-MagKnowledgeIndex.ps1 `
  -Index ./generated/knowledge/index-global.json `
  -Manifest ./tools/knowledge/manifests/global.json
```

Expected successful validation output: `VALID`.

4. Lookup (pointer only; does not regenerate; does not print document bodies):

```text
pwsh ./tools/knowledge/Locate-MagKnowledge.ps1 `
  -Index ./generated/knowledge/index-global.json `
  -Identity GLOBAL `
  -Intent GOVERN `
  -Query "Documentation authority model"
```

Optional refresh after documentation changes:

```text
pwsh ./tools/knowledge/Update-MagKnowledge.ps1 -DryRun
pwsh ./tools/knowledge/Update-MagKnowledge.ps1
```

Details, exit codes, and **GLOBAL+#5** (optional sibling) are in [tools/knowledge/README.md](../tools/knowledge/README.md).

## Setup — Cursor knowledge-control rule

Tracked source (authority for the projection text):

- `tools/cursor/mag-knowledge-control.mdc`

Deployed copy (loaded by Cursor when `<ReposRoot>` is the opened workspace folder):

- `<ReposRoot>\.cursor\rules\mag-knowledge-control.mdc`

Install (manual copy, source → deployed; no automatic deploy script):

```powershell
$root = 'D:\Work\My Repos'   # absolute path of your Cursor workspace folder
New-Item -ItemType Directory -Force -Path "$root\.cursor\rules" | Out-Null
Copy-Item -LiteralPath .\tools\cursor\mag-knowledge-control.mdc -Destination "$root\.cursor\rules\mag-knowledge-control.mdc"
```

Do **not** reverse-copy from the deployed file onto the tracked source.

Drift check (read-only):

```text
pwsh -NoProfile -File ./tools/cursor/Check-MagCursorKnowledgeControl.ps1 -ReposRoot "D:\Work\My Repos"
```

or set `MAG_REPOS_ROOT` and omit `-ReposRoot`.

- Exit `0` / `IDENTICAL` — source matches the deployed copy.
- Exit `1` / `DRIFT`; `2` / `MISSING_SOURCE`; `3` / `MISSING_DEPLOYED`; `4` / `INVALID_ROOT` (root not configured, relative, or missing).

The rule's Locator example uses the placeholder `<MAG-Ecosystem>` = absolute path of your local `MAG-Ecosystem` checkout (for example `<ReposRoot>\MAG-Ecosystem`). The Locator is not installed automatically; the relative commands in this document also work from the repository root.

## Setup — Model Routing Guard (optional)

Source of truth: `tools/model-routing-guard/`.

Deploy copies Guard files into `<ReposRoot>\.cursor\hooks\model-routing-guard\` and writes/merges `<ReposRoot>\.cursor\hooks.json`. The root is required (`-ReposRoot` or `MAG_REPOS_ROOT`); there is no default.

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Deploy-MagModelRoutingGuard.ps1 -ReposRoot "D:\Work\My Repos" -WhatIf
pwsh -NoProfile -File .\tools\model-routing-guard\Deploy-MagModelRoutingGuard.ps1 -ReposRoot "D:\Work\My Repos"
```

`-WhatIf` resolves the root, validates the existing `hooks.json`, and computes the merge without writing.

**Safety — this modifies existing Cursor configuration:**

- Overwrites Guard-owned files under `.cursor\hooks\model-routing-guard\` (`-Force` copy).
- Creates or updates `.cursor\hooks.json`. Guard-owned scope only: in `sessionStart` / `beforeSubmitPrompt` / `preCompact`, entries whose command contains `model-routing-guard` are replaced by exactly one Guard entry; other entries, other events, and other top-level settings are kept. JSON formatting/whitespace is rewritten.
- Guard commands are absolute: `pwsh -NoProfile -File "<ReposRoot>\.cursor\hooks\model-routing-guard\hooks\<hook>.ps1" -ReposRoot "<ReposRoot>"`, so hooks use the same root regardless of the CWD Cursor starts them in.
- Rejected before any copy or write: missing/relative/drive-root root, invalid JSON, non-object `hooks`, non-directory targets, and roots containing `"`, `%`, `$`, or a backtick. Back up `hooks.json` first if it matters to you.

Mode / maintenance (same root contract; `-ProductOwnerApproved` still required; state under `<ReposRoot>\.mag\`):

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMode.ps1 -ReposRoot "D:\Work\My Repos" -Mode Advisory -ProductOwnerApproved
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMaintenance.ps1 -ReposRoot "D:\Work\My Repos" -Action Suspend -ProductOwnerApproved
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMaintenance.ps1 -ReposRoot "D:\Work\My Repos" -Action Resume -ProductOwnerApproved
```

See `tools/model-routing-guard/README.md`.

Smoke / recovery tests (use temp roots; safe for verification):

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagModelRoutingGuard.ps1
pwsh -NoProfile -File .\tools\model-routing-guard\Test-GuardRecovery.ps1 -GuardRoot (Resolve-Path .\tools\model-routing-guard).Path
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagGuardPortability.ps1
```

## Setup - Documentation Mirror (optional)

Mirror tooling lives under `tools/docs/`. It is **optional** for the initial public release. It copies the files listed in an inventory between your canonical repository checkouts ("Local") and a separate transport folder ("Mirror", for example a folder synced by a cloud drive), comparing SHA-256 and recording a baseline. It never claims that a cloud drive actually synced.

### 1. Configure your layout and inventory

1. Copy the example inventory to a location you control (it is not modified by the tools):

   ```powershell
   Copy-Item .\tools\docs\mirror-inventory.example.json 'D:\Work\mirror\my-inventory.json'
   ```

2. Edit the copy:
   - `repositories`: one key per repository folder name directly under the repos root (value `""` = folder name equals key).
   - `entries`: the files to mirror (`repo`, `path` relative to that repository, `category` `document` or `tool`, `require_metadata`). The schema is unchanged from earlier versions.
   - `repos_root` / `mirror_root`: absolute paths, for example `D:\Work\Dev Projects` and `D:\Sync\Docs Mirror`. You may leave them `""` and pass `-ReposRoot` / `-MirrorRoot` on every call instead; CLI values win over the inventory.
3. Choose a Mirror root that is a **dedicated folder**. Its parent folder must already exist. The Mirror itself does not need to exist or be pre-populated.

Author layout: `tools/docs/mirror-inventory.json` (Magshifter repositories under `C:\laragon\repos`, Mirror `C:\laragon\repos\Mirror`) still works, but only when passed explicitly with `-InventoryPath .\tools\docs\mirror-inventory.json`.

Recommended: keep a separate `-BaselinePath` / `-ReceiptPath` per layout. The defaults are `generated/docs-mirror/baseline.json` and `generated/docs-mirror/check-receipt.json` inside this checkout and are shared by every inventory, so separate files keep the baselines and receipts of different layouts from mixing.

### 2. Initial safe CHECK

```powershell
pwsh -NoProfile -File .\tools\docs\Update-MagDocumentationMirror.ps1 -Check `
  -InventoryPath 'D:\Work\mirror\my-inventory.json' `
  -BaselinePath 'D:\Work\mirror\baseline.json' -ReceiptPath 'D:\Work\mirror\check-receipt.json'
```

`-Check` (also the mode when no mode switch is passed) validates the configuration and roots, then classifies every pair (`IDENTICAL`, `MISSING_TARGET`, `NEWER_LOCAL`, `CONFLICT`, ...). It does **not** write to Local, Mirror, or the baseline, but it **does write the check receipt** (`-ReceiptPath`), which binds a later `-Reconcile`. It is therefore not strictly read-only.

### 3. Which operations write

| Mode | Writes |
| --- | --- |
| `-Check` | Only the check receipt file. |
| `-BootstrapClean` | **Deletes every file and folder under MirrorRoot**, then copies each inventory source from Local into the Mirror (SHA-256 verified) and writes the baseline. It is never run implicitly. It refuses before deleting anything if the root is unsafe (see below) or the Mirror tree contains a reparse point (symlink/junction). **Data loss risk under MirrorRoot:** use only for a dedicated transport folder. |
| `-Reconcile` | Writes Mirror/Local pairs proposed by a bound CHECK receipt and updates the baseline; requires `-AuthorizationSha256 <receipt_sha256 from CHECK>`; fails closed if the inventory, baseline, roots, or files changed since that CHECK. |
| `-PublishAffected` | Writes only the listed affected Mirror targets that are newer locally (`-Affected repo/path`, ...) and updates the baseline; requires `-ProductOwnerApproved`. |

### 4. Verify sync

Run `-Check` again. A synchronized Mirror reports every pair as `IDENTICAL` (exit `0`). `drive_sync_claimed` is always `false`: confirming that a cloud drive uploaded the Mirror is outside this tool.

### 5. Rejected paths

All root and inventory checks run before any write, including the CHECK receipt. Rejections exit `5`, print the reason on stderr, and change nothing. A root is not accepted merely because you supplied it: it is validated against the resolved configuration.

| Reason (prefix) | Meaning / fix |
| --- | --- |
| `usage: -InventoryPath is required` | Pass `-InventoryPath` explicitly; there is no default inventory |
| `repos_root_missing` / `mirror_root_missing` | Root not set in the inventory and not passed on the CLI |
| `*_relative` | Root is not absolute (including drive-relative `C:folder`); the current directory is never used |
| `*_malformed:*` / `*_ambiguous:*` | Device path (`\\?\`), invalid characters, stray colon, `.`/`..` segment, 8.3 short name (`~1`), or leading/trailing whitespace or dot; write the plain absolute path |
| `repos_root_not_found` | Repos root does not exist |
| `mirror_root_is_filesystem_root` | Mirror cannot be a drive root such as `D:\` |
| `mirror_root_is_repos_root` / `mirror_root_contains_repos_root` | Mirror equals or is an ancestor of the repos root |
| `mirror_root_is_canonical_repo` / `mirror_root_inside_canonical_repo` / `mirror_root_contains_canonical_repo` | Mirror overlaps a repository listed in the inventory |
| `mirror_root_overlaps_ecosystem_checkout` | Mirror is inside, or contains, this MAG-Ecosystem checkout |
| `mirror_root_inside_git_worktree` | Mirror or one of its parents contains a `.git` entry |
| `mirror_root_reparse` | Mirror or one of its parents is a symlink/junction |
| `mirror_root_parent_missing` / `mirror_root_not_directory` | Create the parent folder first / the path is a file |
| `duplicate_mapping` / `duplicate_repository` / `path_traversal` / `path_outside_repos_root` / `malformed_inventory:*` | Fix the inventory; invalid or duplicate mappings fail closed |
| `reparse_point:*` / `reparse_destination:*` | A symlink/junction inside the Mirror or on a destination path; remove it |

A Mirror inside the repos root (for example `C:\laragon\repos\Mirror`) remains allowed as long as it does not overlap a listed repository.

## Verification commands

From the repository root:

```text
pwsh ./tools/knowledge/tests/MagKnowledge.Tests.ps1
pwsh ./tools/docs/tests/MagDocumentationMirror.Tests.ps1
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagModelRoutingGuard.ps1
pwsh -NoProfile -File .\tools\model-routing-guard\Test-GuardRecovery.ps1 -GuardRoot (Resolve-Path .\tools\model-routing-guard).Path
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagGuardPortability.ps1
pwsh -NoProfile -File .\tools\cursor\Test-MagCursorKnowledgeControl.ps1
```

Knowledge, Cursor, and Guard tests are designed to use isolated/temp roots where applicable. Mirror tests (`MagDocumentationMirror.Tests.ps1`, `MagDocumentationMirror.Portability.Tests.ps1`) build disposable fixtures with spaces in the system TEMP directory and remove them; they never write to a production Mirror or real repositories. The portability suite only **reads** the author inventory and `C:\laragon\repos` (if present) to confirm that the explicit Laragon layout still validates; it reports `NOT VERIFIED` when that layout is absent.

## Troubleshooting

| Symptom | Likely cause |
| --- | --- |
| `#Requires -Version 7.0` / script will not start | Windows PowerShell 5.x used instead of `pwsh` |
| Locator `STALE` / exit 3 / `missing_index` | Index missing or source SHA mismatch; regenerate/validate; Locator does not auto-repair |
| Locator `OUT_OF_SCOPE` for `GLOBAL+#5` / `A…` / `B…` | Wrong identity for the index, reserved identity, or missing optional sibling/index recipe |
| Cursor Check `INVALID_ROOT` / exit 4 | Neither `-ReposRoot` nor `MAG_REPOS_ROOT` set, or the path is relative/missing |
| Cursor Check `MISSING_DEPLOYED` | Rule not copied to `<ReposRoot>\.cursor\rules\`, or a different root was configured |
| Guard `repos_root_not_configured` / `repos_root_not_found` | Root not passed/set or wrong; nothing was written |
| Guard `hooks_json_invalid` | Existing `hooks.json` is not valid JSON; fix it manually, deploy wrote nothing |
| Guard deploy writes unexpected hooks | Existing `.cursor\hooks.json` was merged/updated; restore from backup if needed |
| Mirror `usage: -InventoryPath is required` | No inventory selected; copy `tools/docs/mirror-inventory.example.json` and pass it |
| Mirror `repos_root_*` / `mirror_root_*` / exit 5 | Root missing, relative, malformed, or unsafe; see "Rejected paths" above; nothing was written |
| Mirror bootstrap deleted files | `-BootstrapClean` removes files under MirrorRoot by design |

## Limitations and safety summary

- **IMPLEMENTED (W4):** explicit workspace root for Cursor check and Guard (verified with isolated TEMP fixtures).
- **IMPLEMENTED (W5):** portable Documentation Mirror: explicit inventory and validated roots, generic example inventory (verified with isolated TEMP fixtures only).
- **NOT VERIFIED:** clean Windows install by an unrelated developer.
- **Do not** make the original private repository public or rewrite its history; public release uses a separate sanitized copy (**W7/W8**).
- **Do not** assume MAG Development Center runs these tools.
