# MAG Ecosystem — AI Coding Agent Rules

- MAG-Document-ID: `AI_AGENTS_RULES.md`
- MAG-Content-Updated: `2026-09-12T10:56:10+03:00`

These rules define **how coding agents may execute** work in MAG repositories.

They apply equally to Cursor Agent, Codex, and any future coding agent used on MAG work.

Coding agents are **implementation tools**. They do not own strategy, independent research, architecture, requirements, or project management. Broader MAG development policy is in [`AI_GUIDELINES.md`](AI_GUIDELINES.md). Ecosystem structure, active development identity, and documentation authority navigation are in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). Do not restate those documents here.

Respect **GLOBAL + active development identity** isolation per `MAG_ECOSYSTEM.md`. XenForo-specific execution rules apply only when that identity is a `#N` XenForo add-on project.

Ordered phase transitions and documentation timing are defined in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md). That lifecycle does not expand the execution scope authorized under this document.

Reusable-knowledge capture mechanics belong in [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md). Evaluation integration at procedure completion belongs in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §22. Do not duplicate those procedures here.

Which agent is used is a user/tooling choice. These rules do not change when a more capable agent is introduced. Tool capability does not grant permission to exceed the approved task.

Cursor model-selection / model-routing policy belongs in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §24.4. Cursor usage accounting, Before/After telemetry, and MAG Cursor report-field methodology belong in [`CURSOR_USAGE_ANALYTICS.md`](CURSOR_USAGE_ANALYTICS.md). Do not invent usage percentages here. Do not duplicate the model matrix in this file.

---

## 1. Mandatory Cursor pre-flight and Plain text output

These rules are **mandatory prerequisites** for every Cursor-assisted procedure. They apply to Implementation, Debugging, Testing, Audit, Compatibility investigation, Documentation, Release finalization, Repository inspection, Refactoring, Cleanup, Rollback, and other Cursor-assisted work.

### 1.1 Mandatory Cursor pre-flight

For every Cursor procedure, follow [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §24 for prompt approval/continuation, presentation order, post-execution review, model routing, and the Ukrainian learning note. That section alone owns presentation and model-selection policy; do not recreate its ordered block here.

Mandatory execution and Plain text requirements remain in this document. Respect **GLOBAL + active development identity** isolation and the approved repository/tool context. Resolve an unknown or ambiguous Cursor chat with the Product Owner; do not invent it.

Chat routing for measurement context, usage tracking, automatic After telemetry and failure handling, and separate usage-value display remain in [`CURSOR_USAGE_ANALYTICS.md`](CURSOR_USAGE_ANALYTICS.md). Before remains an analytics field, not a required item in the user-facing prompt presentation block. Do not routinely request manual After reporting.

### 1.2 Plain text output — mandatory

ChatGPT must provide Cursor prompts and copyable code/commands **exclusively in Plain text format**.

This requirement applies to:

- Cursor procedure prompts;
- source code intended for copying;
- PowerShell commands;
- Git commands;
- shell/terminal commands;
- configuration snippets;
- other technical content intended to be copied into Cursor, Terminal, source files, or development tools.

Do **not** use for that content:

- Writing Blocks;
- rich editable blocks;
- special interactive writing formats;
- generated document/artifact containers for ordinary copyable prompts or code.

Purpose: keep technical content directly copyable, predictable, compatible with MAG Workflow Bridge, free from UI-specific transformations, and suitable for deterministic transfer between ChatGPT, Cursor, Terminal, and other development tools.

Normal Markdown formatting may still be used for explanatory conversation when the content is **not** intended for direct technical transfer. The Plain text rule does not prohibit ordinary explanatory formatting in that case.

---

## 2. Allowed tasks

An AI coding agent may:

- Inspect existing repository code and structure required for the defined task.
- Locate files, classes, templates, styles, JavaScript, PHP, XML, configuration, or other components relevant to that task.
- Read Global and active-development documentation required for the current task.
- Implement from an approved, clearly specified change.
- Modify existing code according to explicit requirements.
- Analyze bugs within the repository.
- Optimize or refactor existing code when explicitly requested.
- When the active development identity is `#N`, inspect installed XenForo source when the approved task requires it.
- Run relevant local tests, linters, syntax checks, or development commands needed to verify **this** change.
- Inspect Git status and diffs to understand or validate its own work.
- Report exactly which files were changed and why.
- Identify unrelated problems without modifying them.

---

## 3. Prohibited tasks

An AI coding agent must not:

- Search the internet unless explicitly authorized for a specific task.
- Perform independent external documentation research.
- Independently learn XenForo APIs or frameworks outside the approved task.
- Make architectural decisions or redesign architecture.
- Analyze or define requirements (including inventing missing requirements).
- Explore or choose new solutions as a research exercise.
- Expand task scope without approval.
- Add speculative functionality or implement unspecified future work.
- Implement future stages prematurely.
- Modify unrelated files.
- Fix unrelated issues without authorization.
- Rewrite or reorganize documentation unless explicitly requested.
- Perform unnecessary repository-wide analysis.
- Replace stable working code merely because another implementation looks cleaner, more modern, more elegant, more abstract, or more reusable.
- Introduce abstractions without a current verified need.
- Perform Git lifecycle operations that the user can reasonably handle, unless explicitly requested.
- Restore, reset, discard, delete, or otherwise alter unrelated user work unless explicitly authorized.

Before using an agent **outside** these permitted cases, explain the reason and obtain **explicit approval**.

---

## 4. Required task definition

Before implementation, the task should be sufficiently defined, including where applicable:

1. Exact goal.
2. Expected behavior.
3. Relevant architectural constraints.
4. Current approved stage or increment.
5. Relevant files or subsystem, if already known.
6. What must not be changed.
7. Validation criteria.

If critical information is missing and cannot be determined safely from the repository or approved documentation, **stop and ask**. Do not invent the missing decision.

---

## 5. Implementation workflow

For each task:

1. Inspect only the repository areas needed to understand the task.
2. Read only the documentation relevant to the task (GLOBAL + active development identity).
3. Confirm the existing implementation before modifying it (Existing Code First).
4. Identify dependencies on existing functionality.
5. Follow approved architecture and conventions.
6. Make the smallest sufficient change.
7. Avoid unrelated refactoring.
8. Preserve verified working functionality unless the task explicitly requires changing it.
9. Run only relevant validation.
10. Review the resulting changes (inspect the actual diff).
11. Report the result for manual user review.
12. Stop when the defined task is complete.

Do not automatically continue into another stage or adjacent task.

Do not modify a MAG repository that is outside the approved procedure scope.

---

## 6. Scope and stable-code protection

Use the smallest change that fully solves the defined task.

Do not add speculative features, prepare unused future infrastructure, rename without reason, change conventions unnecessarily, or implement work assigned to later stages.

Discovery of an unrelated problem does not expand the approved task. Report it separately.

If a requested change creates a significant risk to a known stable state, identify that risk **before** making the potentially destructive change. Where practical, preserve a clear path back to the previously verified state.

---

## 7. Documentation during agent execution

An agent may read documentation required to implement the current task.

An agent must not independently reinterpret requirements, rewrite or restructure documentation, “improve” documentation outside the task, change stage status, or resolve documentation conflicts by assumption.

Documentation modification must be an explicit part of the approved task.

If documentation and implementation conflict, **report the conflict**. Do not silently choose a new interpretation.

If implementation appears to require an architectural change, **stop** and report: why the current architecture appears insufficient; the technical conflict; which requirement or boundary is affected; what decision is required. Continue only after that decision is made through the normal MAG process.

When completed work may have produced reusable technical knowledge, follow the evaluation rules in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §22. If a qualifying candidate is found but updating `MAG-Ecosystem` is outside the approved task scope, report it to the product owner. Do not modify Global documentation without approval.

---

## 8. XenForo inspection

**Applies when the active development identity is `#N`.**

Do not invent XenForo APIs or undocumented framework behavior.

When the approved task requires verification of uncertain XenForo behavior, inspect **only** the installed XenForo source relevant to that task.

Do not treat a source-inspection need as permission for broad independent framework research.

If installed source is insufficient and external documentation research becomes necessary, **stop** and request explicit authorization before that research.

---

## 9. Validation

Validation effort must match the **actual change and risk**.

Apply the material-change filter and evidence-reuse rules in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §18. Reuse immediately preceding **valid** verification where it still applies. Do not repeat expensive checks (broad regression, security, or performance suites; full release-finalization) without a concrete reason. A lifecycle or status transition alone is not evidence invalidation.

Prefer the **minimum sufficient safe path**: when the objective is approved, evidence remains valid, and no authority/risk/scope boundary changed, execute the smallest safe procedure. Do not re-analyze merely to re-create ceremony.

Release-artifact rules, Release Finalization scope, and Release Presentation gating are defined in `AI_GUIDELINES.md` and `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 8. Agents must not overwrite canonical `_releases` ZIP filenames. Test builds must be renamed immediately. Do not build the final release ZIP before required Release Presentation data is approved and applied.

Distinguish:

- Validation actually performed.
- Validation that passed.
- Validation that failed.
- Validation not performed.
- Manual verification still required.
- Product Owner Practical Acceptance still required or pending.
- Assumptions that remain unverified.

Do not claim a test passed, XenForo compatibility was verified, runtime behavior was proven from static inspection, or Git state was inspected, unless that is true.

Do not treat completed technical validation as sufficient for Gate 3 — Release Readiness, Release Finalization, or Stable Release when required Product Owner Practical Acceptance per `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 7 remains pending or has not **PASS**.

Selecting a cheaper Cursor model must not reduce these validation requirements.

### Redundant pre-commit review

Do not perform a redundant pre-commit review when the immediately preceding finalization or implementation procedure has already provided sufficient verification and the remaining work only synchronizes approved documentation or other already-approved changes.

In such cases, inspect the resulting diff/report and proceed to the Git checkpoint without starting another separate review procedure.

A new review is required only when the synchronization introduces unexpected changes, unresolved issues, or invalidates previous verification.

### Proportional point-change execution

When a change is already understood, approved, and technically verified, execute only the minimum procedure needed for that exact change and its necessary validation.

- Do not repeat architecture analysis, source audits, research, broad regression review, or already-valid verification without a concrete new uncertainty or risk.
- Do not split one simple deterministic correction into multiple artificial procedures when one procedure can safely perform the change, synchronize the local installed copy when required, and enable Product Owner verification.
- Validation remains proportional to actual change and risk.
- Expand scope only when new uncertainty, dependency, unexpected behavior, security/compatibility concern, or other material risk justifies it.

This optimization must not weaken required validation. Detailed proportional-validation rules remain in `AI_GUIDELINES.md` §18.

---

## 10. User control and Git

Agents may inspect Git status and diffs when needed to understand or validate their own changes.

They must **not**, unless explicitly requested:

- `git add`
- `git commit`
- `git push`
- branch creation or management
- merge
- release tagging
- repository publishing
- `git reset`, restore, or discard of user work

The user reviews, stages, commits, and publishes.

Do not treat an incomplete manual step as completed.

When a required operation is simple, deterministic, and better done by the user, provide the exact command or action instead of consuming the agent to perform it. Include where it should run, what success looks like, and what the user should return when verification is required.

Ready-to-copy technical commands must be provided in **Plain text** per §1.2.

### Checkpoint-protection filter

Before proposing an intermediate Git checkpoint, ask:

**What material state or recovery boundary does this checkpoint protect?**

Do **not** create a separate checkpoint merely because a lifecycle label, status marker, validation report, or mechanical sub-step changed. Apply the detailed checkpoint-protection rules in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §20. Where the lifecycle explicitly mandates a checkpoint, that remains authoritative.

Standard checkpoint:

```text
Approved stage/phase work complete
        ↓
Synchronize authoritative documentation and Cursor usage history where required
        ↓
Review resulting diff and repository status
        ↓
Resolve Critical issues before closure
        ↓
Agent reports result
        ↓
User reviews changes
        ↓
User performs Git operations when authorized
        ↓
Verify clean working tree
        ↓
Stable Git checkpoint
        ↓
Proceed to next approved stage/phase only after closure
```

Authoritative stage/phase closure discipline is defined in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §20.

When the approved task is a completed stage checkpoint, synchronize that project's changelog as part of the same increment. A stage is not complete until required changelog synchronization is finished.

Within a coherent block, prefer one justified checkpoint at the material boundary rather than status-only intermediate commits.

---

## 11. Stop and report

Stop **before** continuing when:

- Requirements are ambiguous and cannot be resolved safely from approved sources.
- Authoritative documents conflict.
- Undocumented XenForo behavior must be verified beyond targeted installed-source inspection (or that inspection is insufficient).
- Implementation would cross an approved rule boundary.
- A required manual or user action is incomplete.
- An unexpected **Critical** issue is discovered.
- The task would require an exception to these rules.

Then tell the user:

1. Which rule or restriction was reached.
2. Why the task cannot safely continue.
3. The exact action, decision, information, permission, or manual operation required.
4. What the agent can do after that action is completed.

Do not silently bypass the rule, assume permission, invent the missing decision, perform a prohibited operation because it seems necessary, or abandon the task without explaining how to unblock it.

### Executor / tool failure recovery

If an execution tool such as Cursor or Work fails:

1. diagnose the concrete failure;
2. correct or safely reroute the current execution step;
3. preserve previously established valid evidence;
4. continue through the minimum sufficient safe path.

Do **not** transform a tool/executor failure into:

- a new lifecycle phase;
- a new approval framework;
- a new documentation-governance process;
- repeated full audits;
- repeated planning without evidence invalidation.

Documentation executor capability failures additionally follow [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md) §§8.1, 10.3, and 16.

### Incomplete user actions

If a previously requested user action was only partial or unsuccessful, stop again. State what succeeded, what remains, why work cannot continue, the exact next user action, and how success can be recognized.

Do not work around an incomplete user action, assume a partial action is enough, change implementation to compensate for an unresolved environment problem, or continue later steps while an earlier required step remains incomplete.

```text
Stop
  ↓
Explain the blocker
  ↓
Tell the user exactly what they need to do
  ↓
User performs the action
  ↓
Verify the result
  ↓
Incomplete?
  ├── YES → Explain exact remaining action → Verify again
  └── NO  → Continue
```

### Micro-process anti-patterns

Treat the following as process smells and avoid them:

**A.** `status changed → edit docs → commit → push` repeated during one uninterrupted objective without material change.

**B.** `validation passed → lifecycle status changed → repeat same validation` without relevant evidence invalidation.

**C.** `approved next action → request confirmation again → execute one mechanical step → request confirmation again` without a new Product Owner decision.

**D.** `Cursor/Work failure → redesign process → create new governance procedure` when the correct response is to fix or reroute the current executor step.
---

## 12. Procedure report

After completing a task, provide a concise report containing:

- Files changed.
- What was changed.
- Validation performed, results, and validation not performed where relevant.
- Manual verification still required.
- Unresolved issues.
- Assumptions.
- Relevant risks.

Classify discovered issues as:

- **Critical**
- **Non-critical**
- **Informational**

Do not `git commit` or `git push` unless explicitly requested.

When Cursor procedures apply, follow `AI_GUIDELINES.md` §24 for presentation, post-execution review, and model selection. Follow `CURSOR_USAGE_ANALYTICS.md` for Before/After tracking, telemetry handling, and separate usage-value display only.

---

## 13. Context efficiency

Use an agent only where it provides meaningful engineering value.

Do not scan the entire repository when the task concerns a known component.

Prefer targeted inspection and searches, existing documentation, explicit specifications, known paths, and focused validation.

Avoid re-reading unchanged large files, broad exploration without a reason, re-reading unrelated history, broad test suites for isolated changes without justification, and repeating operations whose result is already known and still valid.

Keep simple manual operations manual.

---

## 14. Core principle

AI coding agents execute **defined** engineering work. They do not independently define the project.

```text
Plan
  ↓
Specify
  ↓
Implement
  ↓
Validate
  ↓
Review
  ↓
Manual Git operations
```

Keep implementation focused. Keep final control with the user.
