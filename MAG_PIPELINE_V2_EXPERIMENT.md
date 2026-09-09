# MAG Pipeline v2 Experiment

Status: EXPERIMENTAL — NOT GLOBAL AUTHORITY

## 1. Purpose

MAG Pipeline v2 is a controlled process experiment intended to reduce total elapsed development time and procedural friction without reducing correctness, security, XenForo/XFRM compatibility, maintainability, validation quality, documentation accuracy, or Product Owner control.

Primary target:

- reduce total elapsed development time by at least 30%;
- target approximately 40% where the project profile allows it;
- preserve or improve engineering quality.

This document does not replace current Global MAG documentation by default. It becomes active only for a Product Owner-approved pilot project, release, or upgrade cycle.

## 2. Authority and activation

Current Global MAG documentation remains the control baseline.

Pipeline v2 may be activated only when the Product Owner explicitly identifies:

- the pilot project or release;
- the start boundary;
- the end boundary;
- that Pipeline v2 is active for that boundary.

While active, Pipeline v2 temporarily replaces only the procedural mechanics explicitly covered by this document.

The following Global principles remain mandatory:

- GLOBAL defines HOW; #N defines WHAT;
- Existing-Code-First;
- XenForo-native development;
- source verification for uncertain XenForo/XFRM behavior;
- security-conscious and performance-conscious implementation;
- scope discipline;
- no speculative implementation;
- accurate documentation;
- Product Owner approval and Git/release control;
- historical records remain historical.

If Pipeline v2 conflicts with an engineering or safety requirement outside the procedural mechanics defined here, the existing Global safety/engineering rule wins and the conflict must be reported.

## 3. Core optimization principle

Optimize round trips, not engineering rigor.

The default unit of work is the smallest coherent batch, not the smallest possible micro-action.

A coherent batch may contain several already-approved related actions when they:

- belong to the same logical objective;
- share the same architecture and scope;
- can be validated together safely;
- do not cross an approval gate;
- do not hide unrelated changes.

Do not create separate AI procedures solely because individual edits could technically be separated.

## 4. Risk-scaled procedure levels

Every planned execution task should be classified before choosing the procedure depth.

### Level S — Simple

Use for deterministic, low-risk work such as narrow documentation synchronization, one or two known metadata edits, mechanical cleanup, simple renames, already-decided configuration changes, and simple manual Git actions.

Default treatment:

- no broad audit;
- no architecture research;
- no dedicated second review unless a concrete risk exists;
- prefer manual Product Owner action or low-cost deterministic execution;
- include in the nearest coherent documentation/Git checkpoint where practical.

### Level N — Normal

Use for ordinary feature implementation and routine XenForo integration where architecture is already approved.

Default treatment:

- inspect relevant existing code;
- implement the coherent increment;
- run focused validation;
- inspect the resulting diff;
- report issues;
- synchronize affected documentation at the stage boundary.

### Level H — High Risk

Use for work involving materially higher uncertainty or failure cost, including permissions, transactions, persistence, security, upgrades/migrations, destructive operations, complex XenForo/XFRM lifecycle behavior, concurrency/reentrancy, difficult compatibility boundaries, or high regression risk.

Default treatment:

- targeted source verification where uncertainty exists;
- explicit architecture decision;
- focused implementation;
- dedicated validation proportional to the risk;
- explicit issue review before closure.

Risk level may be raised when new evidence justifies it.

## 5. Requirements and architecture workflow

Requirements and architecture decisions remain Product Owner-controlled.

Optimization rule:

- decisions may be discussed and approved incrementally;
- approved decisions within one logical architecture block do not require an immediate Cursor documentation procedure after each decision;
- documentation synchronization normally occurs once at the logical stage or block boundary.

Example:

A1 approved  
A2 approved  
A3 approved  
→ one Architecture documentation synchronization  
→ one checkpoint

This does not permit implementation before the applicable approval gate.

## 6. Targeted research

Research begins with a concrete unresolved question.

Before a new audit:

1. check current project evidence;
2. check applicable verified MAG implementation knowledge;
3. check whether immediately preceding source verification remains valid;
4. inspect only the relevant XenForo/XFRM source if uncertainty remains.

Verified evidence should be reused until invalidated by a relevant platform-version change, architecture change, code-path change, new contradictory evidence, or a concrete validation failure.

Do not repeat an audit merely because a later stage refers to the same mechanism.

## 7. Cursor minimization

Cursor is for work where repository-aware execution materially helps.

Prefer ChatGPT reasoning and Product Owner manual actions for requirements, architecture decisions, wording decisions, simple Git commands, `git status`, `git diff`, `git add`, `git commit`, `git push`, simple file copying, deterministic one-line checks, character counting, and simple metadata confirmation.

Do not create a Cursor procedure merely to avoid a simple safe manual command.

Cursor should normally execute a complete coherent task such as:

inspect relevant code  
→ apply approved change  
→ run focused validation  
→ inspect diff  
→ report

rather than splitting that sequence into multiple procedures without a risk-based reason.

## 8. Documentation strategy

Documentation is synchronized by ownership and boundary, not by habit.

Default ownership:

- TZ: approved product requirements;
- Architecture: approved implementation architecture;
- CLASS_MAP: verified implementation structure;
- Roadmap: current sequencing and state;
- Changelog: meaningful product/release history;
- Cursor Usage History: Cursor telemetry only.

A completed technical procedure does not automatically require edits to every project document.

Documentation should normally be updated when its owned truth changes, at a logical stage/increment closure, before a release-state claim, or when a material conflict would otherwise remain undocumented.

Avoid documentation-only Cursor procedures between every approved micro-decision.

## 9. Git checkpoint strategy

Do not create artificial Git checkpoints for every intermediate action.

Default checkpoint boundary:

work  
→ review  
→ affected documentation synchronization  
→ relevant validation  
→ one logical Git checkpoint  
→ push  
→ clean-status verification

Additional checkpoints are justified when they materially improve rollback safety, isolate high-risk work, or preserve an important stable baseline.

The Product Owner retains final Git control.

## 10. Validation strategy

Validation remains risk-based and evidence-based.

Do not weaken required testing to save time.

Do not repeat already-valid evidence unless the tested behavior changed, the environment materially changed, the previous evidence does not cover the current risk, or a new defect creates uncertainty.

Final integration validation should focus on cross-component behavior and release-level risk not already sufficiently proven by increment-level validation.

## 11. Release flow optimization

Before release execution, assemble one Release Manifest where applicable:

- add-on ID;
- version;
- dependencies;
- description;
- icon;
- developer;
- developer URL;
- support URL or explicit PENDING state;
- donation URL;
- release notes/presentation data;
- required package metadata.

The Product Owner approves the manifest as one coherent release input.

Preferred release flow:

Release Manifest approval  
→ apply release metadata  
→ synchronize installed copy if needed  
→ focused ACP/runtime verification  
→ Product Owner Practical Acceptance  
→ finalize any externally dependent release field  
→ build final release package  
→ validate final package  
→ Release PASS/BLOCKED/FAIL  
→ Product Owner-controlled Stable Release actions  
→ one release documentation closure checkpoint

Do not fragment already-approved release metadata into separate Cursor procedures unless a dependency genuinely requires a pause.

## 12. Background and long-running operations

Pipeline v2 does not prescribe cron, Jobs, Rebuild, or another XenForo mechanism by assumption.

For long-running product functionality:

- first verify the appropriate XenForo-native mechanism;
- process large workloads in safe batches where required;
- avoid one-request global operations that create avoidable timeout or load risk.

This is an engineering rule, not a reason to add process overhead where no such risk exists.

## 13. Cursor telemetry experiment

**Classification:** experimental proposal/evaluation only. This section is **not** Global Cursor methodology authority.

Authoritative Cursor measurement, Before/After handling, automatic After consumption, telemetry-failure rules, visible-delta calculation, and metric finalization are owned by `MAG-Ecosystem` / `CURSOR_USAGE_ANALYTICS.md` in the current Global working tree.

Pipeline v2 retains these experimental operational goals (aligned with current Global direction where noted):

- Cursor telemetry must observe work, not create standalone work;
- never start a Cursor procedure solely to finalize a Cursor Models After value;
- prefer automatic `Cursor Models After: NN%` from MAG GPT|Cursor|Sync report telemetry when valid — ChatGPT consumes it in the background without routine Product Owner After reporting (current Global §8);
- when automatic After is missing/invalid, preserve unavailable/pending metrics and surface a tooling failure to the Product Owner; do not invent or silently substitute values (current Global §8.0.1);
- finalize pending history from the automatic report line when it arrives, without a standalone metric-finalization procedure (current Global §8.1);
- an unchanged displayed percentage means visible delta 0 pp only, not proven zero actual consumption;
- do not invent telemetry.

**Historical experimental note (superseded for current Global workflow):** an earlier Pipeline v2 draft proposed stage-local “last known displayed value” substitution when After was pending. Current Global methodology **does not** authorize silent last-known substitution for failed/missing automatic After. That earlier proposal remains a historical experiment idea only.

**Historical observation from `#2` pilot baseline:** prior workflow sometimes required additional Product Owner-facing metric handling. That observation motivated Pipeline v2 friction reduction but is not proof that manual After reporting remains the normal current workflow.

## 14. Round-trip reduction rule

Before creating a new procedure, ChatGPT should determine whether it can be safely merged into the current coherent batch.

A new procedure is justified when at least one is true:

- Product Owner decision is required first;
- architecture is unresolved;
- risk level materially changes;
- a validation result must determine the next action;
- repository scope changes;
- a new stage/gate begins;
- an unrelated task is discovered;
- rollback safety requires separation.

Otherwise, prefer continuation within the same coherent batch.

## 15. Stop conditions

Pipeline v2 does not authorize automatic progression.

Stop and return control to the Product Owner when a requirement decision is needed, architecture must change, scope expansion is proposed, a Critical issue is found, a release gate requires approval, a Git/release action requires Product Owner authorization, or evidence contradicts the approved design.

## 16. Pilot closure

At pilot completion:

1. finish required engineering/release work;
2. complete `MAG_PIPELINE_V2_EVALUATION.md`;
3. compare the pilot against the best available baseline;
4. classify the outcome as PASS, PARTIAL PASS, or FAIL;
5. do not modify historical Global or project records;
6. do not promote Pipeline v2 automatically.

Only the Product Owner may authorize a later proposal to replace or revise the current Global workflow.

## 17. Deactivation and rollback

Pipeline v2 may be deactivated at any time by the Product Owner.

On deactivation:

- stop applying experimental procedural substitutions;
- continue from the current verified project state under the existing Global baseline;
- preserve all valid implementation and validation evidence;
- do not redo completed work merely because the process mode changed;
- document only the process transition needed for historical clarity.

## 18. Experimental success principle

Pipeline v2 succeeds only if it saves meaningful total time while preserving engineering quality.

A faster process that increases defects, weakens validation, obscures state, reduces XenForo compatibility, or removes Product Owner control is a failure.
