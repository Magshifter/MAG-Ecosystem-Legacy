# MAG Cursor Entry Gate (operational projection)

Operational tooling. Not MAG canonical authority. Not a seventh Global owner.

## Authority

- **Canonical Entry Gate HOW:** `AI_GUIDELINES.md` §27 (MAG Knowledge Control routing).
- Isolation, identity, and applicability taxonomy: `MAG_ECOSYSTEM.md`.
- Mechanical Action Gate: `AI_AGENTS_RULES.md`.
- Generated discovery artifact class: `MAG_DOCUMENTATION_OPERATIONS.md`.

Semantic changes to Entry Gate behavior originate in those canonical owners first. This directory does not define substantive MAG authority.

## Files

| Path | Role |
| --- | --- |
| `tools/cursor/mag-knowledge-control.mdc` | Versioned **source** operational projection for Cursor (tracked in `MAG-Ecosystem` Git). |
| `<ReposRoot>\.cursor\rules\mag-knowledge-control.mdc` | **Deployed** runtime copy Cursor loads when the workspace folder is `<ReposRoot>`. Not authority. |

`<ReposRoot>` is the Cursor workspace folder you open (for example a non-Git multi-repository container that holds `MAG-Ecosystem` and its sibling repositories). It is any absolute Windows path, spaces allowed; there is no built-in default. The deployed path is outside `MAG-Ecosystem` by design.

## Workspace root

Supply the root explicitly:

- `-ReposRoot "<absolute path>"` — wins when given;
- otherwise the `MAG_REPOS_ROOT` environment variable;
- neither set, a relative path, or a missing directory → `INVALID_ROOT` (exit 4). No current-directory fallback.

The author's layout (`C:\laragon\repos`) is supported only when passed or configured explicitly.

## Workspace scope

Cursor discovers project rules under `<workspaceFolder>/.cursor/rules/`. When one window holds `MAG-Ecosystem`, XenForo `#N` repos, `A<N>` repos, and siblings, the workspace folder is their common parent (`<ReposRoot>`). Workspace-root deployment is required so `alwaysApply` Entry Gate routing applies across those repositories.

Do not rely on `MAG-Ecosystem/.cursor/rules/` alone when only the parent folder is opened.

## Locating the MAG-Ecosystem checkout

The rule's Locator example uses the placeholder `<MAG-Ecosystem>`: the absolute path of the local `MAG-Ecosystem` Git checkout (the repository that contains `tools/knowledge/Locate-MagKnowledge.ps1`), for example `<ReposRoot>\MAG-Ecosystem` or the opened workspace folder itself. The rule does not assume a fixed machine path. If the checkout cannot be established, Locator generated discovery is unavailable. The Locator is not installed automatically.

## Deployment contract

- **Direction:** source → deployed only.
- The deployed copy must **never** overwrite the tracked source automatically.
- Deployment is an explicit controlled copy (no automatic deploy script in this Stage).
- This is **not** ordinary documentation `SYNC`, Mirror transport, or Knowledge Index generation.
- Drift between source and deployed must **fail closed** and be reported (`Check-MagCursorKnowledgeControl.ps1`).

## Install (manual, source → deployed)

```powershell
$root = 'D:\Work\My Repos'   # your Cursor workspace folder
New-Item -ItemType Directory -Force -Path "$root\.cursor\rules" | Out-Null
Copy-Item -LiteralPath .\tools\cursor\mag-knowledge-control.mdc -Destination "$root\.cursor\rules\mag-knowledge-control.mdc"
```

## Check

```text
pwsh -NoProfile -File ./tools/cursor/Check-MagCursorKnowledgeControl.ps1 -ReposRoot "<ReposRoot>"
```

Or set `MAG_REPOS_ROOT` and omit `-ReposRoot`. Read-only; never modifies files.

| Output | Exit |
| --- | --- |
| `IDENTICAL sha256=…` | 0 |
| `DRIFT source_sha256=… deployed_sha256=…` | 1 |
| `MISSING_SOURCE` | 2 |
| `MISSING_DEPLOYED` | 3 |
| `INVALID_ROOT` (root not configured, relative, or missing) | 4 |

Self-test (isolated TEMP fixtures only): `pwsh -NoProfile -File ./tools/cursor/Test-MagCursorKnowledgeControl.ps1` → `ALL_CURSOR_CHECK_OK`.
