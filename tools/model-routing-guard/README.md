# MAG Model Routing Guard

Operational tooling. **Not** MAG canonical authority. **Not** a seventh Global owner. **Not** a Software Product identity (`A<N>`) unless Product Owner later reclassifies.

## Authority

- Canonical routing HOW: `AI_GUIDELINES.md` §24.4 (presentation minimum: §24.2).
- Agent STOP obligations: `AI_AGENTS_RULES.md` (executive insert only).
- This directory implements enforcement of an **accepted Routing Plan**. It does not define Product WHAT or competing HOW.

## Working name

**MAG Model Routing Guard** — deterministic plan guard / predicate checker. Not Mechanical Action Gate. Not Cursor Auto.

## Status

MVP **APPROVED** by Product Owner. EXECUTION spike implemented under [`MVP_SPEC.md`](MVP_SPEC.md).

## Classification

Global operational tool under `MAG-Ecosystem/tools/`. Remains here while limited to hooks + small state machine + routing evidence. Persistent UI / own settings service / independent release / multi-integration runtime → Product Owner reconsiders `A<N>`.

## Files

| Path | Role |
| --- | --- |
| `MVP_SPEC.md` | Approved MVP specification |
| `lib/MagRoutingGuard.Common.ps1` | Deterministic decision logic |
| `hooks/*.ps1` | Cursor hook entrypoints |
| `capability-mapping.json` | Subordinate class → model_id prefixes |
| `hooks.json.template` | Hook registration template |
| `examples/routing-plan.example.json` | Sample plan |
| `Deploy-MagModelRoutingGuard.ps1` | Deploy source → `C:\laragon\repos\.cursor\` |
| `Test-MagModelRoutingGuard.ps1` | Offline smoke scenarios |

## Deploy (workspace root = `C:\laragon\repos`)

```text
pwsh -NoProfile -File "C:\laragon\repos\MAG-Ecosystem\tools\model-routing-guard\Deploy-MagModelRoutingGuard.ps1"
```

Then restart Cursor or reload hooks (hooks.json is watched on save).

Place an accepted plan at:

`C:\laragon\repos\.mag\routing-plan.json`

(copy from `examples/routing-plan.example.json` and edit).

Evidence appends to:

`C:\laragon\repos\.mag\routing-evidence.jsonl`

### After MODEL_BOUNDARY / escalation / challenge STOP

1. Switch the Cursor model manually (guard cannot).  
2. Update the plan: clear `signal` / `runtime.blocking_signal`, set `runtime.po_continue_ack` to `true`, advance `current_segment` if needed.  
3. Send `+` / next prompt — guard allows once and clears the ack.

## Smoke test (no Cursor)

```text
pwsh -NoProfile -File ".\Test-MagModelRoutingGuard.ps1" -Scenario mismatch
pwsh -NoProfile -File ".\Test-MagModelRoutingGuard.ps1" -Scenario match
pwsh -NoProfile -File ".\Test-MagModelRoutingGuard.ps1" -Scenario boundary
pwsh -NoProfile -File ".\Test-MagModelRoutingGuard.ps1" -Scenario inert
```

## Explicit maintenance recovery

If the Guard prevents repair, the Product Owner may suspend the runtime plan from an external PowerShell terminal:

```powershell
.\Set-MagGuardMaintenance.ps1 -Action Suspend -ProductOwnerApproved
```

This preserves the plan as `.mag/routing-plan.maintenance.json`; no active plan means INERT. This is an explicit repair action, never an automatic response to mismatch, boundary, or escalation. It authorizes no model or production work. Restore normal enforcement after repair:

```powershell
.\Set-MagGuardMaintenance.ps1 -Action Resume -ProductOwnerApproved
```

Resume refuses to overwrite another active plan. The emergency recovery on 2026-09-27 preserved the earlier example plan separately as `.mag/routing-plan.recovery-20260927.json`; it is not automatically reactivated. Only place a Product Owner-accepted plan at the active path. An explicit `accepted: false` draft or an invalid plan is inert; existing valid file placement remains the v1 acceptance mechanism.

## Model observation and temporary diagnostics

The Guard uses concrete trimmed `model_id`, falling back to concrete `model`. Empty, default, auto, unknown, null, none, and undefined values are not identities. Unknown observation under an active plan remains fail-closed (`MODEL_OBSERVATION_UNKNOWN`), regardless of missing-model warning settings. No model is inferred from model_params.

For a narrowly scoped live debugging pass, create `.mag/routing-observation-debug.enabled`. The next submit writes only model/model_id, hook event, Cursor version (if supplied), model_params presence, observation source, signal and action to `.mag/routing-observation-debug.jsonl`. No prompt body, model_params values, token/cost usage, or session data is stored. Remove the marker after collecting the required observation; logging is disabled by default.

Run `Test-GuardRecovery.ps1 -GuardRoot <this directory>` for recovery/model/STOP/privacy checks. All smoke and recovery tests use isolated temporary workspace roots and must never install an example plan in the live workspace.
