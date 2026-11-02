# MAG-Ecosystem-Legacy — User Manual

Document version: 0.1.1.

This manual explains how to obtain and use MAG-Ecosystem-Legacy. It describes the tools that exist in this repository. It does not add capabilities, and it does not replace the historical governance documents. If this manual disagrees with a script or with [docs/INSTALL.md](../INSTALL.md), the script and the installation guide are the usage evidence to follow, and this manual should be corrected.

Version 0.1.1 is the documentation target selected for this pack. It is not a GitHub release, not a public publication, and not a MAG Development Center product registration.

<!-- mag-item-id: ec2b507e-26c3-4045-9f0c-4592c2a943aa -->
## 1. What MAG-Ecosystem-Legacy is

MAG-Ecosystem-Legacy preserves the historical development of MAG Ecosystem, a multi-class software development framework for AI-assisted work. That history covers global governance, documentation operations, knowledge routing, and Cursor tooling.

The repository keeps that development history in sanitized form. The practical tools that remain usable are:

- governance documents at the repository root
- XenForo document templates under `templates/xenforo-addon/`
- the Knowledge Index and Locator under `tools/knowledge/`
- the Cursor knowledge-control rule under `tools/cursor/`
- the optional Model Routing Guard under `tools/model-routing-guard/`
- the optional Documentation Mirror under `tools/docs/`

Generated indexes and Mirror baselines under `generated/` are derived. They are gitignored and are not authority.

<!-- mag-item-id: 2a6292a0-0420-44af-8651-6b66dba92c5e -->
## 2. Status and maintenance

Development of MAG Ecosystem is closed in this repository. The repository is maintained as a historical record and as a usable snapshot of its tools. It is not an active development line.

Current repository facts:

- Visibility is **PRIVATE**.
- Public publication is **pending**. It is not approved, and this manual does not make the repository publication-ready.
- The documentation target is 0.1.1. Creating these manuals does not create a Git tag or a GitHub release.
- Clean-machine installation on another Windows PC is **NOT VERIFIED**. Commands in this manual match the scripts in this checkout. They were checked on the author's machine, including isolated temporary fixtures. Those fixtures are not a successful installation on a separate PC.

Do not change repository visibility or rewrite history except in a separately authorized step.

<!-- mag-item-id: bae859b9-bbc2-4f05-a59a-7adc84becb9f -->
## 3. Relationship to MAG Development Center

[MAG Development Center](https://magshifter.com/resources/magdc-evidence-driven-control-plane.14/) (MAGDC) is a separate successor project: a governance and evidence control plane. MAGDC is not a compatible runtime replacement for MAG-Ecosystem-Legacy.

MAGDC does not execute these legacy tools. No migration, shared runtime, or compatibility bridge is claimed. Do not assume that a MAGDC command runs Knowledge, the Cursor rule, the Model Routing Guard, or the Documentation Mirror.

The identifier `mag-ecosystem-legacy` in `source.json` names this documentation pack only. It does not register a MAGDC product, a catalog `product_id`, or a talk handle. This repository has no `.magdc/product.yaml`.

Historical governance documents in this repository remain the description of Legacy behavior. MAGDC documentation defines the format of this manual, not the runtime of these tools.

<!-- mag-item-id: 4772fb04-337d-43d8-a4ef-1a8469724a61 -->
## 4. Components

Only the minimum setup is required to use Knowledge **GLOBAL**. Everything else is optional or historical.

<!-- mag-item-id: 435ec50d-33fb-4916-bcf6-5fd68863b766 -->
### 4.1 Minimum setup

| Component | Location | What it does |
| --- | --- | --- |
| Governance documentation | Root `AI_*.md` and `MAG_*.md` | Historical process and agent rules. Markdown only. Nothing to install. |
| XenForo document templates | `templates/xenforo-addon/` | Starter package `P0N__XXX__*.md` for XenForo `#N` add-on products. Markdown only. Nothing to install. |
| Knowledge Index and Locator, **GLOBAL** | `tools/knowledge/` | Builds, validates, and queries a deterministic index of the Global documents. Needs this checkout and PowerShell 7. |

<!-- mag-item-id: 2e237229-0442-4127-bb9f-65029a8a2765 -->
### 4.2 Optional integrations

| Component | Location | What it does |
| --- | --- | --- |
| Cursor knowledge-control rule | `tools/cursor/` | A rule file you copy into a Cursor workspace, plus a read-only drift check. |
| Model Routing Guard | `tools/model-routing-guard/` | Cursor hooks for model-routing enforcement. Deploy **modifies** `<ReposRoot>\.cursor\hooks.json`. |
| Documentation Mirror | `tools/docs/` | Copies listed files between repository checkouts and a separate transport folder. `-BootstrapClean` **deletes** everything under the Mirror root before it copies sources back. |
| Knowledge **GLOBAL+#5** | `tools/knowledge/manifests/global-5.json` | Optional index scope. A real index needs a `Beyond3DViewer` checkout next to this repository. |

<!-- mag-item-id: be6bb7c9-398f-49a0-9a25-441fbcaebea1 -->
### 4.3 Historical and experimental material

- `MAG_PIPELINE_V2_EVALUATION.md` and `MAG_PIPELINE_V2_EXPERIMENT.md` record a closed experiment. They are not Global authority and are not required for setup.
- Governance documents record the author's environment, including `C:\laragon\repos\...` paths and numbered products. Those paths are historical records, not installation defaults.
- `tools/docs/mirror-inventory.json` is the author's Documentation Mirror inventory. It is used only when you pass it explicitly. Start independent use from `tools/docs/mirror-inventory.example.json`.

<!-- mag-item-id: 2d7bc900-4410-44cb-9975-4dd38d3b3664 -->
## 5. Environment and prerequisites

Initial supported environment:

- Windows
- PowerShell 7 (`pwsh`). Every tool script uses `#Requires -Version 7.0`. Windows PowerShell 5.x (`powershell.exe`) does not run them.
- Git, on `PATH`. Knowledge generation reads the Git blob id of a source when a `.git` directory is present.
- Cursor, only for the knowledge-control rule and the Model Routing Guard.

The scripts do not install NuGet packages or PowerShell modules, and they do not download dependencies.

Check PowerShell 7:

```text
pwsh -NoProfile -Command '$PSVersionTable.PSVersion'
```

Run commands from the repository root, the folder that contains `MAG_ECOSYSTEM.md` and `tools/`. The folder name does not matter. The tools locate their checkout from the script path. Paths with spaces are accepted.

These names in older documents mean your checkout of this repository, whatever the folder is called:

- `MAG-Ecosystem`
- `<MAG-Ecosystem>`

The author's checkout lived at `C:\laragon\repos\MAG-Ecosystem`. That layout is not a default.

`C:\laragon\repos` is used by Cursor Check, Guard, or Mirror only when you pass or configure it explicitly.

<!-- mag-item-id: 9861ea81-85e0-4eb4-85a3-1b167e97fc65 -->
## 6. Obtain and install

Repository URL:

```text
https://github.com/Magshifter/MAG-Ecosystem-Legacy.git
```

While the repository is **PRIVATE**, clone it only with a GitHub account that has access. Sign in through a credential helper. Do not put a password or token in the clone URL or in a script.

Examples of sign-in:

- Git Credential Manager, included with Git for Windows, can open a browser sign-in on the first clone.
- GitHub CLI: run `gh auth login` once, then clone with `git` or `gh repo clone Magshifter/MAG-Ecosystem-Legacy`.

After publication, the same URL would work without signing in. Publication is not approved.

Example, from a parent folder you control:

```text
cd "D:\Work\My Repos"
git clone https://github.com/Magshifter/MAG-Ecosystem-Legacy.git
cd MAG-Ecosystem-Legacy
```

Expected layout:

```text
MAG-Ecosystem-Legacy/
  AI_*.md, MAG_*.md
  templates/
  tools/knowledge/
  tools/cursor/
  tools/model-routing-guard/
  tools/docs/
  generated/
```

`generated/` is created by the tools. Do not commit it.

The minimum setup is section 7. Cursor, Guard, Mirror, and GLOBAL+#5 are not required for Knowledge **GLOBAL**.

<!-- mag-item-id: 0bc6695d-4bc2-489d-b180-9f6ece0e7322 -->
## 7. Knowledge GLOBAL

Knowledge **GLOBAL** is the standalone scope. It indexes the Global documents listed by basename in `tools/knowledge/manifests/global.json` and writes `generated/knowledge/index-global.json`.

The index is derived, optional, and non-authoritative. The Locator returns a pointer. It does not print document bodies, and it does not decide that a document applies. A previous generated file is not last-good knowledge. When the index is missing or stale, generated discovery fails closed, and same-scope reading of the canonical documents remains the fallback.

Assignable working identities and generated index recipes are different. The Locator accepts `GLOBAL`, `GLOBAL+#N`, and `GLOBAL+A<N>`. `B<N>` and `GLOBAL+B<N>` are reserved and are rejected. `GLOBAL+#5` is not `GLOBAL+A5`. A valid `GLOBAL+A<N>` identity does not imply an A index file. Do not invent `index-global-a1.json` or any A/B filename.

Supported intents are `GOVERN`, `PLAN`, `IMPLEMENT`, `DEBUG`, `VERIFY`, and `LEARN`.

<!-- mag-item-id: 77a6c823-3afb-4f8d-b009-5001788e3fb8 -->
### 7.1 Generate and validate

From the repository root:

```text
pwsh ./tools/knowledge/Generate-MagKnowledgeIndex.ps1 `
  -Manifest ./tools/knowledge/manifests/global.json
```

`-Manifest` is required. A successful run prints `OK` with unit and source counts and the output path.

Validate the generated index against the same manifest:

```text
pwsh ./tools/knowledge/Validate-MagKnowledgeIndex.ps1 `
  -Index ./generated/knowledge/index-global.json `
  -Manifest ./tools/knowledge/manifests/global.json
```

`-Index` is required. Success prints `VALID`.

Usage errors exit `5`. Generation and validation problems that are not usage errors exit `3`.

<!-- mag-item-id: 4007169b-d656-462c-805e-d35a82c3e94b -->
### 7.2 Look up a pointer

```text
pwsh ./tools/knowledge/Locate-MagKnowledge.ps1 `
  -Index ./generated/knowledge/index-global.json `
  -Identity GLOBAL `
  -Intent GOVERN `
  -Query "Documentation authority model"
```

Required parameters are `-Index`, `-Identity`, `-Intent`, and `-Query`. `-Owner` is optional.

The Locator does not regenerate the index and does not open the document for you. A `FOUND` result includes `owner`, `section`, `heading_path`, `unit_id`, `identity_scope`, `knowledge_class`, and `source_id`. It does not include the section body.

| State | Exit | Meaning |
| --- | --- | --- |
| `FOUND` | 0 | One matching pointer. |
| `NOT_FOUND` | 1 | No match in the index. This is not proof that the knowledge is absent from the documents. |
| `AMBIGUOUS` | 2 | More than one match. |
| `STALE` / `CONFLICT` | 3 | The index is missing or does not match source bytes, including `missing_index`. |
| `OUT_OF_SCOPE` | 4 | The identity is outside that index, including a reserved identity. |
| usage / I/O | 5 | A required parameter is missing or a path cannot be read. |

Matching is an exact normalized title, or, when the query has at least two tokens, every token present in the title or heading path. A partial single-token overlap is `NOT_FOUND` unless the title matches exactly.

Staleness compares the SHA-256 of the current source bytes with `sources[].content_sha256`. A Git blob id is supplementary and is null when the file is untracked.

<!-- mag-item-id: a213bae3-cdba-4d7d-9a7e-195449ca8739 -->
### 7.3 Refresh after document changes

After you change an indexed document, generate and validate again, or use the refresh script.

By default, refresh selects only `tools/knowledge/manifests/global.json`. It does not need `Beyond3DViewer`, and it does not touch GLOBAL+#5.

```text
pwsh ./tools/knowledge/Update-MagKnowledge.ps1 -DryRun
pwsh ./tools/knowledge/Update-MagKnowledge.ps1
```

`-DryRun` reports affected scopes and does not write indexes. `-ChangedFiles` can be added to the set of changed paths. The script does not write Google Drive, commit, or install Git hooks. The Locator never calls it.

| Result | Meaning |
| --- | --- |
| `NO_INDEXED_SOURCE_CHANGE` | Nothing indexed changed. Indexes are not regenerated and are not re-certified. |
| `DRY_RUN` | Affected scopes are reported. No generated write. |
| `UPDATED` | Each affected manifest was generated and then validated. |
| `FAILED` | Generation stopped. Generated discovery for the failed scopes is unusable. Read the canonical documents for those scopes. Exit `3`. |

Technical detail: [tools/knowledge/README.md](../../tools/knowledge/README.md).

<!-- mag-item-id: dfdbfdc4-1645-43ef-8f34-0bb9cfc500c9 -->
## 8. Optional GLOBAL+#5

GLOBAL+#5 is an example scope, not part of the minimum setup. The manifest is `tools/knowledge/manifests/global-5.json`. A real index is `generated/knowledge/index-global-5.json`, and the Locator identity is `GLOBAL+#5`.

The manifest lists specific files under `../Beyond3DViewer/docs/`, named `P05__3DR__*.md`. Generation fails closed when that sibling checkout or those files are absent. There is no scan of neighboring folders.

Refresh that scope only by selecting the manifest directory explicitly:

```text
pwsh ./tools/knowledge/Update-MagKnowledge.ps1 -ManifestDirectory ./tools/knowledge/manifests
```

That command selects every `*.json` manifest in the folder, including GLOBAL+#5. If a selected manifest is missing its sources, the refresh reports `FAILED`, exits `3`, and does not replace existing indexes. Reasons include `missing_development_root` and `missing_source`.

`tools/knowledge/tests/MagKnowledge.Tests.ps1` covers GLOBAL+#5 with synthetic documents under `.mag-kn-test/`. That fixture is not a real `Beyond3DViewer` checkout, and the suite does not write the real `index-global-5.json`. If `.mag-kn-test/` already exists, the suite stops with `FAIL fixture-root-preexisting` and does not delete it. Inspect that folder and remove it manually before rerunning.

<!-- mag-item-id: e281dc8e-5f3e-46ed-8553-03833376c61a -->
## 9. Cursor knowledge-control rule

This component is optional. Knowledge **GLOBAL** does not require it.

Tracked source:

```text
tools/cursor/mag-knowledge-control.mdc
```

Cursor loads the copy at:

```text
<ReposRoot>\.cursor\rules\mag-knowledge-control.mdc
```

`<ReposRoot>` is the folder you open as the Cursor workspace. If you open only this repository, Cursor does not load a rule that was copied to the parent folder.

There is no deploy script. Copy source to the workspace. Do not copy the deployed file back over the tracked source.

```text
$root = "D:\Work\My Repos"
New-Item -ItemType Directory -Force -Path "$root\.cursor\rules" | Out-Null
Copy-Item -LiteralPath .\tools\cursor\mag-knowledge-control.mdc -Destination "$root\.cursor\rules\mag-knowledge-control.mdc"
```

Drift check, read-only:

```text
pwsh -NoProfile -File ./tools/cursor/Check-MagCursorKnowledgeControl.ps1 -ReposRoot "D:\Work\My Repos"
```

An explicit `-ReposRoot` wins. Otherwise the script uses `MAG_REPOS_ROOT`. If neither is set, it stops. The path must be absolute and must be an existing directory. There is no current-directory fallback and no Laragon default.

| Exit | Output | Meaning |
| --- | --- | --- |
| 0 | `IDENTICAL` | The deployed copy matches the tracked source. |
| 1 | `DRIFT` | The copies differ. |
| 2 | `MISSING_SOURCE` | The tracked source is missing. |
| 3 | `MISSING_DEPLOYED` | The rule is not at `<ReposRoot>\.cursor\rules\`. |
| 4 | `INVALID_ROOT` | The root is missing, relative, or not a directory. |

The rule text uses `<MAG-Ecosystem>` as the path of this checkout, for example `<ReposRoot>\MAG-Ecosystem-Legacy`. The Locator is not installed by the copy.

Guide: [tools/cursor/README.md](../../tools/cursor/README.md).

<!-- mag-item-id: d0a7fa7f-79ff-41a1-bee4-267eee3501c4 -->
## 10. Model Routing Guard

The Guard is optional. It is not required for Knowledge **GLOBAL** or for the Cursor rule.

It deploys Cursor hooks (`sessionStart`, `beforeSubmitPrompt`, `preCompact`) into a workspace. Source of truth is `tools/model-routing-guard/`. Deployed files go to `<ReposRoot>\.cursor\hooks\model-routing-guard\`, and deploy creates or updates `<ReposRoot>\.cursor\hooks.json`.

The root contract matches the Cursor check: explicit `-ReposRoot`, otherwise `MAG_REPOS_ROOT`, absolute existing directory, no default. Guard also rejects a drive root such as `D:\`, and a root containing `"`, `%`, `$`, or a backtick, before it writes.

<!-- mag-item-id: 1d00cc6b-144c-4935-95f4-ccf4ab2818f0 -->
### 10.1 Deploy

Run `-WhatIf` first. It resolves the root, validates an existing `hooks.json`, and computes the merge without writing.

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Deploy-MagModelRoutingGuard.ps1 -ReposRoot "D:\Work\My Repos" -WhatIf
pwsh -NoProfile -File .\tools\model-routing-guard\Deploy-MagModelRoutingGuard.ps1 -ReposRoot "D:\Work\My Repos"
```

Deploy is a write:

- It overwrites Guard-owned files under `.cursor\hooks\model-routing-guard\`.
- In `sessionStart`, `beforeSubmitPrompt`, and `preCompact`, it replaces entries whose command contains `model-routing-guard` with exactly one Guard entry.
- Other hook entries, other events, and other top-level settings are kept. JSON formatting is rewritten.
- Hook commands are absolute and include `-ReposRoot`, so they do not depend on the working directory Cursor uses.
- A missing, relative, or drive-root path, invalid JSON, a non-object `hooks` value, or a non-directory target is rejected before any copy.

Back up `.cursor\hooks.json` if you need to restore it.

<!-- mag-item-id: 08d942b5-21ce-4dc3-8c8c-de84bea2eeb2 -->
### 10.2 Mode and maintenance

Mode and maintenance use the same root. Both require `-ProductOwnerApproved`. State is stored under `<ReposRoot>\.mag\`.

Enforcement modes are `Enforced`, `Advisory`, and `Suspended`. Accepted aliases are `Pro`, `Auto`, `Off`, `ENFORCED`, `ADVISORY`, and `SUSPENDED`.

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMode.ps1 -ReposRoot "D:\Work\My Repos" -Mode Advisory -ProductOwnerApproved
```

Maintenance is separate from the mode command. `-Action` is `Suspend` or `Resume`.

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMaintenance.ps1 -ReposRoot "D:\Work\My Repos" -Action Suspend -ProductOwnerApproved
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMaintenance.ps1 -ReposRoot "D:\Work\My Repos" -Action Resume -ProductOwnerApproved
```

Without `-ProductOwnerApproved`, these scripts stop and do not write. `Suspend` while maintenance is already active stops with `Maintenance already active.`

<!-- mag-item-id: ed4ea632-e98c-4e03-a052-abf53a39943b -->
### 10.3 Risks and local tests

Deploy changes the Cursor workspace configuration. A bad merge is recovered from your backup of `hooks.json`, not by an automatic undo in this repository.

These tests use temporary roots. Passing them does not verify a clean-machine installation:

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagModelRoutingGuard.ps1
pwsh -NoProfile -File .\tools\model-routing-guard\Test-GuardRecovery.ps1 -GuardRoot (Resolve-Path .\tools\model-routing-guard).Path
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagGuardPortability.ps1
```

Guide: [tools/model-routing-guard/README.md](../../tools/model-routing-guard/README.md).

<!-- mag-item-id: bb6d05fe-3c8c-459f-916e-392dda820e72 -->
## 11. Documentation Mirror

The Documentation Mirror is optional. It is not required for Knowledge **GLOBAL**.

`tools/docs/Update-MagDocumentationMirror.ps1` copies the files named in an inventory between canonical checkouts (Local) and a separate transport folder (Mirror). Comparison uses SHA-256. The tool records a baseline. It never claims that a cloud drive uploaded or downloaded anything. `drive_sync_claimed` is always false.

<!-- mag-item-id: e2b0ef0b-a788-4475-a99c-b97aaa016167 -->
### 11.1 Inventory and roots

`-InventoryPath` is required. There is no default inventory.

```text
Copy-Item .\tools\docs\mirror-inventory.example.json "D:\Work\mirror\my-inventory.json"
```

Edit the copy:

- `repositories`: one key per folder name directly under the repos root. An empty string value means the folder name equals the key.
- `entries`: files to mirror. Each entry has `repo`, `path` relative to that repository, `category` (`document` or `tool`), and `require_metadata`.
- `repos_root` and `mirror_root`: absolute paths, or empty strings when you pass `-ReposRoot` and `-MirrorRoot` on every call. Command-line values win over the inventory.

The example inventory lists no private repositories. The tools do not modify the example file.

`tools/docs/mirror-inventory.json` is the author's Laragon inventory. Use it only by passing `-InventoryPath .\tools\docs\mirror-inventory.json`.

Choose a dedicated Mirror folder. Its parent must already exist. The Mirror folder itself does not need to exist yet.

Roots must be absolute. They are not resolved from the current directory. Spaces are allowed. A drive root such as `D:\` is rejected. The Mirror must not equal the repos root, contain it, overlap a listed repository, overlap this checkout, sit inside a Git worktree, or be a symlink or junction. A Mirror path inside the repos root is allowed only when it does not overlap a listed repository.

Default baseline and receipt paths are `generated/docs-mirror/baseline.json` and `generated/docs-mirror/check-receipt.json` in this checkout. Every inventory shares those defaults. Pass a separate `-BaselinePath` and `-ReceiptPath` for each layout.

<!-- mag-item-id: 85ec58f7-10c9-47ee-a490-5fbde314f362 -->
### 11.2 Check

`-Check` is the default when you pass no mode switch. Pass only one of `-Check`, `-BootstrapClean`, `-Reconcile`, and `-PublishAffected`.

```text
pwsh -NoProfile -File .\tools\docs\Update-MagDocumentationMirror.ps1 -Check `
  -InventoryPath "D:\Work\mirror\my-inventory.json" `
  -BaselinePath "D:\Work\mirror\baseline.json" -ReceiptPath "D:\Work\mirror\check-receipt.json"
```

Check classifies each pair, including `IDENTICAL`, `MISSING_TARGET`, `NEWER_LOCAL`, and `CONFLICT`. It does not write Local, Mirror, or the baseline. It does write the check receipt. That receipt binds a later `-Reconcile`, so Check is not strictly read-only.

A completed Check exits `0` even when pairs are `MISSING_TARGET`. Read the classifications. Do not treat exit `0` as proof that the Mirror matches Local.

Run Check again after a write. A synchronized Mirror reports every pair as `IDENTICAL`.

<!-- mag-item-id: 7200d3e5-6f3f-4bd0-96f4-ac5dfc23c1eb -->
### 11.3 Writes, including BootstrapClean

| Mode | What it writes |
| --- | --- |
| `-Check` | Only the check receipt. |
| `-BootstrapClean` | Deletes every file and folder under the Mirror root, then copies each inventory source from Local into the Mirror, verifies SHA-256, and writes the baseline. |
| `-Reconcile` | Writes the pairs proposed by one bound Check receipt and updates the baseline. Requires `-AuthorizationSha256` set to that receipt's SHA-256. |
| `-PublishAffected` | Writes only the named Mirror targets that are newer locally. Requires `-Affected` paths and `-ProductOwnerApproved`, and updates the baseline. |

`-BootstrapClean` never runs because another mode was omitted. You must pass the switch. Before it deletes anything, it refuses an unsafe root and refuses a reparse point (symlink or junction) inside the Mirror tree. The data under that Mirror root is removed. Use it only on a dedicated transport folder. It does not delete your canonical repositories when the root checks pass, and it does not delete them by being pointed at a repository: those roots are rejected first.

`-Reconcile` fails closed if the inventory, baseline, roots, or files changed after the Check that produced the receipt.

Root and inventory checks run before any write, including the Check receipt. A rejection exits `5`, prints the reason on the error stream, and changes nothing. Common prefixes are `usage: -InventoryPath is required`, `repos_root_missing`, `mirror_root_missing`, `*_relative`, `mirror_root_is_filesystem_root`, `mirror_root_overlaps_ecosystem_checkout`, `duplicate_mapping`, and `reparse_point:`. The full list is in [docs/INSTALL.md](../INSTALL.md).

`tools/docs/tests/MagDocumentationMirror.Tests.ps1` uses disposable TEMP fixtures. `MagDocumentationMirror.Portability.Tests.ps1` reports `NOT VERIFIED` when the author Laragon layout is absent. Neither test is a clean-machine installation.

<!-- mag-item-id: 99dff3af-16e5-47c6-a39f-f031c5832c04 -->
## 12. Troubleshooting

| Symptom | What to do |
| --- | --- |
| `#Requires -Version 7.0`, or the script does not start | Use `pwsh`, not Windows PowerShell 5.x. |
| `git clone` asks for a password or returns `Repository not found` | The repository is private. Sign in with Git Credential Manager or `gh auth login`. Do not paste a token into the URL. |
| Locator `STALE`, exit `3`, or `missing_index` | Regenerate and validate. The Locator does not repair the index. |
| Locator `OUT_OF_SCOPE` for `GLOBAL+#5`, `A…`, or `B…` | The identity does not match that index, the identity is reserved, or the optional index recipe is absent. |
| `Update-MagKnowledge.ps1` reports `FAILED`, exit `3` | An explicitly selected manifest is missing sources. The default run refreshes GLOBAL only. |
| `MagKnowledge.Tests.ps1` reports `FAIL fixture-root-preexisting` | `.mag-kn-test/` was left behind. Inspect it and remove it manually. |
| Cursor Check `INVALID_ROOT`, exit `4` | Pass an absolute existing `-ReposRoot`, or set `MAG_REPOS_ROOT`. |
| Cursor Check `MISSING_DEPLOYED` | Copy the rule to `<ReposRoot>\.cursor\rules\`, or you checked a different root. |
| Guard `repos_root_not_configured` or `repos_root_not_found` | The root was not passed or does not exist. Nothing was written. |
| Guard `hooks_json_invalid` | Fix `hooks.json` manually. Deploy wrote nothing. |
| Guard deploy changed hooks you did not expect | Restore `hooks.json` from the backup you made before deploy. |
| Mirror `usage: -InventoryPath is required` | Copy `tools/docs/mirror-inventory.example.json` and pass that copy. |
| Mirror `repos_root_*`, `mirror_root_*`, exit `5` | The root is missing, relative, malformed, or unsafe. Nothing was written. |
| Mirror bootstrap deleted files | `-BootstrapClean` deletes the Mirror root contents by design. |

<!-- mag-item-id: 9d23b4dc-d9a0-4a5d-be72-b604a0a384e5 -->
## 13. Security and preservation

- Keep the repository **PRIVATE** until a separate publication decision. Do not change visibility from this manual.
- Do not put passwords or tokens in clone URLs, scripts, or committed files.
- Path B migrated the sanitized development history into this clean GitHub repository. That migrated history preserves 103 commits, with GitHub noreply author and committer metadata, and the historical source trees. Later documentation commits are additional commits on that history. They are not a loss of those 103 commits.
- The previous archive, `Magshifter/MAG-Ecosystem-Legacy-Arhiv` (former ID `1442085997`), was deleted.
- The obsolete pre-sanitization commit `442286df7cb2abff56e84064dd1ceb5a3594e9b8` is not available through the authenticated GitHub API endpoints checked after that deletion. The deleted archive returns 404. This repository's Git API returns 404. Its commits API returns 422, `No commit found`.
- Authenticated API inaccessibility does not prove physical removal from every GitHub cache, backup, or recoverable store.
- `-BootstrapClean` deletes the contents of the Mirror root. `-Reconcile` and `-PublishAffected` write Mirror or Local copies named by the inventory. Check does not write those trees, but it writes a receipt.
- Guard deploy rewrites Guard-owned Cursor hook entries. Mode and maintenance write under `<ReposRoot>\.mag\` and require `-ProductOwnerApproved`.
- `generated/` output is disposable. Deleting it does not delete the canonical Markdown sources. Regenerating an index does not rewrite those sources.

<!-- mag-item-id: 2ee27a30-c7e7-40ac-93b4-cb21a21b8ddc -->
## 14. Limitations

- Clean-machine installation on a separate Windows PC is **NOT VERIFIED**.
- Public publication is **pending** and is not approved. This pack is not a release.
- Passing a TEMP-fixture test does not mean an unrelated developer has installed the repository.
- Optional components are not required for Knowledge **GLOBAL**.
- The Locator does not apply Verified Applicability, does not select implementation patterns, and does not print document text.
- Existing implementation patterns are for `#N`. `A<N>` does not select them as applicable instructions. A missing `A<N>` index is not an invalid identity.
- The Documentation Mirror does not verify cloud synchronization.
- MAGDC does not run these tools.
- Phase 7, Gate 3, and Phase 8 of a release lifecycle are not claimed as passed by this documentation.

<!-- mag-item-id: aa429549-9cdc-4dae-b49b-135eac81a13f -->
## 15. License and maintenance expectations

The repository is MIT. See [LICENSE](../../LICENSE). Copyright (c) 2026 Magshifter. The software is provided as is, without warranty.

There is no support channel implied by this manual. The repository is a historical record and a usable snapshot. It is not an active product line, and these manuals do not promise updates, compatibility with future MAGDC versions, or a published release.

<!-- mag-item-id: 72376f92-c230-497a-96f4-bf707ab3276e -->
## 16. Further reading

- [README.md](../../README.md) — short entry point, status, and historical-cleanup record.
- [docs/INSTALL.md](../INSTALL.md) — installation, rejected Mirror paths, and verification commands.
- [tools/knowledge/README.md](../../tools/knowledge/README.md) — index contract and refresh results.
- [tools/cursor/README.md](../../tools/cursor/README.md) — Cursor rule.
- [tools/model-routing-guard/README.md](../../tools/model-routing-guard/README.md) — Guard.
- `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, and `MAG_ECOSYSTEM.md` — historical governance. They are not installed by this manual.
