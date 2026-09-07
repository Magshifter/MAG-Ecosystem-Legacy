# MAG Ecosystem

This document is the navigation and governance foundation for MAG add-on projects.

It defines **how MAG projects relate to each other and how their documentation is organized**. It does not duplicate detailed development, agent, or analytics rules. Those belong in the Global documentation files listed below and in each project's own documentation.

## Core principle

**GLOBAL defines HOW MAG projects are developed.**

**#N defines WHAT the specific project is and must do.**

Global documentation governs process, workflow, agent rules, and shared ecosystem conventions.

Project (`#N`) documentation governs that project's product requirements, architecture, sequencing, and current code structure.

## Purpose of MAG Ecosystem

MAG Ecosystem is the documentation and process home for Magshifter's XenForo add-ons as a family of **independent products** that share:

- the same development process;
- the same documentation authority model;
- sequential project identity (`#N`);
- isolation of project-specific context unless a real cross-project need exists.

MAG Ecosystem is **not** a runtime product, a shared PHP package, or a license-control system. Individual MAG add-ons remain separate Git repositories and separate XenForo add-ons unless a later approved procedure creates a real shared component.

## Permanent sequential project registry

`#N` is a **permanent logical project identifier**. It is assigned once and is not reused.

Each MAG project also has a **short, stable project code** used in documentation filenames. That code is a filesystem/UI representation of `#N`. It does **not** replace `#N` in Global registry, reports, or AI context.

| ID | Code | Product | Status | Git repository |
| --- | --- | --- | --- | --- |
| #1 | `P01__GLF` | [MAG] Global Links Favicons | Active / Stable 1.4.3 | `GlobalLinksFavicons` |
| #2 | `P02__TS` | [MAG] Tag Synchronizer | Architecture Planning / Pre-Implementation | `TagSynchronizer` |

`#3` and later are assigned **sequentially when a project is approved**. Do not reserve unused numbers, invent products, or skip identifiers.

Local clone convention (current workstation):

```text
C:\laragon\repos\<repository-name>
```

Examples:

```text
C:\laragon\repos\GlobalLinksFavicons
C:\laragon\repos\TagSynchronizer
C:\laragon\repos\MAG-Ecosystem
```

This Global documentation repository is `MAG-Ecosystem`. It is not a MAG add-on and does not occupy a `#N` product slot.

## Documentation levels

### Global

Lives in this repository (`MAG-Ecosystem`). Applies to every MAG project unless a project document is explicitly authorized to specialize a Global rule (and only after a reported, approved conflict resolution).

### Project (`#N`)

Lives in that project's own Git repository. Describes that product only.

Work on `#N` means **GLOBAL + that `#N`**. Documentation from other MAG projects is excluded unless a task specifically requires it (for example a real shared-component change).

## Global documentation set

The current Global documentation tree in this repository is:

| File | Role |
| --- | --- |
| `MAG_ECOSYSTEM.md` | This file. MAG Ecosystem identity, architecture, project relationships, documentation map, and high-level governance. |
| `AI_GUIDELINES.md` | Global MAG development workflow and operational rules. |
| `AI_AGENTS_RULES.md` | Mandatory execution rules and boundaries for AI coding agents and related development tools, including Cursor procedure pre-flight and Plain text output requirements. |
| `CURSOR_USAGE_ANALYTICS.md` | Authoritative Cursor procedure routing/pre-flight, model selection and escalation, usage optimization, Cursor Models Before/After tracking, reporting, forecasting, and analytics methodology. |
| `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` | Canonical ordered lifecycle, stage gates, transitions, and documentation timing. References detailed operational rules in their owning Global documents. |
| `MAG_IMPLEMENTATION_PATTERNS.md` | Global reusable technical knowledge base: verified XenForo/XFRM behavior, implementation patterns, compatibility lessons, failure modes, and related evidence-backed findings. Subordinate to Global process documents and active-project TZ, Roadmap, and Architecture. Does not define product requirements. |

These Global files exist only in `MAG-Ecosystem`. Individual MAG project repositories must **not** create copies, companions, or pointer files named `MAG_ECOSYSTEM.md`, `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, `CURSOR_USAGE_ANALYTICS.md`, `MAG_IMPLEMENTATION_PATTERNS.md`, or `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`.

Projects inherit Global rules by reading this repository. Project-specific requirements belong in that project's TZ, Roadmap, Architecture, CLASS_MAP, Changelog, and README (and optional research/overview files), using the canonical filenames defined below. Project-specific Cursor measurement history may be stored locally (for example `docs/P01__GLF__CURSOR_USAGE_HISTORY.md`).

When a Global process rule changes, edit only `MAG-Ecosystem`. Do **not** synchronize that change into `#1`, `#2`, or later project repositories merely to mirror Global wording.

`CURSOR_USAGE_ANALYTICS.md` is methodology and Cursor-workflow policy. It is not a measurement-history log. MAG Ecosystem process measurements belong in a separate MAG-Ecosystem history artifact when that artifact is later approved. Do not copy analytics rules or the model-selection matrix into this file.

### How MAG projects cite Global documents

Project documentation must cite Global files as **`MAG-Ecosystem` / `<filename.md>`** (for example `MAG-Ecosystem` / `AI_GUIDELINES.md`). Do not repeat the workstation clone path in every product document; the clone convention above is recorded once in this file.

## Project documentation standard

Each MAG project repository should use this standard **logical** set. Authority is defined by the logical document, not by an unprefixed filename.

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

### Project documentation filenames

This is the authoritative MAG convention for project-specific documentation filenames.

1. Global-only files keep their existing unique filenames (`MAG_ECOSYSTEM.md`, `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, `CURSOR_USAGE_ANALYTICS.md`, `MAG_IMPLEMENTATION_PATTERNS.md`, `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`). Do **not** add a `GLOBAL__` prefix to them.
2. Project-specific canonical documentation uses `P<NN>__<CODE>__<Document>.md`.
3. `#N` remains the permanent logical project identifier.
4. `P01`, `P02`, and later are the filename representation of `#1`, `#2`, and later. The prefix does not replace `#N`.
5. Each project receives one short, stable project code recorded in the registry above (`GLF`, `TS`, …).
6. Existing project documentation should use the convention after controlled migration.
7. New MAG projects should use the convention from bootstrap.
8. Physical directories may still use the project-appropriate root/`docs/` layout.
9. The convention applies to the real canonical repository files, not only ChatGPT Project copies.
10. ChatGPT Project should use those same canonical filenames. No separate renamed-copy naming layer is required.

Examples:

```text
#1  P01__GLF__TZ.md
    docs/P01__GLF__Roadmap.md

#2  P02__TS__TZ.md
    P02__TS__Roadmap.md
```

## Project marker system

- `#N` identifies the product in Global registry, reports, and AI context (`#1`, `#2`, …).
- Repository names, add-on IDs, and PHP namespaces follow XenForo / MAG product identity (for example `MAG/GlobalLinksFavicons`), not the `#N` marker.
- Project documentation filenames use `P<NN>__<CODE>__` as defined above so the same files are identifiable in local clones, GitHub, Cursor, and ChatGPT Project.

## AI context isolation

When working on a MAG project:

1. Load **Global** MAG documentation from `MAG-Ecosystem`.
2. Load **that project's** documentation and code.
3. Do **not** load other projects' TZ, Roadmap, Architecture, CLASS_MAP, Changelog, or research notes unless the task explicitly requires them.

Example: work on `#1` = GLOBAL + [MAG] Global Links Favicons. `#2` documentation is out of scope.

Do not modify one MAG repository while the approved procedure is scoped to another.

## Documentation authority model

| Source | Authority |
| --- | --- |
| Global documentation (`MAG_ECOSYSTEM.md`, `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, `CURSOR_USAGE_ANALYTICS.md`, `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`) | **How** MAG work is done: process, agents, Git checkpoints, Cursor pre-flight/model selection and usage methodology, ecosystem conventions. |
| `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` | Canonical lifecycle order, stage gates, phase transitions, and documentation timing; detailed development and execution mechanics remain in their owning Global documents. |
| `MAG_IMPLEMENTATION_PATTERNS.md` | Reusable, evidence-backed technical knowledge for future MAG work. Subordinate to Global process documents and active-project TZ, Roadmap, and Architecture. Not a source of product requirements or process rules. |
| Project TZ | **What** that product must do. Functional requirements. Canonical file: `P<NN>__<CODE>__TZ.md`. |
| Project Architecture | Approved implementation architecture for that product. Describes intended and verified structure; it does not override TZ. |
| Project Roadmap | Approved sequencing and verified progress. Controls what may be implemented **now**. |
| Project CLASS_MAP | Current classes and responsibilities as they exist in code. |
| Project README / overview documents | Descriptive. Not a source of new requirements or process. |
| Project Idea | Non-authoritative research. Must not override TZ, Architecture, Roadmap, or Global rules. |
| Changelog and Git history | Historical. Preserve as history. Do not rewrite the past to match a later decision. |

**Code currently in the project repository is authoritative for what exists.** Requirements and process documents are authoritative for what is approved. Planned work is not implemented work.

## Conflict handling

Meaningful conflicts must be **reported**, not silently resolved by assumption.

Examples of meaningful conflicts:

- Global process vs. a project-specific instruction;
- TZ vs. Architecture vs. Roadmap vs. current code;
- two Global documents disagreeing after migration;
- an undocumented XenForo behavior vs. an assumed API.

Report the conflict, identify the documents and facts involved, and wait for resolution. Do not invent a compromise that changes product behavior or process without approval.

## High-level MAG development workflow

The ordered lifecycle, stage gates, and documentation timing are canonical in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md).

Detailed development, stage/phase closure, and release-artifact mechanics remain in `AI_GUIDELINES.md`; agent execution and checkpoints remain in `AI_AGENTS_RULES.md`; Cursor procedures and analytics remain in `CURSOR_USAGE_ANALYTICS.md`. Reusable-knowledge capture mechanics remain in `MAG_IMPLEMENTATION_PATTERNS.md`.

Project Roadmaps apply the Global lifecycle to approved project increments; they do not authorize automatic progression.

---

## High-level responsibility model

| Role | Responsibility |
| --- | --- |
| **User** | Product owner. Approves requirements, sequencing, reviews, Git, and releases. Final repository control. |
| **ChatGPT** | Architecture, requirements, sequencing, and review partner. Does not silently replace Cursor Agent implementation or user Git. |
| **Cursor IDE** | Editing and inspection environment. |
| **Cursor Agent** | Implements approved, scoped work in the designated repository. Follows Global + `#N`. Does not expand scope. |
| **Codex** | Used only when the user explicitly assigns it. Same Global + `#N` isolation and Existing Code First constraints. |

No assistant may treat another assistant's draft as approved product or process unless the user has accepted it.

## Existing Code First

Prefer extending and verifying the code that already exists in the target MAG project.

Do not rewrite working MAG or XenForo integration code without a verified reason recorded in the approved increment.

Do not introduce a new abstraction, shared library, or parallel implementation "for the ecosystem" when the current project already has a working local solution.

## Native XenForo mechanisms

MAG add-ons target XenForo. Prefer native XenForo APIs, Jobs, Options, permissions, templates, phrases, storage, HTTP helpers, and Admin CP patterns over custom frameworks.

Do not invent XenForo APIs.

## Verification of undocumented XenForo behavior

If XenForo behavior is undocumented, uncertain, or version-specific:

1. Inspect the **installed XenForo source** used for that project.
2. When necessary, consult official XenForo documentation.
3. Record the verified fact in the project documentation that owns it (typically Architecture, CLASS_MAP, or Changelog), not as an undocumented assumption.

## Shared ecosystem components

A shared MAG component (code, add-on, or Global library) is created **only when a real cross-project requirement exists** and is approved.

Until that happens:

- keep implementations in the project that needs them;
- do not extract "future-shared" infrastructure;
- do not add placeholder packages to this repository.

## MAG License Manager (ecosystem concept only)

A future **MAG License Manager** may exist as an ecosystem-level concept (shared licensing for MAG add-ons).

This repository must **not** design, specify, or implement License Manager functionality in this procedure. Project TZ documents that postpone licensing remain the product-level record until a later approved License Manager effort exists.

## Documentation maintenance

- Update Global documents when process or registry changes.
- Update project documents when that project's requirements, architecture, sequencing, or code structure changes.
- Keep changes minimal and scoped to the affected documents.
- Preserve historical Changelog and Git records as history.
- Do not duplicate Global rules into every project, and do not copy one project's TZ into another.
- This document remains the registry and authority map. It points to the other Global files rather than restating them.

## New MAG project bootstrap

When a new MAG add-on is approved:

1. Assign the next sequential `#N` in the registry above.
2. Record product name, status, Git repository name, and short filename code (`P<NN>__<CODE>`).
3. Create the project Git repository (separate from `MAG-Ecosystem`).
4. Add the standard project documentation set as that project needs it (`P<NN>__<CODE>__TZ.md` first when requirements exist). Use the filename convention in this document from bootstrap.
5. Do not copy another project's requirements, architecture, or code "as a template" beyond true Global process.
6. Do not create copies or pointer files of Global process documents in the new project.
7. Do not create shared components as part of bootstrap.

`#2` [MAG] Tag Synchronizer is registered. Its Git repository exists. Status is **Architecture Planning / Pre-Implementation**. Technical decisions A1–A6 are defined; full Architecture approval remains pending and implementation is blocked. It inherits Global rules by reference. It must not contain local copies of Global documentation files from `MAG-Ecosystem`.

## Current MAG-Ecosystem repository contents

This Global documentation repository currently contains:

- `MAG_ECOSYSTEM.md`
- `AI_GUIDELINES.md`
- `AI_AGENTS_RULES.md`
- `CURSOR_USAGE_ANALYTICS.md`
- `MAG_IMPLEMENTATION_PATTERNS.md`
- `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`
