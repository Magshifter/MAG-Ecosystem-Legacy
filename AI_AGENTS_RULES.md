# MAG Ecosystem — AI Coding Agent Rules

These rules define **how coding agents may execute** work in MAG repositories.

They apply equally to Cursor Agent, Codex, and any future coding agent used on MAG work.

Coding agents are **implementation tools**. They do not own strategy, independent research, architecture, requirements, or project management. Broader MAG development policy is in [`AI_GUIDELINES.md`](AI_GUIDELINES.md). Ecosystem structure, `#N` context, and documentation authority navigation are in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). Do not restate those documents here.

Which agent is used is a user/tooling choice. These rules do not change when a more capable agent is introduced. Tool capability does not grant permission to exceed the approved task.

Cursor usage accounting and MAG Cursor report-field methodology belong in `CURSOR_USAGE_ANALYTICS.md` once that file exists. Do not invent usage percentages here.

---

## 1. Allowed tasks

An AI coding agent may:

- Inspect existing repository code and structure required for the defined task.
- Locate files, classes, templates, styles, JavaScript, PHP, XML, configuration, or other components relevant to that task.
- Read Global and active-`#N` documentation required for the current task.
- Implement from an approved, clearly specified change.
- Modify existing code according to explicit requirements.
- Analyze bugs within the repository.
- Optimize or refactor existing code when explicitly requested.
- Inspect installed XenForo source when the approved task requires it.
- Run relevant local tests, linters, syntax checks, or development commands needed to verify **this** change.
- Inspect Git status and diffs to understand or validate its own work.
- Report exactly which files were changed and why.
- Identify unrelated problems without modifying them.

---

## 2. Prohibited tasks

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

## 3. Required task definition

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

## 4. Implementation workflow

For each task:

1. Inspect only the repository areas needed to understand the task.
2. Read only the documentation relevant to the task (GLOBAL + active `#N`).
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

## 5. Scope and stable-code protection

Use the smallest change that fully solves the defined task.

Do not add speculative features, prepare unused future infrastructure, rename without reason, change conventions unnecessarily, or implement work assigned to later stages.

Discovery of an unrelated problem does not expand the approved task. Report it separately.

If a requested change creates a significant risk to a known stable state, identify that risk **before** making the potentially destructive change. Where practical, preserve a clear path back to the previously verified state.

---

## 6. Documentation during agent execution

An agent may read documentation required to implement the current task.

An agent must not independently reinterpret requirements, rewrite or restructure documentation, “improve” documentation outside the task, change stage status, or resolve documentation conflicts by assumption.

Documentation modification must be an explicit part of the approved task.

If documentation and implementation conflict, **report the conflict**. Do not silently choose a new interpretation.

If implementation appears to require an architectural change, **stop** and report: why the current architecture appears insufficient; the technical conflict; which requirement or boundary is affected; what decision is required. Continue only after that decision is made through the normal MAG process.

---

## 7. XenForo inspection

Do not invent XenForo APIs or undocumented framework behavior.

When the approved task requires verification of uncertain XenForo behavior, inspect **only** the installed XenForo source relevant to that task.

Do not treat a source-inspection need as permission for broad independent framework research.

If installed source is insufficient and external documentation research becomes necessary, **stop** and request explicit authorization before that research.

---

## 8. Validation

Validation effort must match the **actual change and risk**.

Reuse immediately preceding **valid** verification where it still applies. Do not repeat expensive checks (broad regression, security, or performance suites; full release-finalization) without a concrete reason.

Release-artifact rules and Release Finalization scope are defined in `AI_GUIDELINES.md`. Agents must not overwrite canonical `_releases` ZIP filenames. Test builds must be renamed immediately.

Distinguish:

- Validation actually performed.
- Validation that passed.
- Validation that failed.
- Validation not performed.
- Manual verification still required.
- Assumptions that remain unverified.

Do not claim a test passed, XenForo compatibility was verified, runtime behavior was proven from static inspection, or Git state was inspected, unless that is true.

### Redundant pre-commit review

Do not perform a redundant pre-commit review when the immediately preceding finalization or implementation procedure has already provided sufficient verification and the remaining work only synchronizes approved documentation or other already-approved changes.

In such cases, inspect the resulting diff/report and proceed to the Git checkpoint without starting another separate review procedure.

A new review is required only when the synchronization introduces unexpected changes, unresolved issues, or invalidates previous verification.

---

## 9. User control and Git

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

Standard checkpoint:

```text
Agent implementation and validation
        ↓
Synchronize documentation that the approved task requires
        ↓
Agent reports result
        ↓
User reviews changes
        ↓
User performs Git operations
        ↓
Stable Git checkpoint
```

When the approved task is a completed stage checkpoint, synchronize that project's changelog as part of the same increment. A stage is not complete until required changelog synchronization is finished.

---

## 10. Stop and report

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

---

## 11. Procedure report

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

When Cursor analytics apply, follow `CURSOR_USAGE_ANALYTICS.md` once present. Do not print Model requests made, Usage-counted requests, or Agent/tool calls.

---

## 12. Context efficiency

Use an agent only where it provides meaningful engineering value.

Do not scan the entire repository when the task concerns a known component.

Prefer targeted inspection and searches, existing documentation, explicit specifications, known paths, and focused validation.

Avoid re-reading unchanged large files, broad exploration without a reason, re-reading unrelated history, broad test suites for isolated changes without justification, and repeating operations whose result is already known and still valid.

Keep simple manual operations manual.

---

## 13. Core principle

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
