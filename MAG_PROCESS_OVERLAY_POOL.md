# MAG Process Overlay Pool

- MAG-Document-ID: `MAG_PROCESS_OVERLAY_POOL.md`
- MAG-Content-Updated: `2026-09-13T10:08:03+00:00`

This file is the ecosystem-level **MAG Process Overlay Pool**. It is a single registered Global process asset containing multiple internal process records (MPO entries).

It is **not** an eighth canonical Global authority document. Durable normalized HOW remains in the seven canonical Global owners defined in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). This Pool holds temporary or ACTIVE process deltas so Product Owner-approved HOW corrections can take effect immediately, be validated in real work, and later be promoted, rejected, or withdrawn.

Individual MPO entries are **not** standalone documents. They do not receive a separate MAG-Document-ID, separate registration, separate Drive identity, or project ownership.

## Index

| ID | Title | Status |
| --- | --- | --- |
| MPO-001 | Two-Level Bootstrap Authority | ACTIVE |

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
- Status: ACTIVE
- Problem: Bootstrap treated Local/Git unavailability as an exceptional path, which forced extra exception wording and blocked clear, immediate Documentation Bootstrap while Local/Git was pending.
- Current canonical behavior: Lifecycle and related owners describe Full, Drive-First, and Resume Bootstrap as normal Phase 1 modes. Drive-First is a normal pause with Local/Git pending. Two-level Documentation/Repository Bootstrap Authority remains an ACTIVE overlay here and is not yet durable canonical Lifecycle policy.
- Active/proposed behavior: Phase 1 Bootstrap has two cumulative operational authority levels.

  **Level 1 — Documentation Bootstrap Authority**

  Activated after Gate 0 and Product Owner authorization of Project Bootstrap.

  Authorizes:

  - approved project identity use;
  - Blueprint package instantiation;
  - canonical Drive project package;
  - provisional documentation state;
  - metadata establishment and package verification;
  - continued Requirements / Research / Architecture documentation work under their normal substantive gates.

  Does not authorize:

  - stable registration;
  - Local/Git claims;
  - product implementation;
  - commit/push/tag/release.

  **Level 2 — Repository Bootstrap Authority**

  Activated when Local/Git is available and Product Owner authorizes Full Bootstrap or Resume Bootstrap.

  Authorizes:

  - Local repository establishment/reconciliation;
  - canonical `/docs/`;
  - current Drive package reconciliation;
  - authorized native skeleton where applicable;
  - local/package validation;
  - preparation of the Git baseline;
  - stable registration after separately authorized Git baseline and successful verification.

  Does not authorize product implementation.

  **Mode mapping**

  - Full Bootstrap: Level 1 → Level 2 without interruption.
  - Drive-First: Level 1 → pause with Local/Git pending. This is a normal bootstrap state, not an exception.
  - Resume Bootstrap: existing Level 1 state → Level 2.

- Scope: process/HOW for `#N` Phase 1 bootstrap authority and the Drive-First / Resume / Full mode relationship. Does not change product WHAT, implementation authorization, commit/push/tag/release, or stable-registration prerequisites beyond restating that they remain separately authorized.
- Affected Global owners: `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` (Phase 1); `MAG_ECOSYSTEM.md` (bootstrap narrative); `AI_GUIDELINES.md` §20 Local/Git closure; `AI_AGENTS_RULES.md` Git-closure wording; `MAG_DOCUMENTATION_OPERATIONS.md` §5 Drive-First/Resume.
- Affected operational assets: `MAG_XENFORO_ADDON_BLUEPRINT.md`; `templates/xenforo-addon/*` only where they record Drive-First / Local/Git pending state.
- Activation decision: Product Owner approved this bootstrap optimization as ACTIVE on `2026-09-13` as the first MAG Process Overlay Pool entry.
- Validation evidence: approved for real-world validation across one or more `#N` bootstrap/workflows. Historical Pipeline v2 experiment/evaluation documents are separate historical evidence and are not this entry.
- Known limitations: two-level authority is not yet promoted into canonical Lifecycle wording; those owners acknowledge ACTIVE overlay precedence instead of duplicating Level 1/Level 2 as permanent rules. Surrounding exception semantics for Drive-First were removed in the post-Pool consistency pass; this entry remains the temporary owner of the Level 1/Level 2 delta.
- Promotion readiness: not ready. Remains ACTIVE until validated in real bootstrap work and then explicitly promoted.
- Promotion result: not promoted.
