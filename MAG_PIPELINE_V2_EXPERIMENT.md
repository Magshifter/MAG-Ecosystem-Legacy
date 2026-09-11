# MAG Pipeline v2 Experiment

- MAG-Document-ID: `MAG_PIPELINE_V2_EXPERIMENT.md`
- MAG-Content-Updated: `2026-09-11T08:17:00+03:00`

Status: EXPERIMENTAL — NOT GLOBAL AUTHORITY

Active approved pilot: `#2` — [MAG] Tag Synchronizer / `1.1.0` — ACTIVE

## Authority disclaimer and promotion gate

These are project-scoped working documents for `#2` ([MAG] Tag Synchronizer), not Global authority. They may evolve during the approved pilot. Registration and metadata establish identity/version tracking and synchronization eligibility only; they grant no substantive authority. They cannot override approved TZ, Architecture, Roadmap, or Global rules. Only expressly approved, bounded pilot procedural exceptions may apply within their recorded scope; no exception extends to another project or cycle.

Apply the per-finding disposition model and separate Global promotion gate in `MAG_PIPELINE_V2_EVALUATION.md` §12. A pilot result or finding classification never grants Global authority. Preserve evidence and decision history; this experiment remains limited to the approved `#2` pilot.

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

### 2.1 Product Owner pilot activation record

Product Owner approval has been given to activate the Pipeline v2 experiment for the following pilot only:

| Field | Value |
| --- | --- |
| Pilot project | `#2` — [MAG] Tag Synchronizer |
| Project marker | `P02__TS` |
| Approved development cycle | `1.1.0` |
| Pipeline v2 status for this cycle | ACTIVE |
| Governing experiment document | `MAG_PIPELINE_V2_EXPERIMENT.md` |
| Evaluation document | `MAG_PIPELINE_V2_EVALUATION.md` |

Activation limits and authority boundaries:

- activation is limited to `#2` / `1.1.0`;
- Pipeline v2 remains experimental;
- this activation does **not** make Pipeline v2 the default MAG lifecycle;
- `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` remains the canonical Global lifecycle authority outside this approved pilot’s procedural substitutions;
- this activation does **not** authorize Pipeline v2 for any other MAG project or version;
- this activation does **not** authorize implementation automatically;
- broader adoption requires a separate Product Owner decision after evaluation under `MAG_PIPELINE_V2_EVALUATION.md`.

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

### 2.2 Global → Pipeline v2 substitution map

This matrix is authoritative only for the approved `#2` / `1.1.0` pilot. It identifies bounded experimental treatment without reproducing or replacing the owning Global procedures.

| Global mechanism | Pipeline v2 treatment | Classification | Owning authority | Pilot-specific boundary |
| --- | --- | --- | --- | --- |
| Requirements approval | Retained without substitution | Unchanged | `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Gate 1; active `#2` TZ | Existing approved requirements remain authoritative; changes still require Product Owner approval |
| Architecture approval | Retained without substitution | Unchanged | `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Gate 2; active `#2` Architecture | Approved A1–A6 remain unchanged; batching cannot amend architecture |
| Implementation planning | Approved related planning may be handled as one coherent block | Optimized | Global lifecycle Phase 5; active `#2` Roadmap | Existing I1–I7 remain unchanged; optimization changes procedure shape only |
| Implementation authorization | Separate explicit Product Owner authorization remains mandatory | Unchanged | `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 5 | Pipeline activation and this framework do not authorize I1 or any implementation |
| Targeted research / source verification | Reuse applicable valid evidence; inspect only unresolved, invalidated, or materially risky behavior | Conditionally substituted | Global lifecycle Phase 3; `AI_GUIDELINES.md` | Evidence reuse is allowed only within verified scope; uncertain XenForo/XFRM behavior still requires verification |
| Validation | Focus validation on changed behavior and uncovered risk while preserving required evidence | Optimized | `AI_GUIDELINES.md`; Global lifecycle Phases 6–8 | No reduction in required quality, security, compatibility, or release validation |
| Documentation synchronization | Batch affected documents at logical ownership and closure boundaries | Optimized | `MAG_DOCUMENTATION_OPERATIONS.md`; `AI_GUIDELINES.md` | No silent state drift, cross-project sync, registration, adoption, or authority change |
| Redundant review suppression | Omit a repeated review only while preceding evidence remains valid and covers current risk | Conditionally substituted | `AI_GUIDELINES.md`; `AI_AGENTS_RULES.md` | New risk, changed state, failed validation, or uncertainty restores the applicable review |
| Git checkpoint strategy | Consolidate related approved work into one logical checkpoint where rollback and review remain safe | Optimized | `AI_GUIDELINES.md`; `AI_AGENTS_RULES.md` | Product Owner Git control remains unchanged; high-risk isolation may require an additional checkpoint |
| Product Owner Practical Acceptance | Preserve as a distinct mandatory gate where the Global lifecycle requires it | Unchanged | `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 7 | Must not be collapsed into technical validation, Release Readiness, or Release Finalization |
| Release Readiness | Preserve Gate 3 and its entry conditions | Unchanged | `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Gate 3 | No batching or efficiency result can bypass Product Owner approval |
| Release Finalization | Consolidate already-approved release inputs and related execution where dependencies permit | Optimized | `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 8 | Remains distinct from Practical Acceptance and Release Readiness; must end with its required result |
| Release actions | No experimental substitution | Unchanged | `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`; `AI_GUIDELINES.md` | Commit, push, tag, publication, deployment, and Stable Release remain Product Owner-controlled |

All Global approval gates not expressly identified as optimized or conditionally substituted remain untouched. `Not applicable` may be recorded for a mechanism only when it genuinely does not apply to a bounded pilot task; it is not a waiver.

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

Pipeline v2 optimizes unnecessary fragmentation. Fewer procedures are not an objective by themselves.

## 4. Risk-scaled procedure levels

Every planned execution task should be classified before choosing the procedure depth.

**Highest applicable material risk wins.**

If a coherent batch contains a material High-Risk component, classify the batch as Level H unless the risk-bearing component is safely separated into its own independently reviewable task. Batching must never downgrade risk classification.

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

Use for work involving materially higher uncertainty or failure cost, including permissions/security, persistence or data integrity, transactions, install/upgrade/migration behavior, destructive operations, concurrency/reentrancy, complex XenForo/XFRM lifecycle behavior, difficult compatibility boundaries, or another condition where failure cost or uncertainty is materially high.

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

## 7. Executor selection and Cursor minimization

**Use the lowest-friction safe executor that preserves Product Owner control, approved scope, required verification, and auditability.**

Potential executors include Product Owner manual action, ChatGPT reasoning, ChatGPT Work, Cursor, or another explicitly approved tool. Select proportionally to task complexity, risk, repository/file access requirements, and verification needs. Executor capability does not expand authority.

Do not create a Cursor or Work procedure merely to avoid a simpler safe execution path. Use Cursor when repository-aware engineering execution materially helps. A Cursor task should normally execute a complete coherent task such as:

inspect relevant code  
→ apply approved change  
→ run focused validation  
→ inspect diff  
→ report

rather than splitting that sequence into multiple procedures without a risk-based reason.

This is a `#2` / `1.1.0` experimental routing principle, not a new Global tool policy.

### 7.1 Optimized prompt and context workflow (experimental)

**Classification:** experimental Pipeline v2 practice only. Authoritative prompt presentation and post-execution review remain in `MAG-Ecosystem` / `AI_GUIDELINES.md` §24. Authoritative Cursor usage metrics remain in `MAG-Ecosystem` / `CURSOR_USAGE_ANALYTICS.md`.

Pipeline v2 evaluates an optimized ChatGPT → Product Owner → Cursor workflow intended to reduce duplicated context and unnecessary round trips:

- present the copyable Cursor prompt first, after Product Owner approval to receive it;
- keep prompts concise and task-specific;
- reference applicable authoritative MAG rules instead of duplicating them in the prompt;
- provide a concise Ukrainian **Ціль/задача** after the prompt;
- route through the correct **Cursor chat** and **Cursor model** without inventing unknown chats;
- avoid requiring **Cursor Models Before** in the user-facing presentation block;
- display applicable Cursor usage values after execution without commentary;
- provide immediate post-execution review and a progressive Ukrainian learning note per `AI_GUIDELINES.md` §24.3.

This experiment measures whether reduced context duplication and clearer presentation improve AI/Cursor workflow efficiency without weakening engineering rigor or Product Owner control.

### 7.2 XenForo Native Tooling First (experimental)

For the active `#2` / `1.1.0` pilot only, verified native XenForo tooling is an executor candidate under §7 when it is the lowest-friction safe path for deterministic XenForo work.

This is a suitability check, not a mandatory handoff or fixed executor order. First inspect the relevant existing implementation and reuse still-valid evidence under §6. Verify the exact native command, options, prerequisites, and effects against the installed XenForo version before selecting it. Command families such as `xf-make:*`, `xf-dev:*`, and `xf-addon:*` are candidates to check, not a claim that every command exists or is suitable.

Prefer verified native tooling when it safely performs the approved deterministic operation, including standard scaffolding or applicable phrase/template, validation, add-on metadata, and release-preparation work. Do not ask Cursor to manually generate equivalent boilerplate when the verified native operation is sufficient. Use Cursor for the remaining project-specific logic, debugging, refactoring, or engineering work.

Tool availability does not authorize execution. Preserve Existing-Code-First, approved scope and architecture, required validation, stage gates, and Product Owner control; mutating commands require applicable authorization. If suitability remains uncertain, resolve only that uncertainty through targeted installed-source inspection instead of a broad framework audit.

Native CLI routing is independent of installing XenForo AI-agent resources. The deferred integration finding and its evidence limits are recorded in `MAG_PIPELINE_V2_EVALUATION.md` §12.4. This routing grants no approval to install resources, change the workspace model, or create an integration bridge.

### 7.3 Resolved deterministic operation (experimental)

**Resolved deterministic operation = execute, not re-analyze.**

Apply this experimental optimization when:

- the objective is already approved;
- source and target are resolved;
- direction is deterministic;
- prior evidence remains valid;
- no authority, risk, or scope boundary changed.

In that state, use the smallest safe execution procedure. Do not create a fresh planning or audit cycle merely because the operation is being retried through another executor.

For documentation synchronization, the Global Fast Sync Path in `MAG_DOCUMENTATION_OPERATIONS.md` §10.1 governs the reusable mechanics. This section records only the Pipeline v2 experimental intent: reduce elapsed-time friction from repeated preflight when the Local source, target identity, classification, and approval are already proven.

Global safety, verification, approval, conflict handling, and stop-condition requirements remain mandatory.

### 7.4 Authorized gate — immediate execution (experimental)

**Classification:** experimental Pipeline v2 practice for the approved `#2` / `1.1.0` pilot only. Not Global authority. Does not change Global lifecycle semantics or which actions require Product Owner authorization.

When the Product Owner authorizes or activates a gate and all evidence required to evaluate that gate is already available, the authorized agent should execute the gate immediately in the same interaction and return the formally defined gate result (`PASS`, `BLOCKED`, or another result defined for that gate). No additional Product Owner confirmation should be requested solely to begin execution of the already-authorized gate.

Required experimental behavior:

```text
Product Owner authorization/activation
→ immediate gate evaluation
→ PASS / BLOCKED / other formally defined gate result
```

Avoid:

```text
Product Owner authorization
→ acknowledgement
→ wait for another confirmation
→ gate evaluation
```

This is a concrete experimental application of §7.3 for gate evaluation: reduce unnecessary round trips without replacing Global lifecycle authority. Outside this pilot, existing Global rules remain authoritative.

Clarifications:

- Product Owner control remains unchanged.
- Required Product Owner authorization is still mandatory.
- This rule removes only redundant confirmation that contains no new decision.
- If evidence is missing, contradictory, stale, or requires a new Product Owner decision, stop and state the concrete blocker or question.
- Missing prerequisites must never be treated as satisfied.
- Gate `PASS` must not automatically authorize the next Product Owner-controlled lifecycle stage when Global rules or the project Roadmap define that authorization separately.

### 7.5 Satisfied prerequisites after gate PASS (experimental)

**Classification:** experimental Pipeline v2 practice for the approved `#2` / `1.1.0` pilot only. Not Global authority. Does not change Global lifecycle semantics, Product Owner control, or XenForo Native Tooling First.

Once a prerequisite has been satisfied by verified evidence and a later gate relying on that evidence has passed, Pipeline v2 must treat that prerequisite as satisfied while the relevant evidence remains valid. The prerequisite must not be reopened or repeated merely because a later implementation stage references the same engineering rule.

Before requesting or performing additional verification, identify a concrete new fact that invalidates the prior evidence or creates a genuinely new technical uncertainty.

Required execution order:

```text
Current lifecycle state
→ existing verified evidence
→ check whether evidence is invalidated
→ identify genuinely new uncertainty
→ only then determine whether additional verification is needed
```

A passed gate is evidence that its required prerequisites were sufficiently satisfied at the time of evaluation. After that gate `PASS`, do not behave as though one of those prerequisites remains unresolved unless a specific new condition invalidates it.

If invalidation exists:

- name the exact prerequisite;
- state the new evidence or changed condition;
- explain why previous evidence no longer resolves it;
- perform only the smallest targeted verification required.

XenForo Native Tooling First (§7.2) remains fully in force. Already verified and still-valid evidence satisfies it. A new verification is justified only by concrete invalidation or new uncertainty.

Valid invalidation examples: changed requirement; changed approved architecture; changed implementation scope; repository change affecting the earlier evidence; relevant XenForo/XFRM/platform/environment change; failed validation; contradictory new evidence; previously unknown API behavior; another concrete reason making prior evidence unreliable.

Correct pilot behavior:

```text
Native Verification completed
→ Architecture approved
→ Implementation Plan completed
→ Pre-Implementation Gate PASS
→ Implementation authorized
→ start approved implementation increment
```

If a new API uncertainty appears during implementation:

```text
identify exact uncertainty
→ narrow targeted Native/XenForo verification
→ continue implementation
```

Incorrect pilot behavior:

```text
Native Verification completed
→ Architecture approved
→ Implementation Plan completed
→ Pre-Implementation Gate PASS
→ Implementation authorized
→ repeat general Native Tooling First audit
→ only then start implementation
```

This is a concrete experimental application of §6, §7.2, and §7.3: reuse still-valid evidence, avoid repeated broad audits, and reduce unnecessary round trips without weakening required verification when genuinely new uncertainty appears.

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

Technical validation, Product Owner Practical Acceptance, Release Readiness, and Release Finalization remain distinct lifecycle boundaries. Batching and time optimization may reduce overhead around them but must never collapse, silently merge, remove, or redefine them. Product Owner Practical Acceptance remains separately required wherever the Global lifecycle requires it.

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

This consolidated flow does not merge technical validation, Product Owner Practical Acceptance, Release Readiness, or Release Finalization. Each retains its Global entry, evidence, decision, and completion boundary.

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

**Experimental documentation-work observation only (not an official `CURSOR_USAGE_ANALYTICS.md` metric):** during early Pipeline v2 documentation-work evaluation, **Other Models** usage was observed as `0% → 32%` (**Δ +32 p.p.**). This observation is experimental context for evaluating AI/Cursor allocation during documentation procedures. It is **not** part of the tracked **Cursor Models** pool, must not be recorded as a Global analytics field, and must not be promoted into authoritative Cursor methodology without separate Product Owner approval.

### 13.1 Evidence capture boundary

Capture metrics, friction observations, over-batching incidents, rework, and finding-specific evidence opportunistically at existing logical stage, closure, or checkpoint boundaries when reliable contemporaneous evidence is available.

Do not create standalone Cursor or Work procedures merely to record routine experiment telemetry when the same evidence can be captured safely during an existing closure. Do not defer all evidence reconstruction until pilot completion when contemporaneous capture is reasonably available. Preserve `pending` or `unavailable` rather than inventing missing evidence.

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

### 14.1 Over-batching control

An **Over-batching incident** is a coherent batch that became too broad and materially reduced reviewability, rollback safety, root-cause isolation, validation clarity, scope control, or Product Owner understanding/control.

Record each incident in the evaluation friction/evidence model with the affected finding ID, boundary, observed impact, corrective action, and remaining quality effect. An incident is evidence against the relevant optimization even when the batch eventually succeeds.

Split or stop a batch when continuing would materially worsen any of these controls. Pipeline v2 reduces unnecessary fragmentation; it does not reward procedure-count reduction at the expense of control.

## 15. Stop conditions

Pipeline v2 does not authorize automatic progression.

Stop and return control to the Product Owner when a requirement decision is needed, architecture must change, scope expansion is proposed, a Critical issue is found, a release gate requires approval, a Git/release action requires Product Owner authorization, or evidence contradicts the approved design.

### 15.1 Current #2 documentation-repair boundary

The separate Documentation Department task affecting `P02__TS__TZ.md`, `P02__TS__Architecture.md`, `P02__TS__Roadmap.md`, `P02__TS__CLASS_MAP.md`, and `docs/P02__TS__IDEA.md` is current pilot context only.

This hardening procedure does not execute, register, adopt, add metadata to, correct, rename, or synchronize those documents. That task remains a separate subsequent coherent block. Pre-Implementation Gate remains not started, I1 is not started, and Tag Synchronizer `1.1.0` implementation remains not authorized.

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
