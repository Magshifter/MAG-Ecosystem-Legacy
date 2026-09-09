# MAG Pipeline v2 Evaluation

Status: EXPERIMENTAL EVALUATION FRAMEWORK — NOT GLOBAL AUTHORITY

## 1. Purpose

This document evaluates whether MAG Pipeline v2 produces a real improvement over the current MAG workflow.

Primary success target:

- at least 30% reduction in total elapsed development time.

Target outcome:

- approximately 40% reduction where project size and risk profile make that realistic.

Quality must not materially regress.

## 2. Pilot identity

Record before the pilot begins:

- Project:
- Project marker:
- Release / upgrade:
- Pilot start boundary:
- Pilot end boundary:
- Baseline chosen for comparison:
- Date started:
- Product Owner approval:
- Initial Cursor Models value, if available:

Do not invent missing values.

## 3. Baseline selection

Prefer the closest comparable completed MAG body of work.

Possible baselines:

- same project, previous similar release;
- another MAG add-on with comparable complexity;
- a comparable stage within a completed project;
- a normalized internal estimate when no direct baseline exists.

Document why the baseline is comparable.

Do not claim precise percentage improvement from a weak baseline.

When exact elapsed-time history is unavailable, use clearly labeled proxy metrics and qualitative evidence.

## 4. Primary metrics

### 4.1 Total elapsed time

Best metric where measurable.

Record pilot start, pilot completion, known inactive/waiting periods where they can be separated reliably, and estimated active collaboration time only when the estimate is explicitly labeled.

Primary comparison:

`time reduction % = (baseline time - pilot time) / baseline time × 100`

Do not fabricate historical time that was never measured.

### 4.2 Interaction round trips

Count meaningful handoff cycles such as:

ChatGPT → Product Owner → Cursor → Product Owner → ChatGPT

A round trip is counted when control leaves the current decision/execution context and returns with a result needed to continue.

Record total round trips, avoidable round trips identified after completion, and round trips per completed stage.

### 4.3 Cursor substantive procedures

Count procedures that materially inspect, implement, test, debug, audit, validate, or modify repository state.

Separately count Implementation, Debugging, Testing/Validation, Audit/Research, Documentation, Release finalization, Repository inspection, and Other.

Do not count a telemetry-only action as substantive work.

### 4.4 Documentation passes

Count distinct documentation synchronization passes.

Record total passes, documentation-only passes, files normally touched per closure, and cases where multiple micro-updates were successfully consolidated.

### 4.5 Git checkpoints

Count logical Git commit/push checkpoints used during the pilot.

Record whether each checkpoint was a stage boundary, risk-preservation checkpoint, release checkpoint, or unnecessary/avoidable in hindsight.

### 4.6 Rework loops

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
- procedures avoided through manual Product Owner action;
- procedures avoided through ChatGPT reasoning;
- repeated audits avoided through valid evidence reuse.

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
- coherent batching prevented multiple round trips.

Keep entries brief and factual.

## 10. Pilot result table

At completion, fill:

| Metric | Baseline | Pipeline v2 | Change | Confidence |
|---|---:|---:|---:|---|
| Elapsed time | | | | |
| Round trips | | | | |
| Substantive Cursor procedures | | | | |
| Documentation passes | | | | |
| Git checkpoints | | | | |
| Rework loops | | | | |
| Critical issues | | | | |
| Non-critical issues | | | | |
| Visible Cursor Models delta | | | | |

Use `unavailable` where evidence does not exist.

Do not backfill with invented values.

## 11. Success criteria

### PASS

Pipeline v2 may be rated PASS when:

- measured or sufficiently evidenced total elapsed-time reduction is at least 30%;
- target of approximately 40% may be noted if achieved;
- no unacceptable regression exists in correctness, security, XenForo/XFRM compatibility, maintainability, validation quality, release quality, or Product Owner control;
- procedural fragmentation is materially lower;
- rework does not erase the savings;
- project state and documentation remain trustworthy.

### PARTIAL PASS

Use when clear efficiency improvement exists but is below 30%, some v2 mechanisms work well while others create friction, evidence is too incomplete for a confident full PASS, or a quality/process weakness was found but can be isolated and corrected without rejecting the entire model.

A PARTIAL PASS should identify exactly which v2 rules should be retained, revised, or retested.

### FAIL

Use when time savings are insignificant or negative, rework materially increases, Critical defects increase because of process compression, validation quality degrades, release/documentation state becomes unreliable, Product Owner control becomes weaker, or the process hides uncertainty rather than resolving it.

## 12. Adoption decision

A successful pilot does not automatically modify Global MAG documentation.

After PASS or PARTIAL PASS:

1. identify which existing Global provisions would change;
2. list exact conflicts;
3. preserve historical project/process records;
4. prepare a scoped Global adoption proposal;
5. obtain Product Owner approval;
6. update owning Global documents only after approval;
7. remove or archive experimental status only after the authoritative replacement is complete.

Do not silently make Pipeline v2 authoritative.

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
- Measured elapsed-time reduction:
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

### Highest-value optimizations

1.
2.
3.

### Weak or failed optimizations

1.
2.
3.

### Recommended decision

- Adopt:
- Revise and retest:
- Reject:
- Next pilot, if needed:

### Product Owner decision

- Decision:
- Date:
- Notes:
