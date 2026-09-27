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

### After STOP (mismatch / boundary / escalation / unobserved)

1. Guard shows a **proposal** (class + suggested models). It does **not** change the Cursor model.  
2. Product Owner switches model only if they agree.  
3. Send exact `+` (plan `continue_token`). Guard accepts **this gate** and continues — including “wrong” or unobserved models for a model-gate stop.  
4. Guard **stays active** for the rest of the prompt session. Later subtasks may STOP+propose again (boundary / escalation / challenge / new segment).  
5. After `+` on mismatch/unobserved, Guard does not re-nag the same model-identity gate for the current segment.

`+` must never itself be blocked. `+` does not cancel Guard until the end of the session.

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

## Operating mode (Pro / Auto / Off)

When the Product Owner cannot switch models (Cursor **Auto** only / exhausted Pro quota), STOP+propose would only create cyclic friction. Use an explicit mode:

| Mode | Behavior | Duration |
| --- | --- | --- |
| **Pro** | STOP+propose armed | permanent until explicit change |
| **Auto** | no STOP proposals | **24h**, then must re-ask mode before continuing |
| **Off** | forced off, no proposals | until explicit change |

Missing mode file = soft **Auto** (no proposals; prefer asking once at session start).  
When Auto **expires**, Guard **STOPs** until Product Owner answers: `Guard Pro` / `Guard Auto` / `Guard Off`. Agents must ask this **first** before substantive work.
```powershell
.\Set-MagGuardMode.ps1 -Mode Auto -DurationHours 168 -ProductOwnerApproved
.\Set-MagGuardMode.ps1 -Mode Pro -DurationHours 24 -ProductOwnerApproved
.\Set-MagGuardMode.ps1 -Mode Off -ProductOwnerApproved
```

Or send an exact chat command (hook switches mode, never blocks):

- `Guard Pro` / `Активуємо план Pro`
- `Guard Auto`
- `Guard Off` / `Вимкни Guard`

State file: `.mag/routing-guard-mode.json` (not Mirror authority).

## Model observation and temporary diagnostics

The Guard uses concrete trimmed `model_id`, falling back to concrete `model`. Empty, default, auto, unknown, null, none, and undefined values are not identities. Unknown observation under an active plan causes a one-time STOP + proposal; Product Owner `+` unlocks and accepts the segment without requiring observation. No model is inferred from model_params.

For a narrowly scoped live debugging pass, create `.mag/routing-observation-debug.enabled`. The next submit writes only model/model_id, hook event, Cursor version (if supplied), model_params presence, observation source, signal and action to `.mag/routing-observation-debug.jsonl`. No prompt body, model_params values, token/cost usage, or session data is stored. Remove the marker after collecting the required observation; logging is disabled by default.

Run `Test-GuardRecovery.ps1 -GuardRoot <this directory>` for recovery/model/STOP/privacy checks. All smoke and recovery tests use isolated temporary workspace roots and must never install an example plan in the live workspace.
