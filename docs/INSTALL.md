# MAG-Ecosystem-Legacy — Installation (Windows)

Target environment for this guide: **Windows + PowerShell 7 (`pwsh`) + Git + Cursor**.

**Clean-machine installation is not verified.** Nobody has installed this repository on a separate Windows PC yet. The commands below match the scripts in this repository today. They were checked only on the author's machine, in isolated temporary fixtures:

- Cursor rule check and Model Routing Guard take an explicit workspace root (**W4**, implemented).
- Documentation Mirror takes an explicitly selected inventory and explicit, validated roots, with no Laragon default (**W5**, implemented and verified with isolated TEMP fixtures only).

Repository status: **MAG-Ecosystem-Legacy** is currently **PRIVATE**, and public publication is pending. See the [README](../README.md) for status, components, and known limitations.

## What you need

Components are grouped by what they require. Only group A is the minimum setup.

| Group | Component | Requires | Status |
| --- | --- | --- | --- |
| **A. Minimum setup** | Governance documentation, XenForo templates, Knowledge Index/Locator for the **GLOBAL** scope | Windows, PowerShell 7, Git (to clone), this checkout | Implemented; standalone |
| **B. Cursor integration** | Cursor knowledge-control rule and drift check | Group A + Cursor + a Cursor workspace folder (`-ReposRoot` / `MAG_REPOS_ROOT`) | Implemented; manual copy |
| **C. Model Routing Guard** | Cursor hooks for model-routing enforcement | Group B + willingness to let it modify `<ReposRoot>\.cursor\hooks.json` | Optional |
| **D. Documentation Mirror** | Local ↔ Mirror file transport | Group A + your own inventory + explicit repos and Mirror roots; a cloud drive client only if you want to sync the Mirror (not provided or verified by this tool) | Optional |
| **E. Historical / experimental** | Pipeline V2 documents, the author inventory `tools/docs/mirror-inventory.json`, the Knowledge **GLOBAL+#5** scope (`Beyond3DViewer`), the author Laragon layout | Not needed for any setup | Historical reference or optional |

The standalone **GLOBAL** setup does **not** require Laragon, private sibling repositories, the Documentation Mirror, the Model Routing Guard, or `Beyond3DViewer`.

## Prerequisites

| Requirement | Notes |
| --- | --- |
| Windows | Initial supported platform for evaluation |
| PowerShell 7 | Every script uses `#Requires -Version 7.0`. Check with `pwsh -NoProfile -Command '$PSVersionTable.PSVersion'`. Windows PowerShell 5.x (`powershell.exe`) does not work |
| Git | Needed to clone and update the repository. Keep `git` on `PATH`: when a `.git` folder is present, Knowledge generation also reads the Git blob id of each source file |
| Cursor | Needed only for the Cursor rule (group B) and the Model Routing Guard (group C) |
| No extra PowerShell packages | The tooling has no NuGet or module dependencies. Nothing is downloaded or installed by the scripts |

Optional sibling checkouts (only if you deliberately enable those scopes):

- `Beyond3DViewer` next to this repository for Knowledge **GLOBAL+#5**
- Your own product checkouts, listed in your copy of `tools/docs/mirror-inventory.example.json`, if you use the Documentation Mirror

## Obtaining the repository

Repository: `https://github.com/Magshifter/MAG-Ecosystem-Legacy.git`

While the repository is **PRIVATE**, cloning works only for a GitHub account that has been given access. Sign in with a credential helper instead of putting credentials in the URL, for example:

- **Git Credential Manager** (included with Git for Windows) opens a browser sign-in the first time you clone, or
- **GitHub CLI:** run `gh auth login` once, then clone with `git` or `gh repo clone Magshifter/MAG-Ecosystem-Legacy`.

Never put a password or token in the clone URL or in scripts. After publication, the same URL will work without signing in.

Example (PowerShell 7, in a parent folder you control):

```powershell
cd 'D:\Work\My Repos'
git clone https://github.com/Magshifter/MAG-Ecosystem-Legacy.git
cd MAG-Ecosystem-Legacy
```

Run every command in this document from the **repository root** (the folder that contains `MAG_ECOSYSTEM.md` and `tools/`). The folder name does not matter to the tools: they find their own checkout from the script location, and paths with spaces work.

## Directory layout expectations

```text
MAG-Ecosystem-Legacy/           ← repository root (run commands here)
  AI_*.md, MAG_*.md             ← governance documentation
  templates/                    ← XenForo addon document templates
  tools/
    knowledge/                  ← Knowledge Index / Locator (standalone GLOBAL)
    cursor/                     ← Cursor rule source + drift check
    model-routing-guard/        ← optional Guard
    docs/                       ← optional Documentation Mirror tooling
  generated/                    ← derived outputs (gitignored); created by tools
```

**Historical names and paths.** The governance documents and tool READMEs use the historical repository name **MAG-Ecosystem** and the placeholder `<MAG-Ecosystem>`. Both mean your local checkout of this repository, whatever its folder name. The author kept this repository at `C:\laragon\repos\MAG-Ecosystem`, beside sibling product repositories and a `Mirror` transport folder. That layout is **author-local** and is not a default anywhere:

- Knowledge **GLOBAL** does not require sibling repositories.
- Cursor Check and Guard use the workspace root you configure.
- Documentation Mirror uses the repos root, Mirror root, and inventory that you select explicitly (see below).

## Environment and configuration

| Variable / setting | Status |
| --- | --- |
| `-ReposRoot` / `MAG_REPOS_ROOT` | Workspace root for the Cursor rule check and all Guard scripts and hooks. See the rules below this table. |
| Cursor workspace folder | Cursor loads `.cursor/rules` and `hooks.json` from the **opened workspace root** (`<ReposRoot>`). If you open only the repository folder, Cursor does not load a rule deployed under its parent folder. |
| Mirror inventory / roots | No default inventory. See the rules below this table. |

How `-ReposRoot` / `MAG_REPOS_ROOT` is resolved:

- An explicit `-ReposRoot` wins. Otherwise the script uses `MAG_REPOS_ROOT`. If neither is set, the script stops before any write. There is no current-directory fallback and no built-in default.
- The path must be absolute and must point to an existing directory. Spaces are allowed. Guard rejects a drive root.
- `C:\laragon\repos` works only when you pass it or configure it explicitly.
- Guard scripts do not save the variable. Installed hooks carry `-ReposRoot` in their `hooks.json` command.

How the Mirror inventory and roots are resolved:

- `-InventoryPath` is required. Start from `tools/docs/mirror-inventory.example.json`, which is generic and lists no private repositories.
- `repos_root` and `mirror_root` come from `-ReposRoot` / `-MirrorRoot` when you pass them, and from the inventory otherwise. If neither is set, the tool stops before any write.
- Roots must be absolute. They are never inferred from the current directory. Spaces are allowed.
- `tools/docs/mirror-inventory.json` is the author-specific Magshifter Laragon inventory. It is used only when you select it explicitly.

## Minimum setup — Knowledge GLOBAL (standalone)

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

4. Look up a document (pointer only: it does not regenerate the index and does not print document bodies):

```text
pwsh ./tools/knowledge/Locate-MagKnowledge.ps1 `
  -Index ./generated/knowledge/index-global.json `
  -Identity GLOBAL `
  -Intent GOVERN `
  -Query "Documentation authority model"
```

**Refresh after documentation changes (standalone):** run steps 2 and 3 again.

Or let `Update-MagKnowledge.ps1` refresh it. By default it selects **only** the shipped standalone GLOBAL manifest (`tools/knowledge/manifests/global.json`), so it works without `Beyond3DViewer` or any other sibling checkout and never touches GLOBAL+#5:

```text
pwsh ./tools/knowledge/Update-MagKnowledge.ps1 -DryRun
pwsh ./tools/knowledge/Update-MagKnowledge.ps1
```

Optional scopes are refreshed only on explicit request. `-ManifestDirectory` selects every manifest in that folder; the shipped folder adds **GLOBAL+#5**:

```text
pwsh ./tools/knowledge/Update-MagKnowledge.ps1 -ManifestDirectory ./tools/knowledge/manifests
```

GLOBAL+#5 needs its own sources (the `Beyond3DViewer` sibling with the listed `docs/P05__3DR__*.md` files). When an explicitly selected manifest is missing its sources, the refresh reports `FAILED` and exits `3` (for example `missing_development_root` or `missing_source`), and existing indexes are not replaced. Nothing is discovered automatically from sibling folders.

Details, exit codes, and **GLOBAL+#5** (optional sibling) are in [tools/knowledge/README.md](../tools/knowledge/README.md).

## Setup — Cursor knowledge-control rule

Tracked source (authority for the projection text):

- `tools/cursor/mag-knowledge-control.mdc`

Deployed copy (loaded by Cursor when `<ReposRoot>` is the opened workspace folder):

- `<ReposRoot>\.cursor\rules\mag-knowledge-control.mdc`

Install it by copying manually, from source → deployed. There is no automatic deploy script:

```powershell
$root = 'D:\Work\My Repos'   # absolute path of your Cursor workspace folder
New-Item -ItemType Directory -Force -Path "$root\.cursor\rules" | Out-Null
Copy-Item -LiteralPath .\tools\cursor\mag-knowledge-control.mdc -Destination "$root\.cursor\rules\mag-knowledge-control.mdc"
```

Do **not** copy in reverse, from the deployed file onto the tracked source.

Drift check (read-only):

```text
pwsh -NoProfile -File ./tools/cursor/Check-MagCursorKnowledgeControl.ps1 -ReposRoot "D:\Work\My Repos"
```

You can also set `MAG_REPOS_ROOT` and omit `-ReposRoot`.

- Exit `0` / `IDENTICAL` — source matches the deployed copy.
- Exit `1` / `DRIFT`; `2` / `MISSING_SOURCE`; `3` / `MISSING_DEPLOYED`; `4` / `INVALID_ROOT` (root not configured, relative, or missing).

The rule's Locator example uses the placeholder `<MAG-Ecosystem>`. It means the absolute path of your local checkout of this repository, for example `<ReposRoot>\MAG-Ecosystem-Legacy`. The Locator is not installed automatically. The relative commands in this document also work from the repository root.

More: [tools/cursor/README.md](../tools/cursor/README.md).

## Setup — Model Routing Guard (optional)

Source of truth: `tools/model-routing-guard/`. Guide: [tools/model-routing-guard/README.md](../tools/model-routing-guard/README.md).

Deploy copies the Guard files into `<ReposRoot>\.cursor\hooks\model-routing-guard\` and writes or merges `<ReposRoot>\.cursor\hooks.json`. The root is required (`-ReposRoot` or `MAG_REPOS_ROOT`). There is no default. Always run `-WhatIf` first:

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Deploy-MagModelRoutingGuard.ps1 -ReposRoot "D:\Work\My Repos" -WhatIf
pwsh -NoProfile -File .\tools\model-routing-guard\Deploy-MagModelRoutingGuard.ps1 -ReposRoot "D:\Work\My Repos"
```

`-WhatIf` resolves the root, validates the existing `hooks.json`, and computes the merge without writing anything.

**Safety: Deploy modifies your existing Cursor configuration.**

- It overwrites Guard-owned files under `.cursor\hooks\model-routing-guard\` (copy with `-Force`).
- It creates or updates `.cursor\hooks.json`, but only Guard-owned entries. In `sessionStart`, `beforeSubmitPrompt`, and `preCompact`, entries whose command contains `model-routing-guard` are replaced by exactly one Guard entry. Other entries, other events, and other top-level settings are kept. JSON formatting and whitespace are rewritten.
- Guard commands are absolute: `pwsh -NoProfile -File "<ReposRoot>\.cursor\hooks\model-routing-guard\hooks\<hook>.ps1" -ReposRoot "<ReposRoot>"`. Hooks therefore use the same root whatever working directory Cursor starts them in.
- Deploy rejects the following before any copy or write: a missing, relative, or drive-root root; invalid JSON; a non-object `hooks`; non-directory targets; and roots containing `"`, `%`, `$`, or a backtick.
- If your `hooks.json` matters to you, back it up first.

Mode and maintenance use the same root contract. `-ProductOwnerApproved` is still required, and state is stored under `<ReposRoot>\.mag\`:

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMode.ps1 -ReposRoot "D:\Work\My Repos" -Mode Advisory -ProductOwnerApproved
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMaintenance.ps1 -ReposRoot "D:\Work\My Repos" -Action Suspend -ProductOwnerApproved
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMaintenance.ps1 -ReposRoot "D:\Work\My Repos" -Action Resume -ProductOwnerApproved
```

Smoke and recovery tests (they use temporary roots, so they are safe for verification):

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagModelRoutingGuard.ps1
pwsh -NoProfile -File .\tools\model-routing-guard\Test-GuardRecovery.ps1 -GuardRoot (Resolve-Path .\tools\model-routing-guard).Path
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagGuardPortability.ps1
```

## Setup — Documentation Mirror (optional)

Mirror tooling lives under `tools/docs/` and is **optional**. It copies the files listed in an inventory between your canonical repository checkouts ("Local") and a separate transport folder ("Mirror"), for example a folder synced by a cloud drive client. It compares SHA-256 hashes and records a baseline. It never claims that a cloud drive actually synced.

### 1. Configure your layout and inventory

1. Copy the example inventory to a location you control. The tools do not modify the example file:

   ```powershell
   Copy-Item .\tools\docs\mirror-inventory.example.json 'D:\Work\mirror\my-inventory.json'
   ```

2. Edit the copy:
   - `repositories`: one key per repository folder name directly under the repos root. A value of `""` means the folder name equals the key.
   - `entries`: the files to mirror (`repo`, `path` relative to that repository, `category` `document` or `tool`, `require_metadata`). The schema is unchanged from earlier versions.
   - `repos_root` / `mirror_root`: absolute paths, for example `D:\Work\Dev Projects` and `D:\Sync\Docs Mirror`. You can leave them `""` and pass `-ReposRoot` / `-MirrorRoot` on every call instead. CLI values win over the inventory.
3. Choose a **dedicated folder** as the Mirror root. Its parent folder must already exist. The Mirror itself does not need to exist or be pre-populated.

Author layout: `tools/docs/mirror-inventory.json` (Magshifter repositories under `C:\laragon\repos`, Mirror `C:\laragon\repos\Mirror`) still works, but only when passed explicitly with `-InventoryPath .\tools\docs\mirror-inventory.json`. It is a historical reference for independent users.

Recommended: keep a separate `-BaselinePath` / `-ReceiptPath` for each layout. The defaults are `generated/docs-mirror/baseline.json` and `generated/docs-mirror/check-receipt.json` inside this checkout, and every inventory shares them. Separate files keep the baselines and receipts of different layouts from mixing.

### 2. Initial safe CHECK

```powershell
pwsh -NoProfile -File .\tools\docs\Update-MagDocumentationMirror.ps1 -Check `
  -InventoryPath 'D:\Work\mirror\my-inventory.json' `
  -BaselinePath 'D:\Work\mirror\baseline.json' -ReceiptPath 'D:\Work\mirror\check-receipt.json'
```

`-Check` is also the mode when no mode switch is passed. It validates the configuration and roots, then classifies every pair (`IDENTICAL`, `MISSING_TARGET`, `NEWER_LOCAL`, `CONFLICT`, ...). It does **not** write to Local, Mirror, or the baseline. It **does write the check receipt** (`-ReceiptPath`), which binds a later `-Reconcile`, so it is not strictly read-only.

A completed CHECK exits `0` whatever the classifications are. For example, a new layout reports `MISSING_TARGET` and still exits `0`. Read the per-pair classifications rather than relying on the exit code.

### 3. Which operations write

| Mode | Writes |
| --- | --- |
| `-Check` | Only the check receipt file. |
| `-BootstrapClean` | **Deletes every file and folder under MirrorRoot**, then copies each inventory source from Local into the Mirror (SHA-256 verified) and writes the baseline. It never runs implicitly. Before deleting anything, it refuses if the root is unsafe (see below) or the Mirror tree contains a reparse point (symlink or junction). **Data loss risk under MirrorRoot:** use it only on a dedicated transport folder. |
| `-Reconcile` | Writes the Mirror/Local pairs proposed by a bound CHECK receipt and updates the baseline. Requires `-AuthorizationSha256 <receipt_sha256 from CHECK>`. Fails closed if the inventory, baseline, roots, or files changed since that CHECK. |
| `-PublishAffected` | Writes only the listed affected Mirror targets that are newer locally (`-Affected repo/path`, ...) and updates the baseline. Requires `-ProductOwnerApproved`. |

### 4. Verify sync

Run `-Check` again. A synchronized Mirror reports every pair as `IDENTICAL`. `drive_sync_claimed` is always `false`: confirming that a cloud drive uploaded the Mirror is outside this tool.

### 5. Rejected paths

All root and inventory checks run before any write, including the CHECK receipt. A rejection exits `5`, prints the reason on stderr, and changes nothing. Supplying a root does not make it accepted: it is validated against the resolved configuration.

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
| `mirror_root_overlaps_ecosystem_checkout` | Mirror is inside, or contains, this repository's checkout |
| `mirror_root_inside_git_worktree` | Mirror or one of its parents contains a `.git` entry |
| `mirror_root_reparse` | Mirror or one of its parents is a symlink/junction |
| `mirror_root_parent_missing` / `mirror_root_not_directory` | Create the parent folder first / the path is a file |
| `duplicate_mapping` / `duplicate_repository` / `path_traversal` / `path_outside_repos_root` / `malformed_inventory:*` | Fix the inventory; invalid or duplicate mappings fail closed |
| `reparse_point:*` / `reparse_destination:*` | A symlink/junction inside the Mirror or on a destination path; remove it |

A Mirror inside the repos root (for example `C:\laragon\repos\Mirror`) is still allowed as long as it does not overlap a listed repository.

## Verification commands

From the repository root:

```text
pwsh ./tools/knowledge/tests/MagKnowledge.Tests.ps1
pwsh ./tools/docs/tests/MagDocumentationMirror.Tests.ps1
pwsh ./tools/docs/tests/MagDocumentationMirror.Portability.Tests.ps1
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagModelRoutingGuard.ps1
pwsh -NoProfile -File .\tools\model-routing-guard\Test-GuardRecovery.ps1 -GuardRoot (Resolve-Path .\tools\model-routing-guard).Path
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagGuardPortability.ps1
pwsh -NoProfile -File .\tools\cursor\Test-MagCursorKnowledgeControl.ps1
```

What each suite needs and touches:

| Suite | Standalone? | Notes |
| --- | --- | --- |
| `MagKnowledge.Tests.ps1` | Yes | Needs no `Beyond3DViewer` or other sibling. GLOBAL+#5 cases use a synthetic fixture (copies of the GLOBAL sources plus synthetic `P05__3DR__*.md` documents) under `.mag-kn-test/` in the repository root, and also check the default GLOBAL-only refresh and fail-closed missing-source cases. It regenerates the real `generated/knowledge/index-global.json` and writes fixture indexes (`index-fx*`, `index-orch*`, removed at the end); it never writes the real `index-global-5.json`. If `.mag-kn-test/` already exists (for example after an aborted run), the suite stops with `FAIL fixture-root-preexisting` without deleting it; inspect and remove it manually. |
| `MagDocumentationMirror.Tests.ps1` | Yes | Builds disposable fixtures (with spaces) in the system TEMP folder, including an outside-root Local/Mirror sentinel pair whose hashes prove nothing is written outside the fixture roots. It does not read or write any author path, real repository, or production Mirror. |
| `MagDocumentationMirror.Portability.Tests.ps1` | Yes | TEMP fixtures only. It only **reads** the author inventory and `C:\laragon\repos` (if present) to confirm that the explicit Laragon layout still validates, and it reports `NOT VERIFIED` when that layout is absent. |
| Guard `Test-MagModelRoutingGuard.ps1`, `Test-GuardRecovery.ps1`, `Test-MagGuardPortability.ps1` | Yes | Temporary roots only. |
| `Test-MagCursorKnowledgeControl.ps1` | Yes | Temporary roots only. |

## Troubleshooting

| Symptom | Likely cause |
| --- | --- |
| `#Requires -Version 7.0` / script will not start | Windows PowerShell 5.x used instead of `pwsh` |
| `git clone` asks for a password or returns `Repository not found` | The repository is private: sign in through Git Credential Manager or `gh auth login` with an account that has access. Do not paste a token into the URL |
| Locator `STALE` / exit 3 / `missing_index` | Index missing or source SHA mismatch; regenerate and validate. The Locator does not auto-repair |
| Locator `OUT_OF_SCOPE` for `GLOBAL+#5` / `A…` / `B…` | Wrong identity for the index, a reserved identity, or a missing optional sibling/index recipe |
| `Update-MagKnowledge.ps1` reports `FAILED`, exit 3 | An explicitly selected manifest (`-ManifestDirectory`) is missing its sources, for example no `Beyond3DViewer` sibling for GLOBAL+#5; the default run refreshes GLOBAL only |
| `MagKnowledge.Tests.ps1` reports `FAIL fixture-root-preexisting` | A `.mag-kn-test/` folder is left from an earlier run; inspect and remove it manually |
| Cursor Check `INVALID_ROOT` / exit 4 | Neither `-ReposRoot` nor `MAG_REPOS_ROOT` set, or the path is relative or missing |
| Cursor Check `MISSING_DEPLOYED` | Rule not copied to `<ReposRoot>\.cursor\rules\`, or a different root was configured |
| Guard `repos_root_not_configured` / `repos_root_not_found` | Root not passed or set, or wrong; nothing was written |
| Guard `hooks_json_invalid` | Existing `hooks.json` is not valid JSON; fix it manually. Deploy wrote nothing |
| Guard deploy writes unexpected hooks | Existing `.cursor\hooks.json` was merged or updated; restore from backup if needed |
| Mirror `usage: -InventoryPath is required` | No inventory selected; copy `tools/docs/mirror-inventory.example.json` and pass it |
| Mirror `repos_root_*` / `mirror_root_*` / exit 5 | Root missing, relative, malformed, or unsafe; see "Rejected paths" above. Nothing was written |
| Mirror bootstrap deleted files | `-BootstrapClean` removes files under MirrorRoot by design |

## Limitations and safety summary

- **IMPLEMENTED (W4):** explicit workspace root for Cursor check and Guard (verified with isolated TEMP fixtures).
- **IMPLEMENTED (W5):** portable Documentation Mirror: explicit inventory and validated roots, generic example inventory (verified with isolated TEMP fixtures only).
- **NOT VERIFIED:** clean Windows installation by an unrelated developer.
- **IMPLEMENTED (W8):** standalone Knowledge refresh (default GLOBAL only; GLOBAL+#5 on explicit request) and standalone Knowledge and Mirror test suites (synthetic and TEMP fixtures; no sibling repositories or author paths). Verified in this checkout and in a disposable copy without sibling repositories, on the author's PC only. The test fixtures are not a real deployment.
- **Repository status:** PRIVATE, publication pending. Do not change visibility or rewrite history outside a separately authorized step. An obsolete pre-sanitization commit is still reachable on GitHub by direct SHA, which blocks publication (see the [README](../README.md#known-limitations)).
- **Do not** assume MAG Development Center runs these tools. It is a separate successor project, not a runtime replacement.
