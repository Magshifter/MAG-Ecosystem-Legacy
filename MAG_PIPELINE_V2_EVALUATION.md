# MAG Pipeline v2 Evaluation

- MAG-Document-ID: `MAG_PIPELINE_V2_EVALUATION.md`
- MAG-Content-Updated: `2026-09-11T07:10:00+03:00`

Status: EXPERIMENTAL EVALUATION FRAMEWORK — NOT GLOBAL AUTHORITY

## Authority disclaimer and promotion gate

These are project-scoped working documents for `#2` ([MAG] Tag Synchronizer), not Global authority. They may evolve during the approved pilot. Registration and metadata establish identity/version tracking and synchronization eligibility only; they grant no substantive authority. They cannot override approved TZ, Architecture, Roadmap, or Global rules. Only expressly approved, bounded pilot procedural exceptions may apply within their recorded scope; no exception extends to another project or cycle.

Per-finding disposition and the separate Global promotion gate are defined in §12. Pilot results, registration, synchronization, Git commit, and pilot activation do not grant Global authority. Preserve evidence and decision history for every finding.

## 1. Purpose

This document evaluates whether MAG Pipeline v2 produces a real improvement over the current MAG workflow.

Primary success target:

- at least 30% reduction in comparable adjusted Wall-clock elapsed time;
- report Active process / collaboration time independently as a second required time result.

Target outcome:

- approximately 40% reduction where project size and risk profile make that realistic.

Quality must not materially regress.

## 2. Pilot identity

Active evaluated pilot (Product Owner approved activation):

- Project: `#2` — [MAG] Tag Synchronizer
- Project marker: `P02__TS`
- Release / upgrade: `1.1.0`
- Pilot start boundary: development cycle `1.1.0` (Pipeline v2 active for this cycle)
- Pilot end boundary: completion of development cycle `1.1.0`, or earlier Product Owner deactivation
- Baseline chosen for comparison: PENDING — no reliable comparable value has yet been established
- Baseline strategy: select and lock the closest completed MAG body of work using §3 before the first substantive `#2` / `1.1.0` implementation increment
- Date started:
- Product Owner approval: YES — Pipeline v2 activated for `#2` / `1.1.0` only
- Initial Cursor Models value, if available:

Evaluation target: the MAG Pipeline v2 experiment for the active pilot above, governed by `MAG_PIPELINE_V2_EXPERIMENT.md`.

Evaluation status: **NOT COMPLETED**. Do not treat evaluation results as completed before the pilot lifecycle provides evidence. Do not invent efficiency values, Cursor usage values, or success claims.

Do not invent missing values.

## 3. Baseline lock

The baseline strategy must be fixed before the first substantive `#2` / `1.1.0` implementation increment. The baseline must not be selected or changed retrospectively after the Pipeline v2 result is known.

### 3.1 Selection method

Select the closest comparable completed MAG body of work using this order:

1. same project, previous similar release;
2. comparable completed stage or release within the same project;
3. another MAG add-on body of work with comparable complexity and risk;
4. a normalized internal estimate only when no direct baseline exists.

Before lock, record:

- selected baseline or exact baseline-selection strategy;
- why it is comparable;
- known limitations;
- confidence;
- date and lifecycle boundary at which it was locked;
- exact evidence used and unresolved values.

If reliable evidence cannot establish an exact baseline value before implementation, lock the approved selection method and mark unresolved values `PENDING`. Do not invent historical timings or measurements. A normalized internal estimate must be labeled `ESTIMATE`.

### 3.2 Current baseline-lock status

- Selected baseline: `PENDING`
- Approved selection method: `PENDING PRODUCT OWNER RATIFICATION`
- Comparability rationale: `PENDING`
- Known limitations: exact historical time evidence has not yet been established
- Confidence: `PENDING`
- Lock date/boundary: must be recorded before the first substantive `#2` / `1.1.0` implementation increment

Required Product Owner decision: ratify either a reliable selected baseline or the §3.1 selection method and its evidence boundary before implementation begins.

Do not claim precise percentage improvement from a weak baseline. When exact history is unavailable, use clearly labeled proxy metrics and qualitative evidence.

## 4. Primary metrics

### 4.1 Wall-clock elapsed time

Calendar time from the recorded pilot start boundary to the recorded completion boundary.

Record start and completion timestamps and separately identify reliably established excluded periods, such as ordinary Product Owner inactivity, unrelated waiting, paused scope, or external delay not caused by Pipeline v2. Report gross wall-clock duration and adjusted wall-clock duration when exclusions are supported by evidence. Do not infer exclusions without evidence.

### 4.2 Active process / collaboration time

Time actively spent on in-scope decision-making, preparation, execution, review, validation, documentation, and required handoffs by the Product Owner and approved executors.

Use measured intervals when available. If reconstructed or estimated, label the value `ESTIMATE`, state the method and confidence, and do not present it as measured fact. Do not count ordinary Product Owner inactivity or unrelated waiting when it can be separated reliably.

The final evaluation reports Wall-clock elapsed time and Active process / collaboration time independently for baseline and Pipeline v2.

Time reduction for each time type may be calculated only when comparable baseline and pilot values are available:

`time reduction % = (baseline time - pilot time) / baseline time × 100`

Do not combine the two time types into one unlabeled value.

Do not fabricate historical time that was never measured.

### 4.3 Interaction round trips

Count meaningful handoff cycles such as:

ChatGPT → Product Owner → Cursor → Product Owner → ChatGPT

A round trip is counted when control leaves the current decision/execution context and returns with a result needed to continue.

Record total round trips, avoidable round trips identified after completion, and round trips per completed stage.

### 4.4 Cursor substantive procedures

Count procedures that materially inspect, implement, test, debug, audit, validate, or modify repository state.

Separately count Implementation, Debugging, Testing/Validation, Audit/Research, Documentation, Release finalization, Repository inspection, and Other.

Do not count a telemetry-only action as substantive work.

### 4.5 Documentation passes

Count distinct documentation synchronization passes.

Record total passes, documentation-only passes, files normally touched per closure, and cases where multiple micro-updates were successfully consolidated.

### 4.6 Git checkpoints

Count logical Git commit/push checkpoints used during the pilot.

Record whether each checkpoint was a stage boundary, risk-preservation checkpoint, release checkpoint, or unnecessary/avoidable in hindsight.

### 4.7 Rework loops

Count cases where completed work had to return to an earlier step because of misunderstood requirement, incorrect architecture, implementation defect, validation failure, documentation-state error, release-state error, or process error.

Fewer procedures are not an improvement if rework increases materially.

## 5. Quality metrics

Record all discovered issues by severity.

### Critical

Any issue that blocks safe continuation, release, correctness, security, required compatibility, or approved behavior.

### Non-critical

A real issue that should be corrected but does not invalidate the stage/release.

### Informational

Observation, limitation, or improvement idea that does not represent a defect.

Compare the number of Critical issues, number of Non-critical issues, defect escape to later stages, defects first discovered after release, validation regressions, and documentation-state inaccuracies.

### 5.1 Quality regression policy

Quality, security, XenForo/XFRM compatibility, maintainability, validation, documentation integrity, and Product Owner control are hard constraints.

- A process-induced Critical regression prevents PASS and normally produces FAIL.
- A material increase in rework, defect escape, validation failure, or documentation-state unreliability prevents an unqualified PASS and normally limits the result to PARTIAL PASS unless the evidence supports FAIL.
- Isolated corrected Non-critical issues do not automatically prevent PASS when they do not indicate systemic process degradation and leave no material residual quality effect.
- Efficiency evidence must never offset or hide quality degradation.

Apply evidence-based judgment. Do not invent unsupported numeric quality thresholds.

## 6. XenForo/XFRM quality controls

The pilot must explicitly confirm that optimization did not weaken:

- Existing-Code-First behavior;
- native XenForo/XFRM mechanism preference;
- source verification for uncertain behavior;
- permissions correctness;
- transaction/data-integrity behavior where relevant;
- install/upgrade behavior where relevant;
- performance boundaries;
- localization requirements;
- release package correctness.

A 30% faster process with a material regression in these areas does not PASS.

Technical validation, Product Owner Practical Acceptance, Release Readiness, and Release Finalization must be evidenced as distinct lifecycle boundaries. Pipeline v2 may reduce overhead around them but must not collapse, silently merge, remove, or redefine them. Product Owner Practical Acceptance remains a separate required gate wherever `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` requires it.

## 7. Cursor usage metrics

**Classification:** experimental evaluation fields only. Detailed Cursor Before/After methodology, automatic After consumption, telemetry-failure handling, and metric finalization are owned by `MAG-Ecosystem` / `CURSOR_USAGE_ANALYTICS.md`. This section does not redefine that methodology.

For pilots run under current Global methodology, prefer automatic `Cursor Models After: NN%` from MAG GPT|Cursor|Sync when valid. Successful automatic telemetry requires no routine Product Owner After interaction. Missing/invalid automatic After must be recorded as unavailable/pending and surfaced as a tooling issue; never guess or substitute.

Record Cursor Models values only when actually available.

Suggested fields:

- stage/release starting displayed percentage;
- final displayed percentage;
- approximate visible percentage-point delta;
- number of substantive Cursor procedures;
- high-cost procedures;
- documentation-only procedures;
- procedures avoided through verified native XenForo tooling;
- procedures avoided through manual Product Owner action;
- procedures avoided through ChatGPT reasoning;
- procedures avoided through ChatGPT Work or another explicitly approved executor;
- repeated audits avoided through valid evidence reuse.

For the native-tooling metric, record the approved operation, installed XenForo version, exact verified command, verification evidence, and the Cursor procedure it replaced. Count an avoided procedure only after the native operation and its required validation complete; a proposed route is not a measured saving. Record native-tooling cases once in this category even when the Product Owner runs the command, avoiding duplicate totals with manual-action savings. Use `unavailable` when evidence is insufficient; do not infer time, request, or quota savings from the procedure count.

An unchanged displayed percentage means visible delta 0 pp only.

Never interpret it as proven zero actual consumption.

Do not invent request counts or unavailable telemetry.

## 8. Procedure-density metrics

Useful ratios:

- substantive Cursor procedures per completed stage;
- total round trips per completed stage;
- documentation passes per completed stage;
- Git checkpoints per completed stage;
- rework loops per completed stage.

These ratios help detect procedural fragmentation even when exact time data is unavailable.

## 9. Friction log

During the pilot, record short observations when the process feels unnecessarily slow or unusually efficient.

Examples:

- repeated request for already-known information;
- unnecessary Cursor handoff;
- documentation updated too early;
- validation repeated without new risk;
- release field blocked by external dependency;
- manual command significantly faster than agent procedure;
- verified native XenForo tooling completed an approved operation without a separate Cursor procedure (record command and validation evidence);
- coherent batching prevented multiple round trips;
- repeated synchronization preflight/analysis after source, target, and classification were already proven, when the active executor lacked raw in-place Drive write capability (see §12.5 `V2-F03`).
- **Over-batching incident** — a batch materially reduced reviewability, rollback safety, root-cause isolation, validation clarity, scope control, or Product Owner understanding/control.

Keep entries brief and factual.

For each Over-batching incident, record the affected finding ID, task/stage boundary, observed control loss, quality impact, corrective action, and whether the incident caused rework or changed the finding evidence. Fewer procedures are not an efficiency objective by themselves.

Capture routine metrics, friction observations, Over-batching incidents, rework, and finding-specific evidence opportunistically at existing logical stage, closure, or checkpoint boundaries. Do not create standalone Cursor or Work procedures solely for routine telemetry when safe capture fits an existing closure. Do not postpone all reconstruction until pilot completion when contemporaneous evidence is reasonably available.

## 10. Pilot result table

At completion, fill:

| Metric | Baseline | Pipeline v2 | Change | Confidence |
|---|---:|---:|---:|---|
| Wall-clock elapsed time | | | | |
| Active process / collaboration time | | | | |
| Round trips | | | | |
| Substantive Cursor procedures | | | | |
| Documentation passes | | | | |
| Git checkpoints | | | | |
| Rework loops | | | | |
| Critical issues | | | | |
| Non-critical issues | | | | |
| Over-batching incidents | | | | |
| Visible Cursor Models delta | | | | |

Use `unavailable` where evidence does not exist.

Do not backfill with invented values.

## 11. Success criteria

### PASS

Pipeline v2 may be rated PASS when:

- measured or sufficiently evidenced comparable time reduction is at least 30%;
- target of approximately 40% may be noted if achieved;
- no process-induced Critical regression exists;
- no material increase in rework, defect escape, validation failure, or documentation-state unreliability exists;
- no unacceptable regression exists in correctness, security, XenForo/XFRM compatibility, maintainability, validation quality, release quality, documentation integrity, or Product Owner control;
- procedural fragmentation is materially lower;
- rework does not erase the savings;
- project state and documentation remain trustworthy.

### PARTIAL PASS

Use when clear efficiency improvement exists but is below 30%, some v2 mechanisms work well while others create friction, evidence is too incomplete for a confident full PASS, or a quality/process weakness was found but can be isolated and corrected without rejecting the entire model.

A material increase in rework, defect escape, validation failure, or documentation-state unreliability normally limits the result to PARTIAL PASS at best unless the evidence supports FAIL. Isolated corrected Non-critical issues do not automatically prevent PASS when they show no systemic process degradation.

A PARTIAL PASS should identify the affected findings and record their individual dispositions under §12; the pilot result does not assign those dispositions automatically.

### FAIL

Use when time savings are insignificant or negative, a process-induced Critical regression occurs, rework materially increases, validation quality degrades, release/documentation state becomes unreliable, Product Owner control becomes weaker, or the process hides uncertainty rather than resolving it.

## 12. Per-finding disposition and adoption decision

Pilot PASS / PARTIAL PASS / FAIL describes the overall evaluation result. It is separate from the disposition of an individual finding. PASS or PARTIAL PASS does not automatically make any finding a `GLOBAL_CANDIDATE`.

### 12.1 Stable initial finding catalog

These finding IDs are fixed for the pilot. Evidence, friction, quality impact, Over-batching incidents, and final disposition must be traceable to the applicable ID.

| Finding ID | Finding | Scope / intent |
| --- | --- | --- |
| `V2-F01` | Coherent batching | Test whether related approved actions can be executed as one reviewable batch without crossing gates or weakening control |
| `V2-F02` | Risk-scaled procedure depth | Test deterministic S/N/H depth using the highest applicable material risk |
| `V2-F03` | Documentation boundary batching | Test synchronization at ownership and logical closure boundaries instead of after every micro-decision |
| `V2-F04` | Evidence reuse / reduced repeated validation | Test reuse of still-valid evidence while restoring verification when scope, risk, or state invalidates it |
| `V2-F05` | Cursor minimization / executor selection | Test use of the lowest-friction safe executor without expanding authority or weakening verification |
| `V2-F06` | Prompt and context optimization | Test concise task-specific prompts and reduced duplicated context under current Global presentation rules |
| `V2-F07` | Git checkpoint consolidation | Test fewer logical checkpoints while preserving reviewability, rollback safety, and Product Owner Git control |
| `V2-F08` | Release-flow consolidation | Test coherent release-input/execution handling while preserving all distinct Global gates and release authority |

Do not assign final dispositions before sufficient evidence and Product Owner decision. If a disposition later changes, append the new evidence, rationale, decision date, and prior-decision reference; never overwrite decision history.

### 12.2 Finding disposition

Assign exactly one of these four outcomes to each evaluated finding, supported by its evidence, limitations, quality impact, and Product Owner decision:

- `GLOBAL_CANDIDATE` — sufficient evidence exists to propose the finding for adoption into the appropriate owning Global document or documents. This classification itself grants no Global authority.
- `KEEP_PROJECT_ONLY` — the finding is accepted for the approved `#2` scope but must not be promoted into Global MAG policy.
- `CONTINUE_EXPERIMENT` — evidence remains insufficient, mixed, or incomplete; further testing is required within an explicitly approved experimental scope.
- `REJECT` — the finding is not accepted for continued use as an approved practice. Preserve its historical evidence and decision record.

Record a stable finding identifier, description, evidence and limitations, disposition, approved scope, decision date, and Product Owner decision. Further testing does not imply approval to expand the pilot or continue into another cycle. A later disposition change records its rationale and new evidence without overwriting the earlier decision.

### 12.3 Separate Global promotion gate

Only a `GLOBAL_CANDIDATE` may enter a separate scoped Global adoption proposal. Candidate status is a proposal qualification, not approval or authority. `KEEP_PROJECT_ONLY`, `CONTINUE_EXPERIMENT`, and `REJECT` must never trigger changes to Global authoritative documentation.

For each proposed candidate:

1. identify the exact finding, evidence, limitations, and quality results;
2. specify the correct owning Global document or documents, exact proposed changes, and any conflicts;
3. obtain explicit Product Owner approval of the scoped proposal;
4. update only the approved owning Global documents;
5. validate the changes, synchronize applicable canonical counterparts under `MAG_DOCUMENTATION_OPERATIONS.md`, and verify the resulting Git state under the applicable Git authorization.

Partial adoption operates finding-by-finding only. Complete and verify the full gate before treating a finding as Global authority. Record the adoption result and references in its decision record; preserve rejected and non-promoted findings, evaluation evidence, and history. Do not remove experimental status from the whole document because one finding is adopted. This procedure defines the evaluation model and promotes no experimental finding.

### 12.4 XF AI-agent integration finding

This is a preserved auxiliary integration finding outside the fixed `V2-F01`–`V2-F08` optimization catalog. If later pilot evidence uses it to evaluate executor selection, cross-reference that evidence to `V2-F05` without renaming or erasing this prior decision record.

- Finding ID: `P02-PV2-XF-AI-001`.
- Description: integration of official XenForo AI-agent guidance into the existing MAG-only, single-folder Cursor workspace.
- Evidence: the preceding audit discussion in the “MAG Ecosystem” conversation (`6a8d3833-5ae4-83ed-a311-81a41b819dc4`) reported XenForo `2.3.12`, an available but uninstalled AI-agent package, and no verified clean external-reference bridge for the existing workspace. The reported audit conclusion was `NO CLEAN BRIDGE — DEFER XF AI INTEGRATION`.
- Limitations: this records the prior audit conclusion, not a new source audit or proof that integration is impossible. External file references and parent-root guidance/skill discovery must not be treated as verified integration; a reference to `SKILL.md` alone does not establish skill registration. No measured efficiency or compatibility benefit is established by this finding.
- Disposition: `CONTINUE_EXPERIMENT`.
- Approved scope: experimental evidence and decision tracking for `#2` / `1.1.0` only.
- Decision date: `2026-09-10`.
- Product Owner decision: record this finding as `CONTINUE_EXPERIMENT`; keep XF AI-agent integration deferred while evaluating verified native-tooling routing independently.
- Rationale and quality impact: evidence for a low-friction integration remains incomplete. Preserve targeted XenForo source verification and required validation without introducing unapproved workspace infrastructure.
- Next action: no installation or integration test is authorized by this record. Any later test requires an explicitly approved bounded scope. Do not install XF AI-agent resources, change the workspace model, or create copies, symlinks, or reference bridges under this documentation change.
- Prior decision reference: preserve the preceding deferred-integration audit conclusion above. This classification does not replace that history, complete the pilot evaluation, or propose Global promotion.

### 12.5 Recorded pilot evidence — Pipeline v2 Drive synchronization friction

**Classification:** active experimental evidence only. Not a final finding disposition and not Global authority.

| Field | Value |
| --- | --- |
| Primary finding ID | `V2-F03` — Documentation boundary batching |
| Cross-reference | `V2-F05` — Cursor minimization / executor selection |
| Current disposition | `CONTINUE_EXPERIMENT` |
| Decision date | `2026-09-11` |

**Evidence (factual):**

- Local `MAG_PIPELINE_V2_EXPERIMENT.md` and `MAG_PIPELINE_V2_EVALUATION.md` were validated and committed at Git `2041ec6d28996f97598cc06ee793adcdd977dcd1` (`Harden Pipeline v2 measurement and control framework`).
- Source SHA-256 values and canonical Drive IDs were already known for both documents.
- Pair classification for both counterparts was already `NEWER_LOCAL`.
- Multiple synchronization attempts across executors repeated registration, authority, metadata, comparison, and planning analysis, but could not complete the write because the active executor lacked safe in-place raw Markdown content replacement on the existing Drive object.
- No unsafe workaround was used.
- No duplicate Drive objects were created.
- The repeated procedural work added elapsed-time friction without increasing confidence in the already-proven Local source.

**Operational state preserved:**

- `MAG_PIPELINE_V2_EXPERIMENT.md` → Drive ID `<DRIVE-DOC:MAG_PIPELINE_V2_EXPERIMENT>` → remains `NEWER_LOCAL`
- `MAG_PIPELINE_V2_EVALUATION.md` → Drive ID `<DRIVE-DOC:MAG_PIPELINE_V2_EVALUATION>` → remains `NEWER_LOCAL`

Do not invent a numerical time saving. Do not mark Drive synchronization complete until an executor with a proven safe in-place raw-content write path performs and verifies the synchronization. Process improvements derived from this evidence are recorded separately in `MAG_DOCUMENTATION_OPERATIONS.md` §10 and do not by themselves change the current Drive classification.

## 13. Known experiment focus areas from #2

**Classification:** historical observations from the completed `#2` pilot baseline, not current Global methodology.

The completed `[MAG] Tag Synchronizer` workflow provides concrete process lessons to test:

- architecture decisions were often followed by separate documentation-only procedures;
- documentation synchronization occurred frequently across Roadmap, Architecture, CLASS_MAP, Changelog, and Cursor history;
- release finalization was fragmented into multiple small procedures;
- Cursor telemetry completion sometimes created additional handling under the methodology then in effect (including manual/deferred After finalization patterns later reduced by automatic MAG GPT|Cursor|Sync After telemetry in current Global `CURSOR_USAGE_ANALYTICS.md`);
- repeated ChatGPT ↔ Product Owner ↔ Cursor handoffs added elapsed-time overhead;
- simple deterministic Git actions were more efficiently handled manually;
- strong technical validation was valuable and must be preserved.

These observations motivate the pilot but are not themselves proof that Pipeline v2 will achieve the target. They do not require routine Product Owner manual After reporting under current Global methodology when valid automatic After telemetry is present.

## 14. Final evaluation template

### Pilot result

- Result: PASS / PARTIAL PASS / FAIL
- Baseline / strategy locked:
- Baseline lock date/boundary:
- Baseline limitations and confidence:
- Wall-clock elapsed-time reduction:
- Active process / collaboration-time reduction:
- Confidence:
- Target ≥30% achieved: YES / NO / UNAVAILABLE
- Approx. 40% target achieved: YES / NO / UNAVAILABLE

### Quality result

- Critical regression:
- Non-critical regression:
- XenForo/XFRM compatibility:
- Validation quality:
- Release quality:
- Documentation accuracy:
- Product Owner control:
- Over-batching incidents:
- Distinct technical validation / Practical Acceptance / Release Readiness / Release Finalization evidence:

### Highest-value optimizations

1.
2.
3.

### Weak or failed optimizations

1.
2.
3.

### Per-finding disposition record

Repeat for each finding, applying §12:

- Finding ID and description:
- Evidence, limitations, and quality impact:
- Disposition: GLOBAL_CANDIDATE / KEEP_PROJECT_ONLY / CONTINUE_EXPERIMENT / REJECT
- Approved project scope:
- Decision rationale:
- Next action or test, if authorized:
- Global proposal / owning documents, for GLOBAL_CANDIDATE only:
- Promotion-gate completion evidence, if separately approved and completed:
- Prior decision references:

### Product Owner decision

- Decision:
- Date:
- Notes:
