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
| `C:\laragon\repos\.cursor\rules\mag-knowledge-control.mdc` | **Deployed** runtime copy Cursor loads when the workspace root is `C:\laragon\repos`. Not authority. |

`C:\laragon\repos` remains a non-Git Laragon multi-repository container. The deployed path is outside `MAG-Ecosystem` by design.

## Workspace scope

Cursor discovers project rules under `<workspaceFolder>/.cursor/rules/`. For the current MAG workflow (edit `MAG-Ecosystem`, XenForo `#N` repos, `A<N>` repos, and siblings in one window), the workspace folder is `C:\laragon\repos`. Workspace-root deployment is required so `alwaysApply` Entry Gate routing applies across those repositories.

Do not rely on `MAG-Ecosystem/.cursor/rules/` alone when only the parent `repos` folder is opened.

## Deployment contract

- **Direction:** source → deployed only.
- The deployed copy must **never** overwrite the tracked source automatically.
- Deployment is an explicit controlled copy (no automatic deploy script in this Stage).
- This is **not** ordinary documentation `SYNC`, Mirror transport, or Knowledge Index generation.
- Drift between source and deployed must **fail closed** and be reported (`Check-MagCursorKnowledgeControl.ps1`).

## Check

```text
pwsh ./tools/cursor/Check-MagCursorKnowledgeControl.ps1
```

States: `IDENTICAL` (exit 0) or `DRIFT` / missing path (non-zero exit). Read-only; never modifies files.
