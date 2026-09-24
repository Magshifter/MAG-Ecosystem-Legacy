# MAG Knowledge Index + Locator (V1)

Operational tooling. Not MAG canonical authority. Not a seventh Global owner.

Generated JSON under `generated/knowledge/` is derived, non-authoritative, non-registered, disposable, and reproducible from explicit manifests. Ordinary `SYNC` / `DOC REGISTER` must not treat it as a MAG document. A previous generated file is not “last good knowledge”; Locator re-hashes sources and fails closed when stale.

## Requirements

- PowerShell 7 (`pwsh`)
- No extra packages
- Run from or with paths relative to `MAG-Ecosystem`

## File roles

| Path | Role |
|------|------|
| `Generate-MagKnowledgeIndex.ps1` | Build index from a manifest |
| `Validate-MagKnowledgeIndex.ps1` | Schema + semantic + SHA-256 checks |
| `Locate-MagKnowledge.ps1` | Deterministic routing; pointer only |
| `lib/` | Shared parse/hash/match helpers |
| `schema/index.v1.schema.json` | Structural contract |
| `manifests/` | Explicit source allowlists |
| `config/source_rules.json` | Heading/class mapping (operational) |
| `config/intent_owner_map.json` | Intent → class filter (operational, not authority) |
| `tests/MagKnowledge.Tests.ps1` | Dependency-free test runner |

## Manifests

`global.json` lists Global files by basename only (no globs). `global-5.json` adds `#5` files under `../Beyond3DViewer/docs/P05__3DR__*.md` as an explicit list. There is no workspace-wide scan. `#8` is not a source.

Forbidden as sources: Knowledge Control roadmap, Pipeline V2 files, `templates/`, `generated/`, `tools/`.

## Commands

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

Locator does **not** regenerate the index and does **not** run section-oriented canonical fallback (`AI_GUIDELINES.md`).

## Locator states / exits

| State | Exit |
|-------|------|
| FOUND | 0 |
| NOT_FOUND | 1 (index miss; not “knowledge absent”) |
| AMBIGUOUS | 2 |
| STALE/CONFLICT | 3 (includes `missing_index`) |
| OUT_OF_SCOPE | 4 |
| usage / I/O | 5 |

FOUND returns `owner`, `section`, `heading_path`, `unit_id`, `identity_scope`, `knowledge_class`, `source_id`. No body.

Primary staleness signal: SHA-256 of exact source bytes vs `sources[].content_sha256`. Git blob is supplementary (`null` when untracked).

## Matching

Exact normalized title, or (query with ≥2 tokens) all tokens in title/heading_path. Partial/single-token overlap is NOT_FOUND except exact title. `aliases` is always `[]` in V1 (deferred).

## unit_id

`{owner_stem}#{slug(heading_path)}`. Slug is NFKC, lowercase, `[a-z0-9-]+`. If that slug is empty or collides, fallback is `{owner_stem}#u-{sha256utf8(heading_path)[0..12]}`.

## Git

Track `tools/knowledge/**`. Ignore `/generated/` (repository `.gitignore`).
