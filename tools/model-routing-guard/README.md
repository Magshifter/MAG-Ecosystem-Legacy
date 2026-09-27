# MAG Model Routing Guard

Operational tooling. **Not** MAG authority. Deterministic hook arm for `AI_GUIDELINES.md` §24.4 **Runtime Routing Enforcement**.

## Authority

| Layer | Owner |
| --- | --- |
| Durable HOW | `AI_GUIDELINES.md` §24.4 |
| Agents | `AI_AGENTS_RULES.md` — obligations remain in **all** tool states |
| Contract | `enforcement-contract.v1.json` — subordinate only |
| Capability Mapping | `capability-mapping.json` — subordinate only |
| This tool | no authority |
| MPO-002 | historical provenance only |

## Capability Mapping / recommendations

- **Preferred** → one concrete model in STOP/WARN proposal text (from current mapping).
- **Compatible alternatives** → `model_id_prefixes` hard MATCH set.
- **Second-opinion** → metadata only; never auto-selected.
- Target routing class comes from the accepted plan/decision (`recommended_routing_class` / next Segment). Guard does **not** invent escalation/downgrade classes.
- Effort/speed are recommendation metadata in v1 (not hard MATCH).

## Enforcement states

| State | Hooks | Commands |
| --- | --- | --- |
| **ENFORCED** | hard STOP/WARN | `Guard Enforced` (alias `Guard Pro`) |
| **ADVISORY** | report, no normal hard block | `Guard Advisory` (alias `Guard Auto`) |
| **SUSPENDED** | inert | `Guard Suspended` (alias `Guard Off`) |

```powershell
.\Set-MagGuardMode.ps1 -Mode Enforced -ProductOwnerApproved
.\Set-MagGuardMode.ps1 -Mode Advisory -ProductOwnerApproved
.\Set-MagGuardMode.ps1 -Mode Suspended -ProductOwnerApproved
```

Defaults: no plan → INERT; accepted plan + missing state file → **ENFORCED**. No 24h expiry.

## `+` semantics

Continuation **request**. Guard re-evaluates the pending STOP prerequisite. Unresolved → STOP remains. Never a mismatch/authority waiver.

Pending state: `.mag/routing-pending.json`.

## Maintenance

```powershell
.\Set-MagGuardMaintenance.ps1 -Action Suspend -ProductOwnerApproved
.\Set-MagGuardMaintenance.ps1 -Action Resume -ProductOwnerApproved
```

Separate from enforcement state. Preserves plan + pending. Does **not** certify `MODEL_MATCH`.

## Deploy / tests

```text
pwsh -NoProfile -File ".\Deploy-MagModelRoutingGuard.ps1"
pwsh -NoProfile -File ".\Test-GuardRecovery.ps1" -GuardRoot <this directory>
```

## Non-goals

No auto model switch, Auto router, LLM routing, weighted scoring, token/$ telemetry.
