# MAG-Ecosystem-Legacy

This repository is **MAG-Ecosystem-Legacy**. It preserves the historical development of MAG Ecosystem, Magshifter's multi-class software development framework for AI-assisted work: global governance, documentation operations, knowledge routing, and Cursor tooling. The repository keeps that development history in sanitized form.

[MAG Ecosystem Legacy — official forum resource](https://magshifter.com/resources/mag-ecosystem-legacy.17/)

## Status

- **Visibility:** this GitHub repository is **PUBLIC**. Source code is available at `Magshifter/MAG-Ecosystem-Legacy` without a private-access clone gate.
- **Forum listing:** the [official forum resource](https://magshifter.com/resources/mag-ecosystem-legacy.17/) is a separate Product Owner-provided listing. It is not the same thing as this GitHub repository, and it is not a GitHub Release.
- **GitHub Release:** no GitHub Release or release tag is documented in this README. The version 0.1.1 user manuals are documentation only, not a packaged release artifact.
- **Development:** MAG Ecosystem development is closed here. This repository is maintained as a historical record and a usable snapshot of its tools. It is not an active development line.

## Relationship to MAG Development Center

[MAG Development Center](https://magshifter.com/resources/magdc-evidence-driven-control-plane.14/) (MAGDC) is a **separate successor** project: a governance and evidence control plane. MAGDC is **not** a compatible runtime replacement for MAG-Ecosystem-Legacy. It does not execute these legacy tools, and no migration, shared runtime, or compatibility bridge exists or is claimed.

## Purpose

MAG Ecosystem defines how MAG developments relate to each other and how documentation and AI workflows stay scoped:

- **GLOBAL** defines HOW (process, agent rules, documentation operations).
- Verified Applicability filters which HOW applies.
- Each active development defines its own WHAT.

## Components

### Implemented and part of the minimum setup

| Component | Location | What it is |
| --- | --- | --- |
| Governance documentation | Root `AI_*.md`, `MAG_*.md` | The historical canonical process and agent rules (Markdown documents; nothing to install) |
| XenForo document templates | `templates/xenforo-addon/` | Starter document package (`P0N__XXX__*.md`) for XenForo `#N` add-on products (Markdown; nothing to install) |
| Knowledge Index and Locator, **GLOBAL** scope | `tools/knowledge/` | Deterministic index generation, validation, and pointer lookup over the Global documents. Standalone: needs only this checkout and PowerShell 7 |
| Cursor knowledge-control rule | `tools/cursor/` | Operational Entry Gate projection for Cursor: a rule (`mag-knowledge-control.mdc`) that you copy manually into your Cursor workspace, plus a read-only drift check |

### Optional integrations

| Component | Location | What it is |
| --- | --- | --- |
| Model Routing Guard | `tools/model-routing-guard/` | Cursor hooks (`sessionStart`, `beforeSubmitPrompt`, `preCompact`) for model-routing enforcement. The deploy script **modifies** your Cursor workspace's `.cursor\hooks.json` |
| Documentation Mirror | `tools/docs/` | Copies listed files between your repository checkouts and a separate transport folder (for example one synced by a cloud drive client). `-BootstrapClean` **deletes** everything under the Mirror root before it repopulates it |
| Knowledge **GLOBAL+#5** scope | `tools/knowledge/manifests/global-5.json` | Example index scope that needs a separate `Beyond3DViewer` checkout next to this repository |

### Historical and experimental material

- `MAG_PIPELINE_V2_EVALUATION.md` and `MAG_PIPELINE_V2_EXPERIMENT.md` record a closed experiment. They are not Global authority and are not needed for any setup.
- The Governance documentation records the author's environment and product registry, for example `C:\laragon\repos\...` paths and the numbered products. These are historical records, not installation requirements or defaults.
- `tools/docs/mirror-inventory.json` is the author's own Documentation Mirror inventory (Laragon layout and Magshifter repositories). It is used only when you select it explicitly. Independent users start from `tools/docs/mirror-inventory.example.json`.

## Supported environment

Initial evaluation environment (minimum setup):

- Windows
- PowerShell 7 (`pwsh`)
- Git
- Cursor (needed for the Cursor rule and for the optional Model Routing Guard)

You do not need Laragon, the private sibling repositories, the Documentation Mirror, the Model Routing Guard, or Beyond3DViewer for the standalone Knowledge **GLOBAL** scope.

## Installation

See [docs/INSTALL.md](docs/INSTALL.md). It covers cloning this public repository and the minimum setup, and it keeps the optional components separate.

## Documentation

User manuals for version 0.1.1:

- [English manual](docs/manual/mag-ecosystem-legacy-manual.en.md)
- [Ukrainian manual](docs/manual/mag-ecosystem-legacy-manual.uk.md)

These manuals explain setup and use. They do not replace the historical governance documents, and they are not a release or a publication approval. Installation detail remains in [docs/INSTALL.md](docs/INSTALL.md).

## Basic usage

From the repository root, in PowerShell 7:

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

Generated indexes under `generated/` are derived, gitignored, and non-authoritative. Details: [tools/knowledge/README.md](tools/knowledge/README.md). Component guides: [tools/cursor/README.md](tools/cursor/README.md) and [tools/model-routing-guard/README.md](tools/model-routing-guard/README.md).

## Known limitations

- **Clean-machine installation is not verified.** No installation on a separate Windows PC has been tested yet. Local results come from isolated temporary fixtures on the author's machine.
- **Historical cleanup:** Path B migrated the sanitized development history into this clean GitHub repository, `Magshifter/MAG-Ecosystem-Legacy`. That migrated history preserves 103 commits, with GitHub noreply author and committer metadata and the historical source trees kept. The previous archive repository, `Magshifter/MAG-Ecosystem-Legacy-Arhiv` (former ID `1442085997`), was deleted. The obsolete pre-sanitization commit `442286df7cb2abff56e84064dd1ceb5a3594e9b8` is not available through the authenticated GitHub APIs checked after that deletion: the deleted archive returns 404, and this repository's Git API returns 404 (its commits API returns 422, No commit found). Authenticated API inaccessibility does not prove physical removal from every GitHub cache, backup, or recoverable store. This GitHub repository is now **PUBLIC**. Clean-machine installation on another Windows PC remains **NOT VERIFIED**.
- Cursor check and Model Routing Guard need an explicit workspace root (`-ReposRoot` or `MAG_REPOS_ROOT`). There is no Laragon default.
- Documentation Mirror needs an explicit `-InventoryPath`. `-Check` writes a check receipt. `-BootstrapClean` deletes everything under the Mirror root before it repopulates it. The tool never claims that a cloud drive actually synced.
- Knowledge **GLOBAL** is the standalone scope. The default `Update-MagKnowledge.ps1` refresh selects GLOBAL only and needs no `Beyond3DViewer` checkout. **GLOBAL+#5** is optional: it is refreshed only with an explicit `-ManifestDirectory`, and a real GLOBAL+#5 index still needs its documented `Beyond3DViewer` sources. When an explicitly selected manifest is missing its sources, the refresh fails closed (`FAILED`, exit `3`) without replacing existing indexes. `tools/knowledge/tests/MagKnowledge.Tests.ps1` is standalone and covers GLOBAL+#5 with synthetic fixture documents (see [docs/INSTALL.md](docs/INSTALL.md#verification-commands) and [tools/knowledge/README.md](tools/knowledge/README.md)).
- `tools/docs/tests/MagDocumentationMirror.Tests.ps1` uses disposable TEMP fixtures only. It does not read author-specific production paths or modify a real production Mirror, and it verifies outside-root preservation with fixture sentinels. The optional author-layout observation in `MagDocumentationMirror.Portability.Tests.ps1` reports `NOT VERIFIED` on machines without that layout. These tests do not prove cloud synchronization.
- Do not change this repository's visibility or rewrite its history outside a separately authorized step.

## License

MIT. See [LICENSE](LICENSE).
