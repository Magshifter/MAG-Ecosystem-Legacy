# MAG Ecosystem — Installation (Windows)

Target environment for this guide: **Windows + PowerShell 7 (`pwsh`) + Cursor**.

Clean-machine installation by an unrelated developer is **not verified**. Commands below match the scripts that exist in this repository today. Cursor rule check and Model Routing Guard take an explicit workspace root (**W4**, implemented). Documentation Mirror still hardcodes Magshifter's Laragon layout (`C:\laragon\repos`); its portability fix (**W5**) is **not yet implemented**.

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
- Other Magshifter product checkouts listed in `tools/docs/mirror-inventory.json` for full Documentation Mirror coverage

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

Author environment often places this repo under `C:\laragon\repos\MAG-Ecosystem` beside sibling product repos and a `Mirror` transport folder. That layout is **author-local**. Knowledge **GLOBAL** does not require siblings. Cursor Check and Guard use the workspace root you configure (no Laragon default). Mirror approved-root checks still require the author layout until **W5**.

## Environment and configuration

| Variable / setting | Status |
| --- | --- |
| `-ReposRoot` / `MAG_REPOS_ROOT` | Workspace root for the Cursor rule check and all Guard scripts/hooks. Explicit `-ReposRoot` wins; otherwise `MAG_REPOS_ROOT`; otherwise the script stops before any write (no current-directory fallback, no built-in default). Must be an absolute path to an existing directory; spaces allowed; a drive root is rejected by Guard. `C:\laragon\repos` works only when passed or configured explicitly. Guard scripts do not persist the variable; installed hooks carry `-ReposRoot` in their `hooks.json` command. |
| Cursor workspace folder | Cursor loads `.cursor/rules` and `hooks.json` from the **opened workspace root** (`<ReposRoot>`). Opening only `MAG-Ecosystem` will not load a rule deployed under its parent folder. |
| Mirror inventory | `tools/docs/mirror-inventory.json` hardcodes `repos_root` / `mirror_root` under `C:\laragon\repos`. Overrides exist on the CLI, but the approved Mirror root in code is still fixed to `C:\laragon\repos\Mirror` until **W5**. |

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

## Setup — Documentation Mirror (optional; Magshifter-local today)

Mirror tooling lives under `tools/docs/`. It is **optional** for the initial public release.

Default inventory (`tools/docs/mirror-inventory.json`) lists Magshifter sibling repositories under `C:\laragon\repos` and Mirror root `C:\laragon\repos\Mirror`.

Read-only check (default mode when no switch is passed):

```text
pwsh ./tools/docs/Update-MagDocumentationMirror.ps1 -Check
```

Optional overrides: `-ReposRoot`, `-MirrorRoot`, `-InventoryPath`, `-BaselinePath`, `-ReceiptPath`. Even with overrides, production code still requires the approved Mirror root to equal `C:\laragon\repos\Mirror` unless you only exercise fixture/`SkipApprovedRootCheck` test paths. Treat non-Laragon Mirror use as **blocked until W5**.

**Destructive / write operations — do not run casually:**

| Mode | Effect |
| --- | --- |
| `-BootstrapClean` | Deletes existing files under the configured Mirror root (transport tree cleanup), then repopulates from inventory sources and writes a baseline. **Data loss risk under MirrorRoot.** |
| `-Reconcile` | Writes Mirror/Local pairs from a bound check receipt; requires `-AuthorizationSha256`. |
| `-PublishAffected` | Writes listed affected Mirror targets; requires `-ProductOwnerApproved`. |

Prefer `-Check` for inspection. Do not run `-BootstrapClean` against a Mirror tree that holds data you care about unless you intend that deletion.

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

Knowledge, Cursor, and Guard tests are designed to use isolated/temp roots where applicable. Mirror tests use a fixture tree under `tools/docs/tests/` and assert they leave production Local/Mirror content untouched; they still **read** some author Laragon paths for existence checks.

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
| Mirror `mirror_root_not_approved` | Non-Laragon Mirror root rejected by current approved-root hardcode (**W5** not done) |
| Mirror bootstrap deleted files | `-BootstrapClean` removes files under MirrorRoot by design |

## Limitations and safety summary

- **IMPLEMENTED (W4):** explicit workspace root for Cursor check and Guard (verified with isolated TEMP fixtures).
- **NOT YET IMPLEMENTED:** W5 portable Mirror approved-root/inventory.
- **NOT VERIFIED:** clean Windows install by an unrelated developer.
- **Do not** make the original private repository public or rewrite its history; public release uses a separate sanitized copy (**W7/W8**).
- **Do not** assume MAG Development Center runs these tools.
