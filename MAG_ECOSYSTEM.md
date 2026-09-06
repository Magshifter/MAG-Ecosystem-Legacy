# MAG Ecosystem

This document is the navigation and governance foundation for MAG add-on projects.

It defines **how MAG projects relate to each other and how their documentation is organized**. It does not duplicate detailed development, agent, or analytics rules. Those belong in the Global documentation files listed below, once they exist, and in each project's own documentation.

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

`#N` is a **permanent logical project identifier**. It is assigned once and is not reused. It is **not** required in physical filenames, folder names, or Git repository names.

| ID | Product | Status | Git repository |
| --- | --- | --- | --- |
| #1 | [MAG] Global Links Favicons | Active / Stable | `GlobalLinksFavicons` |
| #2 | [MAG] Tag Synchronizer | Planned | `TagSynchronizer` |

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

| File | Role |
| --- | --- |
| `MAG_ECOSYSTEM.md` | This file. Registry, levels, authority, bootstrap, maintenance. |
| `AI_GUIDELINES.md` | Detailed MAG development rules (created/migrated in a later procedure). |
| `AI_AGENTS_RULES.md` | Agent workflow and checkpoint rules (created/migrated in a later procedure). |
| `CURSOR_USAGE_ANALYTICS.md` | Cursor usage analytics process and historical MAG records (created/migrated in a later procedure). |

Until those later files exist, this document remains the only Global MAG documentation. Do not treat missing Global files as authorization to invent process.

## Project documentation standard

Each MAG project repository should use this standard set:

| File | Role |
| --- | --- |
| `TZ.md` | Product requirements. Authoritative for **what** the add-on must do. |
| `Roadmap.md` | Approved implementation sequencing and verified stage progress. |
| `Architecture.md` | Approved implementation architecture. |
| `CLASS_MAP.md` | Current code structure and class responsibilities. |
| `Changelog.md` | Historical record of released and staged changes. |
| `README.md` | Descriptive project entry point. |

Optional, created only when useful:

- `Idea.md` — non-authoritative research and working notes.
- `Overview.md` (or an equivalent overview document) — descriptive product overview.
- Other project documents when they serve a real, documented need.

Physical layout inside a project repository may place some of these files at the repository root or under `docs/`. The **logical names and authority** above matter more than a single folder convention. `#N` is not required in those filenames.

## Project marker system

- `#N` identifies the product in Global registry, reports, and AI context (`#1`, `#2`, …).
- Repository names, add-on IDs, PHP namespaces, and documentation filenames follow XenForo / MAG product identity (for example `MAG/GlobalLinksFavicons`), not the `#N` marker.
- Do not rename existing project files solely to insert `#N`.

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
| Global documentation (`MAG_ECOSYSTEM.md`, later `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, analytics process) | **How** MAG work is done: process, agents, Git checkpoints, analytics, ecosystem conventions. |
| Project `TZ.md` | **What** that product must do. Functional requirements. |
| Project `Architecture.md` | Approved implementation architecture for that product. Describes intended and verified structure; it does not override TZ. |
| Project `Roadmap.md` | Approved sequencing and verified progress. Controls what may be implemented **now**. |
| Project `CLASS_MAP.md` | Current classes and responsibilities as they exist in code. |
| Project `README.md` / overview documents | Descriptive. Not a source of new requirements or process. |
| Project `Idea.md` | Non-authoritative research. Must not override TZ, Architecture, Roadmap, or Global rules. |
| `Changelog.md` and Git history | Historical. Preserve as history. Do not rewrite the past to match a later decision. |

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

MAG work is incremental and stage-controlled:

1. Confirm the target project (`#N`) and load GLOBAL + `#N` only.
2. Identify the approved next increment from that project's Roadmap and TZ.
3. Inspect existing project code and installed XenForo source before designing or changing behavior.
4. Implement the smallest verified change that satisfies the approved increment.
5. Verify against the project's requirements and XenForo versions in scope.
6. Synchronize only the documentation that the change actually affects.
7. Stop at the approved Git checkpoint. The user owns Git add / commit / push unless they explicitly request otherwise.

Do not start the next stage, the next MAG project, or a shared component because the current increment is complete.

Detailed stage, review, release, and analytics procedures belong in Global `AI_GUIDELINES.md` and `AI_AGENTS_RULES.md` once migrated.

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
- After Global files are migrated, this document remains the registry and authority map; it should point to those files rather than restating them.

## New MAG project bootstrap

When a new MAG add-on is approved:

1. Assign the next sequential `#N` in the registry above.
2. Record product name, status, and Git repository name.
3. Create the project Git repository (separate from `MAG-Ecosystem`).
4. Add the standard project documentation set as that project needs it (`TZ.md` first when requirements exist).
5. Do not copy another project's requirements, architecture, or code "as a template" beyond true Global process.
6. Do not create shared components as part of bootstrap.

`#2` [MAG] Tag Synchronizer is registered as **Planned**. Its repository and documentation are **not** created in this procedure.

## Repository contents of MAG-Ecosystem (this procedure)

This foundation procedure creates only:

- Git repository `MAG-Ecosystem` on branch `main`;
- `MAG_ECOSYSTEM.md`.

`AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, and `CURSOR_USAGE_ANALYTICS.md` are intentionally absent until later controlled migration procedures.
