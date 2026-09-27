# MAG Model Routing Guard — MVP Spec

Status: **APPROVED** (Product Owner `2026-09-27`) — EXECUTION spike authorized  
Classification: **Global operational tool** under `MAG-Ecosystem/tools/`  
Authority: **none** — implements `AI_GUIDELINES.md` §24.4 (+ Agents executive insert); does not own WHAT or HOW  
Working name: **MAG Model Routing Guard**  
Not: Mechanical Action Gate; not Cursor Auto; not a product identity; not `A1` / new `A<N>` (unless later reclassified)

---

## 1. Purpose

Enforce an **accepted Routing Plan** at Cursor runtime using a deterministic guard:

```text
§24 Routing Plan
→ observe active model
→ evaluate coarse predicates
→ STOP | warn
→ light routing evidence
→ Product Owner switch + `+`
→ continuation
```

Minimize two failure modes:

1. **Wrong active model** vs required routing class / mapping.  
2. **Continuing on an expensive class** after a declared MODEL BOUNDARY (or blocking Runtime Challenge).

## 2. Non-goals (v1)

Do **not** implement in MVP:

- Routing Plan UI / dashboard  
- Automatic model switching  
- LLM-based router / semantic auto-detection / auto-resegmentation  
- Automatic escalation or downgrade  
- Token/$ optimizer or usage dashboards  
- Cloud Agents integration  
- Complex context manager beyond confirmed hook signals (e.g. `preCompact` warn only)  
- Competing policy with §24.4  

## 3. Authority boundary

| Layer | Owner |
| --- | --- |
| Routing policy | `AI_GUIDELINES.md` §24.4 |
| Agent STOP obligations | `AI_AGENTS_RULES.md` (executive) + §24.4 |
| Capability Mapping | subordinate operational mapping under §24.4 |
| This tool | deterministic enforcement only |

If plan/tool/canonical disagree → **canonical wins** → **STOP**. Tool must not invent authority.

**Growth threshold (revisit `A<N>`):** if the tool gains persistent UI, own settings/state store, installer/distribution, independent release cycle, multiple integrations, or service/background runtime — Product Owner reclassifies; until then it stays `MAG-Ecosystem/tools/`.

## 4. Plan location and input format

### 4.1 Accepted plan sources (v1 priority)

1. **Workspace file (preferred for guard):**  
   `C:\laragon\repos\.mag\routing-plan.json`  
   (workspace-root operational state; not MAG authority; not SYNC GLOBAL by default)
2. **Repo-local override (optional later):** `<active-repo>/.mag/routing-plan.json`
3. **Direct Agent Mode:** same schema may be declared in chat; file still preferred when guard is active.

Absence of a plan file: guard is **inert** (no false STOPs) **or** emits a single non-blocking notice that §24.2 expects a routing record — Product Owner chooses at review (default proposal: **inert + optional notice**, not hard STOP).

### 4.2 Minimal JSON schema (v1)

Aligns with §24.2 minimum record; machine-readable.

```json
{
  "routing_plan_version": 1,
  "procedure_id": "string",
  "identity": "GLOBAL | GLOBAL+#N | GLOBAL+A<N>",
  "operating_mode": "Coordinator | DirectAgent",
  "authority": {
    "owner": "AI_GUIDELINES.md",
    "section": "24.4"
  },
  "current_segment": "seg-1",
  "segments": [
    {
      "segment_id": "seg-1",
      "purpose": "string",
      "routing_class": "EXECUTION | LIGHT_REASONING | NORMAL_REASONING | DEEP_REASONING | EXCEPTIONAL_REASONING",
      "required_model_ids": ["optional-concrete-id-or-prefix"],
      "effort_class": "optional",
      "boundary_condition": "none | declared-complete | po-declared",
      "escalation_condition": "none | string",
      "downgrade_condition": "none | string",
      "context_strategy": "INHERIT_CONTEXT | REDUCED_CONTEXT | FRESH_CONTEXT_AT_BOUNDARY"
    }
  ],
  "enforcement": {
    "mismatch_behavior": "STOP",
    "boundary_behavior": "STOP",
    "escalation_behavior": "STOP",
    "downgrade_behavior": "WARN",
    "challenge_behavior": "STOP_IF_EXPENSIVE_OR_WRONG",
    "missing_plan_behavior": "INERT"
  },
  "continue_token": "+",
  "evidence": { "enabled": true }
}
```

`required_model_ids`: optional allowlist for the segment. If empty, guard uses Capability Mapping file (see §5) to resolve class → allowed model id prefixes.

Human §24.2 text record remains mandatory for Coordinator presentation; JSON is the guard input.

## 5. Capability Mapping file (subordinate)

Path (proposed): `MAG-Ecosystem/tools/model-routing-guard/capability-mapping.json`

- Subordinate to §24.4; refreshable without lifecycle Gate.  
- Tool must not invent mappings when unresolved → signal `ROUTING_MAPPING_UNKNOWN` → STOP if enforcement requires a concrete match.  
- Not canonical authority.

## 6. State machine (deterministic)

```text
INERT                    (no plan / missing_plan_behavior=INERT)
  ↓ plan accepted
PLANNED
  ↓ session/prompt with plan
ACTIVE_SEGMENT
  ├─ MODEL_MATCH + no boundary/escalation/challenge  → continue ACTIVE_SEGMENT
  ├─ MODEL_MISMATCH                                  → STOP_SIGNAL → AWAITING_PO
  ├─ MODEL_ESCALATION_REQUIRED                       → STOP_SIGNAL → AWAITING_PO
  ├─ MODEL_BOUNDARY (model change required)          → STOP_SIGNAL → AWAITING_PO
  ├─ RUNTIME_CHALLENGE (blocking)                    → STOP_SIGNAL → AWAITING_PO
  ├─ RUNTIME_CHALLENGE / DOWNGRADE (warn-only)       → WARN → ACTIVE_SEGMENT
  ├─ CONTEXT_WARNING                                 → WARN → ACTIVE_SEGMENT
  ├─ AUTHORITY_CONFLICT / REPLAN_REQUIRED            → FAIL_CLOSED → AWAITING_PO
  └─ final segment complete                          → COMPLETED

AWAITING_PO
  ├─ PO model switch + continue_token (+)            → ACTIVE_SEGMENT (next/current as plan says)
  ├─ replan                                          → PLANNED / REPLAN_REQUIRED
  └─ abort                                           → ABORTED
```

No weighted scoring. No hidden preferences.

## 7. Hook contracts (Cursor)

Implement via Cursor **project/user hooks** deployed from this tool directory (deployment contract analogous to `tools/cursor/`).

| Hook | Guard use |
| --- | --- |
| `beforeSubmitPrompt` | Primary gate: read plan + `model`/`model_id`/`model_params`; return `continue: false` + `user_message` on hard STOP |
| `sessionStart` | Load plan; reset session evidence pointer |
| `subagentStart` | Optional v1.1: warn/deny if subagent model outside segment allowlist |
| `preCompact` | Optional: emit `CONTEXT_WARNING` only |
| `stop` | Optional: record segment idle / await PO |

**Confirmed limitation:** hooks do **not** switch the IDE model picker. Guard never claims to change models. PO switches manually.

## 8. Observable predicates only (v1)

Allowed:

- Active `model_id` / params vs `required_model_ids` or mapping for `routing_class`  
- Plan fields declaring boundary/escalation reached (explicit flags or PO/agent-written plan update)  
- Explicit agent/user message markers agreed in spike (e.g. plan file field `signal: MODEL_BOUNDARY`)  
- Confirmed hook events (`preCompact`)

Forbidden as auto-truth:

- “Semantic analysis finished” without explicit plan/PO/agent signal  
- Invented complexity scores  

## 9. Enforcement defaults

Mirror §24.4 v1 table:

| Signal | Behavior |
| --- | --- |
| AUTHORITY_CONFLICT / REPLAN_REQUIRED | hard STOP |
| MODEL_MISMATCH | hard STOP |
| MODEL_ESCALATION_REQUIRED | hard STOP |
| MODEL_BOUNDARY (model change needed) | STOP until PO switch + `+` |
| RUNTIME_CHALLENGE | STOP if continuing is materially wrong/expensive; else WARN |
| MODEL_DOWNGRADE_RECOMMENDED | WARN |
| CONTEXT_WARNING | WARN |
| missing plan | INERT (default) |

Precedence: AUTHORITY → REPLAN → MISMATCH → ESCALATION → BOUNDARY → CHALLENGE/DOWNGRADE → CONTINUE.

## 10. Evidence schema

Append-only JSONL (proposed):  
`C:\laragon\repos\.mag\routing-evidence.jsonl`

Each event (minimum):

```json
{
  "ts": "RFC3339",
  "procedure_id": "...",
  "identity": "...",
  "segment_id": "...",
  "routing_class": "...",
  "observed_model_id": "...",
  "signal": "MODEL_MISMATCH | ...",
  "action": "STOP | WARN | CONTINUE | PO_CONTINUE | REPLAN | ABORT",
  "note": "optional short"
}
```

**Not** Cursor Models usage measurement. No token/$ fields in v1.

## 11. Fail behavior

- Cannot read plan / corrupt JSON → treat as missing plan (INERT) **or** FAIL_CLOSED if `missing_plan_behavior` later set to STOP (PO choice).  
- Mapping unresolved when match required → STOP (`ROUTING_MAPPING_UNKNOWN`).  
- Hook cannot observe model → UNKNOWN; if match enforcement requires observation → STOP; else WARN once.  
- Never fail open into silent continue when mismatch/escalation/boundary STOP applies.

## 12. Proposed repo layout

```text
MAG-Ecosystem/tools/model-routing-guard/
  README.md                 (operational overview; non-authority)
  MVP_SPEC.md               (this file)
  capability-mapping.json   (subordinate; created at EXECUTION)
  hooks/                    (hook scripts; created at EXECUTION)
  deploy notes in README    (workspace hooks path)
```

Generated/runtime state under `C:\laragon\repos\.mag\` (outside authority docs).

## 13. Acceptance criteria (after EXECUTION spike)

1. With plan requiring EXECUTION model A and picker on incompatible model B → submit blocked + clear message.  
2. With plan signaling MODEL_BOUNDARY → submit blocked until plan acknowledges PO continuation.  
3. Evidence JSONL receives STOP/WARN/PO_CONTINUE events.  
4. No automatic model change occurs.  
5. No usage/$ telemetry emitted.

## 14. Lifecycle note

```text
MVP_SPEC APPROVED
→ EXECUTION spike (hooks + mapping + deploy) — done in-tree
→ real routing evidence from live Cursor sessions
→ decide: remain operational tool vs grow toward A<N>
```

Spike must not reopen architecture covered here.
