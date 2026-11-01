# MAG Model Routing Guard

Operational tooling. **Not** MAG authority. Deterministic hook arm for `AI_GUIDELINES.md` §24.4 **Runtime Routing Enforcement**.

## Workspace root

All Guard scripts act on one Cursor workspace folder `<ReposRoot>` (state under `<ReposRoot>\.mag\`, hooks under `<ReposRoot>\.cursor\`):

- `-ReposRoot "<absolute path>"` wins when given; otherwise `MAG_REPOS_ROOT`;
- neither set, a relative path, a drive root, or a missing directory → the script stops before any write. No current-directory fallback and no built-in default (the author's `C:\laragon\repos` works only when passed or configured explicitly). Paths with spaces are supported.

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
.\Set-MagGuardMode.ps1 -ReposRoot "<ReposRoot>" -Mode Enforced -ProductOwnerApproved
.\Set-MagGuardMode.ps1 -ReposRoot "<ReposRoot>" -Mode Advisory -ProductOwnerApproved
.\Set-MagGuardMode.ps1 -ReposRoot "<ReposRoot>" -Mode Suspended -ProductOwnerApproved
```

Defaults: no plan → INERT; accepted plan + missing state file → **ENFORCED**. No 24h expiry.

## `+` semantics

Continuation **request**. Guard re-evaluates the pending STOP prerequisite. Unresolved → STOP remains. Never a mismatch/authority waiver.

Pending state: `.mag/routing-pending.json`.

## Maintenance

```powershell
.\Set-MagGuardMaintenance.ps1 -ReposRoot "<ReposRoot>" -Action Suspend -ProductOwnerApproved
.\Set-MagGuardMaintenance.ps1 -ReposRoot "<ReposRoot>" -Action Resume -ProductOwnerApproved
```

Separate from enforcement state. Preserves plan + pending. Does **not** certify `MODEL_MATCH`.

## Deploy / tests

```text
pwsh -NoProfile -File ".\Deploy-MagModelRoutingGuard.ps1" -ReposRoot "<ReposRoot>" -WhatIf
pwsh -NoProfile -File ".\Deploy-MagModelRoutingGuard.ps1" -ReposRoot "<ReposRoot>"
pwsh -NoProfile -File ".\Test-GuardRecovery.ps1" -GuardRoot <this directory>
pwsh -NoProfile -File ".\Test-MagGuardPortability.ps1"
```

Deploy copies the lib, hooks, mapping and contract into `<ReposRoot>\.cursor\hooks\model-routing-guard\` and merges `<ReposRoot>\.cursor\hooks.json`:

- Guard-owned scope only: in `sessionStart`, `beforeSubmitPrompt`, `preCompact`, entries whose command contains `model-routing-guard` are replaced by exactly one Guard entry; all other hooks, events, and top-level settings are kept.
- Each Guard command is `pwsh -NoProfile -File "<ReposRoot>\.cursor\hooks\model-routing-guard\hooks\<hook>.ps1" -ReposRoot "<ReposRoot>"`, so hooks resolve the same root regardless of the CWD Cursor launches them from.
- Invalid JSON, a non-object `hooks`, a non-directory target, or a root containing `"`, `%`, `$`, or a backtick is rejected before any file is copied or written. `-WhatIf` validates and computes the merge without writing.

`Test-MagGuardPortability.ps1` uses isolated TEMP fixtures only (root with spaces, decoy `MAG_REPOS_ROOT`, unrelated CWD) → `ALL_PORTABILITY_OK`.

## Non-goals

No auto model switch, Auto router, LLM routing, weighted scoring, token/$ telemetry.
