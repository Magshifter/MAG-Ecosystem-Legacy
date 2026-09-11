# MAG Ecosystem — AI Development Guidelines

- MAG-Document-ID: `AI_GUIDELINES.md`
- MAG-Content-Updated: `2026-09-10T19:20:00+03:00`

This document is the **Global MAG development standard**. It defines **how** MAG XenForo add-ons are developed with AI assistance.

It applies to ChatGPT, Cursor IDE, Cursor Agent, Codex, and any other AI-assisted tool used on MAG work.

Ecosystem identity, project registry, `#N` markers, Global vs Project documentation levels, AI context isolation, high-level documentation authority, project bootstrap, and the License Manager concept are defined in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). This file does not restate those definitions. Load **GLOBAL + the active `#N`** as specified there.

Detailed coding-agent execution boundaries, mandatory Cursor pre-flight, Plain text output requirements, checkpoint mechanics, and report formats belong in `AI_AGENTS_RULES.md`.

ChatGPT → Product Owner → Cursor prompt presentation and post-execution review belong in §24 of this document.

Cursor model selection, usage metrics, Cursor Models Before/After methodology (including automatic After telemetry consumption and failure handling), post-execution usage-value display, history recording, and forecasting methodology belong in `CURSOR_USAGE_ANALYTICS.md`. Project measurement history belongs in the project repository. Do not duplicate that methodology or the model-selection matrix here.

---

Lifecycle order, gates, and documentation timing are canonical in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md). This document owns detailed development and closure mechanics applied at those lifecycle checkpoints.

## 1. Purpose and philosophy

MAG development must remain:

- Correct.
- Stable.
- Maintainable.
- Compatible with the XenForo versions declared by the active project.
- Secure.
- Performant.
- Accurately documented.
- Incrementally developed under **manual user control**.

AI must not treat MAG work as an open-ended rewrite, a research project, or a license to implement later stages because they seem useful.

---

## 2. Authority (development use)

Use the authority model in `MAG_ECOSYSTEM.md`. For implementation work, apply it as follows:

| Source | Use |
| --- | --- |
| `MAG_ECOSYSTEM.md` | Ecosystem identity, registry, documentation map, authority navigation, and GLOBAL + active `#N` context isolation. |
| `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` | Lifecycle order, stage gates, and documentation timing. Stage/phase closure mechanics in this document apply at those checkpoints. |
| Global documentation (other) | Process, tools, Git, security/performance/testing standards, XenForo development rules. |
| `MAG_IMPLEMENTATION_PATTERNS.md` | Reusable, evidence-backed technical knowledge. Subordinate to Global process documents and active-project TZ, Roadmap, and Architecture. Not a source of product requirements. |
| Project TZ | What the add-on must do. Canonical filename: `P<NN>__<CODE>__TZ.md` (`MAG_ECOSYSTEM.md`). |
| Project Roadmap | What increment is approved **now**, and verified progress. |
| Project Architecture | Approved implementation architecture. Does not override TZ. |
| Project CLASS_MAP | Current classes and responsibilities as they exist. |
| Actual project code | What is currently implemented. Documentation must not claim code that does not exist. |
| Installed XenForo source | Undocumented or uncertain framework behavior. |
| Changelog / Git history | History. Do not rewrite the past. |
| README / overview | Descriptive only. |
| Idea | Non-authoritative research. |

`AI_AGENTS_RULES.md` (when present) additionally constrains repository-task execution and states mandatory Cursor pre-flight and Plain text execution requirements. Cursor prompt presentation and post-execution review remain in §24 of this document. Cursor model selection and usage metrics remain in `CURSOR_USAGE_ANALYTICS.md`. If Global documents conflict, **stop and report** rather than silently choosing one.

AI must not invent XenForo APIs or rely on assumptions when installed XenForo source can be inspected.

---

## 3. Incremental development and manual control

Development must remain incremental and controlled by the user.

AI must:

- Read the relevant project requirements before proposing changes.
- Inspect the existing implementation in the active `#N` repository.
- Preserve verified working behavior.
- Identify affected classes and dependencies.
- Explain the proposed change.
- Implement only the requested scope.
- Verify XenForo compatibility for the versions in that project's scope.
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

ChatGPT must not assume undocumented XenForo behavior.

ChatGPT must not silently replace Cursor Agent implementation or the user's Git control.

### Cursor IDE

Cursor IDE is the **primary environment** for:

- Inspecting the local repository.
- Editing files.
- Running local development tasks.
- Testing the add-on.
- Reviewing changes.
- Inspecting installed XenForo source.

### Cursor Agent

Cursor Agent is a **last-resort implementation tool**.

Cursor Agent must **not** be used for:

- Internet searches.
- External documentation research.
- Learning XenForo APIs.
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
- XenForo standards.
- Existing Code First principle.
- Security requirements.
- Performance requirements.
- Documentation rules.
- Git workflow.

Codex must not independently expand implementation beyond the approved stage or task.

### User

The user is product owner: requirements, sequencing, reviews, Git, and releases. Final repository control remains with the user.

No assistant may treat another assistant's draft as approved product or process unless the user has accepted it.

---

## 5. Stage discipline

Follow the stages (or equivalent approved increments) defined in the **active project's** TZ and Roadmap (canonical filenames in `MAG_ECOSYSTEM.md`).

Before implementing a stage:

1. Read the relevant requirements.
2. Read the relevant roadmap section.
3. Inspect current project structure.
4. Inspect related existing code.
5. Identify dependencies.
6. Explain the proposed implementation.
7. Implement **only** the requested stage.
8. Test the result.
9. Review XenForo compatibility.
10. Review security implications as appropriate.
11. Review performance implications as appropriate.
12. Update affected documentation.
13. Prepare the Git checkpoint (user owns commit unless they explicitly request otherwise).

Never automatically implement future stages.

A **minimal** prerequisite from a later stage may be introduced only when:

- The current stage cannot be completed correctly without it.
- The dependency is explicitly identified.
- The scope remains minimal.
- The reason is documented.
- No unrelated future functionality is added.

Existing code from later or earlier stages must not be deleted merely because those stages are incomplete.

A stage may be marked complete only when the project's Roadmap conditions are satisfied. Completion generally requires: required implementation exists; relevant XenForo behavior is verified; tests appropriate to the stage pass; security and performance implications are reviewed; development diagnostics are handled; documentation is synchronized (including the changelog entry the project requires); Cursor usage history is synchronized when applicable; the result is ready for a Git checkpoint; and the approved stage/phase closure sequence in §20 has been completed.

Architecture approval alone does not complete a stage. The presence of placeholder or Alpha code alone does not complete a stage.

Do not interpret stage closure as requiring a Git commit after every tiny action, command, inspection, audit step, or intermediate Cursor procedure. Git checkpoints correspond to completed and approved logical stages/phases or other explicitly approved meaningful checkpoints.

---

## 6. Language

All source code must be written in **English**.

This includes identifiers, filenames, directory names, comments, PHPDoc, JavaScript identifiers, CSS class names, and Git commit messages.

Project documentation is maintained in English unless a separate translated document is explicitly required.

All user-facing XenForo text must use the XenForo Phrase system. User-facing strings must not be hardcoded into PHP or JavaScript.

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
8. Reuse existing XenForo mechanisms.
9. Make the smallest reasonably focused change.

Do not recreate an existing class unless there is a verified technical reason.

Do not introduce a new abstraction only to support hypothetical future functionality or "ecosystem sharing." Shared MAG components exist only under `MAG_ECOSYSTEM.md` (real cross-project requirement, approved).

---

## 8. XenForo standards

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

Third-party add-ons may be inspected to identify candidate XenForo integration points, compatibility considerations, common patterns, and pitfalls.

Third-party code is **not** authoritative XenForo documentation.

Do not blindly copy architecture, code, security or performance behavior, licensing behavior, branding mechanisms, or legacy workarounds.

Every adopted mechanism must be independently verified against installed XenForo source, the project's TZ, MAG architecture, security and performance requirements, and current stage scope.

---

## 10. PHP standards

Use:

```php
declare(strict_types=1);
```

PHP must:

- Follow XenForo-compatible style for the project.
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

JavaScript must remain minimal.

JavaScript may support verified frontend behavior that cannot reasonably be handled by server-rendered markup or CSS, integrate with the XenForo frontend lifecycle where required, and apply presentation behavior to supported dynamic content.

JavaScript must not perform untrusted remote discovery or download, security validation that belongs on the server, server cache control, whole-page DOM scanning as primary architecture, injection into unrelated XenForo UI, or compensation for avoidable server architecture problems.

Use XenForo LESS templates for integrated styling where appropriate. Selectors must be scoped to the add-on.

Presentation must avoid layout shifts, content jumping, horizontal overflow, covered content, unstable alignment, and unnecessary specificity.

Consider desktop, mobile, supported XenForo styles, dynamic content, and RTL where applicable.

Do not maintain duplicate CSS and LESS sources without a documented build or packaging reason.

---

## 12. Content scope

An add-on must process only the XenForo content types and surfaces declared in that project's TZ.

Do not globally inject behavior into unrelated UI (navigation, header, footer, breadcrumbs, standard sidebar, widgets, lists, user menus, Admin CP, and similar) unless the project's requirements explicitly include that surface.

A complete-page DOM scan must not be the primary integration architecture unless TZ and Architecture explicitly require it and XenForo source has been verified.

---

## 13. Security

Untrusted input, untrusted URLs, and untrusted remote responses remain untrusted.

Where a MAG add-on performs external HTTP or stores untrusted files, the **controlled server path** (not normal page rendering) must provide appropriate protection against SSRF, unsafe addresses and schemes, unsafe or excessive redirects, oversized responses, invalid status or type, and malicious payload content. Every redirect destination must be validated.

Prefer XenForo's native untrusted HTTP reader and related facilities when they meet the requirement.

Security failures must not produce fatal XenForo errors during normal forum use.

Errors must not expose sensitive information to users.

Temporary diagnostics must be removed or appropriately replaced before the relevant stage is complete.

Logging must use appropriate severity and must not flood XenForo logs during normal behavior.

---

## 14. Error handling

Add-on failures must fail gracefully.

Normal forum use must continue when parsing, remote requests, storage, cache, or optional features fail.

Do not couple ordinary rendering to the availability of optional external services.

---

## 15. Performance

Performance is a core architecture requirement.

AI must avoid:

- Blocking the XenForo request on avoidable external work.
- Repeated work for the same key without a verified cache or suppression policy.
- Unnecessary database queries and filesystem operations.
- Global DOM scanning.
- Duplicate frontend initialization.
- Large unbounded downloads.

Rendering (or other user-facing request paths declared by the project) must complete normally when optional remote data is missing, slow, unavailable, previously failed, or expired.

Experimental observations are not formal benchmarks and must not be used to roll back a roadmap without approval.

---

## 16. Localization

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

Potential verification includes syntax validation, focused unit tests, XenForo integration checks, add-on data import/export, install/upgrade/uninstall, rendering and AJAX/dynamic-content checks, filesystem and HTTP behavior, security tests, and performance measurements.

Production or live-site observation must not substitute for controlled local verification.

Do not claim tests were run when they were not.

---

## 18. Efficient validation

Validation effort must be **proportional** to the change and to verification already performed.

Do not introduce redundant procedures merely to repeat already sufficient verification.

A later documentation-only or already-approved synchronization does not require a new full review, security audit, or release-finalization suite unless the synchronization introduces unexpected changes, unresolved issues, or invalidates previous verification.

Release Finalization (when a project uses it) verifies the **artifact and deployment boundary**. It does not repeat the preceding stage audit unless that audit has been invalidated (production behavior changed after the audit, a release-blocking defect was found, packaging exposed a problem requiring production changes, or another concrete reason).

### Proportional point-change execution

When a change is already understood, approved, and technically verified, use a **point procedure** limited to the exact change and the validation that change actually requires.

- Do not repeat architecture analysis, source audits, research, broad regression review, or already-valid verification without a concrete new uncertainty or risk.
- Do not split one simple deterministic correction into multiple artificial procedures when one procedure can safely perform the change, synchronize the local installed copy when required, and enable Product Owner verification.
- Validation remains proportional to actual change and risk.
- Expand scope only when new uncertainty, dependency, unexpected behavior, security/compatibility concern, or other material risk justifies it.

This optimization must not weaken required validation.

### Product Owner Practical Acceptance

Per [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) Phase 7, technical or automated validation alone does not complete Integration and Final Validation. Required Product Owner Practical Acceptance must reach explicit **PASS** before Gate 3 — Release Readiness.

Do not treat technical validation as sufficient for release readiness, Release Finalization, or Stable Release while required Practical Acceptance remains pending or has failed.

When Practical Acceptance finds a defect, return proportionally to the earliest affected lifecycle point. Preserve unaffected valid verification evidence; do not automatically repeat audits, architecture analysis, or broad regression work.

This pre-release acceptance does not replace Phase 9 — Post-Release Verification.

## 19. Backwards compatibility

A shipping MAG version is a product baseline, not a permanent public API freeze.

Existing structures may change when the active stage requires it (markup, data attributes, JavaScript, CSS, constructors, method signatures, storage layout, and similar). Such changes must be required, explained before implementation, verified against XenForo, tested, reflected in documentation, and checkpointed in Git.

Working behavior must not be broken casually. Preserve the current shipping product of `#N` unless the approved increment explicitly changes it.

---

## 20. Git workflow

The verified local working copy is authoritative for pending local changes.

The configured remote records the last published repository state.

Each completed and approved logical stage or project phase must be closed with documentation synchronization and a Git checkpoint before work proceeds to the next stage or phase.

This does **not** require a commit after every tiny action, command, inspection, audit step, or intermediate Cursor procedure. Git checkpoints correspond to completed and approved logical stages/phases or other explicitly approved meaningful checkpoints.

Do not commit incomplete, unreviewed, or known-broken work merely to satisfy the checkpoint rule.

Documentation must describe the approved actual state, not planned or assumed completion.

Historical documentation and Git history remain historical records and must not be rewritten to make later decisions appear earlier.

The **user** owns `git add`, `git commit`, and `git push` unless they explicitly request the agent to perform them.

If a stage reveals unresolved **Critical** issues, the stage is not closed and progression is blocked.

### Stage and phase closure sequence

1. Complete the approved work for the current logical stage/phase.
2. Review and explicitly approve the result where product-owner approval is required.
3. Synchronize authoritative project documentation with the actual approved state.
4. When relevant work may have produced reusable technical knowledge, evaluate it for `MAG_IMPLEMENTATION_PATTERNS.md` per §22.
5. Synchronize Cursor usage history when the completed stage/phase included Cursor procedures. Follow [`CURSOR_USAGE_ANALYTICS.md`](CURSOR_USAGE_ANALYTICS.md) §8. Prefer finalizing **Cursor Models After** from valid automatic MAG GPT|Cursor|Sync report telemetry without a Product Owner measurement step. If automatic After is missing/invalid, notify the Product Owner per that document’s telemetry-failure rule and preserve unavailable/pending metrics; do not invent or silently substitute values. Do not launch a standalone metric-finalization procedure.
6. Review the resulting documentation/code diff and repository status.
7. Resolve Critical issues before closure.
8. Create a logical Git commit representing the completed stage/phase when the user requests or authorizes it.
9. Push the approved commit when the user authorizes/executes the push.
10. Verify the working tree is clean.
11. Only then proceed to the next logical stage/phase.

Before publishing:

1. Verify the permanent repository root for the active `#N` (or `MAG-Ecosystem` for Global documentation).
2. Verify intended XenForo add-on structure when the repository is an add-on.
3. Review all changes.
4. Confirm no temporary restore directories are tracked.
5. Confirm no XenForo core or environment-specific files are included.
6. Test the applicable stage.
7. Synchronize documentation.
8. Commit with an English message when the user requests it.
9. Push only the verified local commit when the user requests it.

Do not claim Git state was verified unless it was actually inspected.

Preserve unrelated user changes.

Expected **add-on** repository form (logical; exact paths may vary):

```text
RepositoryRoot
├── .git
├── .gitignore
├── P<NN>__<CODE>__README.md
├── P<NN>__<CODE>__TZ.md
├── P<NN>__<CODE>__Idea.md          (optional)
├── docs/
│   └── P<NN>__<CODE>__*.md
└── src/addons/MAG/<AddOnDirectory>
```

Canonical project documentation filenames are defined in `MAG_ECOSYSTEM.md`. Do not invent a second naming layer.

Global process files live in `MAG-Ecosystem`, not inside each add-on, once migration of those files is complete.

Do not claim a MAG add-on repository must keep copies of Global `AI_GUIDELINES.md` after that migration is approved.

---

## 21. Release artifact preservation

Release Presentation requirements, sequence, and final-package gating are canonical in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) Phase 8. Do not build the final release ZIP before required Release Presentation data is approved and applied per that workflow.

Finalized XenForo release ZIP archives in `_releases` are immutable historical artifacts.

- Never overwrite, replace, or reuse the filename of a previously finalized release ZIP.
- Test and development builds must not use the filename of an existing final release.
- After creating a test build, copy or rename it immediately using an explicit test identifier (for example `MAG-AddOnName-1.0.0-test.zip`).
- Final packages use the canonical version filename (for example `MAG-AddOnName-1.0.0.zip`).
- Preserve previous final release ZIPs so every published version remains recoverable.

`xf-addon:build-release` names the output ZIP from the **installed XenForo add-on version string in the database**, not from `addon.json` alone.

Before `xf-addon:build-release`:

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

After verified implementation changes, update **only** the documents the change actually affects.

Typical project documents (logical): README, TZ, Architecture, CLASS_MAP, Changelog, Roadmap, and optional overview/research files. Use the canonical `P<NN>__<CODE>__` filenames recorded in `MAG_ECOSYSTEM.md`.

Update Global documents only when process, ecosystem conventions, or reusable technical knowledge changed per `AI_GUIDELINES.md` §22.

Documentation must describe the actual verified state. Do not copy one project's product status into Global guidelines.

If code or XenForo source inspection shows that a documented requirement is incorrect, unsafe, impossible, or incompatible:

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
- XenForo/XFRM source inspection;
- testing;
- stabilization;
- release verification;
- production troubleshooting.

It does **not** require a separate Cursor procedure.

Follow the capture procedure defined in `MAG_IMPLEMENTATION_PATTERNS.md` (**Detect → Verify → Search → Classify → Determine scope → Decide → Record → Preserve authority**). Do not duplicate the full algorithm here.

Rules:

- Promote only evidence-backed findings. Do not generalize from donor behavior, assumptions, planned architecture, hypotheses, or accidental implementation behavior.
- Keep product requirements, approved project architecture, project code structure, project-specific behavior, and project history in the active `#N` documentation.
- Add or update Global reusable knowledge only when there is a meaningful future reuse case. Do not turn the knowledge base into a development log.
- If the approved procedure already includes Global documentation synchronization and a qualifying knowledge update is within scope, record it as part of that procedure.
- If reusable knowledge is discovered while working only in an active `#N` repository and modifying `MAG-Ecosystem` would cross the approved repository/procedure scope, do **not** modify Global documentation. Report the candidate to the product owner and wait for approval of a separate Global documentation update.
- Discovery of reusable knowledge does **not** authorize unrelated implementation, architecture changes, requirements changes, cross-project modifications, scope expansion, Git operations, or starting another development stage.

Entry structure, status model, and maintenance mechanics remain authoritative in `MAG_IMPLEMENTATION_PATTERNS.md`.

### ChatGPT Project files after Stable release

After a confirmed Stable release whose result is **RELEASE FINALIZATION PASS**, ChatGPT must give the user a short vertical list of ChatGPT Project files to update or replace so Project context matches the new stable state.

The list must:

- Be concise.
- Contain filenames/paths only unless the user asks for explanation.
- Be grouped by source context using `GLOBAL [MAG] Ecosystem`, `#1 [MAG] Global Links Favicons`, `#2 [MAG] Tag Synchronizer`, and future `#N` markers as applicable.
- Include only files that actually changed or that genuinely need Project-context refresh.
- Use real project-relative paths where useful, for example `docs/P01__GLF__Architecture.md`.
- Include that project's `docs/P<NN>__<CODE>__CURSOR_USAGE_HISTORY.md` when that file actually changed.

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

Do not optimize development merely to reduce Cursor quota usage. Correctness, XenForo compatibility, security, maintainability, testing, and documentation remain higher priorities.

When Cursor analytics or Cursor procedure presentation apply, follow §24 of this document for presentation and post-execution review, `CURSOR_USAGE_ANALYTICS.md` for model selection and usage metrics, and `AI_AGENTS_RULES.md` for mandatory execution and Plain text requirements. Do not invent usage percentages.

---

## 24. Cursor prompt presentation and post-execution review

This section is the Global authority for ChatGPT → Product Owner → Cursor presentation and post-execution review.

Cursor usage metrics, measurement procedure, and post-execution usage-value display belong in [`CURSOR_USAGE_ANALYTICS.md`](CURSOR_USAGE_ANALYTICS.md). Coding-agent Plain text execution requirements remain in [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md). Progressive Product Owner technical-lead learning as a permanent MAG development principle is recorded in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md).

### 24.1 When to present a Cursor prompt

Provide a prepared Cursor prompt only after the Product Owner has approved receiving it for that procedure.

### 24.2 Cursor prompt presentation order

Present information in this order:

1. **Cursor prompt** — first. A dedicated plain-text code block containing only the exact text intended for paste into Cursor. Do not place explanations or execution metadata before it. Keep the prompt concise and task-specific; reference applicable authoritative MAG rules instead of duplicating them unnecessarily.
2. **Ціль/задача** — maximally concise, informative Ukrainian description of the procedure's purpose and expected result.
3. **Cursor chat** — exact target chat. Never invent an unknown Cursor chat; resolve ambiguity with the Product Owner first.
4. **Cursor model** — recommended model/mode per [`CURSOR_USAGE_ANALYTICS.md`](CURSOR_USAGE_ANALYTICS.md) §2.5.

Do not place explanations, Cursor usage values, or other execution metadata before the copyable prompt block.

Do not require **Cursor Models Before** in the user-facing prompt presentation block. Before remains part of analytics methodology in `CURSOR_USAGE_ANALYTICS.md` when applicable.

### 24.3 Post-execution review

After a meaningful Cursor procedure, ChatGPT must immediately provide:

1. **Analysis** — whether the completed work met the approved task.
2. **Confirmed result** — what succeeded.
3. **Problems** — **Critical**, **Non-critical**, and **Unresolved** issues as applicable. If none, state that explicitly.
4. **Recommended next step / Stage** — one concrete recommendation. This does not authorize execution; Product Owner control remains required.
5. **Learning note** — a short Ukrainian note explaining what the Product Owner should understand from this stage as the person leading the development process.

Learning notes must be practical, stage-specific, concise, non-repetitive, and progressively deeper as Product Owner experience grows.

Present applicable Cursor usage values separately, per `CURSOR_USAGE_ANALYTICS.md`, without commentary or interpretation in the usage-values block.

---

## 25. Final principle

AI-assisted MAG development must remain:

- Incremental.
- Evidence-based.
- XenForo-native.
- Existing-code-first.
- Security-conscious.
- Performance-conscious.
- Precisely documented.
- Limited to the active stage of the active `#N`.
- Preservative of that project's current shipping baseline.

Work proceeds from verified code and verified XenForo behavior, not from assumptions, silent conflict resolution, or speculative future architecture.

**GLOBAL defines HOW. `#N` defines WHAT.**
