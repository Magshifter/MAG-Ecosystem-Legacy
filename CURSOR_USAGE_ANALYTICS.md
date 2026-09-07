# MAG Ecosystem — Cursor Usage Analytics

This document is the reusable MAG standard for **measuring, reporting, comparing, and optimizing Cursor usage** across MAG projects.

It is **methodology**, not a procedure-history log. Do not append project or procedure rows to this file.

Project identity (`#N`), Global vs Project documentation, and context isolation are defined in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). Broader development workflow and validation philosophy are in [`AI_GUIDELINES.md`](AI_GUIDELINES.md). Coding-agent execution, stop conditions, and the redundant pre-commit review rule are in [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md).

Lifecycle timing is defined in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md); this document remains authoritative for Cursor measurement and metric-finalization mechanics.

Historical measurements belong with the project (or Global process history) that produced them. See section 13. Do not mix those histories into this standard.

---

## 1. Purpose

MAG tracks Cursor usage to:

- measure real development cost;
- compare procedures, stages, releases, and projects;
- identify unnecessary or potentially avoidable Cursor work;
- improve allocation between ChatGPT, Cursor, Codex, and the user;
- improve prompts and workflow;
- build data for forecasting;
- compare forecasts with actual results;
- optimize resource consumption **without** reducing development quality.

**Correctness, security, XenForo compatibility, maintainability, testing, and accurate documentation always have higher priority than quota reduction.**

A cheaper procedure that weakens those priorities is not an improvement.

---

## 2. Mandatory Cursor procedure pre-flight (FIRST operational rules)

Before **every** Cursor procedure, ChatGPT must complete Cursor chat routing and Cursor model selection **before** recording Cursor Models Before and **before** presenting or executing the Cursor procedure prompt.

### 2.1 Cursor procedure prompt presentation

When ChatGPT provides a Cursor procedure to the product owner, separate **copyable Cursor execution text** from **user-facing execution guidance**.

The **copyable prompt block** must contain **only** the exact text intended to be pasted into Cursor.

Do **not** place user-facing procedure metadata or instructions inside the copyable Cursor prompt unless Cursor itself needs that information for the procedure.

The following user-facing information must be placed **after** the copyable prompt block:

- Cursor chat;
- recommended Cursor model;
- Cursor Models Before instruction/value;
- instructions about what the user must return after execution;
- Cursor Models After instruction;
- any other execution guidance intended for the product owner rather than Cursor.

This rule changes presentation/order only. It does **not** remove mandatory pre-flight information or Cursor usage tracking.

Plain text requirements for copyable technical content remain in [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md).

### 2.2 Required user-facing format

After the copyable Cursor procedure prompt block, the user-facing Cursor chat and model lines must use this exact format when they are presented:

```text
Cursor chat: <target Cursor Agent chat>
Cursor model: <recommended model / mode>
```

Examples of format only (do not invent a chat name when the real name is unknown):

```text
Cursor chat: GLF Agent
Cursor model: Grok 4.6 / Medium

Cursor chat: Tag Synchronizer Agent
Cursor model: Auto

Cursor chat: MAG Ecosystem Agent
Cursor model: Composer 2.5

Cursor chat: MAG Workflow Bridge Agent
Cursor model: Composer 2.5
```

### 2.3 Required operational sequence

The mandatory Cursor procedure information and tracking sequence is:

1. Provide the Cursor procedure prompt in **Plain text** as a copyable block containing only paste-into-Cursor content.
2. Present user-facing execution guidance **after** that block, including Cursor chat routing and Cursor model selection.
3. Record Cursor Models Before.
4. Execute the Cursor procedure.
5. Record Cursor Models After.
6. Review the result.
7. Record/synchronize usage history where required.
8. Decide the next action.

When the procedure itself updates a Cursor usage-history document that includes that procedure's own metrics, step 5 and the final After/delta values in step 7 follow the **Deferred Cursor Models After recording** workflow in §8.1 instead of being completed during the main procedure.

All items remain mandatory. This sequence governs presentation order and what belongs inside vs outside the copyable prompt block.

This sequence applies to **all** Cursor procedures, including Implementation, Debugging, Testing, Audit, Compatibility investigation, Documentation, Release finalization, Repository inspection, Refactoring, Cleanup, Rollback, and other Cursor-assisted work.

### 2.4 Cursor chat routing

Before every Cursor procedure, ChatGPT must identify the correct Cursor Agent chat for the active repository/project/tool context so unrelated project contexts are not mixed.

The selected Cursor chat must correspond to the active work context.

Respect MAG context isolation: **GLOBAL + active `#N`**.

Do not route project-specific work through another project's Cursor Agent chat.

Do not treat standalone tooling repositories as numbered MAG Ecosystem projects.

Do **not** silently invent a canonical Cursor Agent chat name when the actual chat name has not been established. If the required chat name is unknown or ambiguous, resolve it with the user before instructing execution.

### 2.5 Cursor model selection — core principle

Before every Cursor procedure, ChatGPT must recommend the preferred Cursor model/mode.

Required format:

```text
Cursor model: <model / mode>
```

Model selection must happen before the Cursor procedure prompt is presented or executed.

Use the cheapest model/mode appropriate for the task, but escalate when complexity, uncertainty, or risk justifies it.

Consider: task complexity; uncertainty; implementation risk; debugging difficulty; security impact; XenForo integration risk; regression risk; reasoning requirements; usage efficiency.

**Core rule:** Model strength should scale with task complexity, uncertainty, and risk — not with habit.

### 2.6 Model selection matrix

**Auto** — default for ordinary implementation when a specific model is not required. Use for routine implementation, small fixes, rollback, documentation changes, cleanup, simple multi-file changes, and well-specified tasks. Prefer Auto when the prompt is precise, architecture is already decided, risk is low/moderate, and no special reasoning model is required.

**Composer 2.5** — low-cost execution for very clear mechanical tasks: renames, cleanup, formatting, repetitive edits, simple documentation updates, known-pattern changes, narrow deterministic implementation. Do not default to it for ambiguous debugging, architecture decisions, security-sensitive code, uncertain XenForo behavior, or complex refactoring.

**Grok 4.6 / Low** — small coding tasks when specific Grok execution is preferred over Auto: trivial edits, simple rollback, minor cleanup, tiny localized changes.

**Grok 4.6 / Medium** — primary normal manual Grok coding mode: normal feature implementation, ordinary debugging, several related files, medium-complexity refactoring, implementation from already approved architecture. Default manual Grok level when manual Grok selection is appropriate.

**Grok 4.6 / High** — when materially deeper reasoning is required: difficult bugs, multi-subsystem interactions, uncertain root cause, larger refactors, state/lifecycle problems, non-obvious XenForo integration, significant regression risk.

**Grok 4.6 / Extra High** — use rarely: very difficult debugging, architecture-sensitive implementation, complex legacy behavior, multiple failed prior attempts, high-cost mistakes, deeply coupled code, exhaustive reasoning justified. Do not use for routine work.

**GPT-5.6 Sol** — strong alternative/escalation: complex debugging, difficult code reasoning, large dependency analysis, weak/inconsistent Grok results, second high-quality implementation approach, high-risk code review.

**Claude Opus** — strong alternative perspective: architecture review, code review, large-context reasoning, evaluating another model's implementation, alternative debugging analysis, second opinion on risky changes.

### 2.7 Escalation policy

Normal starting point:

- Auto for ordinary well-specified work;
- Composer 2.5 for cheap deterministic/mechanical work.

Escalate to:

- Grok 4.6 / Medium when manual model control or normal development reasoning is useful;
- Grok 4.6 / High when complexity, uncertainty, or regression risk materially increases;
- Grok 4.6 / Extra High only for genuinely exceptional/high-risk cases.

Alternative escalation: GPT-5.6 Sol or Claude Opus when that family is likely to materially improve the result.

Do **not** escalate merely because a stronger model exists.

If a cheaper model produces repeated mistakes, unexplained edits, scope drift, weak reasoning, uncertain implementation, or failed validation, escalate to an appropriate stronger model instead of repeatedly spending requests on the same weak path.

### 2.8 Validation independence

Selecting a cheaper model must **not** reduce validation requirements. Correctness, security, XenForo compatibility, performance, scope control, maintainability, testing, validation quality, and documentation accuracy remain unchanged regardless of selected model.

### 2.9 Model availability

Keep this policy maintainable if Cursor's available models, modes, or names change. Do not invent unavailable model names or capabilities. The permanent governing principle remains: model strength scales with task complexity, uncertainty, and risk — not with habit.

### 2.10 Plain text in the Cursor workflow

The Cursor procedure prompt must be provided in **Plain text** inside the copyable prompt block. Detailed Plain text execution rules for ChatGPT (including prohibitions on Writing Blocks / rich editable blocks for copyable technical content) live in [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md). This analytics document preserves the sequence in §2.3 without duplicating that full output policy.

### 2.11 Usage tracking authority

This file remains the authoritative source for Cursor Models Before/After methodology, visible deltas, history placement, and related usage rules. The copyable prompt presentation rule in §2.1 and the operational sequence in §2.3 govern what belongs inside vs outside the copyable block. Never invent usage values. Do not reintroduce deprecated tracking fields this document intentionally excludes.

---

## 3. Two levels of analysis

**Procedure-level measurement** records one meaningful Cursor procedure: Before, After, visible delta, classification, result, and issues. This is the primary telemetry.

**Project / release / stage analysis** aggregates procedure-level records after a coherent body of work. It may include starting and ending displayed percentages, approximate visible delta, procedure counts by type, high-value work, avoidable work, forecast versus actual, and recommendations. It must not invent category totals the logs cannot support.

Do not treat a single procedure’s visible delta as a full release cost.

---

## 4. Measurement boundary

The tracked pool is **Cursor Models**.

Do not mix it with Other Models, on-demand spend, other Cursor quota pools, ChatGPT usage, or Codex usage unless a separate metric is explicitly introduced.

Cursor currently exposes percentage usage with limited visible precision. Therefore:

- record displayed percentages exactly as observed;
- calculate **visible percentage-point deltas** only (After − Before);
- do not invent fractional consumption;
- do not interpret an unchanged displayed percentage as zero actual consumption;
- treat release/stage totals as **approximate** when measurements lack exact precision.

Displayed percentages are not token counts and are not invoices.

If the user explicitly provides a Cursor Models percentage outside the Cursor report, **use that value**. Do not treat a user-supplied percentage as unavailable.

Never invent percentages. Never silently assume a percentage when a fresh measurement is required.

Do **not** request, report, track, or store **Model requests made**, **Usage-counted requests**, or any replacement request-count metric. Do not print Agent/tool-call counts. They are not MAG Cursor analytics fields.

---

## 5. Zero-visible-delta

If Before and After show the **same** displayed Cursor Models percentage, record:

**Visible delta: 0 percentage points**

(equivalently: no visible percentage-point change)

Do **not** claim the procedure consumed literally zero tokens or compute. The UI resolution cannot prove that.

---

## 6. Procedure classification

Every meaningful procedure should have a type. Minimum set:

- Implementation
- Debugging
- Testing
- Audit
- Compatibility investigation
- Documentation
- Release finalization
- Repository inspection
- Refactoring
- Other

Separate meaningful procedures so their cost can be compared. Do not fold unrelated work into one measurement.

Documentation work may be subclassified when useful. Examples:

- Documentation / Ecosystem Foundation
- Documentation / Guidelines Globalization
- Documentation / Agent Rules Globalization
- Documentation / Cursor Analytics Globalization
- Documentation / Project Cleanup
- Documentation / Final Audit

These examples are labels, not a closed catalog. Add a precise subclass only when it helps comparison.

Where useful, also record project/release/stage classification (`#N`, add-on name, version, roadmap increment).

---

## 7. Procedure-level fields

| Field | Intent |
| --- | --- |
| Project marker | `#N` from the Global registry, or `Global` for MAG-Ecosystem process work |
| Project / add-on | Product or `MAG-Ecosystem` |
| Procedure | Short id or sequence within that body of work |
| Classification | Type and optional documentation subclass |
| Stage / version | Roadmap increment or version if applicable |
| Cursor Models Before | Displayed % at start |
| Cursor Models After | Displayed % after the procedure |
| Visible delta | After − Before, in percentage points |
| Cumulative release usage | Fixed release baseline → After (p.p.), when a release baseline exists |
| Result / issues | What happened; Critical / Non-critical / Informational |
| Notes | Residual context; label inference vs fact |

Do not invent metrics that cannot realistically be collected.

### Recording template

```text
Project marker: #<N> | Global
Project / add-on:
Procedure:
Classification:
Stage / version:
Cursor Models Before:
Cursor Models After:
Visible delta: <p.p.>
Cumulative release usage: <if applicable>
Result / issues:
Notes:
```

Record completed rows in **project (or Global process) history**, not in this file.

---

## 8. Before / After workflow

For a meaningful Cursor procedure, complete the presentation and tracking sequence in §2.3.

Provide the copyable Cursor procedure prompt in **Plain text** first. Present user-facing Cursor chat/model guidance and Cursor Models Before instructions **after** that copyable block unless the user has already recorded Before for that exact procedure.

Then execute the procedure.

**After** the procedure finishes, obtain the displayed percentage again. That is **Cursor Models After**.

When the procedure itself is responsible for writing its own usage-history entry, the main procedure records only verified **Cursor Models Before**. **Cursor Models After** and visible delta remain explicitly pending until the metric-finalization follow-up in §8.1. Do not treat that pending state as the final record.

If After is missing from the Cursor report and the user has not supplied it, **request it before completing the procedure summary**. Do not invent it. Do not copy the previous procedure’s After unless the procedures are consecutive and no meaningful Cursor work occurred in between. Do not copy **Cursor Models Before** as a substitute for After.

The After value of one procedure may become the Before value of the next **only** when they are consecutive and no meaningful Cursor work occurred between measurements.

A procedure is not analytics-complete until After is recorded when the user can provide it.

If Before and After are both known, history must not retain a blank After or an unresolved visible delta. If After is genuinely unknown and cannot be reliably obtained, preserve it as unavailable/unresolved according to §4 and §8.1. Do not invent it.

### 8.1 Deferred Cursor Models After recording

Use this workflow when a Cursor procedure updates a Cursor usage-history document that includes that procedure's own usage metrics.

**Cursor Models After** is only known after the Cursor procedure has completed. The main procedure therefore cannot truthfully record its own final After value while performing the substantive work. This is a two-step completion workflow, not an ad hoc exception.

1. The main Cursor procedure records the known **Cursor Models Before** value in the usage-history entry (and any other fields that do not depend on After).

2. **Cursor Models After** and the resulting visible delta must not be guessed, predicted, inferred, or copied from **Cursor Models Before**.

3. During the main procedure, **Cursor Models After** and visible delta remain explicitly **pending** or **unresolved**. This temporary state is expected and acceptable only until metric finalization.

4. Cursor completes the main requested work and returns its normal procedure report.

5. ChatGPT then requests the actual **Cursor Models After** value from the product owner.

6. The product owner supplies the observed **Cursor Models After** value.

7. ChatGPT calculates the visible delta from the verified Before and After values (After − Before, in percentage points).

8. ChatGPT prepares a separate minimal Cursor follow-up prompt whose **only** purpose is to finalize the usage-history record with:
   - the verified **Cursor Models After**;
   - the calculated visible delta;
   - any directly dependent usage-summary fields that must be synchronized because of those values.

9. The follow-up must not reinterpret, rewrite, or change the substantive result of the completed main procedure.

10. Usage-history synchronization for that procedure is **not** complete until this follow-up has recorded the verified After and visible delta (or preserved After as unavailable when it cannot be reliably obtained).

11. A Git checkpoint/commit for a logical stage or documentation checkpoint that includes this usage-history update should occur only after the usage-history record has been finalized, unless the product owner explicitly decides otherwise.

12. A pending/unresolved After value is acceptable only as the temporary state between the main procedure and the metric-finalization follow-up.

13. If the actual **Cursor Models After** cannot be reliably obtained, preserve it as unavailable/unresolved according to the existing rules in this document. Never invent a value merely to close the record.

14. If **Cursor Models After** equals **Cursor Models Before**, record **Visible delta: 0 percentage points**. This does not prove that the procedure consumed zero actual Cursor resources.

15. The metric-finalization follow-up is part of the same logical Cursor procedure/accounting workflow. It must remain minimal and must not be treated as a new development or architecture task.

---

## 9. ChatGPT procedure report summary (§4A)

After every Cursor procedure/report, ChatGPT must give a very short human-readable summary. Do not repeat the full Cursor report.

Use this sequence, and only this sequence:

1. **Cursor Models After** and **visible delta** from Before. When a fixed release baseline exists, also state cumulative release usage as baseline → After (delta p.p.). Do not invent percentages. If After was not provided, request it before giving this summary. Do not mention Model requests made, Usage-counted requests, or Agent/tool-call counts.
2. **Result** — what the completed procedure achieved.
3. **Main tasks/issues solved.**
4. **Discovered issues** — classify each as **Critical**, **Non-critical**, or **Informational**. If none, say so explicitly. Critical findings must change the immediate next action and must not be hidden behind a normal commit recommendation.
5. **Commit** — if the tree is ready to commit and there are no unresolved Critical issues, give exact ready-to-copy git commands. Do not run `git add` / `git commit` / `git push`. If a Critical issue is unresolved, do not recommend the normal commit. Omit this item when no commit is appropriate. When a completed procedure used §8.1 and its usage-history After/delta are still pending, do not recommend a Git checkpoint for that logical stage or documentation checkpoint until metric finalization is complete, unless the product owner explicitly decides otherwise.
6. **Next step.**
7. **Main tasks of that next step.**
8. **Ask whether to prepare the next prompt.** Do not provide the next Cursor prompt until the user approves.

The withdrawn three-item summary (Obtained / Why it matters / Next) must not be used.

Every ready-to-copy local repository command block must begin with `cd` to the **canonical repository directory** for that work (`MAG-Ecosystem` or the active `#N` clone path in `MAG_ECOSYSTEM.md`).

---

## 10. Efficiency, quota, and proportional validation

Each meaningful procedure should be classified when useful:

- Necessary
- Necessary but optimizable
- Potentially avoidable
- Avoidable

Do not classify work as waste merely because it consumed quota. A procedure that finds a real correctness, security, compatibility, or release problem is valuable even if it used significant Cursor.

Do not assign a percentage of consumption to “avoidable” work unless measurements support it. Separate observed facts from inference; label inference.

Possible causes of excess Cursor work include unclear prompts, overly broad scope, repeated inspection, redundant audit, unnecessary repeated tests, premature implementation, work outside the approved increment, insufficient analysis before Cursor, work the user could safely do manually, unnecessary Agent usage, repeated fixes from an earlier avoidable mistake, documentation churn, unrelated generated-file changes, and duplicated ChatGPT/Cursor work.

Quota optimization that is in scope here:

- do not spend Cursor quota on redundant reviews;
- reuse immediately preceding valid verification when it still applies;
- separate meaningful procedures so cost can be compared;
- prefer safe manual/user work where the agent adds little value;
- choose the cheapest appropriate Cursor model/mode per §2, and escalate only when justified.

Do not move work to the user when that materially increases correctness, security, compatibility, or release risk.

Release Finalization vs preceding audit, and the redundant pre-commit review rule, are defined in `AI_GUIDELINES.md` and `AI_AGENTS_RULES.md`. This file does not restate them.

---

## 11. Forecasting

Before a sufficiently defined future release or major stage:

1. Break the work into expected procedure categories.
2. Compare with **measured MAG procedures** of similar complexity.
3. Estimate an expected Cursor Models **visible percentage-point range**.
4. Identify uncertainty and risk.
5. Distinguish expected necessary cost from contingency/debugging risk.
6. Record the forecast **before** implementation starts.
7. Compare forecast with actual usage after completion.
8. Improve later estimates from the difference.

Prefer ranges such as `Expected: +3 to +5 visible percentage points`. Do not use false precision.

Distinguish **measured data** from **estimates**. Label estimates.

Do **not** assume one add-on’s historical cost automatically predicts another add-on. Use other projects as evidence only, with project identity preserved.

Update forecasts as more MAG projects provide measured data. A recorded pre-implementation forecast is an **immutable historical prediction**. Do not edit it later to match actuals. Record actuals beside it.

---

## 12. Cross-project analytics

Use the same fields and types so MAG can later compare `#1`, `#2`, `#3`, and Global process work (polish vs feature vs architecture, compatibility, debugging, audits, documentation, release finalization, bootstrap vs maintenance).

Keep **project marker and product name** on every historical row. Do not merge datasets without recording which project produced the measurement.

Do not copy another project’s procedure log into this Global standard.

---

## 13. Where historical records live

| Kind of record | Logical home (do not create new files solely from this section) |
| --- | --- |
| Methodology (this document) | `MAG-Ecosystem` / `CURSOR_USAGE_ANALYTICS.md` |
| `#N` procedure logs, release summaries, project forecasts vs actual | That project’s repository, as project history (not TZ/Roadmap requirements). Canonical history filename example: `docs/P01__GLF__CURSOR_USAGE_HISTORY.md`. |
| Global documentation-reorganization / ecosystem-process measurements | `MAG-Ecosystem` process history, separate from this methodology file |

Do not silently rewrite measured historical records because methodology later changes. If a field is retired or reinterpreted, keep old rows as recorded and note the interpretation change in notes or a later dated correction. Corrections must be transparent.

A previously incomplete field may be completed only from verified evidence. Never fabricate telemetry merely to make the log continuous.

Existing `#1` analytics history remains in the `#1` repository until a later controlled extraction.

### History completeness

Every meaningful completed Cursor procedure must be recorded in the appropriate project or process usage-history document.

When Before/After telemetry is fully known at the end of the main procedure, record it in that procedure's history entry immediately.

When §8.1 applies, the main procedure records verified Before and an explicitly pending After/delta; metric finalization completes the same logical procedure record. Analytics/history synchronization is not complete until After and visible delta are finalized or preserved as unavailable per §8.1.

A user-supplied Cursor Models percentage is authoritative for that procedure when clearly identified.

ChatGPT is responsible for noticing when a completed Cursor procedure discussed in chat has not yet been synchronized into project history.

After a completed release, hotfix cycle, or coherent body of work, ChatGPT must verify that meaningful Cursor procedures since the previous history checkpoint are represented before analytics/history synchronization is considered complete.

Stable-release ChatGPT Project synchronization must include that project's `docs/P<NN>__<CODE>__CURSOR_USAGE_HISTORY.md` when that file actually changed.

---

## 14. Release-level summary template

At the end of a release (or equivalent Global process phase), summarize in **that project’s or process history**:

- starting and final Cursor Models percentages;
- approximate visible delta;
- number of tracked procedures;
- consumption by category **only where measurements allow**;
- major high-value procedures;
- unnecessary / potentially avoidable work;
- optimization lessons;
- manual work shifted away from Cursor;
- unexpected debugging/compatibility cost;
- forecast versus actual if a forecast existed;
- recommendations for the next increment.

If category totals cannot be derived without inventing numbers, say so.
