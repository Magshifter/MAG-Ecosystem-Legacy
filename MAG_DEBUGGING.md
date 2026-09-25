# MAG Debugging

- MAG-Document-ID: `MAG_DEBUGGING.md`
- MAG-Content-Updated: `2026-09-25T19:50:00+03:00`

## 1. Purpose and scope

This document is the Global MAG **operational debugging specification** for MAG work.

It defines a reusable operational workflow: investigation → evidence → root-cause confirmation → verification → knowledge classification.

It is a **Global operational asset**. It implements and reifies current Global debugging discipline. It does **not** create substantive MAG authority, product requirements, lifecycle phases, or reusable technical truth on its own.

The governing MAG model is **CONTROL → ROUTING → AUTHORITY**. This document operationalizes debugging within that model. It does **not** redefine CONTROL, ROUTING, or AUTHORITY.

Operational rules in this document:

- Debugging **observations** are evidence. They are **not** automatically root cause.
- A successful validator or test run is evidence. It is **not** automatically complete runtime truth.
- An agent validation or fix report is **not** Product Owner acceptance.
- Debugging must preserve **identity** and **product-WHAT** boundaries defined by the active development identity and its authoritative project documentation. Working identities are `GLOBAL`, `GLOBAL+#N`, and `GLOBAL+A<N>`. `B<N>` is reserved and is not a current working identity. Platform or surface is not identity.
- Absence of a matching Pattern, and absence of a platform-specific profile, does **not** block debugging. Use this Global methodology and targeted verification.
- This document tells agents and coordinators **how** to run a debugging case. Canonical owners remain the source of **what** is true, **what** is allowed, and **what** may be promoted.

## 2. Authority and ownership boundaries

If this document conflicts with a canonical owner, **the canonical owner wins**. Report the conflict; do not silently prefer this operational specification.

| Concern | Canonical owner |
| --- | --- |
| Ecosystem identity, authority hierarchy, GLOBAL + active development identity isolation, operational-asset status | [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md) |
| Entry Gate, intent, retrieval scope, development standards, evidence and fact handling, material-change principles | [`AI_GUIDELINES.md`](AI_GUIDELINES.md) |
| Coding-agent execution boundaries, stop/report mechanics, checkpoints, **Mechanical Action Gate** | [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md) |
| Reusable source-backed technical knowledge, capture procedure, status model, promotion mechanics | [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md) |
| Documentation identity, registration, SYNC, derived generated discovery artifacts | [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md) |
| Ordered lifecycle (Global Core plus the applicable `#N` XenForo Product profile), validation stages, release acceptance, post-release verification, knowledge-capture timing | [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) |
| Development-specific WHAT, architecture, requirements, and debugging evidence | Active development documents (for example project TZ, Architecture, Roadmap, and **AUDIT** where that identity actually has an applicable AUDIT artifact). Do not invent an `A<N>` eight-document package. |

`MAG_DEBUGGING.md` is **not** a seventh canonical Global authority owner. It is **not** a second [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md). It is **not** the Entry Gate owner and **not** the Mechanical Action Gate owner.

Registration as a Global operational asset is recorded in `MAG_ECOSYSTEM.md` (operational-asset table and `SYNC GLOBAL` eligibility). This file is **not** a seventh canonical Global authority owner.

## 3. Debugging operational ladder

MAG debugging uses an operational ladder:

```text
DEBUG → VERIFY → LEARN
```

This is an **operational debugging flow**. It is **not** a new MAG lifecycle, **not** a new authority hierarchy, and **not** a substitute for lifecycle gates or Product Owner approvals.

DEBUG, VERIFY, and LEARN may **iterate** when evidence invalidates a hypothesis, verification exposes another failure, or classification reveals a need to reopen investigation.

### DEBUG

- Establish the symptom and **affected scope** (identity, surface, component boundary).
- Reproduce where possible; otherwise characterize conditions under which the symptom appears.
- Collect observations and artifacts (logs, traces, screenshots, diffs, source excerpts) tied to specific claims.
- Separate **known facts** from **hypotheses**.
- Inspect the actual implementation, runtime behavior, or source — not documentation alone when contradiction is possible.
- Narrow the **failure domain** (see §7).
- Test hypotheses with targeted evidence.
- Identify a **candidate** root cause.
- Do **not** report root cause as **confirmed** until evidence supports it.

### VERIFY

- Verify the actual fix or corrected behavior against the **owning requirement** and relevant implementation boundary.
- Distinguish **targeted technical validation** from broader lifecycle validation, release checks, and Product Owner practical acceptance.
- Check **relevant regression** paths proportional to the change and risk.
- Runtime or production claims require **appropriate runtime or production evidence**.
- Validator **PASS** alone must not be presented as complete system truth or as proof that every related surface behaves correctly.

### LEARN

- Classify what was learned (see §9).
- Do **not** automatically promote findings to Global reusable knowledge.
- Development-specific findings remain **development-scoped** unless separately classified, validated, and approved for reusable capture.
- Reusable technical candidates follow [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md) capture, verification, scope, **Verified Applicability** metadata, status, fail-closed reuse, and Product Owner approval rules.
- **No reusable lesson** is a valid and complete outcome.

## 4. Debugging case structure

Use the following fields to structure a debugging case or session. This is an **operational structure** for discipline and reporting. It is **not** a new mandatory project document, **not** a new registry object, and **not** a requirement to create a separate file unless the approved task says so.

Do **not** allocate `DBG-*` identifiers or other Knowledge Control IDs in this operational specification.

| Field | Purpose |
| --- | --- |
| **Identity** | Active `GLOBAL` / `GLOBAL+#N` / `GLOBAL+A<N>` context and allowed scope. `B<N>` is reserved. Platform or surface is not identity. |
| **Task / symptom** | What failed or is under investigation. |
| **Expected behavior** | Behavior required by the owning requirement or boundary. |
| **Observed behavior** | What actually happened. |
| **Reproduction conditions** | Steps, data, environment, and prerequisites. |
| **Affected scope** | Components, surfaces, identities, and boundaries touched. |
| **Evidence collected** | Artifacts and observations with provenance. |
| **Known facts** | Claims supported by current evidence. |
| **Hypotheses** | Explanations not yet confirmed. |
| **Failure domain** | Routing label from §7; not a conclusion. |
| **Candidate root cause** | Leading explanation pending confirmation. |
| **Root-cause evidence** | Evidence that confirms or refutes the candidate. |
| **Proposed/implemented change** | Change scope actually authorized and applied. |
| **Verification performed** | What was run or observed to verify the fix. |
| **Regression checks** | Related paths checked after the change. |
| **Remaining uncertainty** | What is still unknown or unverified. |
| **Knowledge classification** | Result from §9. |
| **References** | Links to owning canonical and project documents. |

## 5. Evidence discipline

This section states **operational** evidence discipline for debugging. Authoritative fact handling, material-change rules, and promotion policy remain in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) and [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md).

Principles:

- **Observation ≠ explanation.** Record what was seen separately from why it might have happened.
- **Correlation ≠ root cause.** Co-occurrence does not prove mechanism.
- **Validator PASS ≠ complete runtime truth.** A passing check proves what that check actually exercised.
- **Agent report ≠ Product Owner acceptance.** Automated or agent-reported success does not replace required Product Owner gates.
- **Historical behavior ≠ current behavior** without current evidence.
- **Documentation claim ≠ implementation fact** when current source or runtime contradicts the document.
- A **failed hypothesis** must be discarded or downgraded. Do not preserve it as fact.

Require evidence to be **tied to the claim it supports**. When evidence is missing, conflicting, stale, or outside allowed scope, report the uncertainty rather than inventing certainty.

For production observations and conflicts between documentation and behavior, follow [`AI_GUIDELINES.md`](AI_GUIDELINES.md) and applicable lifecycle rules in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md).

## 6. Root-cause procedure

Bounded operational procedure for root-cause work. This is **not** a lifecycle phase sequence.

1. Establish **identity** and **allowed scope** per [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md).
2. Establish the **owning expected behavior** from the active development WHAT owners (and Global HOW where relevant).
3. **Reproduce** or characterize the symptom.
4. **Preserve** relevant evidence before destructive intervention where applicable.
5. **Inspect** the actual execution path, source, or runtime — not assumptions.
6. Divide the system into plausible **failure domains** (§7).
7. Form the **smallest useful hypotheses**.
8. **Test** hypotheses with targeted evidence.
9. **Eliminate** disproved hypotheses.
10. **Confirm** root cause with evidence that explains the observed failure.
11. Apply only the **authorized fix scope**.
12. **Verify** the fix and relevant regressions (§8).
13. **Classify** resulting knowledge (§9).

For **HIGH-RISK** agent-initiated actions (commits, pushes, canonical edits, and other high-risk classes), follow [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md) **Mechanical Action Gate** rules. Do not treat debugging urgency as authorization to bypass those controls.

## 7. Failure-domain framework

Failure domains are **investigation aids** only. They are **not** technical truths and **not** root-cause conclusions.

The list is **non-exhaustive**. A domain label routes investigation; it does not close the case.

Generic categories:

- requirements / expected-behavior mismatch
- configuration / environment
- data / state
- server-side execution
- client-side execution
- lifecycle / initialization / teardown
- asynchronous / job / queue behavior
- caching / persistence
- integration / API boundary
- deployment / synchronization
- validation / test blind spot
- unknown / not yet isolated

Do not embed XenForo-specific or product-specific Pattern bodies here. Where reusable XenForo or MAG technical knowledge exists, reference the relevant section in [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md) by title — do not copy the Pattern body into this document.

## 8. Verification and regression discipline

Distinguish operationally:

| Kind | Role |
| --- | --- |
| **Reproduction check** | Symptom still occurs (or not) under stated conditions. |
| **Targeted fix verification** | The specific change addresses the confirmed or strongly supported cause. |
| **Relevant regression verification** | Related paths still behave as required after the change. |
| **Broader lifecycle validation** | Stage- or release-scope validation defined by lifecycle and guidelines. |
| **Product Owner practical acceptance** | Product Owner exercises the scope as a real user/administrator where required. |
| **Post-release / runtime observation** | Evidence from deployment or production use. |

Do **not** redefine lifecycle gates. Mandatory validation and acceptance rules remain in [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md) and [`AI_GUIDELINES.md`](AI_GUIDELINES.md).

**Verification must match the claim being made.**

Methodological examples (generic):

- A backend or CLI test alone cannot prove a full browser interaction path.
- A click-path or UI driver test alone cannot prove all server-side invariants.
- Static inspection alone cannot prove runtime behavior.
- Local validation alone cannot prove production behavior.

Choose verification proportional to the claim and risk.

## 9. Knowledge classification

Use this **operational** classification set at the end of LEARN (or when closing a debugging case):

- **Project-specific finding** — Correct or useful for the active development identity; not automatically reusable elsewhere.
- **Known Global pattern confirmed** — Current evidence is consistent with an existing entry in [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md); does **not** create a new Pattern.
- **Candidate reusable Global pattern** — May warrant capture after Verify and scope review; not promoted by classification alone.
- **Existing Global pattern contradicted or requires revalidation** — Evidence conflicts with a Pattern; route to Patterns maintenance, do not override silently from this document.
- **Process/documentation issue** — Workflow, documentation sync, registration, or operational gap; route to the owning Global document or project owner.
- **No reusable lesson** — Valid closure; debugging still succeeded operationally.
- **Unknown** — Insufficient evidence to classify safely.

**Classification ≠ promotion.**

Project-specific evidence remains project-scoped unless separately classified, validated, and approved for reusable capture per [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md).

**Candidate reusable Global pattern** must go through the Patterns capture procedure (Detect → Verify → Search → Classify Status → determine Verified scope + applicability → Decide → Record), including Product Owner approval where required and explicit Verified Applicability metadata, before becoming reusable Global knowledge. Classification is not promotion. Fail-closed Pattern reuse: if applicability cannot be established, do not reuse the Pattern; perform targeted verification.

If an existing Global Pattern is contradicted, report and handle through [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md) revalidation or correction mechanics. `MAG_DEBUGGING.md` does not amend Patterns.

Do **not** create `DBG-*` identifiers.

## 10. Development evidence boundary

Development-specific debugging evidence belongs to the **active development identity**.

Project **AUDIT** (and justified child audits) may hold product-specific debugging and validation evidence where that identity actually has an applicable AUDIT artifact. Do not invent an `A<N>` eight-document package.

Do **not** copy into this document as Global truth:

- project-specific requirements, paths, IDs, or fixtures;
- provider or integration behavior unique to one product;
- benchmarks, thresholds, or numeric budgets from one project;
- implementation decisions or runtime conclusions tied to one release line.

Examine cross-development evidence only when the Product Owner explicitly authorizes a **real cross-development task**.

Generic reusable lessons must be **separately classified** and handled through [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md).

Large `#N` debugging histories (for example extensive hardening or validator matrices in a project AUDIT) demonstrate that this boundary is practical. They remain **development evidence**. They do not become Global debugging rules by accumulation.

## 11. Relationship to reusable Patterns

| Question | Owner |
| --- | --- |
| How do we investigate, prove, verify, and classify a debugging case? | **`MAG_DEBUGGING.md`** (this document) |
| What reusable source-backed technical knowledge has been validated for reuse, and under what scope? | **`MAG_IMPLEMENTATION_PATTERNS.md`** |

`MAG_DEBUGGING.md` may **point** to relevant Pattern titles or sections.

It must **not** duplicate Pattern bodies as its own playbook knowledge.

A debugging case may end with:

- no reusable lesson;
- confirmation of an existing Pattern;
- a candidate Pattern;
- evidence that an existing Pattern requires revalidation.

## 12. Reporting and completion

Minimum **debugging completion report**:

- symptom / task;
- affected identity and scope;
- **confirmed root cause**, or **Unknown** if not confirmed;
- evidence supporting the conclusion;
- exact change made, if any;
- verification performed;
- remaining uncertainty;
- regression result;
- knowledge classification (§9);
- any required follow-up routed to the correct owner (Patterns, lifecycle, documentation operations, project AUDIT, Product Owner decision).

Do **not** report:

- **"fixed"** solely because code changed;
- **"validated"** solely because an agent says so;
- runtime or production success without matching evidence;
- Product Owner acceptance unless the Product Owner actually accepted it under the applicable lifecycle gate.

If root cause remains unresolved, report **Unknown** rather than manufacturing closure.

## 13. References

Reference; do not duplicate detailed rules from:

- [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md)
- [`AI_GUIDELINES.md`](AI_GUIDELINES.md)
- [`AI_AGENTS_RULES.md`](AI_AGENTS_RULES.md)
- [`MAG_IMPLEMENTATION_PATTERNS.md`](MAG_IMPLEMENTATION_PATTERNS.md)
- [`MAG_DOCUMENTATION_OPERATIONS.md`](MAG_DOCUMENTATION_OPERATIONS.md)
- [`MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`](MAG_ADDON_DEVELOPMENT_LIFECYCLE.md)
- Active development requirements and **AUDIT** documents as applicable to the case
