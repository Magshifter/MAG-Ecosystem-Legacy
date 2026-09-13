# MAG Add-on Development Lifecycle

- MAG-Document-ID: `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`
- MAG-Content-Updated: `2026-09-13T10:08:03+00:00`

This document defines the Global MAG lifecycle for developing and maintaining **MAG XenForo add-ons (`#N`)**.

**Scope:** This lifecycle applies to **`#N` MAG XenForo Projects** unless a separately approved lifecycle exists for another development class. Process rules that are not XenForo-specific remain available through GLOBAL + active development identity, but XenForo-only phases, gates, and release mechanics in this document apply only where the active identity is `#N`.

It defines the ordered development path from an initial idea through project approval, requirements, technical verification, architecture, implementation, validation, release, post-release verification, reusable-knowledge capture, and subsequent maintenance.

This document is the canonical Global authority for the ordered add-on lifecycle, stage gates, and documentation timing: when documents are created, updated, reviewed, and finalized.

Detailed rules remain in their owning Global documents. This lifecycle references those rules; it does not replace or independently redefine them.

It does not replace:
- [MAG_ECOSYSTEM.md](MAG_ECOSYSTEM.md)
- [AI_GUIDELINES.md](AI_GUIDELINES.md)
- [AI_AGENTS_RULES.md](AI_AGENTS_RULES.md)
- [CURSOR_USAGE_ANALYTICS.md](CURSOR_USAGE_ANALYTICS.md)
- [MAG_IMPLEMENTATION_PATTERNS.md](MAG_IMPLEMENTATION_PATTERNS.md)
- any active project TZ, Roadmap, Architecture, CLASS_MAP, Changelog, README, or approved research/audit documentation.

GLOBAL defines HOW.
Active development defines WHAT.

Detailed development rules remain in AI_GUIDELINES.md.
Coding-agent execution rules remain in AI_AGENTS_RULES.md.
Cursor model-selection / model-routing policy remains in AI_GUIDELINES.md §24.4.
Cursor usage telemetry remains in CURSOR_USAGE_ANALYTICS.md.
Reusable technical knowledge remains in MAG_IMPLEMENTATION_PATTERNS.md.
Project identity and documentation authority remain in MAG_ECOSYSTEM.md.


### Authority boundaries and adoption

The lifecycle applies to GLOBAL + the active `#N` XenForo project. Project document authority, identity, naming, and context isolation remain defined in [MAG_ECOSYSTEM.md](MAG_ECOSYSTEM.md).

Lifecycle transitions do not enlarge an agent's authorized scope. Apply [AI_AGENTS_RULES.md](AI_AGENTS_RULES.md) to execution in every phase, including research, documentation, and release work. Apply [AI_GUIDELINES.md](AI_GUIDELINES.md) §24 whenever a phase uses Cursor for prompt presentation, post-execution review, or model routing. Apply [CURSOR_USAGE_ANALYTICS.md](CURSOR_USAGE_ANALYTICS.md) whenever a phase uses Cursor for usage metrics and measurement; this document does not define telemetry fields, automatic After consumption, or usage-value display formats.

The Global documentation map in MAG_ECOSYSTEM.md includes this lifecycle and MAG_IMPLEMENTATION_PATTERNS.md. Keep that map synchronized when an approved Global document or authority boundary changes.

Process/HOW execution must honor currently ACTIVE entries in [`MAG_PROCESS_OVERLAY_POOL.md`](MAG_PROCESS_OVERLAY_POOL.md) inside their explicit scope. An ACTIVE overlay may temporarily specialize this lifecycle's process behavior until promotion, rejection, or withdrawal. Do not enlarge overlay scope and do not duplicate an ACTIVE overlay as a second permanent rule set here.

If another Global document contains an incompatible lifecycle sequence or documentation-timing rule, identify the exact conflict for Product Owner resolution and synchronize the owning documents through an approved change. Do not silently select a rule or duplicate its detailed implementation here.

## 1. Purpose

The purpose of this lifecycle is to ensure that MAG add-ons are developed in a controlled order:

```text
Idea
→ Evaluation
→ Project Approval
→ Project Bootstrap
→ Requirements
→ Targeted Research and Verification
→ Architecture
→ Architecture Approval
→ Implementation Planning
→ Incremental Implementation
→ Integration and Final Validation
   → Product Owner Practical Acceptance
→ Release Readiness
→ Release Finalization
   → Release Presentation
   → final release package build and validation
→ Stable Release
→ Post-Release Verification
→ Knowledge Capture
→ Maintenance / Next Version
```

The lifecycle prevents implementation from becoming the mechanism through which requirements or architecture are discovered accidentally.

The amount of work performed in each phase must remain proportional to the complexity, uncertainty, and risk of the project or change.


## 2. Lifecycle principles

The lifecycle follows these principles:

1. Requirements precede architecture.
2. Architecture precedes implementation when architecture decisions are required.
3. Uncertain XenForo/XFRM behavior is verified before architecture relies on it.
4. Research is targeted to unresolved technical questions rather than performed as a mandatory broad audit.
5. Existing verified MAG knowledge should be reused when its verified scope applies.
6. Implementation is incremental.
7. Validation is proportional to actual risk.
8. Documentation evolves with the project and must describe verified state.
9. Historical records remain historical.
10. Reusable technical knowledge is captured only when justified.
11. Stable releases become the baseline for subsequent development.
12. The Product Owner controls approval gates, implementation authorization, Git checkpoints, and releases.
13. Product Owner technical-lead learning develops progressively through practical, stage-specific learning after meaningful Cursor procedures. ChatGPT provides concise Ukrainian learning notes as part of post-execution review per [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §24.3. Learning notes deepen progressively as Product Owner experience grows. They do not authorize execution and do not replace requirements, architecture, or validation authority.

A smaller project may pass through some phases quickly.

A complex or uncertain project may require multiple research and architecture iterations.

Scaling the amount of work must not reverse the decision order.


## 3. Lifecycle state model

A project or release may be in one primary lifecycle phase at a time.

Possible high-level states include:

- Idea
- Evaluation
- Requirements Definition
- Research / Verification
- Architecture Planning
- Implementation Planning
- Implementation
- Validation
- Release Finalization
- Stable
- Maintenance

Project Roadmap documentation records the approved current sequencing and verified progress.

Planned work must not be represented as implemented work.

### Closure prerequisite for phase transitions

Before advancing from a completed logical stage or phase, complete the mandatory closure procedure in [AI_GUIDELINES.md](AI_GUIDELINES.md) §20 and the applicable execution/checkpoint rules in [AI_AGENTS_RULES.md](AI_AGENTS_RULES.md) §10. An output ready for review is not a closed phase. Local/Git closure applies to Full Bootstrap and Resume Bootstrap completion. Documentation-only Drive-First progression in Phase 1 does not require Local/Git closure while Local/Git remains pending. Drive-First is a normal Phase 1 pause state while the current ACTIVE bootstrap overlay applies.

Research/architecture iterations and intermediate actions within the same approved logical phase do not create artificial Git checkpoints. Existing project phase/stage identifiers remain historical identifiers; record their mapping to this lifecycle without renumbering completed history.

### Coherent lifecycle blocks

Related approved lifecycle actions that share one uninterrupted objective **SHOULD** execute as one coherent block when no material state change or recovery boundary requires separation.

Typical uninterrupted release objective:

```text
Gate
→ Release Finalization
→ package/release actions
→ Stable Release actions
→ Post-Release Verification
→ final documentation closure
```

These actions must **not** automatically become separate Git checkpoints, validation cycles, Cursor/Work invocations, or Product Owner confirmation cycles merely because lifecycle labels changed.

Coherent blocks may remove artificial checkpoints, repeated validation, repeated confirmations, and micro-procedures. They **MUST NOT** remove mandatory Global checkpoints or genuine Product Owner-controlled authorization boundaries. Distinct gates retain separate evidence and formal results even when executed within one coherent block.

Apply the material-change and checkpoint-protection filters in [AI_GUIDELINES.md](AI_GUIDELINES.md) §§18–20 and [AI_AGENTS_RULES.md](AI_AGENTS_RULES.md) §10. Lifecycle label change alone is not a checkpoint reason.

### Immediate gate evaluation

When the Product Owner activates or authorizes a gate and all evidence required to evaluate that gate is already available, evaluate the gate immediately in the same interaction and return the formally defined gate result (`PASS`, `BLOCKED`, or another result defined for that gate). Do not request another Product Owner confirmation solely to begin evaluation of the already-authorized gate.

Required semantics:

```text
Product Owner authorization/activation
→ immediate gate evaluation
→ PASS / BLOCKED / other formally defined gate result
```

Clarifications:

- Product Owner control remains unchanged.
- Required Product Owner authorization is still mandatory.
- Missing, contradictory, or stale evidence is a stop condition, not a satisfied prerequisite.
- Gate `PASS` is only the gate result.
- Gate `PASS` does **not** authorize a later Product Owner-controlled lifecycle stage when Global rules or the project Roadmap define that authorization separately.
- Implementation authorization, Gate 3 approval of release finalization, Stable Release authorization, Git/tag/publication authorization, and similar remain separate where this lifecycle defines them.

## 4. Phase 0 — Idea and Evaluation

### Purpose

Determine whether a proposed add-on or major product concept should become a MAG project.

### Entry conditions

A product idea, problem, opportunity, or candidate add-on concept exists.

### Required work

Clarify at a high level:

- the problem being solved;
- intended users;
- expected product value;
- approximate product boundary;
- relationship to XenForo/XFRM or other required platform components;
- obvious overlap with an existing MAG project;
- whether the concept appears sufficiently distinct to justify a separate product.

Do not define detailed implementation architecture during this phase.

### Conditional work

Working IDEA material may be used when the concept requires research, alternatives, unresolved thinking, or historical preservation.

IDEA is non-authoritative. It does not need to remain current product truth. Distinguish historical or superseded reasoning from later approved TZ when both exist.

### Documentation actions

Before Gate 0, a permanent `#N` may not yet exist. Phase 0 reasoning may remain outside the canonical project structure until Project Approval.

After Gate 0, Phase 1 instantiates `P<NN>__<CODE>__IDEA.md` as a mandatory package container. Presence of that file is not completed evaluation and does not approve the project.

### Completion conditions

The Product Owner has enough information to decide whether to:

- approve the project;
- reject it;
- defer it;
- continue evaluation.

### Gate 0 — Project Approval

Only the Product Owner may approve creation of a new MAG project.

Approval authorizes:

- assignment of the next sequential #N;
- assignment of a stable project code;
- repository bootstrap;
- canonical project documentation bootstrap.

Approval does not authorize product implementation.


## 5. Phase 1 — Project Bootstrap

### Purpose

Create the controlled identity and documentation foundation for the approved project.

### Entry conditions

Gate 0 passed.

### Required work

Follow the approved-project bootstrap procedure in [MAG_ECOSYSTEM.md](MAG_ECOSYSTEM.md). This phase owns its place in the lifecycle; project identity, registry, repository, and naming mechanics remain in that document.

### Documentation actions

Instantiate all nine canonical project documents defined in MAG_ECOSYSTEM.md as one coherent Product Owner-approved bootstrap package. A mandatory container is not mandatory substantive work. Use honest initial-state content where requirements, architecture, implementation, usage records, or audit findings do not yet exist. Document creation grants neither substantive approval nor implementation authorization.

AUDIT is the standard parent/core evidence document. Use it directly or add only justified child audits; do not create a mandatory child-audit set.

### Bootstrap modes

**Full Bootstrap:** establish the approved identity and verified documentation package, Local repository structure including `/docs/`, applicable counterparts, and the separately authorized Git baseline required for stable registration.

**Drive-First Bootstrap:** after Gate 0, establish the permanent identity and canonical package on Drive when Local/Git is unavailable. Record **Bootstrap Incomplete — Local/Git Pending** in README and Roadmap. Requirements, targeted research, architecture, and other approved documentation work may continue on Drive, subject to their normal substantive approval gates. Drive-First is a normal Phase 1 state, not an exception. An ACTIVE Process Overlay may temporarily specialize bootstrap HOW until promotion. This path does not claim Phase 1 fully complete, stable registration, implementation authorization, or release readiness.

**Resume Bootstrap:** reuse the identity, current Drive package, approvals, and completed work. Create or complete the Local structure including `/docs/`, reconcile the current canonical Drive bodies into the approved Local locations, then complete the separately authorized Git baseline and stable registration. Do not repeat requirements or architecture solely because bootstrap started on another device.

One approved bootstrap scope covers the package; do not require nine approvals or repeat an already sufficient bootstrap authorization. Detailed batch onboarding, safe writes, reconciliation, and whole-package verification belong to MAG_DOCUMENTATION_OPERATIONS.md §5.

### Completion conditions

Full bootstrap completion requires:

- verified permanent identity and canonical naming;
- the nine-document package describing the actual current state;
- Local repository structure and reconciled applicable counterparts;
- the Product Owner-authorized Git baseline and stable registration;
- successful package verification.

Drive-First permits documentation work to proceed while these Local/Git conditions remain explicitly pending. Resume Bootstrap closes them without resetting verified substantive progress. Bootstrap completion alone never authorizes commit, push, tag, or release.

## 6. Phase 2 — Requirements Definition

### Purpose

Define WHAT the product must do before deciding HOW it will be implemented.

### Entry conditions

Full Bootstrap is complete, or the approved Drive-First identity and verified canonical package are available with Local/Git prerequisites explicitly pending under Phase 1.

### Required work

Define:

- purpose;
- functional requirements;
- supported workflows;
- scope;
- explicit non-goals;
- user-visible behavior;
- failure expectations where product-relevant;
- permissions expectations;
- compatibility requirements;
- dependency requirements;
- localization readiness for every `#N`: TZ must consider user-facing and admin-facing text and require XenForo-native phrases/localization where that text exists;
- relevant edge cases;
- unresolved product decisions.

Localization readiness begins with requirements and architecture. Hardcoded user/admin-facing UI strings are not the normal implementation path. Multiple translations are not required at bootstrap; record applicability honestly when no UI/text exists.

Do not turn implementation convenience into a product requirement.

Do not silently infer architecture from donor code or existing accidental implementation.

### Documentation actions

Primary authoritative document:

- `P<NN>__<CODE>__TZ.md`

Roadmap should record Requirements Definition as the active phase and must not claim implementation progress that does not exist.

IDEA remains non-authoritative and need not remain current product truth.

### Completion conditions

- requirements are internally coherent;
- unresolved product decisions that block architecture are resolved;
- scope and non-goals are explicit;
- compatibility target is sufficiently defined for technical investigation;
- Product Owner approves the TZ.

### Gate 1 — Requirements Approval

The Product Owner approves WHAT the product must do.

After approval, TZ becomes authoritative for product requirements.

Architecture must not silently change approved requirements.


## 7. Phase 3 — Targeted Research and Verification

### Purpose

Resolve technical uncertainty required to make architecture decisions.

### Entry conditions

Relevant requirements are sufficiently understood.

### Required work

First identify what is unknown.

Research only the technical questions needed for the current architecture.

Potential sources include:

- current project code;
- installed XenForo source;
- installed XFRM source;
- applicable verified MAG Implementation Patterns;
- approved project research;
- third-party donor add-ons as non-authoritative evidence;
- official XenForo documentation when installed source is insufficient and its use is appropriate under Global rules.

### Existing knowledge first

Before starting an expensive investigation, search applicable verified MAG reusable knowledge.

Reuse it only when its verified scope matches the current problem.

Entries marked Needs Revalidation or otherwise version/environment-specific must be revalidated where required.

### Donor boundary

Third-party add-ons may identify candidate mechanisms.

They do not establish XenForo/XFRM truth.

Relevant donor conclusions must be independently verified against authoritative native behavior before architecture relies on them.

### Documentation actions

Create a dedicated research/audit document only when it has a real evidence-preservation purpose.

Examples:

- `P<NN>__<CODE>__NATIVE_SOURCE_AUDIT.md`
- `P<NN>__<CODE>__DONOR_AUDIT.md`
or a procedure-specific research document using the project prefix.

Small source findings may instead be recorded directly in the project document that owns the resulting verified fact.

Do not create audit documents merely to satisfy the lifecycle.

### Completion conditions

For the architecture decision being considered:

- required technical uncertainty has been resolved or explicitly recorded;
- verified facts are distinguishable from assumptions;
- unresolved blockers are identified;
- evidence exists for the next architecture decision.

Research and Architecture may iterate:

```text
Research
→ Architecture decision
→ new uncertainty
→ targeted Research
→ Architecture decision
```

This is not permission for open-ended research.


## 8. Phase 4 — Architecture Planning

### Purpose

Define HOW the approved requirements will be implemented using verified technical facts.

### Entry conditions

- relevant requirements are approved;
- sufficient technical evidence exists for the architecture decisions currently being made.

### Required work

Define only architecture required by approved scope.

Where applicable, establish:

- XenForo/XFRM integration points;
- lifecycle boundaries;
- services/components;
- data flow;
- persistence;
- permission boundaries;
- validation boundaries;
- transaction behavior;
- recursion/reentrancy behavior;
- background work;
- failure behavior;
- upgrade/install behavior;
- compatibility boundaries;
- security boundaries;
- performance-sensitive paths;
- class responsibilities at the architectural level;
- XenForo-native phrase/localization design for user-facing and admin-facing UI text where it exists.

Architecture decisions may be approved incrementally.

Incremental approval does not authorize implementation unless the project explicitly reaches the implementation approval gate.

### Documentation actions

Primary:

- `P<NN>__<CODE>__Architecture.md`

Supporting:
- `P<NN>__<CODE>__Roadmap.md`
relevant research/audit documents

TZ changes only when an actual requirement decision changes.

Architecture must not overwrite TZ authority.

### Completion conditions

- architecture covers the approved requirements sufficiently for implementation planning;
- Critical architecture questions are resolved;
- known technical assumptions are identified;
- required compatibility boundaries are established;
- no unresolved issue prevents safe implementation;
- Product Owner has reviewed the Architecture.

### Gate 2 — Architecture Approval

The Product Owner approves the implementation architecture.

Until this gate passes, implementation remains blocked when the project requires architecture approval.

Architecture approval authorizes implementation planning, not uncontrolled implementation.


## 9. Phase 5 — Implementation Planning

### Purpose

Convert approved requirements and architecture into small executable increments.

### Entry conditions

Gate 2 passed.

### Required work

Define implementation stages/increments.

Each increment should establish:

- exact goal;
- expected behavior;
- relevant requirements;
- relevant architecture decisions;
- dependencies;
- likely affected subsystem;
- what must not change;
- validation criteria;
- completion criteria.

Avoid planning speculative future implementation detail beyond what is useful for controlled sequencing.

### Documentation actions

Primary:

- `P<NN>__<CODE>__Roadmap.md`

Architecture remains authoritative for implementation design.

TZ remains authoritative for requirements.

### Implementation authorization

After planning, the Product Owner must authorize the defined increment before Phase 6 starts. Gate 2 alone is not implementation authorization. An existing explicit authorization remains valid within its stated scope; routine steps inside that scope do not require repeated approval. Approval of one increment does not authorize later increments.

### Completion conditions

At least the next implementation increment is sufficiently defined to execute safely.

The entire future release does not need to be decomposed into artificial micro-stages before useful implementation can begin.


## 10. Phase 6 — Incremental Implementation

### Purpose

Implement the approved product in controlled, reviewable increments.

### Entry conditions

- relevant requirement is approved;
- relevant architecture is approved;
- current increment is approved and sufficiently defined.

### Required cycle

Apply the detailed development and validation rules in [AI_GUIDELINES.md](AI_GUIDELINES.md), and execution, reporting, and checkpoint rules in [AI_AGENTS_RULES.md](AI_AGENTS_RULES.md).

For each increment:

```text
Approved increment
→ inspect existing implementation
→ inspect only relevant dependencies
→ make the smallest sufficient change
→ perform relevant validation
→ inspect resulting changes
→ synchronize affected documentation
→ user review
→ mandatory closure for a completed logical stage/phase under AI_GUIDELINES.md §20
→ stop or proceed only to the next approved increment
```

Follow Existing Code First.

Prefer XenForo-native mechanisms.

Do not implement future stages merely because they are convenient to add now.

### Documentation actions

Update only affected documents.

Potentially affected:

- `P<NN>__<CODE>__CLASS_MAP.md`
- `P<NN>__<CODE>__Architecture.md`
- `P<NN>__<CODE>__Roadmap.md`
- `P<NN>__<CODE>__Changelog.md`
- `P<NN>__<CODE>__README.md`
- `P<NN>__<CODE>__Overview.md`
- `P<NN>__<CODE>__CURSOR_USAGE_HISTORY.md`

TZ changes only when approved product requirements change.

CLASS_MAP must describe code that actually exists.

Architecture must describe approved/verified architecture rather than speculative future implementation.

Roadmap must distinguish completed, current, and planned work.

Changelog remains historical.

### Completion conditions for an increment

- required implementation exists;
- relevant validation passed; if required manual validation remains, label the result pending validation rather than fully complete;
- Critical issues are resolved;
- affected documentation is synchronized;
- required user review and logical-stage closure under AI_GUIDELINES.md §20 are complete;
- no unrelated next-stage work was performed.


An increment awaiting required review, manual validation, or closure remains pending; it must not be marked complete or used to authorize the next logical stage.

## 11. Phase 7 — Integration and Final Validation

### Purpose

Verify that the completed release scope works as a coherent product rather than only as isolated increments.

Product Owner Practical Acceptance is the mandatory final acceptance step of this phase. The Product Owner personally exercises the completed release scope as a real user and, where relevant, administrator to detect workflow, usability, integration, and behavioral issues that formal automated or technical validation may not reveal.

### Entry conditions

Required implementation scope for the target release is complete.

### Required work

#### Technical integration and final validation

Validation depth is risk-based.

Where applicable verify:

- functional integration;
- regression behavior;
- XenForo/XFRM compatibility;
- security;
- permissions;
- persistence and lifecycle;
- performance;
- installation;
- upgrade behavior;
- packaging;
- frontend behavior;
- ACP behavior;
- localization readiness of user/admin-facing text, including native phrase use and resolution where applicable;
- failure paths;
- cleanup behavior.

Do not mechanically repeat expensive validation already performed when preceding valid evidence still applies.

Do not reduce required validation merely to reduce Cursor usage.

#### Product Owner Practical Acceptance (mandatory)

After required technical integration and final validation for the release scope has completed, the Product Owner must personally exercise the completed release scope in an appropriate local or otherwise relevant XenForo environment.

Practical Acceptance depth must be proportional to the product and release risk. Do not require an artificial exhaustive test script for every release.

Practical Acceptance must produce an explicit **PASS** or identify issues requiring correction.

This pre-release acceptance does not replace Phase 9 — Post-Release Verification, which remains responsible for issues observable only after actual release, deployment, or production use.

When Practical Acceptance finds a defect, classify the issue and return only to the earliest affected lifecycle point necessary for a proportional correction and revalidation. Preserve unaffected technical validation evidence; do not automatically repeat audits, architecture analysis, or broad regression work solely because Practical Acceptance failed.

### Documentation actions

Synchronize only affected authoritative project documents.

Record significant verified compatibility/security/performance findings in the document that owns them.

Record the Product Owner Practical Acceptance result explicitly when performed.

Create a separate validation/audit artifact only when preserving that evidence has a real future purpose.

### Completion conditions

- required validation for release risk has completed;
- no unresolved Critical issue remains;
- known limitations are documented accurately;
- product documentation reflects verified state;
- Product Owner Practical Acceptance has **PASS**.

Phase 7 is not complete, and Gate 3 — Release Readiness must not be entered, until required Product Owner Practical Acceptance has **PASS**.


## 12. Gate 3 — Release Readiness

The release may proceed to finalization only when:

- approved release requirements are satisfied;
- required implementation exists;
- required validation is complete;
- Product Owner Practical Acceptance has **PASS**;
- Critical issues are resolved;
- known limitations are accurately documented;
- release documentation is synchronized;
- the Product Owner approves release finalization.

Passing this gate does not itself publish the release.


## 13. Phase 8 — Release Finalization

### Purpose

Prepare and verify the actual release state and artifact.

Release Finalization includes **Release Presentation** as a mandatory component immediately before the final release package is built. Release Presentation is not a separate top-level lifecycle phase.

```text
Release Readiness
→ Release Finalization
   → Release Presentation
   → final release package build and validation
→ Stable Release
```

### Entry conditions

Gate 3 passed and the finalization scope is authorized.

### Release Presentation (mandatory)

Every MAG add-on must complete Release Presentation before the **final** release ZIP is built.

Release Presentation governs release-facing description, branded icon, Developer link, project-specific Support link, and Donate link. It does not redefine Local, integration, web, production, Release Readiness, or other existing validation processes.

#### Release-facing description

1. ChatGPT proposes the description using only approved/current documentation of the active `#N` project.
2. The Product Owner reviews it.
3. The Product Owner may correct it.
4. The Product Owner must explicitly approve the final text.
5. The main description must not exceed **150 characters**.
6. Do not invent functionality, claims, compatibility, or benefits not supported by approved project documentation.
7. The presentation must always include a separate final line:

```text
Made in Ukraine
```

The `Made in Ukraine` line is mandatory and is separate from the main description character limit.

#### MAG branded icon

Authoritative Global source:

```text
MAG-Ecosystem/magicon.png
```

Policy:

- required current size: **96×96 px**;
- this is the common branded icon for MAG add-ons;
- it remains the default until the Product Owner approves a new design concept;
- numbered project release work may consume/copy it as required by the verified XenForo-native mechanism;
- numbered projects must **not** modify the authoritative Global source file;
- do not resize, regenerate, redesign, or otherwise modify `magicon.png` during Release Presentation work in a numbered project repository.

Before use, verify that `magicon.png` exists and report its actual dimensions. If actual dimensions conflict with the approved 96×96 requirement, report the conflict. Do not modify the Global file to resolve the conflict during Release Presentation.

#### Developer link (fixed Global rule)

| Field | Value |
| --- | --- |
| Label | `Developer` |
| Display identity | `Magshifter` |
| URL | `https://bio.site/magshifter` |

This is reusable across MAG add-ons unless the Product Owner later changes the Global rule.

#### Support link (project/release-specific)

The Support URL is the URL of the Resource page for that specific add-on on the Product Owner's forum.

Rules:

- never invent it;
- never infer it;
- never substitute another URL;
- never use a placeholder in the final release package.

When the add-on is otherwise ready for final release packaging, ChatGPT must request the Resource URL from the Product Owner.

The Product Owner creates the Resource for the add-on on the forum and supplies its URL.

That exact Product Owner-supplied Resource URL becomes the Support URL for the release.

The final release package must **not** be built while a required Support URL is unknown.

#### Donate link (fixed Global rule)

| Field | Value |
| --- | --- |
| Label | `Donate` |
| URL | `https://donatello.to/Magshifter` |

This is reusable across MAG add-ons unless the Product Owner later changes the Global rule.

#### Required Release Presentation sequence

Within Release Finalization, use this sequence:

1. Confirm the project is at the appropriate existing Release Finalization point.
2. ChatGPT prepares the proposed release-facing description from approved `#N` documentation.
3. Product Owner reviews/corrects and explicitly approves the description.
4. Prepare the standard MAG icon from `MAG-Ecosystem/magicon.png`.
5. Prepare the fixed Developer and Donate information.
6. Request the project-specific Resource URL from the Product Owner.
7. Product Owner creates the add-on Resource on the forum and supplies its URL.
8. Use that exact Resource URL as Support.
9. Before implementation, verify the exact XenForo-native mechanism for:
   - icon;
   - description;
   - Developer link;
   - Support link;
   - Donate link;
   - release package inclusion.

   Use the applicable installed/reference XenForo source and native build tooling.

   Do not assume `addon.json` field names, file paths, asset locations, or package behavior.

10. Apply the approved Release Presentation metadata/assets using the verified XenForo-native mechanism.
11. Build the final release ZIP.
12. Validate the final release ZIP.
13. Synchronize affected project documentation under normal MAG rules.
14. Complete the logical Git checkpoint, push, and clean verification under normal MAG rules.
15. Only after Release Finalization is fully closed may the separate Product Owner Stable Release gate be considered.

#### Final package rule

A ZIP built before all required Release Presentation data is available is **not** the final Stable Release package when that presentation data must be included in the package.

In particular, when the Support URL belongs in the package metadata, a package built before the Product Owner supplies the Resource URL is preliminary and must be rebuilt after the approved Support URL is added.

#### Final release-package validation

Final release-package validation must verify, where applicable:

- approved version identity;
- approved description;
- mandatory separate `Made in Ukraine` line;
- approved MAG icon;
- Developer information/link;
- exact Product Owner-supplied Resource URL as Support;
- Donate link;
- expected XenForo-native metadata/assets;
- package integrity;
- expected package contents;
- absence of unintended repository, development, test, private, credential, or unrelated files.

Detailed release-artifact mechanics and Git rules remain in the appropriate Global documents.

#### Historical integrity

Do not rewrite historical project procedures or completed release records to pretend this Global rule existed earlier.

Projects that reached Release Finalization before adoption of this rule may complete the newly required Release Presentation work as a separate current procedure before Stable Release where applicable.

### Required work (after Release Presentation)

As applicable:

- verify release version metadata;
- verify add-on metadata/dependencies;
- verify canonical packaging;
- verify release artifact;
- verify required install/upgrade path;
- verify no development-only diagnostics remain;
- synchronize Changelog;
- synchronize README/Overview where product state changed;
- synchronize Roadmap;
- synchronize Architecture/CLASS_MAP where affected;
- synchronize Cursor usage history where applicable;
- inspect final repository diff/status;
- resolve release-blocking issues.

### Documentation actions

Release-related project documentation must describe the actual shipping state.

Historical entries must not be rewritten to pretend later decisions existed earlier.

### Completion result

Release Finalization must end with an explicit result such as:

- PASS
- BLOCKED
- FAIL

Only a confirmed PASS may proceed to Stable Release.

Phase 8 PASS confirms readiness of the final artifact and completed Release Presentation. It does not authorize publication.


## 14. Stable Release

### Purpose

Establish a new verified shipping baseline.

### Authority

The Product Owner controls:

- final release approval;
- Git commit/push where applicable;
- tags;
- publication;
- deployment.

AI and coding agents must not infer publication from a successful build or finalization.

### Result

After confirmed publication, the release becomes the current stable baseline.

Project documentation and ChatGPT Project context should be refreshed according to applicable Global documentation synchronization rules.


## 15. Phase 9 — Post-Release Verification

### Purpose

Detect issues that may appear only through real installation, upgrade, deployment, or production use.

### Entry conditions

A release has actually been installed, upgraded, deployed, or otherwise exercised in the relevant environment.

### Conditional work

Depending on risk:

- real upgrade verification;
- clean installation verification;
- production observation;
- runtime route verification;
- filesystem residue verification;
- compatibility observation;
- error-log review;
- performance observation.

Not every release requires an extensive production audit.

### Rule

A production observation is evidence, not automatically a formal benchmark or new requirement.

Unexpected behavior must be investigated before documentation or architecture is rewritten.

### Documentation actions

Update the project document that owns the verified result.

If a defect requires a hotfix, start the appropriate reduced maintenance lifecycle.

Preserve release history.


## 16. Phase 10 — Reusable Knowledge Capture

### Purpose

Determine whether completed work produced technical knowledge useful to future MAG projects.

### Entry conditions

Relevant implementation, debugging, validation, compatibility, upgrade, or release work produced a potentially reusable finding.

### Required work

Review potentially reusable findings from the completed work. Determine whether each finding belongs in project documentation only or qualifies for Global knowledge capture.

Use the status model, evidence requirements, verified-scope rules, and maintenance rules in [MAG_IMPLEMENTATION_PATTERNS.md](MAG_IMPLEMENTATION_PATTERNS.md). Do not restate them here or promote a project-specific requirement into a Global default.

### Conditional work

Prepare a focused candidate entry when a finding has a useful reuse case. Revalidate uncertain evidence before presenting it as verified knowledge. Updating the Global repository requires authorization for that separate scope; project implementation approval does not authorize a Global edit.

### Documentation actions

Preserve the source finding in its owning project document. Add or update a qualified entry in MAG_IMPLEMENTATION_PATTERNS.md through an authorized Global documentation action.

Knowledge may be captured earlier when verification is complete. This phase is the end-of-cycle check for missed findings, not a reason to postpone useful evidence recording.

### Validation

Check that the candidate has traceable evidence and that its proposed scope matches what was verified. Check for an existing entry before adding another.

### Completion conditions

Every relevant candidate is recorded, rejected as unsuitable for Global reuse, or explicitly deferred with a reason. A completed review may validly produce no Global entry.

### User approval / Gate

No new release gate. Global changes require their own authorized scope.

### Output

Verified project evidence and, when justified, an approved Global knowledge contribution or a recorded follow-up.

### Next allowed phase

Phase 11 — Maintenance and Next Version.


## 17. Phase 11 — Maintenance and Next Version

### Purpose

Maintain the stable baseline and process new work through an appropriately scaled lifecycle.

### Entry conditions

A stable release or an existing maintained project provides a known baseline. Post-release findings, defects, compatibility changes, or approved product requests may initiate work.

### Required work

- identify the problem or requested change against the current baseline;
- classify it as a defect, requirement change, compatibility change, or other bounded maintenance work;
- establish the affected release scope;
- identify which approved requirements, architecture decisions, and validation evidence remain applicable;
- obtain authorization for the next bounded action;
- route the change to the earliest phase whose decisions must change.

New requirements return to Phase 2. Uncertain technical behavior returns to Phase 3. Changed design returns to Phase 4. A verified defect within unchanged requirements and architecture may proceed to focused Phase 5 planning.

### Conditional work

For a new version, define its requirements delta and sequencing without reopening unrelated settled decisions. A genuinely separate product returns to Phase 0 and Gate 0; a version change does not create a new project identity.

### Documentation actions

Update the affected TZ, Architecture, and Roadmap for approved changes. Keep released Changelog entries and completed stage history intact. Update CLASS_MAP and descriptive documents when implementation changes them.

Record Cursor procedure history according to CURSOR_USAGE_ANALYTICS.md when applicable.

### Validation

Confirm that the chosen entry phase covers the actual uncertainty and risk. Validate each implemented change and its release through the applicable later phases.

### Completion conditions

The maintenance cycle has passed its applicable implementation, validation, release, and follow-up steps, or has an explicit paused/closed state.

### User approval / Gate

The Product Owner approves changed requirements, affected architecture, implementation scope, and release actions as applicable. Unchanged approvals need not be recreated.

### Output

A new verified baseline, a completed authorized checkpoint, or a documented pending decision.

### Next allowed phase

The earliest affected phase for approved next work, continued maintenance, or closure. A next-version idea is not automatic authorization to start it.


## 18. Documentation Lifecycle Matrix

Canonical project filenames and physical placement are defined in MAG_ECOSYSTEM.md. Logical project document names below refer to their canonical P<NN>__<CODE>__ filenames.

This matrix defines timing. Approval details, execution mechanics, evidence standards, and history methodology remain in their owning Global documents.

| Document | Create | Update / finalize | Approval or review point | Historical handling |
| --- | --- | --- | --- | --- |
| IDEA | Phase 1 canonical package container; useful Phase 0 notes may precede identity assignment and are preserved when adopted | During exploration; preserve useful rejected, superseded, or deferred alternatives as history | Supports Gate 0; does not approve requirements | Non-authoritative product exploration; do not convert old ideas into retroactively approved decisions; historical reasoning need not remain current truth |
| TZ | Phase 1 with honest initial status; define substantive requirements in Phase 2 | On approved requirement changes; verify release scope in Phase 7 | Gate 1; Product Owner approval for changed requirements | Preserve traceability of approved changes; do not rewrite requirements to match accidental behavior |
| Architecture | Phase 1 with honest initial status; develop design in Phase 4 from sufficient verified evidence | On approved design changes; synchronize verified implementation details during Phase 6 and before release | Gate 2 for the relevant design; reapproval when an affected decision changes | Preserve decision history; distinguish approved design from implemented state |
| Roadmap | Phase 1 with real initial status and sequencing | At phase transitions, increment completion, scope changes, and release closure | Product Owner approves executable scope and sequencing | Preserve completed stages; distinguish completed, current, pending validation, and planned work |
| CLASS_MAP | Phase 1 stating that no implementation exists yet where applicable; populate from real code in Phase 6 | After changes to actual classes and responsibilities; verify before release when affected | Review with the affected increment under agent/development rules | Describe current code; do not list planned classes as implemented |
| Changelog | Phase 1 stating the actual initial state; record staged/released changes only when they exist | During development and Phase 8 release finalization | Review as part of the release/checkpoint process | Preserve released and staged historical facts; distinguish unreleased work from shipped releases |
| README | Phase 1 with verified identity and bootstrap status | When verified product state, dependencies, installation, or usage changes; finalize for release | Review for accuracy before release | Descriptive; must not introduce requirements |
| Overview | Only when a separate descriptive overview is useful | When the verified product description changes | Review with affected documentation; not a separate product gate | Descriptive; preserve relevant history without duplicating TZ |
| AUDIT | Phase 1 parent/core document with honest evidence status | Record evidence directly or index justified child audits | Evidence supports dependent decisions; it does not approve requirements or architecture | Preserve source/version context, earlier findings, and corrections |
| Child research / audit evidence | Phase 3 or another phase with a real need beyond the parent AUDIT | During investigation; append or clearly identify revalidation and corrected conclusions | Evidence review before a dependent decision; findings do not approve architecture | Retain source/version context and distinguish earlier findings from later corrections |
| Cursor usage history | Phase 1 stating no procedures are recorded yet where applicable; populate from the first applicable procedure under CURSOR_USAGE_ANALYTICS.md | At required procedure checkpoints and after a release or coherent body of work | Follow the authoritative reporting and synchronization sequence in CURSOR_USAGE_ANALYTICS.md (prefer automatic After telemetry; do not invent values) | Preserve measurements and historical forecasts; do not invent telemetry or rewrite forecasts to match actuals |
| MAG_IMPLEMENTATION_PATTERNS.md | Global knowledge base; never bootstrap a project-local copy | When verified work yields qualified reusable knowledge; review candidates by Phase 10 | Authorized Global documentation scope; apply its own entry rules | Preserve traceable evidence and correct superseded conclusions using its maintenance rules |
| MAG_ECOSYSTEM.md | Existing Global registry and authority map | On approved project bootstrap, relevant status/identity changes, closure, or approved Global documentation-map changes | Authorized Global documentation scope | Retain permanent project identity; do not reuse closed project identifiers |
| MAG_ADDON_DEVELOPMENT_LIFECYCLE.md | Global lifecycle adoption | When an approved lifecycle, gate, or documentation-timing decision changes | Product Owner approval of Global process changes | Do not retroactively claim that earlier projects followed later procedures |

### Documentation checkpoints

1. Before a decision gate: the owning document must state the decision being approved.
2. Before implementation: the relevant requirements, architecture, and next increment must be clear enough to execute.
3. After an increment: synchronize documents affected by verified changes; explicitly record pending validation.
4. Before release readiness: reconcile release scope, actual implementation, evidence, and product documentation; confirm required Product Owner Practical Acceptance has **PASS**.
5. During finalization: complete Release Presentation; verify documentation against the actual shipping artifact and version.
6. After release: record relevant real-environment findings, complete applicable history synchronization, and review reusable-knowledge candidates.

The nine canonical documents are created in Phase 1 as mandatory containers with honest current-state records. AUDIT exists ≠ an audit was performed. CURSOR_USAGE_HISTORY exists ≠ telemetry may be invented. CLASS_MAP exists ≠ implementation exists. Architecture exists ≠ architecture is approved. Do not fabricate audit findings, telemetry, requirements, or code maps to populate them. Create optional child audits and other additional documents only when they have real information to own. Mandatory history synchronization follows its owning Global rules even when no product documentation changed.


## 19. Lifecycle Scaling Rules

Scaling changes the depth and amount of work, not the order of decisions or the Product Owner's control.

### New complex add-on

Use the full lifecycle. Iterate between targeted research and architecture where uncertainty requires it. Approve coherent design boundaries before authorizing their implementation.

### Small add-on with understood native mechanisms

Use the same gates with concise documents and reduced research depth. Record why existing evidence is sufficient. A dedicated audit document is unnecessary when a focused finding in the owning document is adequate.

### Minor feature

Use a requirements delta, an affected-architecture check, focused implementation planning, approved implementation, proportional validation, affected documentation synchronization, and the applicable release sequence.

Unchanged requirements and architecture retain their existing approval. A new feature still needs approval for its new behavior and implementation scope.

### Bugfix

Verify the problem against approved behavior, inspect the affected architecture and existing implementation, define the smallest sufficient fix, obtain implementation authorization, validate the affected behavior, synchronize affected documents, and complete the approved checkpoint or release.

If the investigation exposes a requirement ambiguity or a design change, return to the relevant decision phase.

### Emergency hotfix

Use the shortest safe path permitted by the owning Global rules. Urgency does not authorize an agent to change scope, skip necessary validation, or publish independently.

Any exceptional deferral of documentation must be explicitly justified and approved, consistent with Global rules, and recorded with the affected documents and a follow-up completion point. Do not describe deferred synchronization as complete. Preserve the minimum evidence necessary to understand the fix and release.

### Documentation-only change

Use a bounded documentation scope, verify statements against their owning sources, review the resulting text, and complete the authorized documentation checkpoint. Do not manufacture implementation, packaging, or release work where no software release is involved.

### Existing project adoption

Map the verified current state to the appropriate phase. Preserve completed releases and historical stages. Identify real gaps and seek decisions for affected work; do not invent retroactive approvals or restart completed work solely to match this document.

A project already beyond Phase 7 when this rule is adopted but not yet Stable Released may perform Product Owner Practical Acceptance as a current supplemental pre-release gate before Stable Release. Historical projects, procedures, and records must not be rewritten to pretend this rule existed earlier.


## 20. Exceptions and Stop Conditions

Apply detailed execution stop conditions and issue-reporting rules from AI_AGENTS_RULES.md and development/conflict rules from AI_GUIDELINES.md and MAG_ECOSYSTEM.md.

At lifecycle level, stop the affected transition when:

- a required approval is missing or the requested action exceeds approved scope;
- requirements, architecture, sequencing, and actual code materially disagree;
- a necessary architecture decision depends on unverified native behavior;
- a Critical issue prevents safe implementation or release;
- required validation is missing, failed, or invalidated by later changes;
- required Product Owner Practical Acceptance is missing, pending, or failed;
- release documentation or the artifact does not match the claimed shipping state;
- a Global authority conflict remains unresolved.

Report the current phase, the blocked transition, the evidence, and the decision or validation required to proceed. Distinguish confirmed facts, proposals, assumptions, unresolved questions, Critical issues, Non-critical issues, and Informational findings using the owning Global reporting rules.

An unresolved issue may be explicitly recorded without blocking unrelated approved work only when that work does not depend on it and remains within scope. Recording a blocker does not satisfy a dependent phase's completion conditions.

Return to the earliest affected phase when new evidence invalidates an approved decision. Preserve unaffected evidence and approvals; repeat validation when the change makes earlier evidence insufficient.

An exception must identify its scope, reason, affected rule, approving decision, and remaining obligations. This lifecycle does not grant a blanket power to waive other Global rules.


## 21. Project Closure / Abandonment

Only the Product Owner decides to close, abandon, or defer a project or release effort.

Before recording closure:

- identify the last verified state and any released baseline;
- distinguish completed work from unfinished or unvalidated work;
- record the reason and disposition of open work;
- identify ongoing support or maintenance obligations, if any;
- update the Roadmap and descriptive entry point;
- update the Global project registry through an authorized action when project status changes;
- preserve requirements, decisions, evidence, release history, and applicable usage history.

Closure does not authorize deleting repositories, removing release artifacts, rewriting history, or reusing the permanent #N.

A deferred project records what must be resolved before resumption. On resumption, revalidate stale assumptions and continue from the earliest affected phase. Do not silently restore outdated approvals to changed scope.

Completing one release is not project abandonment; an active product normally enters maintenance.


## 22. Transition and Completion Summary

This summary makes phase outputs and next transitions explicit. Each transition also requires the entry conditions of its destination and the closure prerequisite in section 3. “Allowed” means eligible under the recorded authorization, not an instruction for an agent to continue automatically. Gate PASS alone does not authorize the next Product Owner-controlled stage when this lifecycle defines separate authorization.

| Current phase | Required output / validation basis | Next allowed transition |
| --- | --- | --- |
| Phase 0 — Idea and Evaluation | Sufficient product evaluation for a decision | Gate 0, further evaluation, deferral, or rejection |
| Gate 0 — Project Approval | Product Owner approval of project creation | Phase 1 |
| Phase 1 — Project Bootstrap | Verified identity and nine-document package; Full/Resume completion also requires Local structure, approved Git baseline, and stable registration | Phase 2 documentation work may begin in Drive-First with Bootstrap Incomplete — Local/Git Pending; other gates remain applicable |
| Phase 2 — Requirements Definition | Coherent requirements, explicit scope, resolved blocking product decisions | Gate 1 |
| Gate 1 — Requirements Approval | Approved WHAT | Phase 3, or Phase 4 when existing evidence is sufficient and that conclusion is recorded |
| Phase 3 — Targeted Research and Verification | Traceable evidence sufficient for the next decision; unresolved blockers identified | Phase 4 when dependencies are resolved; Phase 2 if requirements need revision |
| Phase 4 — Architecture Planning | Design sufficient for current scope, grounded in verified facts | Gate 2, or targeted Phase 3 iteration |
| Gate 2 — Architecture Approval | Approved HOW for the relevant scope | Phase 5 |
| Phase 5 — Implementation Planning | Executable next increment with boundaries and validation criteria | Phase 6 after explicit implementation authorization |
| Phase 6 — Incremental Implementation | Implemented increment, relevant validation, reviewed changes, synchronized affected documents | Next approved increment; Phase 7 when release scope is complete; earlier affected phase for a new blocker |
| Phase 7 — Integration and Final Validation | Completed required release validation; Product Owner Practical Acceptance **PASS**; accurate documentation | Gate 3; authorized correction cycle if validation or Practical Acceptance fails |
| Gate 3 — Release Readiness | Product Owner approval of release finalization | Phase 8 |
| Phase 8 — Release Finalization | Release Presentation completed; final artifact and shipping state verified; explicit PASS, BLOCKED, or FAIL | Final release approval/publication only on PASS; correction and revalidation otherwise |
| Stable Release | Confirmed authorized publication establishes the shipping baseline | Phase 9 |
| Phase 9 — Post-Release Verification | Required observations completed and findings recorded, or a documented risk-based determination that no additional checks are needed | Phase 10; Phase 11 maintenance/hotfix when a defect requires action |
| Phase 10 — Reusable Knowledge Capture | Candidate review completed; qualified findings recorded or explicitly deferred | Phase 11 |
| Phase 11 — Maintenance and Next Version | Classified and authorized next change, completed checkpoint, or known stable baseline | Earliest affected phase, continued maintenance, or Product Owner-approved closure |

Phase 9 completion must not be claimed while required environment checks remain pending. If an approved release requires no additional post-release checks, record that determination; do not imply that unperformed checks passed.

Phase 8 PASS confirms readiness of the final artifact, not publication. Stable status does not erase post-release obligations or prove behavior in an environment that has not yet been exercised.


## 23. Authority Summary

- **MAG_ADDON_DEVELOPMENT_LIFECYCLE.md** is canonical for ordered lifecycle phases, transitions, stage gates, and documentation timing.
- **[MAG_ECOSYSTEM.md](MAG_ECOSYSTEM.md)** owns ecosystem identity, development-class taxonomy, namespace registry, documentation map, naming, context isolation, and the documentation authority model.
- **[AI_GUIDELINES.md](AI_GUIDELINES.md)** owns detailed development workflow and operational standards.
- **[AI_AGENTS_RULES.md](AI_AGENTS_RULES.md)** owns coding-agent execution boundaries, stop/report mechanics, and applicable checkpoint rules.
- **[CURSOR_USAGE_ANALYTICS.md](CURSOR_USAGE_ANALYTICS.md)** owns Cursor usage measurement and telemetry methodology only.
- **[AI_GUIDELINES.md](AI_GUIDELINES.md) §24.4** owns Cursor model-selection / model-routing policy.
- **[MAG_IMPLEMENTATION_PATTERNS.md](MAG_IMPLEMENTATION_PATTERNS.md)** owns source-backed reusable technical knowledge and its qualification and maintenance rules.
- **Active project documentation** owns the approved product requirements, architecture, sequencing, verified structure, and project history under MAG_ECOSYSTEM.md.
- **Actual code and verified evidence** establish what exists and what has been demonstrated; they do not silently redefine approved requirements.
- **The Product Owner** retains control over requirements, priorities, architecture, implementation authorization, Git actions, and releases.

GLOBAL defines HOW. Active development defines WHAT.

ChatGPT coordinates and prepares decisions and documentation. Cursor/Codex execute approved technical tasks within their governing rules. This lifecycle makes the order explicit without transferring decision authority to the tools.
