# MAG Ecosystem — Cursor Usage Analytics

- MAG-Document-ID: `CURSOR_USAGE_ANALYTICS.md`
- MAG-Content-Updated: `2026-09-13T13:45:00+00:00`

This document is the reusable MAG standard for **measuring, reporting, comparing, and optimizing Cursor usage** across MAG projects.

It is **telemetry and usage methodology only**, not a procedure-history log and **not** a model-selection policy owner. Do not append project or procedure rows to this file.

Project identity (`#N`, `A<N>`, `B<N>`, `Global`), Global vs active-development documentation, context isolation, and the Global documentation authority map are defined in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). Operating modes, ChatGPT → Product Owner → Cursor prompt presentation, post-execution review, **Cursor model-selection / model-routing policy**, and broader development workflow are in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §24 and related sections. Coding-agent execution, stop conditions, and the redundant pre-commit review rule are in [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md).

Lifecycle timing is defined in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md); this document remains authoritative for Cursor measurement, Cursor Models Before/After methodology, automatic After telemetry consumption, visible-delta calculation, reporting, and metric finalization. Reusable technical knowledge and its capture procedure belong in [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md).

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

Before **every** Cursor procedure in **Coordinator Mode**, ChatGPT must complete Cursor chat routing, recommend the Cursor model per [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §24.4, establish **Cursor Models Before** when applicable for analytics/history, and present the procedure only after Product Owner approval to receive the prepared prompt (or continue under an already-authorized continuation per `AI_GUIDELINES.md` §24.1).

**Direct Agent Mode** does not require that ChatGPT presentation handoff. Record telemetry per this document when a procedure occurs; do not invent missing Before/After values. Operating-mode and presentation rules remain in `AI_GUIDELINES.md` §24.

Presentation order, post-execution review, and **model-selection / model-routing policy** belong in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §24. This document owns usage metrics and measurement procedure only.

### 2.1 Cursor procedure prompt presentation

When ChatGPT provides a Cursor procedure to the Product Owner, follow [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §24.2.

The **copyable prompt block** must appear **first** and contain **only** the exact text intended to be pasted into Cursor.

Do **not** place explanations, execution metadata, or Cursor usage values before the copyable prompt block.

Do **not** place user-facing procedure metadata or instructions inside the copyable Cursor prompt unless Cursor itself needs that information for the procedure.

After the copyable prompt block, present in order:

- **Ціль/задача** — per `AI_GUIDELINES.md` §24.2;
- **Cursor chat**;
- **Cursor model**.

Do **not** include **Cursor Models Before** in the user-facing prompt presentation block. Before remains part of analytics methodology and history recording when applicable.

Do **not** routinely instruct the Product Owner to read or report **Cursor Models After**. When MAG GPT|Cursor|Sync appends a valid automatic After line to the returned Cursor report, ChatGPT consumes it per §8 without Product Owner interaction.

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

1. Obtain Product Owner approval to receive the prepared prompt.
2. Provide the Cursor procedure prompt in **Plain text** as the first copyable block containing only paste-into-Cursor content.
3. Present **Ціль/задача**, **Cursor chat**, and **Cursor model** after that block per `AI_GUIDELINES.md` §24.2.
4. Establish **Cursor Models Before** for analytics/history when applicable. Do not present Before in the user-facing prompt presentation block.
5. Execute the Cursor procedure.
6. Consume **Cursor Models After** from automatic report telemetry when present and valid (§8); otherwise apply the telemetry-failure rule.
7. Display applicable Cursor usage values per §9.1 without commentary or interpretation.
8. Provide post-execution review per `AI_GUIDELINES.md` §24.3.
9. Record/synchronize usage history where required.
10. Decide the next action.

When a procedure writes its own usage-history entry before After is known, finalize After from the automatic report line as soon as that report is returned to ChatGPT. Do not launch a separate Cursor procedure solely to write After/delta, and do not ask the Product Owner to measure After when a valid automatic value was supplied.

This sequence applies to **all** Cursor procedures, including Implementation, Debugging, Testing, Audit, Compatibility investigation, Documentation, Release finalization, Repository inspection, Refactoring, Cleanup, Rollback, and other Cursor-assisted work.

### 2.4 Cursor chat routing

Before every Cursor procedure, ChatGPT must identify the correct Cursor Agent chat for the active repository/project/tool context so unrelated project contexts are not mixed.

The selected Cursor chat must correspond to the active work context.

Respect MAG context isolation: **GLOBAL + active development identity** per `MAG_ECOSYSTEM.md`.

Do not route work for one approved development identity through another identity's Cursor Agent chat.

Do not assign XenForo `#N` markers to non-`#N` products. Unregistered MAG-branded repositories do not receive a development identity automatically.

Do **not** silently invent a canonical Cursor Agent chat name when the actual chat name has not been established. If the required chat name is unknown or ambiguous, resolve it with the user before instructing execution.

### 2.5 Cursor model recommendation — telemetry recording

Before every Cursor procedure, ChatGPT must recommend the preferred Cursor model/mode using the normative policy in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §24.4.

Required recorded format:

```text
Cursor model: <model / mode>
```

This document **records** the selected model for measurement and history. It does **not** define model-selection policy, escalation policy, or the current model recommendation matrix.

**Historical note:** Prior Global revisions of this document contained a normative model-selection matrix and escalation policy. That policy ownership has moved to `AI_GUIDELINES.md` §24.4. Do not treat this file as a second policy owner.

### 2.6 Validation independence (telemetry)

Selecting a cheaper or stronger model must **not** reduce validation requirements. Correctness, security, XenForo compatibility, performance, scope control, maintainability, testing, validation quality, and documentation accuracy remain unchanged regardless of selected model. Normative model-routing rules remain in `AI_GUIDELINES.md` §24.4.

### 2.7 Plain text in the Cursor workflow

The Cursor procedure prompt must be provided in **Plain text** inside the copyable prompt block. Detailed Plain text execution rules for ChatGPT (including prohibitions on Writing Blocks / rich editable blocks for copyable technical content) live in [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md). This analytics document preserves the sequence in §2.3 without duplicating that full output policy.

### 2.8 Usage tracking authority

This file remains the authoritative source for Cursor Models Before/After methodology, automatic After telemetry consumption and failure handling, visible deltas, post-execution usage-value display, history placement, and related usage rules. Prompt presentation, post-execution review, and Cursor model-selection / model-routing policy belong in `AI_GUIDELINES.md` §24. Never invent usage values. Do not reintroduce deprecated tracking fields this document intentionally excludes, including request-count metrics.

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

Preferred After source for returned Cursor reports is the automatic MAG GPT|Cursor|Sync footer line:

`Cursor Models After: NN%`

When that line is present and valid, ChatGPT must consume it automatically, compute visible delta internally when Before is known, and finalize usage history without asking the Product Owner for After. Successful automatic telemetry must not interrupt or clutter normal procedure review.

If automatic After is missing, blank, malformed, or otherwise unusable:

- do not invent or infer a value;
- do not silently substitute Cursor Models Before;
- do not copy an earlier After value;
- explicitly inform the Product Owner that automatic Cursor Models After telemetry failed or returned an empty/invalid value;
- treat this as a likely MAG GPT|Cursor|Sync telemetry/tooling issue for Product Owner investigation;
- preserve the metric as unavailable/pending where necessary until reliable telemetry exists.

Telemetry failure does not block review of the substantive Cursor procedure result unless a later operation specifically requires finalized analytics.

If the Product Owner explicitly provides a Cursor Models percentage outside the Cursor report, **use that value**. Do not treat a clearly identified user-supplied percentage as unavailable. Do not routinely request manual After when automatic telemetry succeeded.

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

Where useful, also record project/release/stage classification (`#N`, `A<N>`, `B<N>`, product name, version, roadmap increment).

---

## 7. Procedure-level fields

| Field | Intent |
| --- | --- |
| Project marker | Approved development identity from the Global registry (`#N`, `A<N>`, `B<N>`), or `Global` for MAG-Ecosystem process work |
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
Project marker: #<N> | A<N> | B<N> | Global
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

Provide the copyable Cursor procedure prompt in **Plain text** first per `AI_GUIDELINES.md` §24.2. Present **Ціль/задача**, **Cursor chat**, and **Cursor model** after that block. Establish **Cursor Models Before** for analytics/history when applicable, but do not include Before in the user-facing presentation block.

Then execute the procedure.

### 8.0 Automatic Cursor Models After (preferred)

MAG GPT|Cursor|Sync may append this line to the Cursor report transferred back to ChatGPT:

`Cursor Models After: NN%`

When a valid automatic After line is present:

- ChatGPT consumes it automatically as **Cursor Models After**;
- ChatGPT does **not** ask the Product Owner to provide After manually;
- ChatGPT does **not** repeat or call attention to successful telemetry during normal procedure review;
- ChatGPT calculates visible delta internally when Before is available (After − Before, in percentage points);
- usage-history finalization uses that automatic value;
- telemetry processing remains subordinate to the substantive procedure result.

Cursor Models Before/After tracking remains part of MAG analytics methodology, but routine successful After handling is background workflow rather than a Product Owner interaction.

### 8.0.1 Telemetry failure

If automatic Cursor Models After is missing, blank, malformed, or otherwise unusable:

- do not invent or infer a value;
- do not silently substitute Cursor Models Before;
- do not copy an earlier After value as if it were a new measurement;
- explicitly inform the Product Owner that automatic Cursor Models After telemetry failed or returned an empty/invalid value;
- identify this as a likely MAG GPT|Cursor|Sync telemetry/tooling issue so the Product Owner can investigate/fix the tool;
- preserve After/delta as unavailable/pending where necessary until reliable telemetry exists.

Do not turn telemetry failure into a blocker for reviewing the substantive Cursor procedure result unless a later operation specifically requires finalized analytics.

### 8.1 Finalizing After when history was written early

Prefer finalizing analytics from the automatic After value in the returned Cursor report without another Product Owner measurement step.

1. Do **not** launch a separate Cursor procedure solely to write **Cursor Models After** or visible delta.

2. When the returned Cursor report contains a valid automatic After line, finalize the current procedure's After and visible delta from that line immediately, including any usage-history row that had been left pending because the procedure wrote history before After was known.

3. Do **not** ask the Product Owner to manually obtain After when a valid automatic value was already supplied.

4. Within the same stage, a finalized automatic After may become **Cursor Models Before** for the next procedure when no fresher verified Before is required.

5. At the beginning of a **new** stage, establish Before from a verified current reading (Product Owner observation or other verified source). Do **not** silently carry a prior-stage value as a newly measured baseline.

6. If automatic After failed (§8.0.1) and a procedure still has pending After/delta:
   - notify the Product Owner per the failure rule;
   - keep the metric unavailable/pending;
   - do not invent values to close the record;
   - do not use “last known” substitution as a silent stand-in for a failed automatic After measurement of this procedure.

7. Equal displayed percentages mean visible delta **0 percentage points** only; they do not prove zero actual consumption (see §5).

8. Keep Cursor usage history **stage-local** and **procedure-specific**. Do not blur measurements across stages.

9. **Cursor Models** values must never be invented.

A procedure's history row is not analytics-complete until After and visible delta are finalized or preserved as unavailable per §4 and this section.

---

## 9. Post-execution usage display and review boundary

Post-execution review belongs in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §24.3. This section owns only Cursor usage presentation after execution.

### 9.1 Post-execution Cursor usage display

After a meaningful Cursor procedure, display the applicable Cursor usage values only, without commentary or interpretation.

Use this format when values are known:

```text
Cursor Models Before: <value or unavailable/pending>
Cursor Models After: <value or unavailable/pending>
Visible delta: <p.p. or unavailable/pending>
```

Include **Cumulative release usage** only when a fixed release baseline exists and the value is known.

Process automatic **Cursor Models After** / visible-delta finalization in the background per §8 when a valid automatic line is present. Do not lead with or call attention to successful telemetry in the usage-values block.

If automatic After is missing/invalid, show **unavailable/pending** for After and visible delta per §8.0.1. State telemetry failure in the post-execution review per `AI_GUIDELINES.md` §24.3, not in the usage-values block.

Do not invent percentages. Do not mention Model requests made, Usage-counted requests, or Agent/tool-call counts.

### 9.2 Review and commit guidance boundary

Follow `AI_GUIDELINES.md` §24.3 for analysis, confirmed result, **Critical** / **Non-critical** / **Unresolved** problems, recommended next step / Stage, and the Ukrainian learning note.

When the tree is ready to commit and there are no unresolved Critical issues, commit guidance may be included in the review. Do not run `git add` / `git commit` / `git push` unless explicitly authorized. If a Critical issue is unresolved, do not recommend the normal commit.

Do not provide the next Cursor prompt until the Product Owner approves receiving it.

Every ready-to-copy local repository command block must begin with `cd` to the **canonical repository directory** for that work (`MAG-Ecosystem` or the active development identity's clone path in `MAG_ECOSYSTEM.md`).

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
- choose the Cursor model/mode per `AI_GUIDELINES.md` §24.4, and escalate only when justified.

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

Use the same fields and types so MAG can later compare `#1`, `#2`, `#3`, `A1`, `B1`, and Global process work (polish vs feature vs architecture, compatibility, debugging, audits, documentation, release finalization, bootstrap vs maintenance).

Keep **project marker and product name** on every historical row. Do not merge datasets without recording which project produced the measurement.

Do not copy another project’s procedure log into this Global standard.

---

## 13. Where historical records live

| Kind of record | Logical home (do not create new files solely from this section) |
| --- | --- |
| Methodology (this document) | `MAG-Ecosystem` / `CURSOR_USAGE_ANALYTICS.md` |
| `#N` / `A<N>` / `B<N>` procedure logs, release summaries, project forecasts vs actual | That development's repository, as project history (not TZ/Roadmap requirements). Canonical history filename example: `docs/P01__GLF__CURSOR_USAGE_HISTORY.md`. |
| Global documentation-reorganization / ecosystem-process measurements | `MAG-Ecosystem` process history, separate from this methodology file |

Do not silently rewrite measured historical records because methodology later changes. If a field is retired or reinterpreted, keep old rows as recorded and note the interpretation change in notes or a later dated correction. Corrections must be transparent.

A previously incomplete field may be completed only from verified evidence. Never fabricate telemetry merely to make the log continuous.

Existing `#1` analytics history remains in the `#1` repository until a later controlled extraction.

### History completeness

Every meaningful completed Cursor procedure must be recorded in the appropriate project or process usage-history document.

When Before/After telemetry is fully known at the end of the main procedure — including when After arrived via a valid automatic MAG GPT|Cursor|Sync footer — record it in that procedure's history entry immediately.

When a procedure wrote history before After was known, finalize the same logical procedure record from the automatic After line as soon as the Cursor report returns to ChatGPT (§8.1). Analytics/history synchronization is not complete until After and visible delta are finalized or preserved as unavailable per §8.

A user-supplied Cursor Models percentage is authoritative for that procedure when clearly identified. Do not routinely request manual After when automatic telemetry already supplied a valid value.

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
