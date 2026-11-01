# MAG Ecosystem

MAG Ecosystem is Magshifter's multi-class software development framework for AI-assisted work: global governance, documentation operations, knowledge routing, and Cursor tooling.

This repository is the **completed legacy development branch**. Further architectural development continues in the separate [MAG Development Center](https://github.com/Magshifter/MAG-Development-Center) project. MAGDC is a successor project, not a drop-in runtime, compatibility layer, or executor for these legacy tools.

Public release identity for the planned open copy: **MAG-Ecosystem-Legacy**. That public repository is prepared separately and is **not** claimed available from this private tree.

## Purpose

MAG Ecosystem defines how MAG developments relate to each other and how documentation and AI workflows stay scoped:

- **GLOBAL** defines HOW (process, agent rules, documentation operations).
- Verified Applicability filters which HOW applies.
- Each active development defines its own WHAT.

## Architecture and capabilities

| Area | Location | Role |
| --- | --- | --- |
| Governance documentation | Root `AI_*.md`, `MAG_*.md` | Canonical process and agent rules |
| XenForo product templates | `templates/xenforo-addon/` | Starter document package for `#N` products |
| Knowledge Index / Locator | `tools/knowledge/` | Deterministic index generation and pointer lookup |
| Documentation Mirror | `tools/docs/` | Optional Local ↔ Mirror transport tooling |
| Cursor knowledge-control rule | `tools/cursor/` | Operational Entry Gate projection for Cursor |
| Model Routing Guard | `tools/model-routing-guard/` | Optional Cursor hook arm for model-routing enforcement |

Pipeline V2 evaluation/experiment documents at the repository root are historical/experimental and are not required for day-one use.

## Supported environment

Initial supported evaluation environment:

- Windows
- PowerShell 7 (`pwsh`)
- Cursor

Cursor rule check and Model Routing Guard take an explicit workspace root (`-ReposRoot` or `MAG_REPOS_ROOT`; **W4**). Documentation Mirror takes an explicitly selected inventory and explicit, validated repos/Mirror roots with no Laragon default (**W5**); start from `tools/docs/mirror-inventory.example.json`.

## Installation

See [docs/INSTALL.md](docs/INSTALL.md).

## Basic usage

From the repository root, after PowerShell 7 is available:

```text
pwsh ./tools/knowledge/Generate-MagKnowledgeIndex.ps1 `
  -Manifest ./tools/knowledge/manifests/global.json

pwsh ./tools/knowledge/Validate-MagKnowledgeIndex.ps1 `
  -Index ./generated/knowledge/index-global.json `
  -Manifest ./tools/knowledge/manifests/global.json

pwsh ./tools/knowledge/Locate-MagKnowledge.ps1 `
  -Index ./generated/knowledge/index-global.json `
  -Identity GLOBAL `
  -Intent GOVERN `
  -Query "Documentation authority model"
```

Generated indexes under `generated/` are derived, gitignored, and non-authoritative. Details: [tools/knowledge/README.md](tools/knowledge/README.md).

## Known limitations

- Clean-machine installation on an unrelated Windows PC is **not verified**.
- Cursor check and Guard require an explicit workspace root (`-ReposRoot` or `MAG_REPOS_ROOT`); there is no Laragon default.
- Documentation Mirror requires an explicit `-InventoryPath`; the shipped `tools/docs/mirror-inventory.json` is the author-specific Laragon inventory (explicit selection only). Mirror is **optional** for the initial public release. `-Check` writes a check receipt; `-BootstrapClean` deletes everything under the Mirror root before repopulating it.
- Knowledge **GLOBAL** is the initial standalone supported index scope. **GLOBAL+#5** is optional and needs a sibling `Beyond3DViewer` checkout.
- A sanitized history-preserving public copy (**W7**) and publication (**W8**) are separate authorized steps. This private repository must not be made public or have its history rewritten.

## License

MIT — see [LICENSE](LICENSE).

## Relationship to MAG Development Center

[MAG Development Center](https://github.com/Magshifter/MAG-Development-Center) is the successor governance and evidence control plane. It does **not** currently execute MAG Ecosystem legacy tools, and no migration, shared runtime, or compatibility bridge is claimed in this release documentation.
