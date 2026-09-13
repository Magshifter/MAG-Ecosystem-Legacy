# MAG Process Overlay Pool

- MAG-Document-ID: `MAG_PROCESS_OVERLAY_POOL.md`
- MAG-Content-Updated: `2026-09-13T14:15:00+00:00`

This file is the ecosystem-level **MAG Process Overlay Pool**. It is a single registered Global process asset containing multiple internal process records (MPO entries).

It is **not** an eighth canonical Global authority document. Durable normalized HOW remains in the seven canonical Global owners defined in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). This Pool holds temporary or ACTIVE process deltas so Product Owner-approved HOW corrections can take effect immediately, be validated in real work, and later be promoted, rejected, or withdrawn.

Individual MPO entries are **not** standalone documents. They do not receive a separate MAG-Document-ID, separate registration, separate Drive identity, or project ownership.

## Index

| ID | Title | Status |
| --- | --- | --- |
| MPO-001 | Two-Level Bootstrap Authority | PROMOTED |

## Scope and ownership

- Ecosystem-level only. Not project-scoped.
- Process/HOW only. Does not redefine product WHAT, approved project requirements, architecture decisions, implementation scope, or release content.
- One Product Owner activation decision is enough to move a prepared DRAFT entry to ACTIVE.
- Do not create a separate experiment file, Drive file, or registration per MPO.
- A project may supply evidence for an entry. The process concept remains here.

## Lifecycle

```text
DRAFT → ACTIVE → VALIDATED → PROMOTED
DRAFT → ACTIVE → REJECTED
DRAFT → ACTIVE → WITHDRAWN
```

- **DRAFT** — proposed delta; no execution effect.
- **ACTIVE** — Product Owner-approved; immediately participates in process execution by precedence.
- **VALIDATED** — tested in real work enough for canonical integration; no longer an overlay unless Status is still ACTIVE.
- **PROMOTED** — integrated into owning Global documents and operational assets; historical trace only; no overlay effect.
- **REJECTED / WITHDRAWN** — no execution effect.

Only **Status: ACTIVE** overlays current HOW. DRAFT, VALIDATED, PROMOTED, REJECTED, and WITHDRAWN records do not override canonical Global wording.

## Process/HOW precedence

Owned by `MAG_ECOSYSTEM.md`. Summary:

1. explicit current Product Owner decision;
2. ACTIVE Pool entry, inside its explicit scope;
3. canonical Global owning document;
4. Global operational asset (Blueprint/templates);
5. active-development process representation.

If an ACTIVE overlay affects a controlled authority boundary (Git, release, security, registration, or lifecycle authorization), that effect must be stated in the entry. Silent expansion of scope is forbidden.

If two ACTIVE overlays conflict, stop and require Product Owner resolution. If a newer explicit Product Owner decision makes an overlay impossible, record supersession or withdrawal; do not ignore it silently.

## Commands

Operational command text lives in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §26:

- `PROCESS CHANGE`
- `PROCESS POOL STATUS`
- `PROMOTE PROCESS POOL`
- `PROMOTE MPO-XXX`

Promotion is a Global documentation normalization procedure. After promotion, canonical Global documents must be self-contained. Do not leave permanent “see MPO-XXX for current rule” dependencies in normalized Global wording.

## Entry schema

### MPO-XXX — \<short title\>

- Area:
- Status:
- Problem:
- Current canonical behavior:
- Active/proposed behavior:
- Scope:
- Affected Global owners:
- Affected operational assets:
- Activation decision:
- Validation evidence:
- Known limitations:
- Promotion readiness:
- Promotion result:

---

### MPO-001 — Two-Level Bootstrap Authority

- Area: `#N` Phase 1 Project Bootstrap / documentation and repository authority
- Status: PROMOTED
- Problem: Bootstrap treated Local/Git unavailability as an exceptional path, which forced extra exception wording and blocked clear, immediate Documentation Bootstrap while Local/Git was pending.
- Current canonical behavior: Durable HOW is self-contained in canonical owners. Lifecycle Phase 1 owns two-level bootstrap authority, Phase 1 completion, and Local/Git vs Drive states. Documentation Operations §5 owns Drive-First, Local/Git-First, Full, and Resume as operational availability paths. This entry has no overlay effect.
- Active/proposed behavior: Historical delta only. The promoted Level 1 / Level 2 model and Drive-independent Phase 1 completion live in `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 1. Do not execute from this record.
- Scope: historical process/HOW for `#N` Phase 1 bootstrap authority. No current overlay scope.
- Affected Global owners: `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` (Phase 1); `MAG_ECOSYSTEM.md` (bootstrap narrative); `AI_GUIDELINES.md` §20 Local/Git closure; `AI_AGENTS_RULES.md` Git-closure wording; `MAG_DOCUMENTATION_OPERATIONS.md` §5 surface availability.
- Affected operational assets: `MAG_XENFORO_ADDON_BLUEPRINT.md`; `templates/xenforo-addon/*` only where they record Drive-First / Local/Git pending / Drive Reconciliation Pending state.
- Activation decision: Product Owner approved this bootstrap optimization as ACTIVE on `2026-09-13` as the first MAG Process Overlay Pool entry. Wave 1 Product Owner decision on `2026-09-13` amended Drive independence from Phase 1 completion without promoting this entry.
- Validation evidence: Wave 1 canonicalized Local/Git vs Drive states. `#4` Resume Bootstrap reached Local/Git Bootstrap Complete with Drive Reconciliation Pending. Wave 2 Product Owner procedure promoted the remaining Level 1 / Level 2 payload into Lifecycle Phase 1.
- Known limitations: none for current operation. Historical ACTIVE overlay wording was removed at promotion; this record is not executable.
- Promotion readiness: promoted.
- Promotion result: **PROMOTED** on `2026-09-13` by Wave 2 Product Owner-authorized Global normalization. Canonical documents are self-contained. Do not consult this entry for current bootstrap HOW. No MPO-002 created.
