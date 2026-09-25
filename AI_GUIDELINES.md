# MAG Ecosystem — AI Development Guidelines

- MAG-Document-ID: `AI_GUIDELINES.md`
- MAG-Content-Updated: `2026-09-25T23:55:00+03:00`

This document is the **Global MAG development standard**. It defines **how** MAG software is developed with AI assistance.

It applies to ChatGPT, Cursor IDE, Cursor Agent, Codex, and any other AI-assisted tool used on MAG work.

Ecosystem identity, development-class taxonomy, namespace registry, Global vs active-development documentation levels, AI context isolation, high-level documentation authority, MAG Knowledge Control classification, development bootstrap, and the License Manager concept are defined in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). This file does not restate those definitions. Load **GLOBAL + the active development identity** as specified there.

`#N` and `A<N>` are assignable identity families. `B<N>` is reserved and is not a current working identity. Do not use `GLOBAL+B<N>` while `B<N>` remains reserved. Platform or surface does not determine identity.

Identity classes (`#N`, `A<N>`, `B<N>`), registry, and context isolation are owned by `MAG_ECOSYSTEM.md`. After identity scope, **Verified Applicability** filters which Global HOW applies to the current Product Class, surface, and technology. Applicability is routing, not authority. Keyword similarity is not proof of applicability. The current canonical owner body wins.

Unless a section explicitly scopes otherwise, XenForo add-on engineering rules in this document apply only when the active development identity is a `#N` XenForo Product. Do not import `#N` requirements into `A<N>`. Absence of a specialized profile means use the Global Core Lifecycle; it must not block a valid `A<N>` development.

Detailed coding-agent execution boundaries, mandatory Cursor pre-flight, Plain text output requirements, checkpoint mechanics, and report formats belong in `AI_AGENTS_RULES.md`.

ChatGPT → Product Owner → Cursor prompt presentation, **operating-mode selection (Coordinator Mode / Direct Agent Mode)**, post-execution review, and **Cursor model-selection / model-routing policy** belong in §24 of this document.

MAG Knowledge Control routing (Entry Gate, intents, Identity Scope × Intent × Verified Applicability, Locator states, and same-scope fallback) belongs in §27 of this document. It is routing, not a seventh authority owner.

Do not collect, display, or maintain Cursor Models usage measurements.

---

Lifecycle order, numbered Gates, process hierarchy (`Lifecycle → Phase → Increment → Step`), Phase Authorization, and documentation timing are canonical in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md): Global Core plus the applicable specialization. `#N` uses Core plus the numbered `#N` XenForo Product profile. `A<N>` uses Core unless a separately proven recurring specialization exists. This document owns detailed development and closure mechanics applied at those lifecycle checkpoints. Gate is a decision point, not a work-hierarchy level.

## 1. Purpose and philosophy

MAG development must remain:

- Correct.
- Stable.
- Maintainable.
- Compatible with the declared host, runtime, and surfaces of the active development identity.
- Compatible with the XenForo versions declared by the active `#N` project when the active development identity is `#N`.
- Secure.
- Performant.
- Accurately documented.
- Incrementally developed under **manual user control**.

AI must not treat MAG work as an open-ended rewrite, a research project, or a license to implement later Phases or Increments because they seem useful.

---

## 2. Authority (development use)

Use the authority model in `MAG_ECOSYSTEM.md`. For implementation work, apply it as follows:

| Source | Use |
| --- | --- |
| `MAG_ECOSYSTEM.md` | Ecosystem identity; Product Class, Surface, Technology, and Verified Applicability taxonomy; registry; documentation map; authority navigation; and GLOBAL + active development identity context isolation. |
| `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` | Global Core Lifecycle plus the numbered `#N` XenForo Product profile: numbered Gates, Phase transitions, process hierarchy, Phase Authorization, and `#N` documentation timing. Closure mechanics in this document apply at those checkpoints. `#N` Phase/Gate numbers remain valid. |
| Global documentation (other) | Process, tools, Git, and class-neutral security/performance/testing standards. XenForo add-on engineering rules apply only when the active identity is `#N`. |
| `MAG_IMPLEMENTATION_PATTERNS.md` | Reusable, evidence-backed technical knowledge. Subordinate to Global process documents and active-development TZ, Roadmap, and Architecture. Not a source of product requirements. |
| Project requirements (WHAT) | What the active identity's product must do. For `#N`: XenForo Product requirements in `P<NN>__<CODE>__TZ.md`. `A<N>` WHAT remains in that identity's approved documentation. Do not invent an `A<N>` eight-document package. |
| Project Roadmap | What increment is approved **now**, and verified progress. |
| Project Architecture | Approved implementation architecture. Does not override approved product WHAT. |
| Project CLASS_MAP | Current classes and responsibilities as they exist. For `#N`, canonical filename `P<NN>__<CODE>__CLASS_MAP.md`. |
| Actual project code | What is currently implemented. Documentation must not claim code that does not exist. |
| Installed XenForo source | Undocumented or uncertain XenForo framework behavior when the active development identity is `#N`. |
| Changelog / Git history | History. Do not rewrite the past. |
| README / overview | Descriptive only. |
| Idea | Non-authoritative research. |

`AI_AGENTS_RULES.md` (when present) additionally constrains repository-task execution and states mandatory Cursor pre-flight and Plain text execution requirements. Cursor prompt presentation, post-execution review, and model-selection policy remain in §24 of this document.

Process execution must consider canonical Global rules and currently ACTIVE entries in [`MAG_PROCESS_OVERLAY_POOL.md`](MAG_PROCESS_OVERLAY_POOL.md). If an ACTIVE overlay conflicts with canonical process wording inside its explicit scope, follow the overlay until promotion, rejection, or withdrawal. DRAFT and historical statuses have no execution effect. The Pool is not a seventh canonical Global authority owner; governance is defined in `MAG_ECOSYSTEM.md`. Commands are in §26.

If Global documents conflict, or two ACTIVE overlays conflict, **stop and report** rather than silently choosing one.

For `#N` XenForo add-on work, AI must not invent XenForo APIs or rely on assumptions when installed XenForo source can be inspected.

---

## 3. Incremental development and manual control

Development must remain incremental and controlled by the user.

AI must:

- Read the relevant project requirements before proposing changes.
- Inspect the existing implementation in the active development repository.
- Preserve verified working behavior.
- Identify affected classes and dependencies.
- Explain the proposed change.
- Implement only the requested scope.
- When the active development identity is `#N`, verify XenForo compatibility for the versions in that project's scope.
- Review security and performance implications as appropriate to the change.
- Test in proportion to risk and previous verification.
- Synchronize only affected documentation.
- Keep changes small and focused.
- Stop when the requested stage or task is complete.

AI must not:

- Implement functionality merely because it may be useful later.
- Expand the current stage without approval.
- Replace working code for stylistic preference.
- Invent framework behavior.
- Present planned functionality as implemented.
- Present an experimental observation as a formal benchmark.
- Present a placeholder class as functional.
- Automatically implement future stages.
- Modify a MAG repository that is outside the approved procedure scope.

---

## 4. Responsibility model

High-level roles are in `MAG_ECOSYSTEM.md`. This section defines MAG development responsibilities in enough detail to apply them. Execution checklists for coding agents belong in `AI_AGENTS_RULES.md` when that file exists.

### ChatGPT

ChatGPT is responsible for:

- Architecture.
- Technical analysis.
- Planning.
- Requirements clarification.
- Documentation analysis and writing.
- Code review.
- Risk identification.
- Development decisions.
- Explaining implementation approaches.
- Reviewing completed stages.

ChatGPT must not assume undocumented host, runtime, or framework behavior. When the active identity is `#N`, that includes undocumented XenForo behavior.

ChatGPT must not silently replace Cursor Agent implementation or the user's Git control.

When ChatGPT has an available Google Drive connector and needs MAG documentation or a factual Google Drive document state, retrieve from Google Drive directly. Do not require Mirror, duplicate Project uploads, manual file copies, or Cursor merely to obtain documentation already directly accessible. Mirror is not a mandatory intermediary or proxy proof of Drive state for ChatGPT when Drive is directly accessible. If Drive retrieval is unavailable or insufficient, use same-scope canonical fallback in §27. If required authority remains unresolved, the result is Unknown. Do not invent. Documentation-surface mechanics are owned by [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md).

### Cursor IDE

Cursor IDE is the **primary environment** for:

- Inspecting the local repository.
- Editing files.
- Running local development tasks.
- Testing the active product.
- Reviewing changes.
- Inspecting installed XenForo source when the active development identity is `#N`.

Cursor uses Local as its primary MAG documentation surface. When documentation freshness, reconciliation, or possible externally-authored changes matter, Cursor checks the corresponding Mirror state second. Cursor must not access Google Drive by default. Direct Google Drive access occurs only when the Product Owner explicitly requests it for the current task. Local is not an automatic winner over newer or conflicting Mirror evidence; apply [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md) comparison and conflict rules.

### Cursor Agent

Cursor Agent is an **execution tool** for approved, clearly specified repository work.

Operating mode (Coordinator Mode vs Direct Agent Mode) is owned in §24. Direct Agent Mode lets the agent session work directly under Global HOW. It does **not** enlarge this permitted-task list, grant Git/release authority, or bypass gates.

Cursor Agent must **not** be used for:

- Internet searches.
- External documentation research.
- Learning XenForo APIs when the active identity is `#N`, or independently learning other host/framework APIs outside the approved task.
- Architectural decisions.
- Requirements analysis.
- Exploring new implementation approaches.
- Deciding what should be implemented.

Cursor Agent may **only** be used for:

- Working with existing repository code.
- Implementing a clearly specified change.
- Optimization.
- Refactoring.
- Debugging.
- Analysis of existing code.

Before using Cursor Agent **outside** these permitted cases, explain the reason and obtain **explicit approval**.

### Codex

Codex may be used for code-related assistance when the user assigns it.

Codex must follow the same MAG:

- Project and stage discipline.
- XenForo standards when the active development identity is `#N`.
- Existing Code First principle.
- Security requirements.
- Performance requirements.
- Documentation rules.
- Git workflow.

Codex must not independently expand implementation beyond the approved stage or task.

### User

The user is product owner: requirements, sequencing, reviews, Git, and releases. Final repository control remains with the user.

No assistant may treat another assistant's draft as approved product or process unless the user has accepted it.

### Goal-bound completion

Determine the current lifecycle or procedure goal and the evidence actually required to complete it. Once its canonical completion conditions are satisfied, close that goal.

An adjacent transport, Mirror, baseline, or tooling imperfection must not become a new blocker unless an applicable canonical completion condition actually depends on it. Record or report a relevant non-blocking tooling issue separately when useful. Do not silently expand the lifecycle procedure into tooling redesign, audits, new capabilities, extra approvals, or repeated Cursor work.

---

## 5. Stage discipline

**Stage** is not a work-hierarchy level. Forward work uses `Lifecycle → Phase → Increment → Step` in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md). Historical Stage N, Slice, Block, Wave, U, I, and AD identifiers remain valid in existing project records; they must not silently create extra approval, validation, documentation, or Git checkpoint boundaries.

Follow the Phases and authorized Increments defined in the **active project's** approved sequencing documentation (canonical filenames for `#N` in `MAG_ECOSYSTEM.md`). Apply the Global Core Lifecycle. When the active identity is `#N`, also follow the numbered `#N` Phases and Gates.

Before implementing an authorized Increment or Phase:

1. Read the relevant requirements.
2. Read the relevant roadmap section.
3. Inspect current project structure.
4. Inspect related existing code.
5. Identify dependencies.
6. Explain the proposed implementation.
7. Implement **only** the requested Increment or Phase scope.
8. Test the result.
9. Review compatibility with the active identity's declared host, runtime, and surfaces. When the active identity is `#N`, review XenForo compatibility for the versions in that project's scope.
10. Review security implications as appropriate.
11. Review performance implications as appropriate.
12. Update affected documentation.
13. Apply Git checkpoint granularity from the lifecycle owner. The user owns `git add` / `commit` / `push` unless they explicitly request them **or** a live Phase Authorization covers those exact verbs.

Never automatically implement future Phases or Increments.

A **minimal** prerequisite from a later Phase or Increment may be introduced only when:

- The current authorized scope cannot be completed correctly without it.
- The dependency is explicitly identified.
- The scope remains minimal.
- The reason is documented.
- No unrelated future functionality is added.

Existing code from later or earlier Phases must not be deleted merely because those Phases are incomplete.

A Phase or Increment may be marked complete only when the project's Roadmap conditions are satisfied. Completion generally requires: required implementation exists; relevant declared host, runtime, and surface behavior is verified (when `#N`, relevant XenForo behavior is verified); tests appropriate to the change pass; security and performance implications are reviewed; development diagnostics are handled; **authoritative documents actually affected by the work** are synchronized (including a changelog entry only when that identity has an applicable changelog **and** the change materially requires one); Cursor usage history is synchronized when applicable; and the approved closure sequence in §20 has been completed at the granularity required by the lifecycle owner.

Architecture approval alone does not complete a Phase or Increment. The presence of placeholder or Alpha code alone does not complete it.

Do not interpret closure as requiring a Git commit after every tiny action, command, inspection, audit Step, Increment label, Gate result, or intermediate Cursor procedure.

---

## 6. Language

All source code must be written in **English**.

This includes identifiers, filenames, directory names, comments, PHPDoc, JavaScript identifiers, CSS class names, and Git commit messages.

Project documentation is maintained in English unless a separate translated document is explicitly required.

When the active development identity is `#N`, all user-facing XenForo text must use the XenForo Phrase system. User-facing strings must not be hardcoded into PHP or JavaScript.

---

## 7. Existing Code First

Before changing code:

1. Inspect the current implementation.
2. Understand the active runtime flow.
3. Identify existing classes related to the task.
4. Verify whether the requested functionality already exists.
5. Identify dependencies on completed or partially implemented work.
6. Preserve verified working functionality.
7. Avoid unnecessary rewrites.
8. Reuse existing host/runtime mechanisms when they meet the requirement. When the active identity is `#N`, prefer XenForo-native mechanisms (see §8).
9. Make the smallest reasonably focused change.

Do not recreate an existing class unless there is a verified technical reason.

Do not introduce a new abstraction only to support hypothetical future functionality or "ecosystem sharing." Shared MAG components exist only under `MAG_ECOSYSTEM.md` (real cross-project requirement, approved).

---

## 8. XenForo standards

**Scope: `#N` MAG XenForo add-on projects only.**

MAG add-ons follow official XenForo conventions for the versions declared by the active project.

Prefer native XenForo mechanisms such as:

- Entities, Finders, Repositories, Services, Jobs.
- Code Event Listeners and Class Extensions.
- Template Modifications.
- Options, Permissions, Phrases, Routes, Controllers.
- XenForo filesystem and HTTP facilities.

Use only mechanisms appropriate to the active requirement.

Do not:

- Modify XenForo core files.
- Directly modify XenForo default templates when a Template Modification is appropriate.
- Invent undocumented XenForo APIs.
- Assume that an API from another XenForo version behaves identically.
- Create custom architecture when XenForo already provides a suitable native mechanism.

When XenForo behavior is uncertain:

1. Inspect the **installed XenForo source** first.
2. Identify the actual call path and lifecycle.
3. Consult **official XenForo documentation** when necessary.
4. Record the verified conclusion in the project document that owns it.
5. Only then make the implementation decision.

---

## 9. Third-party reference add-ons

**Scope: `#N` MAG XenForo add-on projects only.**

Third-party add-ons may be inspected to identify candidate XenForo integration points, compatibility considerations, common patterns, and pitfalls.

Third-party code is **not** authoritative XenForo documentation.

Do not blindly copy architecture, code, security or performance behavior, licensing behavior, branding mechanisms, or legacy workarounds.

Every adopted mechanism must be independently verified against installed XenForo source, the project's TZ, MAG architecture, security and performance requirements, and current stage scope.

---

## 10. PHP standards

These standards apply when the active product uses PHP. They do not create a language or platform profile. When `#N`, follow XenForo-compatible style for the project; otherwise follow the active development's established PHP style.

Use:

```php
declare(strict_types=1);
```

PHP must:

- Use meaningful types.
- Use focused classes and methods.
- Avoid unnecessary static state.
- Avoid suppressed errors in final production paths unless explicitly justified.
- Avoid hidden side effects.
- Escape output for the correct context.
- Keep services testable where practical.

PHPDoc should add useful information and must not merely repeat obvious type declarations.

Do not introduce dependencies without a clear benefit.

---

## 11. Frontend: JavaScript, CSS, and LESS

**Scope: `#N` MAG XenForo add-on projects only.**

JavaScript must remain minimal.

JavaScript may support verified frontend behavior that cannot reasonably be handled by server-rendered markup or CSS, integrate with the XenForo frontend lifecycle where required, and apply presentation behavior to supported dynamic content.

JavaScript must not perform untrusted remote discovery or download, security validation that belongs on the server, server cache control, whole-page DOM scanning as primary architecture, injection into unrelated XenForo UI, or compensation for avoidable server architecture problems.

Use XenForo LESS templates for integrated styling where appropriate. Selectors must be scoped to the add-on.

Presentation must avoid layout shifts, content jumping, horizontal overflow, covered content, unstable alignment, and unnecessary specificity.

Consider desktop, mobile, supported XenForo styles, dynamic content, and RTL where applicable.

Do not maintain duplicate CSS and LESS sources without a documented build or packaging reason.

---

## 12. Content scope

**Scope: `#N` MAG XenForo add-on projects only.**

An add-on must process only the XenForo content types and surfaces declared in that project's TZ.

Do not globally inject behavior into unrelated UI (navigation, header, footer, breadcrumbs, standard sidebar, widgets, lists, user menus, Admin CP, and similar) unless the project's requirements explicitly include that surface.

A complete-page DOM scan must not be the primary integration architecture unless TZ and Architecture explicitly require it and XenForo source has been verified.

---

## 13. Security

Untrusted input, untrusted URLs, and untrusted remote responses remain untrusted.

Where a MAG product performs external HTTP or stores untrusted files, the **controlled server path** (not normal page rendering) must provide appropriate protection against SSRF, unsafe addresses and schemes, unsafe or excessive redirects, oversized responses, invalid status or type, and malicious payload content. Every redirect destination must be validated.

When the active identity is `#N`, prefer XenForo's native untrusted HTTP reader and related facilities when they meet the requirement.

Security failures must not expose the product's normal user-facing path to fatal errors. When `#N`, security failures must not produce fatal XenForo errors during normal forum use.

Errors must not expose sensitive information to users.

Temporary diagnostics must be removed or appropriately replaced before the relevant stage is complete.

Logging must use appropriate severity and must not flood the product's operational logs during normal behavior. When `#N`, logging must not flood XenForo logs during normal behavior.

---

## 14. Error handling

Product failures must fail gracefully.

Normal user-facing use must continue when parsing, remote requests, storage, cache, or optional features fail. When `#N`, normal forum use must continue in those cases.

Do not couple ordinary rendering to the availability of optional external services.

---

## 15. Performance

Performance is a core architecture requirement.

AI must avoid:

- Blocking the user-facing request path on avoidable external work. When `#N`, do not block the XenForo request on avoidable external work.
- Repeated work for the same key without a verified cache or suppression policy.
- Unnecessary database queries and filesystem operations.
- Global DOM scanning.
- Duplicate frontend initialization.
- Large unbounded downloads.

Rendering (or other user-facing request paths declared by the project) must complete normally when optional remote data is missing, slow, unavailable, previously failed, or expired.

Experimental observations are not formal benchmarks and must not be used to roll back a roadmap without approval.

---

## 16. Localization

**Scope: `#N` MAG XenForo add-on projects only.**

All user-facing text must use XenForo phrases.

Phrase names must follow XenForo conventions, use a consistent MAG/add-on prefix, remain stable where practical, and be documented when they are part of administrator configuration.

If a project maintains an official extra-language XML **outside** the canonical add-on ZIP:

- Keep it in sync when source phrases change.
- Align `base_version_id` with the add-on `version_id` when that is the project's established policy.
- Validate coverage, placeholders, and XML before release finalization when phrases changed.
- Do not add it to the canonical ZIP unless a later approved stage changes that policy.

Internal diagnostic text is not automatically user-facing.

---

## 17. Testing

Testing must correspond to the active stage and risk.

Potential verification includes syntax validation, focused unit tests, filesystem and HTTP behavior, security tests, and performance measurements appropriate to the active identity's approved in-scope surfaces.

When the active identity is `#N`, potential verification also includes XenForo integration checks, add-on data import/export, install/upgrade/uninstall, rendering and AJAX/dynamic-content checks, and other XenForo suite items applicable to that increment. Do not require that XenForo suite for `A<N>`.

Production or live-site observation must not substitute for controlled local verification.

Do not claim tests were run when they were not.

---

## 18. Efficient validation

Validation effort must be **proportional** to the change and to verification already performed.

This section is the primary Global owner of **Evidence Inheritance**, **Validation Delta**, and proportional validation behavior. Lifecycle placement of Phase 7 product correctness, Phase 8 shipping correctness, Normal Release Fast Path, Practical Acceptance, Gate 3, PRV, and Knowledge Capture remains in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md). Do not create an evidence ledger, registry, receipt, freshness gate, timestamp ceremony, or extra audit artifact solely to record inheritance. Evidence stays in existing appropriate owners.

Do not introduce redundant procedures merely to repeat already sufficient verification.

### Evidence Inheritance

**Evidence Inheritance is the default MAG validation principle.**

Valid evidence remains valid for the same relevant state until a material change invalidates it.

A lifecycle transition, Phase label, Gate evaluation, new report, release-preparation step, passage into Release Finalization, or a desire for additional confidence is **not** by itself evidence invalidation.

Before repeating validation, analysis, research, source inspection, architecture review, security review, compatibility verification, Product Owner Practical Acceptance, or another expensive proof, determine:

1. What relevant evidence already exists?
2. What materially changed since that evidence?
3. Which evidence was actually invalidated?
4. What evidence is missing?
5. What new boundary-specific evidence is required?

Reuse everything else.

If applicability of prior evidence is **Unknown** or contradictory, fail closed: do not inherit it; perform targeted verification of the uncertain claim. Do not invent certainty.

Typical invalidation triggers include: changed requirement; changed approved architecture; changed implementation scope or code path; repository change affecting the earlier evidence; relevant host/runtime/platform/environment change (when `#N`, relevant XenForo/XFRM/environment change); failed validation; contradictory new evidence; previously unknown API behavior; release artifact change that could invalidate product behavior; or another concrete reason making prior evidence unreliable.

### Validation Delta

**Validation Delta is the normal planner for repeated verification.**

Validation Delta =

- missing evidence;
- invalidated evidence;
- evidence required only by the new boundary, artifact, or environment.

Only that delta should normally be verified. Depth remains proportional to actual change and risk.

If nothing relevant changed and no new boundary-specific evidence exists, do not rerun validation solely because the lifecycle advanced.

### Material-change filter

The five Evidence Inheritance questions above are the material-change filter. If nothing relevant changed:

- reuse existing evidence;
- do not repeat the validation or analysis;
- do not reopen completed work solely because a lifecycle label or status marker changed.

If the change is narrow, perform only the minimum narrow Validation Delta.

Do not run broad regression merely because lifecycle status changed.

A later documentation-only or already-approved synchronization does not require a new full review, security audit, or release-finalization suite unless the synchronization introduces unexpected changes, unresolved issues, or invalidates previous verification.

Release Finalization verifies **shipping / release-artifact correctness** of the artifact the product actually ships. It inherits uninvalidated product-correctness evidence. It does not repeat the preceding product audit unless that evidence has been invalidated. `#N` Phase 7 / Phase 8 ownership and Normal Release Fast Path are in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md). Do not apply XenForo ZIP, `hashes.json`, Resource URL, or Release Presentation fields to `A<N>`.

Evidence Inheritance does **not** skip Gate 3, Stable Release authorization, or other genuine Product Owner decision gates. It may inherit a prior explicit Product Owner Practical Acceptance **PASS** for unchanged product state as defined in the lifecycle owner.

### Coherent execution blocks

Related approved actions that share one logical objective **SHOULD** execute as one coherent block when no material state change or recovery boundary requires separation.

Lifecycle labels alone are not material-change evidence and must not automatically create separate validation cycles, Cursor/Work invocations, documentation-only procedures, Git checkpoints, or Product Owner confirmations.

Distinct lifecycle gates retain separate evidence and formal results even when executed within one coherent block. Coherent blocks may remove artificial overhead; they must **not** collapse, silently merge, remove, or redefine mandatory Global gates or genuine Product Owner authorization boundaries.

Split or stop a coherent block when continuing would materially harm reviewability, rollback safety, root-cause isolation, validation clarity, scope control, or Product Owner understanding/control.

### Proportional point-change execution

When a change is already understood, approved, and technically verified, use a **point procedure** limited to the exact change and the validation that change actually requires. Prefer the **minimum sufficient safe path**.

- Do not repeat architecture analysis, source audits, research, broad regression review, or already-valid verification without a concrete new uncertainty or risk.
- Do not split one simple deterministic correction into multiple artificial procedures when one procedure can safely perform the change, synchronize the local installed copy when required, and enable Product Owner verification.
- Validation remains proportional to actual change and risk.
- Expand scope only when new uncertainty, dependency, unexpected behavior, security/compatibility concern, or other material risk justifies it.

This optimization must not weaken required validation or authorize unsafe shortcuts.

### Adaptive Validation Matrix applicability

The Adaptive Validation Matrix form lives in [`MAG_XENFORO_ADDON_BLUEPRINT.md`](MAG_XENFORO_ADDON_BLUEPRINT.md). It is evidence/applicability framing, not a policy owner, and not default ceremony. Use it when the active identity is `#N` and the risk warrants it. Do not require the Matrix for `A<N>`. Inherited valid evidence does not need to be re-executed merely to populate the Matrix. Product-correctness rows map to Phase 7; package/artifact rows map to Phase 8; PRV rows belong to Phase 9 and must not invite pre-release duplication.

When `#N`, use the full/explicit Matrix for:

- medium/high-risk increments;
- formal audits;
- release/release-candidate validation where applicable;
- changes where multiple evidence dimensions materially matter.

For small/low-risk deterministic changes, use concise validation evidence appropriate to the change (for example `git diff --check`, targeted tests, lint/build result, relevant source verification, exact before/after state). Do not fill a full Matrix of N/A rows for a tiny deterministic edit. N/A remains valid where the owning rule permits it.

Required Product Owner Practical Acceptance, Release Readiness (when `#N`, Gate 3), and other mandatory owning verification rules are not waived by using concise evidence.

### Product Owner Practical Acceptance

Technical validation and Product Owner Practical Acceptance are distinct. Core Validation / Acceptance requires a valid Practical Acceptance **PASS** for a release scope before Release Readiness. When the active identity is `#N`, that is [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) Phase 7. An agent must not substitute its own acceptance for Product Owner Practical Acceptance.

If the Product Owner already accepted the exact relevant product state during approved Increments and no product-relevant change occurred afterward, that explicit **PASS** may be inherited. Do not mechanically require the Product Owner to repeat the same acceptance solely because Phase 7 began. Refresh Practical Acceptance proportionally when relevant product behavior changed.

Do not treat technical validation as sufficient for release readiness, Release Finalization, or Stable Release while required Practical Acceptance remains pending or has failed.

When Practical Acceptance finds a defect, return proportionally to the earliest affected lifecycle point. Preserve unaffected valid verification evidence; do not automatically repeat audits, architecture analysis, or broad regression work.

This pre-release acceptance does not replace Core Post-Release Verification. When `#N`, that mapping remains Phase 9 — Post-Release Verification.

## 19. Backwards compatibility

A shipping MAG version is a product baseline, not a permanent public API freeze.

Existing structures may change when the active stage requires it (markup, data attributes, JavaScript, CSS, constructors, method signatures, storage layout, and similar). Such changes must be required, explained before implementation, verified against the declared host/runtime (when `#N`, verified against XenForo), tested, reflected in documentation, and checkpointed in Git.

Working behavior must not be broken casually. Preserve the current shipping product of the active development identity unless the approved increment explicitly changes it.

---

## 20. Git workflow

The verified local working copy is authoritative for pending local changes.

The configured remote records the last published repository state.

Each completed and approved Phase must be closed with **affected-documentation delta** and a Git checkpoint at the granularity owned by [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) (Phase-end default; Increment checkpoint only when that Increment is a material rollback/risk boundary or the Product Owner chose that granularity). [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md) §10 requires compliance with this filter; it does not own a second copy.

Normal closure path:

```text
validated Phase state
→ affected documentation delta
→ Fast Sync when [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md) §10.1 applies
→ one justified material Git checkpoint
→ normal push when Phase-authorized
→ clean-state verification
→ DONE
```

Fast Sync is the normal proven-state synchronization path. Do not repeat registration, authority, metadata onboarding, historical timestamp reconstruction, full document audit, unchanged source validation, or another planning cycle solely because synchronization is occurring. **Authorization does not create executor capability.** If Fast Sync cannot proceed, report it pending and continue other authorized closure work only when safe.

This does **not** require a commit after every tiny action, command, inspection, audit Step, Increment, Gate result, intermediate Cursor procedure, lifecycle label change, status-marker change, documentation synchronization, Practical Acceptance recording, or mechanical sub-step. Git checkpoints correspond to justified material Phase (or explicitly justified Increment) closure, or other explicitly approved meaningful checkpoints that protect material audit or recovery state.

Default: one coherent material change set → one justified material checkpoint.

### Checkpoint-protection filter

Before proposing an intermediate Git checkpoint, ask:

**What material state or recovery boundary does this checkpoint protect?**

Do **not** create a separate checkpoint merely because:

- a lifecycle label changed;
- a Gate, Increment, Slice, Block, Wave, or documentation status marker changed;
- a validation report exists;
- Practical Acceptance was recorded;
- documentation synchronization completed;
- a mechanical Step completed.

Create or retain a checkpoint when it protects meaningful state such as:

- material product or source change;
- architecture or requirements change;
- release artifact or release identity change;
- an irreversible or high-risk transformation requiring a rollback boundary;
- immutable artifact association;
- a mandatory Global checkpoint;
- an explicit Product Owner request;
- another meaningful audit or recovery need.

Where [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) explicitly mandates a checkpoint, that remains authoritative.

Do not commit incomplete, unreviewed, or known-broken work merely to satisfy the checkpoint rule.

Documentation must describe the approved actual state, not planned or assumed completion.

Historical documentation and Git history remain historical records and must not be rewritten to make later decisions appear earlier.

The **user** owns `git add`, `git commit`, and `git push` unless they explicitly request the agent to perform them **or** a live Phase Authorization in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) explicitly covers those exact verbs and live Git identity/repository/branch/tracking still match. When that live Phase Authorization still matches, do **not** request another Product Owner approval for those covered normal Git verbs. Force-push, rebase, history rewrite, tag, and publication are never inherited from Phase Authorization.

Never force-push `main` unless the Product Owner explicitly authorizes that exact force-push operation. No inferred authorization. Normal commit approval, normal push approval, release approval, Direct Agent Mode, Full Bootstrap, checkpoint authorization, and Phase Authorization do not grant force-push permission. If force-push appears necessary: inspect, report, and wait for Product Owner decision. Do not provide destructive auto-recovery. Compact Git recovery behavior is in [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md) §10.

If a Phase reveals unresolved **Critical** issues, the Phase is not closed and progression is blocked.

**Drive-First / Local/Git-First Bootstrap:** approved documentation work may progress under MAG_ADDON_DEVELOPMENT_LIFECYCLE.md Phase 1 and MAG_DOCUMENTATION_OPERATIONS.md §5. Drive-First is a normal `#N` bootstrap state: documentation may proceed while Local/Git closure remains pending. Local/Git-First may complete Local/Git Bootstrap Complete while Drive remains **Drive Reconciliation Pending**. Neither path claims implementation, commit, push, tag, or release authorization. Drive reconciliation is not required for Phase 1 completion or stable registration. A Pool status change alone is not a Git checkpoint.

### Phase closure sequence

1. Complete the approved work for the current Phase (and any Increments inside it that required completion).
2. Review and explicitly approve the result where a new Product Owner decision is required. Do not re-ask for actions already covered by a live Phase Authorization.
3. Update only the authoritative documents materially affected by the actual work. Fast Sync those registered documents when [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md) §10.1 applies. Do not mechanically touch Roadmap, Changelog, Architecture, README, audit, or status documents merely because they exist.
4. When several consecutive lifecycle transitions occur inside one uninterrupted authorized successful coherent block, record them together in one meaningful authoritative update at this closure boundary unless an intermediate state required independent durable preservation.
5. When relevant work may have produced reusable technical knowledge, evaluate it for `MAG_IMPLEMENTATION_PATTERNS.md` per §22.
6. Review the resulting documentation/code diff and repository status.
7. Resolve Critical issues before closure.
8. Create the justified material Git commit at Phase-end granularity, or at Increment granularity only when required by the lifecycle owner. The agent may perform `git add` / `commit` when a live Phase Authorization covers those verbs; otherwise the user performs them. Do not request duplicate approval for those covered verbs.
9. Push the approved commit when the user authorizes it **or** the same live Phase Authorization covers normal push and tracking still matches. Do not request duplicate approval for that covered push.
10. Verify the working tree is clean.
11. Only then proceed to the next Phase.

### Consolidated state recording

If several consecutive lifecycle transitions occur inside one uninterrupted, authorized, successful coherent block, they may be recorded together in one meaningful authoritative documentation update at the next material closure boundary.

Example: Phase validation PASS → Gate PASS → finalization PASS does not automatically require three Roadmap edits, three sync operations, and three commits. One final authoritative update may record the sequence and evidence references when no intermediate state needed independent durable preservation.

Require an earlier independent durable update when there is a concrete reason, such as BLOCKED, FAIL, work stopping for a meaningful period, authority or scope changing, a Product Owner decision changing the path, a recovery boundary being required, or the intermediate state itself having durable long-term value. Do not hide material failures or decisions merely to reduce documentation.

Before publishing:

1. Verify the permanent repository root for the active development identity (or `MAG-Ecosystem` for Global documentation).
2. When the active development identity is `#N`, verify intended XenForo add-on structure.
3. Review all changes.
4. Confirm no temporary restore directories are tracked.
5. Confirm no host, SDK, or environment-specific files that must not ship are included. When `#N`, confirm no XenForo core or environment-specific files are included.
6. Test the applicable authorized scope.
7. Synchronize documentation.
8. Commit with an English message when the user requests it or a live Phase Authorization covers normal commit.
9. Push only the verified local commit when the user requests it or a live Phase Authorization covers normal push.

Do not claim Git state was verified unless it was actually inspected.

Preserve unrelated user changes.

Canonical `#N` package identity and filenames are defined in `MAG_ECOSYSTEM.md`. Operational instantiation (eight bootstrap-created documents under `docs/`, public root `README.md`, `IDEA.md` casing) is defined in `MAG_XENFORO_ADDON_BLUEPRINT.md`. Do not maintain a second package tree here. This eight-document package and Blueprint path do not apply to `A<N>`. `A<N>` documentation follows approved needs in `MAG_ECOSYSTEM.md`. Do not invent an `A<N>` documentation package here.

New `#N` projects use that Blueprint/`docs/` layout. `#1` and `#2` historical root/`docs/` mixes and `Idea.md` casing are grandfathered. Do not migrate, rename, or retrofit them, and do not treat those historical layouts as new-project templates.

Global process files live in `MAG-Ecosystem`, not inside each product repository.

Do not claim a MAG product repository must keep copies of Global `AI_GUIDELINES.md`.

---

## 21. Release artifact preservation

Core Release Finalization means Product Owner-authorized shipping of the artifact the active product actually ships. It does not invent a universal ZIP or version scheme.

**Scope of the remainder of this section: `#N` MAG XenForo add-on projects only.**

Release Presentation requirements, sequence, and final-package gating are canonical in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) Phase 8. Do not build the final release ZIP before required Release Presentation data is approved and applied per that workflow.

Finalized XenForo release ZIP archives in `_releases` are immutable historical artifacts.

- Never overwrite, replace, or reuse the filename of a previously finalized release ZIP.
- Test and development builds must not use the filename of an existing final release.
- After creating a test build, copy or rename it immediately using an explicit test identifier (for example `MAG-AddOnName-1.0.0-test.zip`).
- Final packages use the canonical version filename (for example `MAG-AddOnName-1.0.0.zip`).
- Preserve previous final release ZIPs so every published version remains recoverable.

`xf-addon:build-release` names the output ZIP from the **installed XenForo add-on version string in the database**, not from `addon.json` alone.

Before `xf-addon:build-release`:

- Confirm version identity is already resolved under [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) **XenForo add-on version identity** (clean GLOBAL scheme or a documented Legacy Version Baseline). Do not invent `version_id`. If identity is `Unknown`, STOP before bump or ZIP.
- Verify source `addon.json` `version_string` and `version_id` match the intended release.
- Verify the installed XenForo add-on DB version is aligned with that intended release.
- When they differ, run the established native XenForo alignment procedure first (on the current stack: `xf-addon:bump-version --from-json`).
- List the target `_releases` directory.
- Confirm the intended canonical ZIP filename does not already exist.
- Never rely only on `addon.json` to predict the output ZIP filename.
- Never allow `build-release` to overwrite a historical final archive. If the canonical filename already exists, stop and rename or relocate the new build.

Minimum Release Finalization verification typically includes: version metadata; canonical ZIP identity; ZIP contents; `hashes.json` vs packaged files; required packaged assets; exclusion of development and runtime-only files; preservation of historical final ZIPs; supported-XenForo install/upgrade smoke; file health where applicable; installed add-on version and active state; ZIP size and SHA-256; and, where applicable, approved Release Presentation metadata (description, mandatory separate `Made in Ukraine` line, MAG icon, Developer link, Product Owner-supplied Support Resource URL, and Donate link) per `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 8.

When source phrases changed, also validate any official extra-language file the project maintains outside the ZIP.

---

## 22. Documentation synchronization

After verified implementation changes, ask: **which authoritative documents were materially affected by the actual work?** Update those documents only.

Do not mechanically touch Roadmap, Changelog, Architecture, README, audit documents, or status documents merely because they exist in a documentation package. Use existing owner responsibilities and the current documentation matrix to determine actual affected documents. A status-only edit must not become a completion predicate unless the status itself has durable authoritative value. Do not weaken mandatory documentation where the underlying state genuinely changed.

Typical project documents (logical): README, TZ, Architecture, CLASS_MAP, Changelog, Roadmap, and optional overview/research files. For `#N`, use the canonical `P<NN>__<CODE>__` filenames recorded in `MAG_ECOSYSTEM.md`. `A<N>` documentation follows approved needs from `MAG_ECOSYSTEM.md`. Do not design a new non-`#N` logical-document model here.

Update Global documents only when process, ecosystem conventions, or reusable technical knowledge changed per `AI_GUIDELINES.md` §22.

Documentation must describe the actual verified state. Do not copy one project's product status into Global guidelines.

If code or applicable host/runtime source inspection shows that a documented requirement is incorrect, unsafe, impossible, or incompatible:

1. Stop implementation.
2. Identify the conflict.
3. Record the evidence.
4. Explain the impact.
5. Propose a correction.
6. Obtain approval where the correction changes requirements.
7. Update the authoritative document.
8. Synchronize related documents.
9. Only then continue.

AI must not silently change requirements for implementation convenience.

### Reusable implementation knowledge

When completed MAG work may have produced reusable technical knowledge, evaluate whether it belongs in [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md).

This evaluation is a normal completion consideration for relevant:

- implementation;
- debugging;
- audit;
- compatibility investigation;
- host/runtime source inspection (when `#N`, XenForo/XFRM source inspection);
- testing;
- stabilization;
- release verification;
- production troubleshooting.

It does **not** require a separate Cursor procedure.

Follow the capture procedure defined in `MAG_IMPLEMENTATION_PATTERNS.md` (**Detect → Verify → Search → Classify → Determine scope → Decide → Record → Preserve authority**). Do not duplicate the full algorithm here.

Rules:

- Promote only evidence-backed findings. Do not generalize from donor behavior, assumptions, planned architecture, hypotheses, or accidental implementation behavior.
- Keep product requirements, approved project architecture, project code structure, product-specific behavior, and project history in the active development identity's documentation.
- When ChatGPT identifies a technically valuable reusable candidate during MAG work — implementation pattern, architecture technique, optimization, security practice, debugging technique, benchmark methodology, workflow improvement, or similar — **explicitly flag it to the Product Owner** as a candidate for the Global MAG knowledge library while the context and evidence are still available. Do not wait only for procedure close-out if the finding is already clear.
- Project-specific evidence, measurements, fixtures, and stack choices stay in the active assignable development identity's documentation or research archive (`#N` or `A<N>`). `B<N>` is reserved and has no active WHAT archive. Only the **generalized reusable principle** may be promoted to Global documentation.
- Promotion to `MAG_IMPLEMENTATION_PATTERNS.md` or other Global knowledge requires Product Owner approval. Identifying a candidate does **not** authorize Global edits, implementation, architecture changes, requirements changes, or scope expansion outside the approved procedure.
- Add or update Global reusable knowledge only when there is a meaningful future reuse case. Do not turn the knowledge base into a development log.
- If the approved procedure already includes Global documentation synchronization and a qualifying knowledge update is within scope, record it as part of that procedure.
- If reusable knowledge is discovered while working only in an active development repository and modifying `MAG-Ecosystem` would cross the approved repository/procedure scope, do **not** modify Global documentation without Product Owner approval of a separate Global documentation update. Until then, flag the candidate to the Product Owner.
- Discovery of reusable knowledge does **not** authorize unrelated implementation, architecture changes, requirements changes, cross-project modifications, scope expansion, Git operations, or starting another development stage.

Entry structure, status model, and maintenance mechanics remain authoritative in `MAG_IMPLEMENTATION_PATTERNS.md`.

### ChatGPT Project files after Stable release

After a confirmed Stable release whose result is **RELEASE FINALIZATION PASS**, ChatGPT must give the user a short vertical list of ChatGPT Project files to update or replace so Project context matches the new stable state.

The list must:

- Be concise.
- Contain filenames/paths only unless the user asks for explanation.
- Be grouped by source context using `GLOBAL [MAG] Ecosystem`, `#1 [MAG] Global Links Favicons`, `#2 [MAG] Tag Synchronizer`, `A1 [MAG] GPT|Cursor|Sync`, and other approved development-identity markers defined in `MAG_ECOSYSTEM.md`.
- Include only files that actually changed or that genuinely need Project-context refresh.
- Use real project-relative paths where useful, for example `docs/P01__GLF__Architecture.md`.

Do not produce this list for release candidates, test builds, blocked releases, or failed finalization.

---

## 23. AI behavior

AI must:

- State assumptions.
- Distinguish facts from proposals.
- Cite inspected code when making implementation claims.
- Identify uncertainty.
- Stop when additional authority is required.
- Avoid presenting incomplete work as complete.
- Avoid claiming tests or Git verification that did not occur.
- Preserve unrelated user changes.
- Keep recommendations proportional to the current task.

When a production observation conflicts with documentation, inspect code and controlled evidence before changing stage interpretation.

Do not optimize development merely to reduce Cursor quota usage. Correctness, applicable host/runtime compatibility, security, maintainability, testing, and documentation remain higher priorities. When `#N`, XenForo compatibility remains among those higher priorities.

When Cursor procedure presentation applies, follow §24 of this document for presentation, post-execution review, and model selection; and follow `AI_AGENTS_RULES.md` for mandatory execution and Plain text requirements. Do not collect, display, or maintain Cursor Models usage measurements.

---

## 24. Operating modes, Cursor prompt presentation, continuation, and model routing

This section is the Global authority for **MAG operating modes**, ChatGPT → Product Owner → Cursor presentation (Coordinator Mode), Direct Agent Mode execution surface, post-execution review, and **Cursor model-selection / model-routing policy**.

Coding-agent Plain text execution requirements remain in [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md). Progressive Product Owner technical-lead learning as a permanent MAG development principle is recorded in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md).

### 24.0 Operating modes

Mode selection affects coordination surface only. Both modes consume the same Global HOW. Mode selection does **not** change Product Owner authority, Git ownership, numbered lifecycle Gates, implementation authorization, release authorization, context isolation, scope boundaries, stop-on-conflict, or strategically required approvals. Direct Agent Mode does **not** create a parallel governance system.

**Coordinator Mode**

ChatGPT coordinates the procedure and prepares execution instructions. Cursor, Codex, or another execution agent performs repository work. ChatGPT may review results and coordinate next steps. This is the traditional MAG path.

In Coordinator Mode, use the established presentation: model recommendation → short reason → plain-text execution prompt per §24.1–24.2.

**Direct Agent Mode**

Cursor, Codex, or another approved agent session works directly under Global MAG HOW for the active development identity. ChatGPT is optional between individual operations.

The execution agent may inspect, plan, perform an already authorized procedure, report results, and continue an already approved coherent block or live Phase Authorization.

Direct Agent Mode must **not** require artificial prompt-copy theater when the agent already holds the active context and authority. Do not require “ready to receive?” handshakes, repeated restatement of already-approved instructions, or copy/paste through ChatGPT when no coordination value exists.

Explicit Product Owner decisions and authorization boundaries remain mandatory where Global HOW requires them. Direct Agent Mode does **not** authorize Git, Gates, implementation, or release by default. A live Phase Authorization may cover only the verbs it explicitly includes.

If the Product Owner does not name a mode, infer the surface actually in use (ChatGPT preparing a paste prompt = Coordinator Mode; an in-repository agent session with Global HOW loaded = Direct Agent Mode) and do not force a mode switch.

### 24.1 When to present a Cursor prompt

**Coordinator Mode only.** Provide a prepared Cursor prompt only after the Product Owner has approved receiving it for that procedure, **or** when the Product Owner continues an already-authorized next action with `+` or equivalent continuation within the same approved procedure/coherent block.

Direct Agent Mode does not present a paste prompt for work the agent is already authorized to execute in the current session.

`+` means: continue the already-defined next action in the current approved procedure.

Do **not**:

- ask for another confirmation for the same already-approved step;
- create a new planning cycle for that same step;
- reopen prior analysis without evidence invalidation;
- re-explain the same decision.

`+` does **not** authorize a new Product Owner decision, a new Gate, scope expansion, Git/release publication, or the next Phase when Global rules require separate authorization. Continuation inside a live Phase Authorization may proceed through already-included Steps without a new prompt.

### 24.2 Cursor prompt presentation order

**Coordinator Mode.** Present information in this order:

1. **Cursor prompt** — first. A dedicated plain-text code block containing only the exact text intended for paste into Cursor. Do not place explanations or execution metadata before it. Keep the prompt concise and task-specific; reference applicable authoritative MAG rules instead of duplicating them unnecessarily.
2. **Ціль/задача** — maximally concise, informative Ukrainian description of the procedure's purpose and expected result.
3. **Cursor chat** — exact target chat. Never invent an unknown Cursor chat; resolve ambiguity with the Product Owner first. Do not route work for one approved development identity through another identity's Cursor Agent chat.
4. **Cursor model** — recommended model/mode per §24.4.

Do not place explanations, usage values, or other execution metadata before the copyable prompt block.

Prefer the lowest-friction safe executor that preserves Product Owner control, approved scope, required verification, and auditability. Do not create a Cursor or Work procedure merely to avoid a simpler safe path. A Cursor task should normally execute a complete coherent task rather than split without a risk-based reason.

### 24.3 Post-execution review

After a meaningful Cursor procedure in **Coordinator Mode**, ChatGPT must immediately provide:

1. **Analysis** — whether the completed work met the approved task.
2. **Confirmed result** — what succeeded.
3. **Problems** — **Critical**, **Non-critical**, and **Unresolved** issues as applicable. If none, state that explicitly.
4. **Recommended next step / Stage** — one concrete recommendation. This does not authorize execution; Product Owner control remains required.
5. **Learning note** — a short Ukrainian note explaining what the Product Owner should understand from this stage as the person leading the development process.

Learning notes must be practical, stage-specific, concise, non-repetitive, and progressively deeper as Product Owner experience grows.

In **Direct Agent Mode**, report in the same session under [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md). Optional later ChatGPT review is not a required extra gate and does not authorize Git, implementation, or the next lifecycle stage.

### 24.4 Cursor model-selection / model-routing policy

This subsection is the **canonical Global owner** of Cursor model-selection and model-routing policy.

Stable principles:

- Model selection is based on the **complexity of technical decisions still unresolved**, not file type, number of files, or whether code is being edited.
- Use the **minimum sufficient** model reliably strong enough for the remaining decisions.
- Unresolved Product semantics or Architecture must return to the **Product Owner** (with ChatGPT in Coordinator Mode) before Cursor implementation.
- Deterministic or already-decided execution must not default to an unnecessarily expensive reasoning model.
- Escalation above the minimum sufficient model requires a concrete reason.
- Whenever recommending a stronger reasoning model over the lower candidate, provide one short reason why the lower model is insufficient.
- Escalation during execution should go only as high as newly observed reasoning or risk requires.
- Unnecessary model strength is over-selection and should be avoided.
- Selecting a cheaper model must not reduce validation requirements.

#### Current model recommendations

These named recommendations are subordinate to the stable principles above and may be updated when Cursor's available models change without rewriting unrelated lifecycle rules. Do not invent unavailable model names.

| Model | Prefer when |
| --- | --- |
| **Composer 2.5** | Default for deterministic/mechanical work, known-path implementation, approved detailed plans, known tests/commands, localization, XML/templates, metadata, cleanup, and multi-file implementation when **no material engineering decision remains**. First candidate for execution-dominant work even when PHP or multiple files are involved. |
| **Auto** | Ordinary well-specified work when a specific model is not required and Composer is not the clearer fit. |
| **Grok 4.6 Low** | Small localized uncertainty within an otherwise approved path. |
| **Grok 4.6 Medium** | Normal engineering decisions within approved Architecture. |
| **Grok 4.6 High** | Complex root cause, transactions, concurrency/reentrancy, security, difficult lifecycle, upgrade/migration/compatibility, multi-subsystem integration, or broad regression-risk reasoning. |
| **Grok 4.6 Extra High** | Exceptional escalation when High is insufficient or uncertainty/failure cost is extreme. |
| **GPT-5.6 Sol / Claude Opus** | Alternative escalation when that family is likely to materially improve the result after justified Grok escalation, or for strong second-opinion review. |

Decision tree:

```text
1. Are Product semantics or Architecture still unresolved?
   → YES: stop Cursor implementation; return to the Product Owner (ChatGPT coordinates in Coordinator Mode)
   → NO: continue

2. Is remaining work execution-dominant with no material engineering decision left?
   → YES: Composer 2.5 (or Auto when Composer is not the clearer fit)
   → NO: continue

3. Is uncertainty small and localized within an approved path?
   → YES: Grok 4.6 Low
   → NO: continue

4. Is the work normal engineering within approved Architecture?
   → YES: Grok 4.6 Medium
   → NO: continue

5. Does the work involve complex root cause, transactions, concurrency/reentrancy,
   security, difficult lifecycle, upgrade/migration/compatibility, multi-subsystem
   integration, or broad regression-risk reasoning?
   → YES: Grok 4.6 High (Extra High only when High is insufficient or failure cost is extreme)
   → NO: re-evaluate from step 2 with a concrete reason
```

---

## 25. Final principle

AI-assisted MAG development must remain:

- Incremental.
- Evidence-based.
- Host-native where a host applies. When `#N`, XenForo-native.
- Existing-code-first.
- Security-conscious.
- Performance-conscious.
- Precisely documented.
- Limited to the active stage of the active development identity.
- Preservative of that project's current shipping baseline.

Work proceeds from verified code and verified host/runtime behavior, not from assumptions, silent conflict resolution, or speculative future architecture. When `#N`, that host/runtime is XenForo.

**GLOBAL defines HOW. Verified Applicability determines WHICH HOW applies. Active development defines WHAT.**

---

## 26. Process Overlay Pool commands

Governance of the MAG Process Overlay Pool is defined in `MAG_ECOSYSTEM.md`. Records live in `MAG_PROCESS_OVERLAY_POOL.md`. These commands are the operational interface. They do not authorize product implementation, Git, or release.

### `PROCESS CHANGE`

Create or update a Pool entry and prepare it for Product Owner activation.

```text
identify process problem
→ create/update DRAFT MPO entry
→ resolve scope/owners/conflicts
→ present concise decision
→ Product Owner approval
→ set ACTIVE
```

Do not rewrite all Global owners merely to activate an experimental optimization. One concise Product Owner activation decision is enough to move a prepared DRAFT to ACTIVE. Do not create a separate registration, Drive file, or project experiment document per MPO.

### `PROCESS POOL STATUS`

Return a concise status of Pool entries grouped by ACTIVE, VALIDATED, promotion-ready, DRAFT, and REJECTED/WITHDRAWN where useful.

### `PROMOTE PROCESS POOL`

Promote all eligible VALIDATED entries.

### `PROMOTE MPO-XXX`

Promote one eligible validated entry.

Promotion procedure:

```text
read validated entry
→ resolve canonical owner(s)
→ identify all conflicting/obsolete wording
→ produce integration plan
→ Product Owner approval where required
→ update canonical Global owners
→ update affected operational assets
→ remove obsolete workaround/overlay wording
→ cross-document consistency verification
→ mark entry PROMOTED
→ normal documentation closure
```

After promotion, canonical Global documents must be self-contained. Do not leave permanent “see MPO-XXX for current rule” dependencies in normalized Global wording. The Pool stores history and delta trace, not permanent policy indirection. Do not create a Git checkpoint solely because a Pool status changed.

---

## 27. MAG Knowledge Control routing

This section is the Global owner of MAG Knowledge Control **AI routing behavior**: Entry Gate, intents, Identity Scope × Intent × Verified Applicability, Locator states, and same-scope canonical fallback.

It does **not** create MAG authority. Ecosystem isolation and Knowledge Control classification remain in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). Mechanical Action Gate remains in [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md). Generated discovery artifact mechanics remain in [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md).

Invariant: **CONTROL → ROUTING → AUTHORITY**. Successful routing is a pointer to a canonical owner section, not evidence and not authority.

### Entry Gate

Before substantive MAG coordination, classify the turn as **CONTINUE** or **RESOLVE**.

**CONTINUE** only when all of the following hold:

- the immediately preceding assistant turn stated an explicit next action;
- current Product Owner input is pure continuation/approval;
- same valid `working_identity` (`GLOBAL`, `GLOBAL+#N`, or `GLOBAL+A<N>`);
- no topic/identity transition, correction, contradiction, or authority uncertainty.

Otherwise **RESOLVE**.

Do not infer identity from an arbitrary opened file or distant conversation history. Platform or surface does not determine identity.

### Working state (ephemeral, not authority)

Session cache only:

- `working_identity`
- `working_task`
- `working_intent`
- `working_owners_opened`
- `working_block`

This state is cache, not authority. A Product Owner correction invalidates dependent `working_*` state.

### Intents

Only these intents are approved:

- `GOVERN`
- `PLAN`
- `IMPLEMENT`
- `DEBUG`
- `VERIFY`
- `LEARN`

Unknown intent is out of scope. Do not invent additional intents.

### Retrieval model — Identity Scope × Intent × Verified Applicability

Establish **identity scope** before semantic retrieval.

- **GLOBAL** permits Global owners and Global operational assets only.
- **GLOBAL + active development identity** (`GLOBAL+#N` or `GLOBAL+A<N>`) permits Global plus **that** development only.
- Do not use `GLOBAL+B<N>` while `B<N>` is reserved.
- Never retrieve another development's WHAT unless the Product Owner explicitly authorizes a real cross-development task.
- Platform or surface is not identity.

After identity scope, apply **Verified Applicability**. It filters which Global HOW is eligible for the current Product Class, surface, and technology. Applicability is not authority. Keyword similarity is not proof of applicability. The current canonical owner body wins over working state, Locator, generated index, and conversation.

Absence of a specialized profile means use the Global Core Lifecycle. Do not block a valid `A<N>` development for lack of a profile. Do not import `#N` HOW into `A<N>`.

Generated discovery may lag this taxonomy. A missing exact-scope generated index does not mean knowledge is absent. Same-scope canonical fallback remains required.

`MAG_IMPLEMENTATION_PATTERNS.md` applicability requires verified Scope compatibility. Keyword similarity alone is insufficient.

Intent-allowed owner classes (routing filter, not authority):

| Intent | Allowed owner classes |
| --- | --- |
| `GOVERN` | `global_authority_section`, `global_process_section`, `global_operational_section` |
| `PLAN` | `global_authority_section`, `global_operational_section`, `development_tz`, `development_roadmap`, `development_architecture`, `development_idea`, `development_readme` |
| `IMPLEMENT` | `reusable_pattern_unit`, `reusable_knowledge_procedure`, `global_authority_section`, `development_architecture`, `development_class_map` |
| `DEBUG` | `global_operational_section`, `reusable_pattern_unit`, `reusable_knowledge_procedure`, `global_authority_section`, `development_audit`, `development_architecture`, `development_class_map` |
| `VERIFY` | `global_authority_section`, `reusable_knowledge_procedure`, `reusable_pattern_unit`, `development_audit`, `development_changelog`, `development_roadmap` |
| `LEARN` | `reusable_knowledge_procedure`, `reusable_pattern_unit`, `global_operational_section`, `global_authority_section` |

### Locator

When an appropriate current generated index is available, Locator may be used as **routing only**. Locator does not regenerate the index as part of retrieval. Generated indexes are not canonical MAG documents.

Locator states:

- `FOUND`
- `NOT_FOUND`
- `AMBIGUOUS`
- `STALE/CONFLICT`
- `OUT_OF_SCOPE`

Semantics:

- `FOUND` is a pointer, not evidence. Open the canonical owner section named by the pointer before using the rule.
- `NOT_FOUND` does not mean knowledge is absent.
- `AMBIGUOUS` must not be silently resolved.
- `STALE/CONFLICT` results must be discarded. Do not use stale “last-good” routing as authority.
- `OUT_OF_SCOPE` must not broaden identity scope.

The current canonical owner body always wins over working state, Locator, generated index, and conversation.

Generated indexes are optional routing. They may lag taxonomy. Do not invent an index filename recipe for a missing identity scope. Do not change generated-index schema from this section.

### Retrieval surfaces

Executor-specific documentation surfaces are owned by [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md). This subsection states the Knowledge Control routing consequence.

**ChatGPT:** identity/scope resolution → direct Google Drive retrieval when relevant and available → same-scope fallback only when direct retrieval is unavailable or insufficient → Mirror only when the task actually concerns Mirror transport/reconciliation or another applicable rule requires it.

**Cursor:** identity/scope resolution → Local → Mirror when freshness, reconciliation, or possible externally-authored changes are relevant → apply existing comparison/conflict rules → no direct Google Drive access unless the Product Owner explicitly requests it for the current task.

Do not create one universal Drive-first or Mirror-first retrieval rule. Mirror is not a Knowledge Control source.

### Fallback

If Locator is missing, unavailable, failed, stale, conflicting, unsupported, or otherwise unusable, fall back to **same-scope, section-oriented canonical retrieval**. Fallback must not broaden identity scope. Missing generated discovery is not knowledge absence.

If required authority remains unresolved after fallback, the result is **Unknown**. Do not invent.

Goal-bound completion in §4 applies to Knowledge Control sessions: close the current goal when its canonical completion conditions are satisfied. An adjacent Mirror/baseline/tooling defect is not a retrieval or registration blocker unless that completion condition actually depends on it.
