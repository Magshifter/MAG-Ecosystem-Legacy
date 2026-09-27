# MAG Ecosystem

- MAG-Document-ID: `MAG_ECOSYSTEM.md`
- MAG-Content-Updated: `2026-09-27T18:00:00+03:00`

This document is the navigation and governance foundation for MAG software development across approved Product Classes and identity namespaces.

It defines **how MAG developments relate to each other and how their documentation is organized**. It does not duplicate detailed development, agent, or lifecycle rules. Those belong in the Global documentation files listed below and in each active development's own documentation.

## Core principle

**GLOBAL defines HOW.**

**Verified Applicability determines WHICH HOW applies.**

**Active development defines WHAT.**

Global documentation governs process, workflow, agent rules, ordered lifecycle where applicable, reusable technical knowledge, documentation operations, and shared ecosystem conventions. Verified Applicability filters which of those Global rules apply to the current identity, Product Class, surface, and technology. It does not create authority.

The active development's product documentation and code govern that product's requirements, architecture, sequencing, implementation state, and history.

General context rule: **GLOBAL + active development identity**.

Specialized forms:

- XenForo Product work ΓåÆ **GLOBAL + active `#N`**
- Software Product work ΓåÆ **GLOBAL + active `A<N>`**

`B<N>` is not a current working identity. Do not use `GLOBAL + B<N>` while `B<N>` remains reserved.

Unrelated development-specific WHAT documentation must remain excluded unless explicitly required.

### Process/HOW governance hierarchy

```text
Product Owner
    Γåô
MAG Process Overlay Pool (ACTIVE entries only)
    Γåô
Canonical Global authority documents
    Γåô
Global operational assets
    Γåô
Active development
```

This hierarchy applies to process/HOW only. It does not change product WHAT.

The MAG Process Overlay Pool is a controlled active overlay layer, not a seventh canonical Global authority document. Canonical Global documents remain the durable normalized authority. ACTIVE Pool entries may override conflicting canonical process wording inside their explicit scope until promoted, rejected, or withdrawn.

## Purpose of MAG Ecosystem

MAG Ecosystem is Magshifter's **multi-class software development ecosystem**. It is the governance, development-process, documentation, and tooling framework for explicitly approved MAG software developments across approved Product Classes.

Approved products within these classes share:

- the same Global process and documentation authority model;
- permanent development identities within approved namespaces;
- isolation of unrelated development WHAT context unless a real cross-development need exists.

Products remain independent MAG identities unless a later approved procedure creates a real shared component. Repository, executable, client, service, language, technology, and platform counts do not by themselves define identity.

MAG Ecosystem is **not** itself a runtime product, a shared application package, or a license-control system.

## Identity, Product Class, Surface, Technology, and Applicability

These are distinct MAG concepts. Do not treat them as synonyms.

- **Identity** is the permanent MAG development identifier. One identity means one standalone Product WHAT. Additional repositories, executables, clients, services, languages, technologies, platforms, or surfaces do not by themselves create another identity.
- **Product Class** is the approved kind of MAG product that a namespace is authorized to identify. `#N` identifies XenForo Products. `A<N>` identifies Software Products. `B<N>` is reserved and currently identifies no Product Class.
- **Surface** is a product environment or delivery face (for example Windows, Android, iOS, Web, XenForo host, backend/service). One identity may have multiple surfaces.
- **Technology** is runtime, language, framework, subsystem, or a similar implementation choice. Technology does not define identity.
- **Verified Applicability** is a routing/filter mechanism that determines which Global HOW applies to the current identity, Product Class, surface, and technology. It is not MAG authority.

```text
CONTROL ΓåÆ ROUTING ΓåÆ AUTHORITY
```

The current canonical owner body remains authority. Successful routing, including Verified Applicability filtering, is a pointer to that body, not a replacement for it. Keyword similarity is not proof of applicability.

There is no mandatory second-level Global process stack per Product Class or surface. Profiles, templates, and operational assets are optional specialization. Create them only when a recurring need is proven. They do not become additional Global authority owners.

`#N` XenForo Product HOW ΓÇö including the ordered `#N` lifecycle, eight-document package, Blueprint, XenForo templates, and XenForo-specific validation, version, and release rules ΓÇö remains owned by its current documents and is not redesigned here.

## Development identity namespaces

Each MAG development identity belongs to exactly one approved identity namespace.

Each namespace:

- has a unique prefix;
- has an independent numeric sequence;
- has an explicitly approved Product Class meaning, or is reserved with no Product Class;
- does not consume identifiers in another namespace;
- does not reserve identifiers in another namespace;
- assigns permanent identities when it is an assignable Product Class namespace;
- does not reuse retired identities.

Unused identifiers are not silently reserved. Approved historical identities are immutable. Unused gaps remain available for future assignment unless explicitly retired by the Product Owner.

A repository using MAG branding does not automatically receive an identity. Product Class and initial identity assignment require explicit Product Owner approval. Reclassification between namespaces is a Product Class change; it requires explicit Product Owner approval and a controlled documentation migration. A new OS, platform, or surface does not by itself create or require a new namespace.

Future namespaces such as `C`, `D`, etc. require explicit Product Owner approval before they acquire Product Class meaning. Approve a new namespace only for a genuinely new Product Class, not because a product uses a new platform or surface.

### `#N` ΓÇö MAG XenForo Products

`#N` is a **permanent logical XenForo Product identifier** within the `#N` namespace. It is assigned once and is not reused.

Each `#N` XenForo Product also has a **short, stable project code** used in documentation filenames. That code is a filesystem/UI representation of `#N`. It does **not** replace `#N` in Global registry, reports, or AI context.

| ID | Code | Product | Status | Git repository | Local path |
| --- | --- | --- | --- | --- | --- |
| #1 | `P01__GLF` | [MAG] Global Links Favicons | Active / Stable 1.4.3 | `GlobalLinksFavicons` | `C:\laragon\repos\GlobalLinksFavicons` |
| #2 | `P02__TS` | [MAG] Tag Synchronizer | Active / Stable 1.1.0 APPROVED; PRV PASS; external publication not recorded | `TagSynchronizer` | `C:\laragon\repos\TagSynchronizer` |
| #3 | `P03__SL` | [MAG] Simple Landing | Active / Gate 1 complete; Targeted Research / Installed-Source Verification NEXT | `SimpleLanding` | `C:\laragon\repos\SimpleLanding` |
| #4 | `P04__DG` | [MAG] Doc&Guide | Active / Stable 1.0.1 (`1000190`); 1.1.0 Gate 1 PASSED; Architecture / UX NEXT; Gate 2 pending | `DocGuide` | `C:\laragon\repos\DocGuide` |
| #5 | `P05__3DR` | [MAG] Beyond 3D Viewer | Active / Released 1.1.0 (`1001100`); 1.2 not started | `Beyond3DViewer` | `C:\laragon\repos\Beyond3DViewer` |
| #6 | `P06__DT` | [MAG] Design Toolkit | Active / Initial requirements discovery | `DesignToolkit` | `C:\laragon\repos\DesignToolkit` |
| #8 | `P08__AE` | [MAG] ACP Enhancements | Active / Published Stable 1.0.0 (`1000090`, Resource mag-acp-enhancements.12); Local/Git `1.0.2` / `1000290`; Phase 9 finalized into 1.0.1; external publication of 1.0.1/1.0.2 pending Product Owner | `ACP-Enhancements` | `C:\laragon\repos\ACP-Enhancements` |
| #9 | `P09__DI` | [MAG] Donatello Integration | Active / Gate 1 PASSED; Phase 3 complete; Architecture NEXT; Drive Reconciliation Pending | `Donatello-Int` | `C:\laragon\repos\Donatello-Int` |
| #10 | `P10__TB` | [MAG] Telegram Bridge | Active / Phase 1 Local/Git Bootstrap Complete; Requirements Definition NEXT; Drive Reconciliation Pending | `Telegram-Bridge` | `C:\laragon\repos\Telegram-Bridge` |

The `#N` registry table is the canonical current-fact source for identity, current lifecycle/status label, current stable version where shown, Git repository, and local path as currently recorded. Additional repositories or paths do not by themselves create another `#N` identity. Narrative below may explain classification, history, and meaning; it must not independently restate volatile current status, version, or path.

Approved historical `#N` identities are immutable and are not renumbered. Unused gaps remain available for future assignment unless the Product Owner explicitly retires or reserves them. Agents must not silently fill a gap, skip to a higher number, or invent a product to occupy an unused identifier. Identities in other namespaces do not consume or reserve `#N` slots.

Applicable XenForo-specific Global rules continue to apply to `#N` products.

### `A<N>` ΓÇö MAG Software Products

`A<N>` is a **permanent logical Software Product identifier** within the `A<N>` namespace. It is platform-neutral. It is assigned once and is not reused. Windows, Android, iOS, Web, backend/service, or other surfaces of the same Product WHAT remain that `A<N>` identity.

| ID | Product | Classification | Status | Git repository | Local path |
| --- | --- | --- | --- | --- | --- |
| A1 | [MAG] GPT\|Cursor\|Sync | MAG Desktop / Development Application | Active / Stable 1.1.1 | `MAG-GPT-Cursor-Sync` | `C:\laragon\repos\MAG-Workflow-Bridge` |
| A2 | [MAG] Art Environment | Local AI Control / Workflow Platform | Active / Bootstrap complete; Requirements NEXT | `MAG-Art-Environment` | `C:\laragon\repos\MAG-Art-Environment` |

The `A<N>` registry table is the canonical current-fact source for each registered `A<N>` identity, that product's instance classification, status, version where shown, Git repository, and local path as currently recorded. The Classification column describes **this product**, not the `A<N>` namespace.

**A1 ΓÇö concise registry metadata**

- Identity: A1 is a registered MAG Ecosystem Software Product identity, but it is not a XenForo `#N` product. It must not consume `#3` or any other `#N` slot.
- Product category: Windows desktop / development workflow utility. This is A1 surface/instance metadata. It does not define `A<N>`.
- Purpose: Connect ChatGPT Desktop, Cursor Agent, and Cursor Terminal through controlled local workflows that reduce repetitive manual transfer operations.
- Current status, version, repository, and local path: the `A<N>` registry table above.

Global documentation contains only this concise product-level identity, classification, and purpose metadata. Detailed architecture, hotkeys, TER mechanics, terminal implementation, telemetry, installation, and release history remain owned by the A1 product repository.

Some internal technical identifiers retain the historical `MAG Workflow Bridge` name for compatibility. That historical name does not change the public Git repository identity in the registry table.

**A2 ΓÇö concise registry metadata**

- Identity: A2 is a registered MAG Ecosystem Software Product identity. It is not a XenForo `#N` product and must not consume any `#N` slot. Documentation code: `AE`. Canonical filenames use `A02__AE__<Document>.md`. The code `AE` does not consume `#8` `P08__AE`.
- Product Class: MAG Software Product. Classification (this product, not the `A<N>` namespace): Local AI Control / Workflow Platform.
- Purpose: A local controlled environment in which the user defines Rules, Knowledge Base, Project State, Workflow, Quality Gates, Human Control, and AI connections/adapters, and applies that controlled context to their projects. AI does not own process, rules, knowledge, or project state; AI is a replaceable client/executor.
- Product WHAT authority: `docs/A02__AE__REQUIREMENTS.md`.
- Approved canonical document set:
  - `docs/A02__AE__REQUIREMENTS.md`
  - `docs/A02__AE__ARCHITECTURE.md`
  - `docs/A02__AE__ROADMAP.md`
  - `docs/A02__AE__CHANGELOG.md`
- Drive transport: no Drive object identity recorded. **Drive Reconciliation Pending** here is documentation-transport debt only. It is **not** a registration, Product Approval, or Local/Git bootstrap-incompleteness predicate. Current product/lifecycle status remains the `A<N>` registry table above.
- Current status, repository, and local path: the `A<N>` registry table above.

Global documentation contains only this concise product-level identity, classification, purpose, WHAT-authority, and approved-set metadata. Detailed requirements, architecture, sequencing, and history remain owned by the A2 product repository. Architecture in that set is not approved architecture.

### `B<N>` ΓÇö RESERVED

`B<N>` is **reserved**. It currently identifies no Product Class. It has no Mobile, Android, or iOS meaning. Do not assign a `B<N>` identity while it remains reserved.

No `B<N>` product is currently registered. Do not invent a `B1`.

## Local clone convention

Current workstation layout:

```text
C:\laragon\repos\<folder>
```

Registered development local paths in the identity tables above are the currently recorded canonical or primary Local locations. Additional clones, clients, or repositories of the same identity do not by themselves create another identity. This Global documentation repository is `MAG-Ecosystem` at `C:\laragon\repos\MAG-Ecosystem`. It is not a numbered product identity in any Product Class.

`C:\laragon\repos\Mirror` is the MAG documentation/tool **transport workspace** used with an external Google Drive sync client for phone/remote access. It is **not** a repository identity, **not** a canonical authority location, **not** a registration surface, **not** a Knowledge Control source, and **not** an additional Global owner. Operational rules are in `MAG_DOCUMENTATION_OPERATIONS.md` ┬º19.

## Documentation levels

### Global

Lives in this repository (`MAG-Ecosystem`). It is the Global authority map for every MAG development. Which Global HOW applies is determined by Verified Applicability. A development document may specialize a Global rule only after a reported, approved conflict resolution. A currently ACTIVE MAG Process Overlay Pool entry may specialize process/HOW inside its recorded scope.

### Active development identity

Lives in that development's own Git repository after Local/Git bootstrap is complete. For an approved `#N` Drive-First Bootstrap, Google Drive holds the canonical project documentation while Local/Git is pending. Describes that product only.

Work on an active development identity means **GLOBAL + that identity** (for example GLOBAL + `#2`, GLOBAL + `A1`, GLOBAL + `A2`). Documentation from other approved developments is excluded unless a task specifically requires it (for example a real shared-component change).

## Synchronization-managed document identity

A synchronization-managed Markdown document has one canonical filename and exactly one visible metadata block immediately below its single H1 heading:

- `MAG-Document-ID`: the exact canonical filename including `.md`.
- `MAG-Content-Updated`: the latest established substantive document revision, in RFC 3339 format `YYYY-MM-DDTHH:mm:ss┬▒HH:mm`.

`MAG-Document-ID` identifies the same logical document across managed Local Git repositories, Google Drive, ChatGPT, and Cursor.

`MAG-Content-Updated` changes when the document receives a substantive content change. It does **not** change merely because of synchronization, copying, upload/download, transport conversion, safe formatting normalization, filesystem timestamps, or Drive timestamps.

This metadata supports identity, comparison, and conflict detection. It does not create or override substantive authority. Detailed synchronization scope, commands, comparison, conflict handling, approval, execution, verification, cleanup, reporting, and Git handoff boundaries are governed by `MAG_DOCUMENTATION_OPERATIONS.md`.

Synchronization-managed status is explicit. The existence of a Markdown file alone does not register it or place it in SYNC scope, and metadata alone does not grant substantive authority.

Global registration is represented by the authoritative Global documentation set below together with valid metadata and the applicable Local authoritative state. Stable development registration follows the approved development identity, the currently recorded canonical Local/Git baseline, applicable development documentation model and authority, valid metadata, and approved Git baseline. Additional repositories of the same identity do not by themselves create another identity. Mirror CHECK, Mirror baseline, and adjacent transport-tooling state are not registration predicates.

Before Git handoff, provisional registration may exist inside an explicit Product Owner-approved controlled registration, adoption, or `#N` bootstrap procedure. Drive-First Bootstrap permits continued documentation work within that approved scope under **Bootstrap Incomplete ΓÇö Local/Git Pending**. These documents are not part of default SYNC discovery or the stable registered documentation set. Resume Bootstrap completes Local/Git prerequisites under `MAG_DOCUMENTATION_OPERATIONS.md` ┬º5. Drive reconciliation is a separate documentation-operations obligation and is not required for Phase 1 completion or stable registration; see `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 1.

Document onboarding, adoption, counterpart creation, rename, retirement, and unregistered-file handling are governed by `MAG_DOCUMENTATION_OPERATIONS.md`.

## Global documentation set

The current Global documentation set comprises **six** authoritative files in this repository. These remain the durable canonical authority owners:

| File | Role |
| --- | --- |
| `MAG_ECOSYSTEM.md` | This file. MAG Ecosystem identity, Product Class, Surface, Technology, and Applicability taxonomy; namespace registry; documentation map; context isolation; and high-level governance. |
| `AI_GUIDELINES.md` | Global MAG development workflow and operational rules; Evidence Inheritance and Validation Delta; goal-bound completion; ChatGPT/Cursor retrieval-surface routing; ┬º24 owns Cursor prompt presentation, post-execution review, and Cursor model-selection / model-routing policy. ┬º26 owns Process Overlay command text. |
| `AI_AGENTS_RULES.md` | Mandatory execution rules and boundaries for AI coding agents and related development tools, including Cursor procedure pre-flight and Plain text output requirements. |
| `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` | Canonical Global Core Lifecycle and the `#N` XenForo Product specialization/profile: numbered Gates, Phase transitions, process hierarchy, Phase Authorization, Phase 7 product correctness, Phase 8 shipping correctness, Normal Release Fast Path, documentation timing, and XenForo add-on `version_id` / `version_string` policy. Not `#N`-only. References detailed operational rules in their owning Global documents. |
| `MAG_IMPLEMENTATION_PATTERNS.md` | Global reusable technical knowledge base: verified, source-backed implementation patterns (predominantly XenForo/XFRM for `#N` products), compatibility lessons, failure modes, and related evidence-backed findings. Subordinate to Global process documents and active-development TZ, Roadmap, and Architecture. Does not define product requirements. |
| `MAG_DOCUMENTATION_OPERATIONS.md` | Authoritative documentation synchronization protocol across managed Local Git repositories, Google Drive, ChatGPT, and Cursor. Executor documentation surfaces; Fast Sync is the normal proven-state path; executor capability is a separate prerequisite from authorization. |

These six files are not joined by a seventh equivalent authority owner.

### MAG Knowledge Control

MAG Knowledge Control is the MAG control/discovery architecture that routes MAG work to existing authority. It does not create a seventh Global authority owner.

Invariant:

```text
CONTROL ΓåÆ ROUTING ΓåÆ AUTHORITY
```

Control mechanisms, session/working state, routing, generated discovery artifacts, and Global operational assets do not create substantive MAG authority.

Identity scope is established before development-specific retrieval. Retrieval remains **GLOBAL + active development identity** unless the Product Owner explicitly authorizes a real cross-development task. Current assignable identity scopes are `GLOBAL`, `GLOBAL+#N`, and `GLOBAL+A<N>`. `GLOBAL+B<N>` is not a current working identity while `B<N>` is reserved.

Verified Applicability is a routing/filter applied after identity scope. It selects which Global HOW is eligible for the current Product Class, surface, and technology. It does not create authority. Keyword similarity is not proof of applicability. Generated discovery may lag this taxonomy; missing generated indexes are not knowledge absence. Same-scope canonical fallback remains required.

The Entry Gate and derived discovery mechanisms (including Locator and generated indexes) are non-authoritative routing/discovery mechanisms. Successful routing or discovery is a **pointer to authority**, not authority.

- AI routing behavior (Entry Gate, intents, Locator states, same-scope fallback) belongs to `AI_GUIDELINES.md`.
- Agent action enforcement (Mechanical Action Gate and related execution controls) belongs to `AI_AGENTS_RULES.md`.
- Generated discovery artifact mechanics (classification, publication, SYNC exclusion, pointer/revision validation) belong to `MAG_DOCUMENTATION_OPERATIONS.md`.

### MAG Process Overlay Pool

`MAG_PROCESS_OVERLAY_POOL.md` is the ecosystem-level process overlay asset for Product Owner-approved HOW corrections, optimizations, and temporary ACTIVE deltas.

- It is owned at ecosystem level, not by a project.
- Scope is process/HOW only.
- ACTIVE entries participate in execution according to the precedence model below.
- Canonical Global documents remain the durable normalized authority.
- Global operational assets apply canonical rules and currently ACTIVE overlays; they do not independently define policy.
- Promotion integrates a validated entry into its canonical Global owners and affected operational assets, then retires the overlay effect.

Entry lifecycle, schema, and records live in that file. Individual MPO records are not separate registered documents. Process Overlay commands are `PROCESS CHANGE`, `PROCESS POOL STATUS`, `PROMOTE PROCESS POOL`, and `PROMOTE MPO-XXX` (operational text in `AI_GUIDELINES.md` ┬º26).

Do not rewrite multiple Global owners merely to activate an experimental process optimization. Do not create project-specific process experiment/evaluation documents by default.

### Global operational assets

Operational assets implement and reify current Global rules plus applicable ACTIVE overlays for repeatable execution. They are subordinate to process authority. They cannot independently create policy, cannot redefine product WHAT, and must be aligned when owning Global rules or ACTIVE overlays change. They are **not** members of the six canonical Global authority documents. Optional class or surface specialization assets, profiles, and templates are created only when a recurring need is proven. Do not create a new process stack or Global owner for each Product Class, platform, or surface.

| Asset | Kind | Sync / registration |
| --- | --- | --- |
| `MAG_XENFORO_ADDON_BLUEPRINT.md` | Registered Global operational asset | Ordinary two-bullet metadata. Eligible for `SYNC GLOBAL` as an operational asset, not as a project document or seventh authority owner. |
| `MAG_DEBUGGING.md` | Registered Global operational debugging asset | Eligible for `SYNC GLOBAL` as an operational asset. It applies canonical debugging/evidence/verification/reusable-knowledge boundaries and does not define product WHAT, reusable technical truth, or independent process policy. |
| `templates/xenforo-addon/*` | Supporting template assets | Not instantiated project documents. Transfer only through the approved package path in `MAG_DOCUMENTATION_OPERATIONS.md` ┬º4. Outside ordinary SYNC discovery. |

The Blueprint consumes ACTIVE overlay rules. It is not the owner of those rules. Detailed identity and transport rules remain in `MAG_DOCUMENTATION_OPERATIONS.md`.

`MAG_DEBUGGING.md` operationalizes debugging workflow. Reusable source-backed technical knowledge remains owned by `MAG_IMPLEMENTATION_PATTERNS.md`. Development-specific debugging evidence remains development-scoped unless separately classified, validated, and approved for reusable capture.

These Global files and assets exist only in `MAG-Ecosystem`. Individual product repositories must **not** create copies, companions, or pointer files named `MAG_ECOSYSTEM.md`, `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, `MAG_IMPLEMENTATION_PATTERNS.md`, `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`, `MAG_DOCUMENTATION_OPERATIONS.md`, `MAG_PROCESS_OVERLAY_POOL.md`, `MAG_XENFORO_ADDON_BLUEPRINT.md`, or `MAG_DEBUGGING.md`.

Developments inherit Global rules by reading this repository. Product-specific requirements belong in that development's authoritative WHAT documentation, using the filename conventions defined below.

When a durable Global process rule changes, edit only `MAG-Ecosystem`. For a fast Product Owner-approved process correction still under evaluation, create or activate an MPO entry instead of rewriting multiple canonical owners. Do **not** synchronize Global process wording into `#1`, `#2`, `A1`, or later registered developments merely to mirror Global wording.

Cursor model-selection / model-routing policy belongs in `AI_GUIDELINES.md` ┬º24. Do not copy the model-selection matrix into this file.

### How MAG developments cite Global documents

Development documentation must cite Global files as **`MAG-Ecosystem` / `<filename.md>`** (for example `MAG-Ecosystem` / `AI_GUIDELINES.md`). Do not repeat the workstation clone path in every product document; the clone convention above is recorded once in this file.

## Project documentation standard

Every newly approved `#N` XenForo Product has the following **conceptual eight-document package**. A mandatory canonical container/identity is **not** mandatory substantive work. Creation never implies a passed gate, approved requirements, approved architecture, performed audit, or existing implementation. Authority is defined by the logical document, not by its mere creation or filename. This package does not apply to `A<N>`. `B<N>` is reserved and is not an assignable documentation class. This requirement does not authorize migration or renaming of existing or historical project documents.

| Logical document | Canonical filename | Role |
| --- | --- | --- |
| TZ | `P<NN>__<CODE>__TZ.md` | Complete product requirements. Authoritative for **what** the add-on must do. Does not by itself decide the first implementation-bound release slice. |
| Roadmap | `P<NN>__<CODE>__Roadmap.md` | Approved implementation sequencing, verified stage progress, and the approved first-release implementation slice. |
| Architecture | `P<NN>__<CODE>__Architecture.md` | Approved implementation architecture. |
| CLASS_MAP | `P<NN>__<CODE>__CLASS_MAP.md` | Current code structure and class responsibilities. |
| Changelog | `P<NN>__<CODE>__Changelog.md` | Historical record of released and staged changes. |
| README | `P<NN>__<CODE>__README.md` | Descriptive project entry point and bootstrap status. |
| IDEA | `P<NN>__<CODE>__IDEA.md` | Non-authoritative product exploration, Phase 0 reasoning/evaluation, alternatives, historical/superseded concepts, and future concepts that do not belong to authoritative TZ. |
| AUDIT | `P<NN>__<CODE>__AUDIT.md` | Parent/core document for research and verification evidence; findings do not approve requirements or architecture. |

Bootstrap creates **eight** containers: README, TZ, Roadmap, Architecture, CLASS_MAP, Changelog, IDEA, and AUDIT.

Package verification **PASS**es when the eight bootstrap-created files exist correctly and identity and metadata are otherwise valid.

The package establishes ownership, not speculative content. Where substantive information is unavailable, record an honest state such as `Not yet defined`, `Not yet approved`, `No implementation exists yet`, or `No audit findings yet`. AUDIT exists Γëá an audit was performed. CLASS_MAP exists Γëá implementation exists. Architecture exists Γëá architecture is approved.

CLASS_MAP is a mandatory bootstrap-created container. Before implementation exists, honest minimal content equivalent to `No implementation exists yet.` is valid. Do not require speculative classes, namespaces, handlers, listeners, or file maps. Once implementation exists, CLASS_MAP becomes substantive under normal documentation rules.

AUDIT is a mandatory parent container. It may hold evidence directly for a small project. Child audits are optional and created only when a real audit surface requires them. Do not generate empty child audits by default. Do not delete existing historical child audits merely because they are currently empty.

Additional documents are optional, created only when useful:

- Overview ΓÇö `P<NN>__<CODE>__Overview.md` ΓÇö descriptive product overview.
- Other project documents when they serve a real, documented need, using the same filename prefix.

Physical layout inside a project repository may place some of these files at the repository root or under `docs/`. The **logical names and authority** above remain unchanged.

Do not keep duplicate copies under the old unprefixed names after a controlled migration. Do not create a separate renamed-copy layer for ChatGPT Project; ChatGPT Project should use these same canonical filenames.

Non-`#N` developments use the ecosystem-level filename conventions below when a controlled documentation set is approved. Filename adoption and short-code assignment remain separate Product Owner-controlled procedures.

### Experimental / Evaluation documents

Future process optimizations use the MAG Process Overlay Pool. Do **not** create a separate project-specific `PIPELINE_EXPERIMENT`, `PROCESS_EXPERIMENT`, `PROCESS_EVALUATION`, or equivalent document by default. A project may provide evidence, observations, validation cases, measurements, or implementation experience for an MPO entry; the process delta remains ecosystem-level.

Historical Experimental / Evaluation documents already present remain historical evidence. Do not automatically rename, delete, or migrate them, and do not change their historical meaning. They still cannot override approved TZ, Architecture, Roadmap, or Global rules, and they are not parallel Global process authority.

New Experimental registered documents, if ever approved, remain non-authoritative working evidence for a documented non-process need. Registration and metadata establish identity/version tracking and synchronization eligibility only.

Promotion of a validated process overlay is a controlled Global documentation normalization procedure (`PROMOTE MPO-XXX` / `PROMOTE PROCESS POOL`). No automatic promotion follows PASS, PARTIAL PASS, registration, synchronization, or Git commit.

The following existing documents have stable registration as **Experimental registered documents** for project `#2`, retained under their current canonical names and locations as an explicit naming/location exception:

- `MAG_PIPELINE_V2_EXPERIMENT.md` ΓÇö canonical Local: `MAG-Ecosystem` repository root; Drive object: `<DRIVE-DOC:MAG_PIPELINE_V2_EXPERIMENT>`.
- `MAG_PIPELINE_V2_EVALUATION.md` ΓÇö canonical Local: `MAG-Ecosystem` repository root; Drive object: `<DRIVE-DOC:MAG_PIPELINE_V2_EVALUATION>`.

Both retain the existing Drive folder `<DRIVE-FOLDER:MAG_PIPELINE_V2>`. Physical placement in the ecosystem repository or Drive does not place them in the six-file Global authority set. They belong to `SYNC #2` or exact-filename scope, not `SYNC GLOBAL`. Do not create copies in TagSynchronizer or rename existing counterparts. The approved Git baseline was established in `2e16465`, followed by the Evaluation pilot-activation record in `3c5f864`; both documents are now available for stable discovery in their registered project scope. Stable registration grants synchronization eligibility only, not substantive authority. Detailed registration and validation rules remain in `MAG_DOCUMENTATION_OPERATIONS.md` ┬º5.

**Pipeline v2 post-promotion state:** after Product Owner-approved Global promotion of validated `#2` / `1.1.0` findings, these two documents remain **historical experiment / evaluation evidence only**. They are **not** parallel Global process authority. Durable HOW remains in the six-file Global documentation set. Currently ACTIVE Process Overlay Pool entries may temporarily specialize process/HOW inside their explicit scope until promotion, rejection, or withdrawal.

### Documentation filename conventions

This is the authoritative MAG convention for development-specific documentation filenames at the ecosystem level.

1. Global-only files keep their existing unique filenames (`MAG_ECOSYSTEM.md`, `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md`, `MAG_IMPLEMENTATION_PATTERNS.md`, `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`, `MAG_DOCUMENTATION_OPERATIONS.md`, `MAG_PROCESS_OVERLAY_POOL.md`, `MAG_XENFORO_ADDON_BLUEPRINT.md`, `MAG_DEBUGGING.md`). Do **not** add a `GLOBAL__` prefix to them.
2. `#N` XenForo Product documentation uses `P<NN>__<CODE>__<Document>.md`.
3. `A<N>` Software Product documentation uses `A<NN>__<CODE>__<Document>.md` when adopted through an approved procedure.
4. `B<NN>__<CODE>__<Document>.md` remains the reserved filename prefix for the `B<N>` namespace. Do not adopt `B<N>` documentation while `B<N>` is reserved.
5. `#N` remains the permanent logical XenForo Product identifier. `P01`, `P02`, and later are the filename representation of `#1`, `#2`, and later. The prefix does not replace `#N`.
6. Each `#N` project receives one short, stable project code recorded in the registry above (`GLF`, `TS`, ΓÇª).
7. Existing project documentation should use the convention after controlled migration.
8. New `#N` XenForo Products should use the convention from bootstrap.
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

- `#N` and `A<N>` identify assignable active development identities in Global registry, reports, and AI context (`#1`, `#2`, `A1`, ΓÇª). `B<N>` remains a reserved prefix and is not a current working identity.
- `Global` identifies MAG-Ecosystem process work. It is not a substitute for a registered product identity such as `A1`.
- For `#N` XenForo Products only: repository names, add-on IDs, and PHP namespaces follow XenForo / MAG product identity (for example `MAG/GlobalLinksFavicons`), not the `#N` marker.
- `#N` project documentation filenames use `P<NN>__<CODE>__` as defined above so the same files are identifiable in local clones, GitHub, Cursor, and ChatGPT Project.

## AI context isolation

When working on a MAG development:

1. Load **Global** MAG documentation from `MAG-Ecosystem`, including currently ACTIVE Process Overlay Pool entries and applicable operational assets.
2. Load **that development's** product documentation and code.
3. Do **not** load other developments' TZ, REQUIREMENTS, PLAN, Roadmap, Architecture, CLASS_MAP, Changelog, or research notes unless the task explicitly requires them.

Examples:

- work on `#1` = GLOBAL + [MAG] Global Links Favicons; `#2`, `A1`, and other developments are out of scope;
- work on `#2` = GLOBAL + [MAG] Tag Synchronizer; `#1`, `A1`, and other developments are out of scope;
- work on `A1` = GLOBAL + [MAG] GPT\|Cursor\|Sync; `#1`, `#2`, `A2`, and other developments are out of scope;
- work on `A2` = GLOBAL + [MAG] Art Environment; `#N`, `A1`, and other developments are out of scope;
- work on Global documentation = GLOBAL only.

Do not modify one MAG repository while the approved procedure is scoped to another.

Current canonical authority is the current retrieved body of the logical document identified by MAG-Document-ID, together with an explicit current Product Owner decision where the HOW hierarchy requires it. Resolve that body from the executor-specific documentation surface owned by [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md): ChatGPT with available Google Drive access retrieves Drive directly; Cursor uses Local first and may compare Mirror for freshness; Cursor does not access Google Drive by default. No managed location is the universal MAG authority. Existing comparison, conflict, and synchronization rules still govern. Mirror CHECK/baseline is not a registration predicate.

Conversation history, conversation summaries, ChatGPT Project copies, agent reports, and prior assistant statements are continuity or evidence claims. They do not become MAG authority merely because they are already in the session. If they conflict with a current canonical owner, report the conflict; do not silently prefer the conversation.

A MAG coordination session must resolve current MAG_ECOSYSTEM.md before substantive MAG coordination, then only the further owners required by the task. If required identity, applicable owner, or required rule becomes uncertain later in the same session, re-resolve that current canonical authority. Do not assume an earlier read remains reliably represented.

If required task-specific context cannot be recovered from current canonical documentation and still-reliable Product Owner decisions, stop authoritative coordination that depends on it and say what is unreliable. Do not invent the missing state.

## Documentation authority model

Each Global file has one primary authority. Do not duplicate its detailed rules in other Global documents.

| Source | Authority |
| --- | --- |
| `MAG_ECOSYSTEM.md` | Ecosystem identity; Product Class, Surface, Technology, and Applicability taxonomy; namespace registry; documentation map; authority navigation; and GLOBAL + active development identity context isolation. |
| `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` | Canonical Global Core Lifecycle and the `#N` XenForo Product specialization/profile: numbered Gates, Phase transitions, process hierarchy (`Lifecycle ΓåÆ Phase ΓåÆ Increment ΓåÆ Step`), Phase Authorization, Phase 7 product correctness, Phase 8 shipping correctness, Normal Release Fast Path, documentation timing, and XenForo add-on version identity. Not `#N`-only. Does not redefine detailed rules owned by other Global documents. |
| `AI_GUIDELINES.md` | Detailed development standards, principles, Evidence Inheritance, Validation Delta, Phase closure mechanics, coherent closure, consolidated state recording, goal-bound completion, ChatGPT/Cursor retrieval-surface routing, operational workflow, Cursor prompt presentation, and Cursor model-selection / model-routing policy. |
| `AI_AGENTS_RULES.md` | Coding-agent execution boundaries, mandatory Cursor pre-flight, checkpoints, and applicable report requirements. |
| `MAG_IMPLEMENTATION_PATTERNS.md` | Reusable, source-backed technical knowledge base and its capture/maintenance procedure. Subordinate to Global process documents and active-development TZ, Roadmap, and Architecture. Not a source of product requirements or process rules. |
| `MAG_DOCUMENTATION_OPERATIONS.md` | Documentation identity validation, synchronization scope and commands, executor documentation surfaces, Fast Sync as the normal proven-state path, executor capability, comparison, conflict handling, approval, execution, verification, cleanup, reporting, and Git handoff boundaries. |
| `MAG_PROCESS_OVERLAY_POOL.md` | Ecosystem-level ACTIVE process/HOW overlays only. Not a seventh canonical authority owner. Individual MPO records are not standalone documents. |
| Global operational assets | Blueprint, XenForo templates, and `MAG_DEBUGGING.md` implement Global rules and ACTIVE overlays. They do not independently define policy. |
| Project TZ | **What** that `#N` XenForo Product must do. Complete functional requirements. Canonical file: `P<NN>__<CODE>__TZ.md`. Does not require every requirement to ship in 1.0.0. `A<N>` Product WHAT remains in that identity's approved documentation; this row does not invent an `A<N>` eight-document package. |
| Project Architecture | Approved implementation architecture for that product. Describes intended and verified structure; it does not override TZ. |
| Project Roadmap | Approved sequencing, verified progress, and the approved first-release implementation slice. Controls what may be implemented **now**. Gate 1 semantics are in `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`. |
| Project CLASS_MAP | Current classes and responsibilities as they exist in code. |
| Project README / overview documents | Descriptive. Not a source of new requirements or process. |
| Project IDEA | Non-authoritative product exploration, Phase 0 reasoning/evaluation, alternatives, historical/superseded concepts, and future concepts. Must not override TZ, Architecture, Roadmap, Global HOW, or ACTIVE overlays. Need not remain current product truth. |
| Changelog and Git history | Historical. Preserve as history. Do not rewrite the past to match a later decision. |

**Code currently in the development repository is authoritative for what exists.** Requirements and process documents are authoritative for what is approved. Planned work is not implemented work.

## Conflict handling

Meaningful conflicts must be **reported**, not silently resolved by assumption.

For process/HOW conflicts, apply this precedence:

1. explicit current Product Owner decision;
2. ACTIVE MAG Process Overlay Pool entry, inside its explicit scope;
3. canonical Global owning document;
4. Global operational asset such as Blueprint/templates;
5. active-development process representation.

This precedence does not apply to product WHAT, approved project requirements, architecture decisions, implementation scope, or release content. An ACTIVE overlay must not silently redefine those boundaries. If it explicitly affects Git, release, security, registration, or lifecycle authorization, that effect must be stated in the Pool entry.

If two ACTIVE overlays conflict, or overlay scope is ambiguous, stop the affected action and require Product Owner resolution. Do not choose arbitrarily. If a newer explicit Product Owner decision makes an overlay impossible, record supersession or withdrawal.

Examples of meaningful conflicts:

- Global process vs. a development-specific instruction;
- TZ vs. Architecture vs. Roadmap vs. current code;
- two Global documents disagreeing after migration;
- two ACTIVE overlays disagreeing inside overlapping scope;
- an undocumented XenForo behavior vs. an assumed API.

Report the conflict, identify the documents and facts involved, and wait for resolution. Do not invent a compromise that changes product behavior or process without approval.

## High-level MAG development workflow

The ordered lifecycle, stage gates, and documentation timing for `#N` XenForo add-ons are canonical in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md).

Detailed development, stage/phase closure, release-artifact mechanics, and Cursor model-selection policy remain in `AI_GUIDELINES.md`; agent execution and checkpoints remain in `AI_AGENTS_RULES.md`. Reusable-knowledge capture mechanics remain in `MAG_IMPLEMENTATION_PATTERNS.md`.

Project Roadmaps apply the Global lifecycle to approved `#N` project increments; they do not authorize automatic progression.

---

## High-level responsibility model

| Role | Responsibility |
| --- | --- |
| **User** | Product owner. Approves requirements, sequencing, reviews, Git, and releases. Final repository control. |
| **ChatGPT** | Architecture, requirements, sequencing, and review partner. Retrieves MAG documentation from Google Drive directly when that connector is available. Does not silently replace Cursor Agent implementation or user Git. |
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

Multiple surfaces, clients, or repositories of **one** identity are not a shared ecosystem component and do not by themselves require extraction.

Until a real cross-development component is approved:

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

When a new MAG development is approved in a given assignable namespace:

1. Assign a permanent identifier in `#N` or `A<N>` by explicit Product Owner decision. Do **not** assign `B<N>` while it remains reserved. For `#N`, verify the chosen identifier against the current registry. Do not renumber an approved identity, invent a product, silently fill an unused gap, or assume that a higher existing identity forces the next number. Unused gaps remain assignable unless explicitly retired.
2. Record product name, status, project code, intended Git repository name, and applicable filename convention metadata. Record surfaces as product facts when known; they do not create extra identities. A permanent `#N` identity may be assigned after Project Approval even when Local/Git is unavailable; record pending prerequisites without claiming stable registration.
3. Create the development repository structure (separate from `MAG-Ecosystem`) when applicable and available. Additional repositories of the same identity, if later approved, do not create another identity. For `#N`, Full Bootstrap or Local/Git-First completes Local/Git prerequisites; Drive-First Bootstrap may defer them under the explicit incomplete state below. Git actions remain separately Product Owner-controlled.
4. For every new `#N`, instantiate the eight bootstrap-created documents above in one coherent Product Owner-approved bootstrap scope, validate it, synchronize Drive counterparts when that work is in the approved scope, and verify the local package without per-file approval loops. Deferred Drive counterparts remain Drive Reconciliation Pending. For `A<N>`, select documentation from actual approved needs; the XenForo package does not apply. Do not create a second-level process stack, template set, or operational asset for `A<N>` by default.
5. Do not copy another development's requirements, architecture, or code "as a template" beyond true Global process.
6. Do not create copies or pointer files of Global process documents in the new development.
7. Do not create shared components as part of bootstrap.

For `#N`, Drive-First, Local/Git-First, Full, and Resume are normal documentation-surface paths owned by `MAG_DOCUMENTATION_OPERATIONS.md` ┬º5. Drive-First follows Project Approval and permits substantive documentation work on Drive under **Bootstrap Incomplete ΓÇö Local/Git Pending**. Local/Git-First may complete Local/Git Bootstrap Complete while Drive is deferred. Resume Bootstrap reuses the permanent identity, current Drive documents when they exist, and completed work; establishes the Local repository structure including `/docs/`; and completes the separately authorized Git baseline required for **Local/Git Bootstrap Complete** and stable registration. Reconcile an existing Drive package into Local when those counterparts exist. Deferred Drive counterparts remain **Drive Reconciliation Pending** and do not invalidate Phase 1 completion or revert registration to provisional. Do not restart requirements or architecture merely because the device changed. Lifecycle states and two-level bootstrap authority belong to `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 1. Bootstrap completion does not authorize commit, push, tag, or release.

`#2` [MAG] Tag Synchronizer is registered. Current identity, status, version, repository, and local path are in the `#N` registry table above. It inherits Global rules by reference. It must not contain local copies of Global documentation files from `MAG-Ecosystem`.

`#4` [MAG] Doc&Guide is an approved XenForo identity. Current identity, status, repository, and local path are in the `#N` registry table above. Phase 1 reached **Local/Git Bootstrap Complete** through Drive-First ΓåÆ Resume Bootstrap. Drive state: **Drive Reconciled**. Local and Drive documentation reconciled after the 2026-09-22 Drive-first Phase 3 preparation update. It inherits Global rules by reference and must not contain local copies of Global documentation files from `MAG-Ecosystem`.

`#9` [MAG] Donatello Integration is an approved XenForo identity. Current identity, status, repository, and local path are in the `#N` registry table above. Phase 1 **Local/Git Bootstrap Complete** (`2026-09-26`). Phase 2 **Requirements Definition** complete; **Gate 1 PASS** (`2026-09-27`). Phase 3 **Targeted Research and Verification** complete (`2026-09-27`); **Phase 4 Architecture** is next and not started. Drive state: **Drive Reconciliation Pending**. Implementation and Architecture approval are **not** granted. It inherits Global rules by reference and must not contain local copies of Global documentation files from `MAG-Ecosystem`.

`#10` [MAG] Telegram Bridge is an approved XenForo identity. Current identity, status, repository, and local path are in the `#N` registry table above. Phase 1 reached **Local/Git Bootstrap Complete** through Local/Git-First on `2026-09-27`. XenForo add-on namespace: `MAG/TelegramBridge`. Drive state: **Drive Reconciliation Pending**. Phase 2 Requirements Definition is next. Gate 1, Architecture, and implementation are **not** approved or authorized. It inherits Global rules by reference and must not contain local copies of Global documentation files from `MAG-Ecosystem`.

## Current MAG-Ecosystem repository contents

This heading names the **canonical Global authority documents and the XenForo operational template tree**. It is **not** an exhaustive inventory of the MAG-Ecosystem Git repository. Historical Experimental/Evaluation documents, `tools/`, `generated/` artifacts, and other non-authority paths may exist; they are not additional Global owners. Those paths are discovered from their owning sections (for example Experimental / Evaluation documents above) and [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md).

The Global owners / operational assets currently recorded here are:

- `MAG_ECOSYSTEM.md`
- `AI_GUIDELINES.md`
- `AI_AGENTS_RULES.md`
- `MAG_IMPLEMENTATION_PATTERNS.md`
- `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`
- `MAG_DOCUMENTATION_OPERATIONS.md`
- `MAG_PROCESS_OVERLAY_POOL.md`
- `MAG_XENFORO_ADDON_BLUEPRINT.md`
- `MAG_DEBUGGING.md`
- `templates/xenforo-addon/*`
