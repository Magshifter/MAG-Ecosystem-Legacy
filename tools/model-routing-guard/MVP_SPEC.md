# MAG Model Routing Guard — MVP Spec

Status: **APPROVED** — runtime enforcement under canonical `AI_GUIDELINES.md` §24.4 Runtime Routing Enforcement  
Classification: Global operational tool under `MAG-Ecosystem/tools/`  
Authority: **none** — subordinate to `AI_GUIDELINES.md` §24.4  
Working name: **MAG Model Routing Guard**  
Contract: `enforcement-contract.v1.json` (subordinate projection — **not** authority)  
Mapping: `capability-mapping.json` (subordinate Capability Mapping — **not** authority)  
Provenance: MPO-002 promoted into §24.4 (historical only; not executable)

---

## 1. Purpose

Deterministic runtime enforcement of an **accepted Routing Plan** as the mechanical continuation of §24.4. Guard must not invent weaker routing semantics.

Layers: **A** canonical STOP → **B** Guard message (one concrete preferred recommendation) → **C** PO resolution → **D** tool recovery → **E** `+` continuation request + **re-evaluation**.

---

## 2. Non-goals

No UI, auto model switch, LLM router, semantic auto-class, auto escalate/downgrade, Auto router, weighted scoring, token/$ telemetry, Cloud routing, new `A<N>`, seventh Global owner.

---

## 3. Authority

| Layer | Owner |
| --- | --- |
| Durable routing HOW | `AI_GUIDELINES.md` §24.4 (Runtime Routing Enforcement + Capability Mapping) |
| Agent obligations | `AI_AGENTS_RULES.md` + §24.4 (always, all enforcement states) |
| Machine-readable contract | `enforcement-contract.v1.json` — subordinate only |
| Capability Mapping file | `capability-mapping.json` — subordinate only |
| This tool / `.mag` state | operational — no authority |
| MPO-002 | historical promotion provenance only — **not** current HOW |

Conflict → §24.4 wins; Guard STOPs on contract/mapping stale-conflict. Target routing class is supplied by the accepted routing decision/plan — Guard does **not** invent class escalation/downgrade.

---

## 4. Capability Mapping / recommendation

| Concept | Role |
| --- | --- |
| `preferred_model_id` (+ effort/speed/display) | One concrete recommendation projected into STOP/WARN text |
| `model_id_prefixes` | Hard MATCH compatibility set (preferred + approved alternatives) |
| `second_opinion_model_ids` | Metadata only — never auto-selected |

v1: effort/speed are recommendation metadata, not hard MATCH. Unknown observed effort alone ≠ `MODEL_MISMATCH`.

Target class rules (deterministic):

| Signal | Target class |
| --- | --- |
| `MODEL_MISMATCH` | current segment `routing_class` |
| `MODEL_ESCALATION_REQUIRED` | explicit `recommended_routing_class` only; else `ROUTING_MAPPING_UNKNOWN` |
| `MODEL_BOUNDARY` | next Segment class, else explicit `recommended_routing_class`; else `ROUTING_MAPPING_UNKNOWN` |
| `MODEL_DOWNGRADE_RECOMMENDED` | explicit `recommended_routing_class` only; absent → WARN without concrete model; no “one class lower” inference |

Optional `recommended_model_id_override` must be compatible with the target class prefixes; incompatible → `ROUTING_MAPPING_UNKNOWN`. Preferred concrete model is always re-resolved from the **current** mapping file (not persisted as policy).

---

## 5. Runtime Enforcement States

| State | Hooks | Agents §24.4 |
| --- | --- | --- |
| **ENFORCED** | hard STOP/WARN per contract | in force |
| **ADVISORY** | evaluate + report; no normal hard block | **in force** |
| **SUSPENDED** | hooks inert | **in force**; not MATCH |

Primary commands: `Guard Enforced` / `Guard Advisory` / `Guard Suspended`  
Legacy aliases only: `Guard Pro`→ENFORCED, `Guard Auto`→ADVISORY, `Guard Off`→SUSPENDED  

No TTL. State until explicit PO change.

Defaults:
- no accepted plan → **INERT**
- accepted plan + missing state file → **ENFORCED**

---

## 6. Pending STOP + `+`

Sidecar: `.mag/routing-pending.json` (not mutated into the plan body).

May persist: signal, required_resolution, plan_fingerprint, segment, observed model, `recommended_routing_class`, optional override/reason. Does **not** persist a dynamically resolved preferred model as policy.

`+` = **continuation request**: recognize → re-evaluate pending predicate → resolved? clear : STOP remains.

No generic `+` clear. No wrong-model waiver.

---

## 7. Maintenance (separate)

`Set-MagGuardMaintenance.ps1` Suspend/Resume. Effective tool SUSPENDED; preserves plan + pending; never MATCH; never auto-activates.

---

## 8. Observation / contract

Concrete `model_id`, else concrete `model`. UNKNOWN ≠ MATCH. Policy table from `enforcement-contract.v1.json`. Mapping from `capability-mapping.json`. No prompt/token/$ logging.

---

## 9. Acceptance

See `Test-GuardRecovery.ps1`. Canonical HOW is §24.4 — not MPO-002.
