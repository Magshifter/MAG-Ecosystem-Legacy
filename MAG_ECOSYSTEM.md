# MAG Ecosystem

- MAG-Document-ID: `MAG_ECOSYSTEM.md`
- MAG-Content-Updated: `2026-09-11T12:30:00+03:00`

This document is the navigation and governance foundation for MAG software development across approved development classes.

It defines **how MAG developments relate to each other and how their documentation is organized**. It does not duplicate detailed development, agent, or analytics rules. Those belong in the Global documentation files listed below and in each active development's own documentation.

## Core principle

**GLOBAL defines HOW.**

**Active development defines WHAT.**

Global documentation governs process, workflow, agent rules, ordered lifecycle where applicable, reusable technical knowledge, documentation operations, and shared ecosystem conventions.

The active development's product documentation and code govern that product's requirements, architecture, sequencing, implementation state, and history.

General context rule: **GLOBAL + active development identity**.

Specialized forms:

- XenForo project work → **GLOBAL + active `#N`**
- Desktop/application/tool work → **GLOBAL + active `A<N>`**
- Mobile work → **GLOBAL + active `B<N>`**

Unrelated development-specific WHAT documentation must remain excluded unless explicitly required.

## Purpose of MAG Ecosystem

MAG Ecosystem is Magshifter's **multi-class software development ecosystem**. It is the governance, development-process, documentation, and tooling framework for explicitly approved MAG software developments across approved development classes.

Approved products within these classes share:

- the same Global process and documentation authority model;
- permanent development identities within approved namespaces;
- isolation of unrelated development WHAT context unless a real cross-development need exists.

Products remain independent repositories and products unless a later approved procedure creates a real shared component.

MAG Ecosystem is **not** itself a runtime product, a shared application package, or a license-control system.

## Development identity namespaces

Each MAG development identity belongs to exactly one approved identity namespace.

Each namespace:

- has a unique prefix;
- has an independent numeric sequence;
- has an explicitly approved semantic meaning;
- does not consume identifiers in another namespace;
- does not reserve identifiers in another namespace;
- assigns permanent identities;
- does not reuse retired identities.

Unused identifiers are not silently reserved.

A repository using MAG branding does not automatically receive an identity. Classification and initial identity assignment require explicit Product Owner approval. Reclassification between namespaces requires explicit Product Owner approval and a controlled documentation migration.

Future namespace classes such as `C`, `D`, etc. require explicit Product Owner approval before they acquire semantic meaning.

### `#N` — MAG XenForo Projects

`#N` is a **permanent logical XenForo project identifier** within the `#N` namespace. It is assigned once and is not reused.

Each `#N` XenForo project also has a **short, stable project code** used in documentation filenames. That code is a filesystem/UI representation of `#N`. It does **not** replace `#N` in Global registry, reports, or AI context.

| ID | Code | Product | Status | Git repository |
| --- | --- | --- | --- | --- |
| #1 | `P01__GLF` | [MAG] Global Links Favicons | Active / Stable 1.4.3 | `GlobalLinksFavicons` |
| #2 | `P02__TS` | [MAG] Tag Synchronizer | Active / Stable 1.0.0 | `TagSynchronizer` |

`#3` and later are assigned **sequentially when a XenForo project is approved**. Do not reserve unused numbers, invent products, or skip identifiers. Identities in other namespaces do not consume or reserve `#N` slots.

Applicable XenForo-specific Global rules continue to apply to `#N` products.

### `A<N>` — MAG Desktop / Development Applications

`A<N>` is a **permanent logical desktop/development application identifier** within the `A<N>` namespace. It is assigned once and is not reused.

| ID | Product | Classification | Status | Git repository |
| --- | --- | --- | --- | --- |
| A1 | [MAG] GPT\|Cursor\|Sync | MAG Desktop / Development Application | Active / Stable 1.1.0 | `MAG-GPT-Cursor-Sync` |

**A1 — concise registry metadata**

- Product category: Windows desktop / development workflow utility.
- Purpose: Connect ChatGPT Desktop, Cursor Agent, and Cursor Terminal through controlled local workflows that reduce repetitive manual transfer operations.

Global documentation contains only this concise product-level identity, status, and purpose metadata. Detailed architecture, hotkeys, TER mechanics, terminal implementation, telemetry, installation, and release history remain owned by the A1 product repository.

Local clone convention (current workstation):

```text
C:\laragon\repos\MAG-Workflow-Bridge
```

The public repository name is `MAG-GPT-Cursor-Sync`. Some internal technical identifiers retain the historical `MAG Workflow Bridge` name for compatibility.

### `B<N>` — MAG Mobile Applications

`B<N>` is reserved for explicitly approved Android, iOS, or cross-platform mobile MAG applications.

No `B<N>` product is currently registered. Do not invent a `B1`.

## Local clone convention

```text
C:\laragon\repos\<repository-name>
```

Examples:

```text
C:\laragon\repos\GlobalLinksFavicons
C:\laragon\repos\TagSynchronizer
C:\laragon\repos\MAG-Workflow-Bridge
C:\laragon\repos\MAG-Ecosystem
```

This Global documentation repository is `MAG-Ecosystem`. It is not a numbered product identity in any development class.

## Documentation levels

### Global

Lives in this repository (`MAG-Ecosystem`). Applies to every MAG development unless a development document is explicitly authorized to specialize a Global rule (and only after a reported, approved conflict resolution).

### Active development identity

Lives in that development's own Git repository. Describes that product only.

Work on an active development identity means **GLOBAL + that identity** (for example GLOBAL + `#2`, GLOBAL + `A1`). Documentation from other approved developments is excluded unless a task specifically requires it (for example a real shared-component change).

## Synchronization-managed document identity

A synchronization-managed Markdown document has one canonical filename and exactly one visible metadata block immediately below its single H1 heading:

- `MAG-Document-ID`: the exact canonical filename including `.md`.
- `MAG-Content-Updated`: the latest established substantive document revision, in RFC 3339 format `YYYY-MM-DDTHH:mm:ss±HH:mm`.

`MAG-Document-ID` identifies the same logical document across managed Local Git repositories, Google Drive, ChatGPT, and Cursor.

`MAG-Content-Updated` changes when the document receives a substantive content change. It does **not** change merely because of synchronization, copying, upload/download, transport conversion, safe formatting normalization, filesystem timestamps, or Drive timestamps.

This metadata supports identity, comparison, and conflict detection. It does not create or override substantive authority. Detailed synchronization scope, commands, comparison, conflict handling, approval, execution, verification, cleanup, reporting, and Git handoff boundaries are governed by `MAG_DOCUMENTATION_OPERATIONS.md`.

Synchronization-managed status is explicit. The existence of a Markdown file alone does not register it or place it in SYNC scope, and metadata alone does not grant substantive authority.

Global registration is represented by the authoritative Global documentation set below together with valid metadata and the applicable Local authoritative state. Stable development registration follows the approved development identity, canonical Local repository, applicable development documentation model and authority, valid metadata, and approved Git baseline.

Before Git handoff, provisional registration may exist only inside the explicit Product Owner-approved controlled registration or adoption procedure that created it. Provisional documents are available for validation and review within that procedure but are not part of default SYNC discovery or the stable registered documentation set.

Document onboarding, adoption, counterpart creation, rename, retirement, and unregistered-file handling are governed by `MAG_DOCUMENTATION_OPERATIONS.md`.

## Global documentation set

The current Global documentation set comprises **seven** authoritative files in this repository:

| File | Role |
| --- | --- |
| `MAG_ECOSYSTEM.md` | This file. MAG Ecosystem identity, development-class taxonomy, namespace registry, documentation map, context isolation, and high-level governance. |
| `AI_GUIDELINES.md` | Global MAG development workflow and operational rules; §24 owns Cursor prompt presentation and post-execution review. |
| `AI_AGENTS_RULES.md` | Mandatory execution rules and boundaries for AI coding agents and related development tools, including Cursor procedure pre-flight and Plain text output requirements. |
| `CURSOR_USAGE_ANALYTICS.md` | Authoritative Cursor procedure routing/pre-flight, model selection and escalation, usage optimization, Cursor Models Before/After tracking (including automatic After telemetry consumption and failure handling), reporting, forecasting, and analytics methodology. |
| `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` | Canonical ordered lifecycle for `#N` XenForo add-ons: stage gates, transitions, and documentation timing. References detailed operational rules in their owning Global documents. |
| `MAG_IMPLEMENTATION_PATTERNS.md` | Global reusable technical knowledge base: verified, source-backed implementation patterns (predominantly XenForo/XFRM for `#N` products), compatibility lessons, failure modes, and related evidence-backed findings. Subordinate to Global process documents and active-development TZ, Roadmap, and Architecture. Does not define product requirements. |
| `MAG_DOCUMENTATION_OPERATIONS.md` | Authoritative documentation synchronization protocol across managed Local Git repositories, Google Drive, ChatGPT, and Cursor. |

These Global files exist only in `MAG-Ecosystem`. Individual product repositories must **not** create copies, companions, or pointer files named `MAG_ECOSYSTEM.md`, `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, `CURSOR_USAGE_ANALYTICS.md`, `MAG_IMPLEMENTATION_PATTERNS.md`, `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`, or `MAG_DOCUMENTATION_OPERATIONS.md`.

Developments inherit Global rules by reading this repository. Product-specific requirements belong in that development's authoritative WHAT documentation, using the filename conventions defined below. Development-specific Cursor measurement history may be stored locally (for example `docs/P01__GLF__CURSOR_USAGE_HISTORY.md`).

When a Global process rule changes, edit only `MAG-Ecosystem`. Do **not** synchronize that change into `#1`, `#2`, `A1`, or later registered developments merely to mirror Global wording.

`CURSOR_USAGE_ANALYTICS.md` is methodology and Cursor-workflow policy. It is not a measurement-history log. MAG Ecosystem process measurements belong in a separate MAG-Ecosystem history artifact when that artifact is later approved. Do not copy analytics rules or the model-selection matrix into this file.

### How MAG developments cite Global documents

Development documentation must cite Global files as **`MAG-Ecosystem` / `<filename.md>`** (for example `MAG-Ecosystem` / `AI_GUIDELINES.md`). Do not repeat the workstation clone path in every product document; the clone convention above is recorded once in this file.

## Project documentation standard

Each `#N` XenForo project repository should use this standard **logical** set. Authority is defined by the logical document, not by an unprefixed filename.

| Logical document | Canonical filename | Role |
| --- | --- | --- |
| TZ | `P<NN>__<CODE>__TZ.md` | Product requirements. Authoritative for **what** the add-on must do. |
| Roadmap | `P<NN>__<CODE>__Roadmap.md` | Approved implementation sequencing and verified stage progress. |
| Architecture | `P<NN>__<CODE>__Architecture.md` | Approved implementation architecture. |
| CLASS_MAP | `P<NN>__<CODE>__CLASS_MAP.md` | Current code structure and class responsibilities. |
| Changelog | `P<NN>__<CODE>__Changelog.md` | Historical record of released and staged changes. |
| README | `P<NN>__<CODE>__README.md` | Descriptive project entry point. |

Optional, created only when useful:

- Idea — `P<NN>__<CODE>__Idea.md` — non-authoritative research and working notes.
- Overview — `P<NN>__<CODE>__Overview.md` — descriptive product overview.
- Cursor usage history — `P<NN>__<CODE>__CURSOR_USAGE_HISTORY.md` (often under `docs/`).
- Other project documents when they serve a real, documented need, using the same filename prefix.

Physical layout inside a project repository may place some of these files at the repository root or under `docs/`. The **logical names and authority** above remain unchanged.

Do not keep duplicate copies under the old unprefixed names after a controlled migration. Do not create a separate renamed-copy layer for ChatGPT Project; ChatGPT Project should use these same canonical filenames.

Non-`#N` developments use the ecosystem-level filename conventions below when a controlled documentation set is approved. Filename adoption and short-code assignment remain separate Product Owner-controlled procedures.

### Experimental / Evaluation documents

Experimental / Evaluation documents are optional project-scoped working evidence: hypotheses, temporary procedures, candidate workflows, observations, metrics, and evaluation results. They may evolve throughout the approved experiment. Registration and metadata establish identity/version tracking and synchronization eligibility only; they grant no substantive authority. They cannot override approved TZ, Architecture, Roadmap, or Global rules. Only expressly approved, bounded pilot procedural exceptions may apply within their recorded scope; no exception extends to another project or cycle.

Promotion follows documented evaluation, selection of findings for full or partial adoption, a scoped proposal for the owning Global documents, explicit Product Owner approval, and verified updates there. No automatic promotion follows PASS, PARTIAL PASS, registration, synchronization, or Git commit.

The following existing documents have stable registration as **Experimental registered documents** for project `#2`, retained under their current canonical names and locations as an explicit naming/location exception:

- `MAG_PIPELINE_V2_EXPERIMENT.md` — canonical Local: `MAG-Ecosystem` repository root; Drive object: `<DRIVE-DOC:MAG_PIPELINE_V2_EXPERIMENT>`.
- `MAG_PIPELINE_V2_EVALUATION.md` — canonical Local: `MAG-Ecosystem` repository root; Drive object: `<DRIVE-DOC:MAG_PIPELINE_V2_EVALUATION>`.

Both retain the existing Drive folder `<DRIVE-FOLDER:MAG_PIPELINE_V2>`. Physical placement in the ecosystem repository or Drive does not place them in the seven-file Global authority set. They belong to `SYNC #2` or exact-filename scope, not `SYNC GLOBAL`. Do not create copies in TagSynchronizer or rename existing counterparts. The approved Git baseline was established in `2e16465`, followed by the Evaluation pilot-activation record in `3c5f864`; both documents are now available for stable discovery in their registered project scope. Stable registration grants synchronization eligibility only, not substantive authority. Detailed registration and validation rules remain in `MAG_DOCUMENTATION_OPERATIONS.md` §5.

### Documentation filename conventions

This is the authoritative MAG convention for development-specific documentation filenames at the ecosystem level.

1. Global-only files keep their existing unique filenames (`MAG_ECOSYSTEM.md`, `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, `CURSOR_USAGE_ANALYTICS.md`, `MAG_IMPLEMENTATION_PATTERNS.md`, `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`, `MAG_DOCUMENTATION_OPERATIONS.md`). Do **not** add a `GLOBAL__` prefix to them.
2. `#N` XenForo project documentation uses `P<NN>__<CODE>__<Document>.md`.
3. `A<N>` desktop/application product documentation uses `A<NN>__<CODE>__<Document>.md` when adopted through an approved procedure.
4. `B<N>` mobile product documentation uses `B<NN>__<CODE>__<Document>.md` when adopted through an approved procedure.
5. `#N` remains the permanent logical XenForo project identifier. `P01`, `P02`, and later are the filename representation of `#1`, `#2`, and later. The prefix does not replace `#N`.
6. Each `#N` project receives one short, stable project code recorded in the registry above (`GLF`, `TS`, …).
7. Existing project documentation should use the convention after controlled migration.
8. New `#N` XenForo projects should use the convention from bootstrap.
9. Physical directories may still use the development-appropriate root/`docs/` layout.
10. The convention applies to the real canonical repository files, not only ChatGPT Project copies.
11. ChatGPT Project should use those same canonical filenames. No separate renamed-copy naming layer is required.
12. Ecosystem identity conventions do not by themselves require filename migration. Any migration remains a separate controlled procedure requiring Product Owner approval.

Examples:

```text
#1  P01__GLF__TZ.md
    docs/P01__GLF__Roadmap.md

#2  P02__TS__TZ.md
    P02__TS__Roadmap.md
```

## Development marker system

- `#N`, `A<N>`, and `B<N>` identify the active development identity in Global registry, reports, and AI context (`#1`, `#2`, `A1`, …).
- `Global` identifies MAG-Ecosystem process work. It is not a substitute for a registered product identity such as `A1`.
- For `#N` XenForo products only: repository names, add-on IDs, and PHP namespaces follow XenForo / MAG product identity (for example `MAG/GlobalLinksFavicons`), not the `#N` marker.
- `#N` project documentation filenames use `P<NN>__<CODE>__` as defined above so the same files are identifiable in local clones, GitHub, Cursor, and ChatGPT Project.

## AI context isolation

When working on a MAG development:

1. Load **Global** MAG documentation from `MAG-Ecosystem`.
2. Load **that development's** product documentation and code.
3. Do **not** load other developments' TZ, Roadmap, Architecture, CLASS_MAP, Changelog, or research notes unless the task explicitly requires them.

Examples:

- work on `#1` = GLOBAL + [MAG] Global Links Favicons; `#2`, `A1`, and other developments are out of scope;
- work on `#2` = GLOBAL + [MAG] Tag Synchronizer; `#1`, `A1`, and other developments are out of scope;
- work on `A1` = GLOBAL + [MAG] GPT\|Cursor\|Sync; `#1`, `#2`, and other developments are out of scope;
- work on Global documentation = GLOBAL only.

Do not modify one MAG repository while the approved procedure is scoped to another.

## Documentation authority model

Each Global file has one primary authority. Do not duplicate its detailed rules in other Global documents.

| Source | Authority |
| --- | --- |
| `MAG_ECOSYSTEM.md` | Ecosystem identity, development-class taxonomy, namespace registry, documentation map, authority navigation, and GLOBAL + active development identity context isolation. |
| `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` | Canonical ordered lifecycle for `#N` XenForo add-ons: stage gates, phase transitions, and documentation timing. Does not redefine detailed rules owned by other Global documents. |
| `AI_GUIDELINES.md` | Detailed development standards, principles, stage/phase closure mechanics, and operational workflow applied at lifecycle checkpoints. |
| `AI_AGENTS_RULES.md` | Coding-agent execution boundaries, mandatory Cursor pre-flight, checkpoints, and applicable report requirements. |
| `CURSOR_USAGE_ANALYTICS.md` | Cursor procedure routing/pre-flight, model selection and escalation, usage tracking, reporting, forecasting, and analytics methodology. |
| `MAG_IMPLEMENTATION_PATTERNS.md` | Reusable, source-backed technical knowledge base and its capture/maintenance procedure. Subordinate to Global process documents and active-development TZ, Roadmap, and Architecture. Not a source of product requirements or process rules. |
| `MAG_DOCUMENTATION_OPERATIONS.md` | Documentation identity validation, synchronization scope and commands, comparison, conflict handling, approval, execution, verification, cleanup, reporting, and Git handoff boundaries. |
| Project TZ | **What** that `#N` product must do. Functional requirements. Canonical file: `P<NN>__<CODE>__TZ.md`. |
| Project Architecture | Approved implementation architecture for that product. Describes intended and verified structure; it does not override TZ. |
| Project Roadmap | Approved sequencing and verified progress. Controls what may be implemented **now**. |
| Project CLASS_MAP | Current classes and responsibilities as they exist in code. |
| Project README / overview documents | Descriptive. Not a source of new requirements or process. |
| Project Idea | Non-authoritative research. Must not override TZ, Architecture, Roadmap, or Global rules. |
| Changelog and Git history | Historical. Preserve as history. Do not rewrite the past to match a later decision. |

**Code currently in the development repository is authoritative for what exists.** Requirements and process documents are authoritative for what is approved. Planned work is not implemented work.

## Conflict handling

Meaningful conflicts must be **reported**, not silently resolved by assumption.

Examples of meaningful conflicts:

- Global process vs. a development-specific instruction;
- TZ vs. Architecture vs. Roadmap vs. current code;
- two Global documents disagreeing after migration;
- an undocumented XenForo behavior vs. an assumed API.

Report the conflict, identify the documents and facts involved, and wait for resolution. Do not invent a compromise that changes product behavior or process without approval.

## High-level MAG development workflow

The ordered lifecycle, stage gates, and documentation timing for `#N` XenForo add-ons are canonical in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md).

Detailed development, stage/phase closure, and release-artifact mechanics remain in `AI_GUIDELINES.md`; agent execution and checkpoints remain in `AI_AGENTS_RULES.md`; Cursor procedures and analytics remain in `CURSOR_USAGE_ANALYTICS.md`. Reusable-knowledge capture mechanics remain in `MAG_IMPLEMENTATION_PATTERNS.md`.

Project Roadmaps apply the Global lifecycle to approved `#N` project increments; they do not authorize automatic progression.

---

## High-level responsibility model

| Role | Responsibility |
| --- | --- |
| **User** | Product owner. Approves requirements, sequencing, reviews, Git, and releases. Final repository control. |
| **ChatGPT** | Architecture, requirements, sequencing, and review partner. Does not silently replace Cursor Agent implementation or user Git. |
| **Cursor IDE** | Editing and inspection environment. |
| **Cursor Agent** | Implements approved, scoped work in the designated repository. Follows Global + active development identity. Does not expand scope. |
| **Codex** | Used only when the user explicitly assigns it. Same Global + active development identity isolation and Existing Code First constraints. |

No assistant may treat another assistant's draft as approved product or process unless the user has accepted it.

## Existing Code First

Prefer extending and verifying the code that already exists in the target MAG development.

Do not rewrite working MAG or XenForo integration code without a verified reason recorded in the approved increment.

Do not introduce a new abstraction, shared library, or parallel implementation "for the ecosystem" when the current development already has a working local solution.

## Native XenForo mechanisms (`#N` only)

These rules apply to **`#N` MAG XenForo add-ons** only.

MAG XenForo add-ons target XenForo. Prefer native XenForo APIs, Jobs, Options, permissions, templates, phrases, storage, HTTP helpers, and Admin CP patterns over custom frameworks.

Do not invent XenForo APIs.

## Verification of undocumented XenForo behavior (`#N` only)

These rules apply to **`#N` MAG XenForo add-ons** only.

If XenForo behavior is undocumented, uncertain, or version-specific:

1. Inspect the **installed XenForo source** used for that project.
2. When necessary, consult official XenForo documentation.
3. Record the verified fact in the project documentation that owns it (typically Architecture, CLASS_MAP, or Changelog), not as an undocumented assumption.

## Shared ecosystem components

A shared MAG component (code, add-on, or Global library) is created **only when a real cross-development requirement exists** and is approved.

Until that happens:

- keep implementations in the development that needs them;
- do not extract "future-shared" infrastructure;
- do not add placeholder packages to this repository.

## MAG License Manager (ecosystem concept only)

A future **MAG License Manager** may exist as an ecosystem-level concept (shared licensing for MAG add-ons).

This repository must **not** design, specify, or implement License Manager functionality in this procedure. Project TZ documents that postpone licensing remain the product-level record until a later approved License Manager effort exists.

## Documentation maintenance

- Update Global documents when process or registry changes.
- Update development documents when that development's requirements, architecture, sequencing, or code structure changes.
- Keep changes minimal and scoped to the affected documents.
- Preserve historical Changelog and Git records as history.
- Do not duplicate Global rules into every development, and do not copy one development's TZ into another.
- This document remains the registry and authority map. It points to the other Global files rather than restating them.

## New development bootstrap

When a new MAG development is approved in a given identity class:

1. Assign the next sequential identifier in that class (`#N`, `A<N>`, or `B<N>` as applicable). For `#N`, assign the next XenForo slot. `#3` is the next available XenForo project identity.
2. Record product name, status, Git repository name, and applicable filename convention metadata.
3. Create the development Git repository (separate from `MAG-Ecosystem`) when the approved product requires one.
4. Add the standard documentation set for that class only as the development needs it. For `#N`, use `P<NN>__<CODE>__TZ.md` first when requirements exist.
5. Do not copy another development's requirements, architecture, or code "as a template" beyond true Global process.
6. Do not create copies or pointer files of Global process documents in the new development.
7. Do not create shared components as part of bootstrap.

`#2` [MAG] Tag Synchronizer is registered. Its Git repository exists. Status is **Active / Stable 1.0.0**. Stable Release 1.0.0 is released; Post-Release Verification is the next lifecycle stage and has not started. It inherits Global rules by reference. It must not contain local copies of Global documentation files from `MAG-Ecosystem`.

## Current MAG-Ecosystem repository contents

This Global documentation repository currently contains:

- `MAG_ECOSYSTEM.md`
- `AI_GUIDELINES.md`
- `AI_AGENTS_RULES.md`
- `CURSOR_USAGE_ANALYTICS.md`
- `MAG_IMPLEMENTATION_PATTERNS.md`
- `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`
- `MAG_DOCUMENTATION_OPERATIONS.md`
