# MAG Process Overlay Pool

- MAG-Document-ID: `MAG_PROCESS_OVERLAY_POOL.md`
- MAG-Content-Updated: `2026-09-27T13:25:00+03:00`

This file is the ecosystem-level **MAG Process Overlay Pool**. It is a single registered Global process asset containing multiple internal process records (MPO entries).

It is **not** a seventh canonical Global authority document. Durable normalized HOW remains in the six canonical Global owners defined in [`MAG_ECOSYSTEM.md`](MAG_ECOSYSTEM.md). This Pool holds temporary or ACTIVE process deltas so Product Owner-approved HOW corrections can take effect immediately, be validated in real work, and later be promoted, rejected, or withdrawn.

Individual MPO entries are **not** standalone documents. They do not receive a separate MAG-Document-ID, separate registration, separate Drive identity, or project ownership.

## Index

| ID | Title | Status |
| --- | --- | --- |
| MPO-001 | Two-Level Bootstrap Authority | PROMOTED |
| MPO-002 | Runtime Routing Enforcement | PROMOTED |
| MPO-003 | Documentation-aware execution closure | ACTIVE |

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
- Promotion result: **PROMOTED** on `2026-09-13` by Wave 2 Product Owner-authorized Global normalization. Canonical documents are self-contained. Do not consult this entry for current bootstrap HOW.

---

### MPO-002 — Runtime Routing Enforcement

- Area: Cursor model routing / runtime enforcement
- Status: PROMOTED
- Problem: §24.4 previously lacked a complete Runtime Enforcement State / STOP re-evaluation / maintenance-boundary contract, which allowed Guard code to drift into a weaker second policy table.
- Current canonical behavior: Runtime Routing Enforcement is **self-contained** in `AI_GUIDELINES.md` §24.4 (`#### Runtime Routing Enforcement`). Current HOW must be read from §24.4. This Pool entry has **no overlay effect**.
- Active/proposed behavior: Historical promoted delta only. Do not execute from this record. Do not consult MPO-002 for current routing HOW.
- Scope: historical process/HOW for Runtime Routing Enforcement. No current overlay scope.
- Affected Global owners: `AI_GUIDELINES.md` §24.4 (promoted). `AI_AGENTS_RULES.md` unchanged (existing §24.4 delegation remains sufficient).
- Affected operational assets: `tools/model-routing-guard/*` (contract/docs/loader aligned to canonical §24.4).
- Activation decision: Product Owner approved ACTIVE validation on `2026-09-27`, then approved promotion into §24.4 on `2026-09-27`.
- Validation evidence: Pre-promotion ACTIVE validation retained (offline `Test-GuardRecovery` ALL_RECOVERY_OK; smoke match/mismatch; isolated live A–E; bare `+` unresolved STOP; maintenance preserves pending; missing state→ENFORCED; SUSPENDED≠MATCH). Promotion verification `2026-09-27`: §24.4 subsection added; contract `1.0.1` without ACTIVE-overlay dependency; Guard recovery/smoke re-run PASS after provenance change.
- Known limitations: Cursor may not expose trustworthy concrete model identity in every hook case; UNKNOWN remains explicit under §24.4.
- Promotion readiness: promoted.
- Promotion result: **PROMOTED** on `2026-09-27` into `AI_GUIDELINES.md` §24.4 Runtime Routing Enforcement. Overlay no longer overrides execution. Do not consult this entry for current routing HOW. Canonical documents are self-contained. Not a seventh Global owner.

---

### MPO-003 — Documentation-aware execution closure

- Area: Cursor procedure closure / affected documentation transport / ChatGPT post-execution Drive refresh
- Status: ACTIVE
- Problem: A completed Cursor procedure may modify synchronization-managed documentation but finish without transporting those affected files to Mirror. Separately, ChatGPT may receive the final Cursor report and continue documentation-dependent review from stale conversational/working state rather than re-reading the affected canonical documents from Google Drive. Combined result: repeated “sync Drive” prompts, extra Cursor procedures solely for synchronization, stale cache temporarily outranking current Drive, and unnecessary Drive checks after coding procedures that did not change documentation.
- Current canonical behavior: `MAG_DOCUMENTATION_OPERATIONS.md` §19 CHECK does not mutate canonical Local, Mirror, or baseline content (it writes only its derived, non-authoritative CHECK receipt to `-ReceiptPath`); CHECK-bound RECONCILE is not self-authorizing and does not write `MISSING_TARGET` / `CONFLICT` / `IDENTICAL`. `AI_GUIDELINES.md` §24.3 requires post-execution review but does not yet bind Cursor closure to bounded Local→Mirror publication of **only** files changed in the current procedure, nor bind ChatGPT to an immediate Drive re-read gated on whether documentation actually changed. `AI_AGENTS_RULES.md` requires explicit documentation-transport authorization for Mirror mutation and forbids inferring Drive completion from Mirror.
- Active/proposed behavior:
  1. **One process.** Cursor procedure → determine whether synchronization-managed documentation (inventory-managed documentation/tool assets in current scope) was substantively changed, using **actual changed-file evidence**, not task-name heuristics.
  2. **No documentation change.** Normal Cursor validation/report. Mirror publication `NOT_APPLICABLE`. ChatGPT does **not** inspect Google Drive merely because coding completed. ChatGPT does **not** introduce documentation synchronization as a next step.
  3. **Documentation changed.** Validate only affected documentation. Run procedure-bound **Local→Mirror publication** (`Update-MagDocumentationMirror.ps1 -PublishAffected -InventoryPath <inventory> -Affected <paths>`; `-InventoryPath` is required (no default inventory): the author legacy layout selects `-InventoryPath .\tools\docs\mirror-inventory.json`; independent installations pass their own inventory configured from `tools/docs/mirror-inventory.example.json`) for exactly those inventory-managed files whose Local bytes are the newly validated procedure result and whose pair is safely classifiable as `NEWER_LOCAL` (or already `IDENTICAL`). Verify Local/Mirror equality for successful pairs. Cursor final report states documentation impact and publication result. ChatGPT receives the report and, **before** documentation-dependent substantive review, retrieves the **affected** canonical/project documents **directly from Google Drive** (plus required owners). Mirror is not Drive proxy. Stale `working_*` / conversation cache must not override newly retrieved Drive bodies.
  4. **Drive CURRENT** for that revision → review Drive content; **MUST NOT** propose another synchronization step for the same revision; continue §24.3.
  5. **Drive STALE / not yet updated** → report pending once; name affected files/expected revision where known; **do not** create another Cursor synchronization prompt; **do not** ask Cursor to fetch the same docs; wait for Product Owner/external sync completion signal; then re-read Drive; continue review.
  6. **Drive CONFLICT / unexpected divergence** → report exact conflict; follow normal documentation conflict process.
  7. **Triggers.** SHOULD: substantive edit to a registered/managed Markdown or other explicitly Mirror-managed documentation asset in scope. MUST NOT trigger solely: PHP/JS/CSS/source-only; tests-only; code refactor with no doc edits; git inspection; validation commands; build output; runtime state; generated artifacts.
  8. **Publish-Affected vs RECONCILE.** Ordinary CHECK-bound RECONCILE remains intact for Mirror→Local, uncertain direction, conflicts, externally changed Mirror, and other §19 reconciliation. Publish-Affected is **Local→Mirror only**, **affected-file set only**, procedure-bound. It does **not** silently create missing Mirror targets, adopt unmanaged extras, delete/rename, resolve conflicts, or overwrite a proven independent Mirror-side change (`NEWER_DRIVE` / no-baseline divergence / both-changed = BLOCKED/CONFLICT). Do not invent `NEWER_MIRROR`. Do not use mtime as authority. Local is not an unconditional winner merely because Cursor authored this procedure.
  9. **Write mechanics.** Eligible pairs: Local validated bytes → bounded temp write → replace → SHA-256 verify → Local/Mirror equality → baseline advance only after equality. Idempotent: already equal → `IDENTICAL`, no content write. `drive_sync_claimed` always false; Google Drive status from local tooling is **UNKNOWN**.
  10. **Authorization inheritance.** When Product Owner approved the Cursor procedure, that procedure includes documentation changes in bounded scope, publication is only those exact managed files, direction is proven Local→Mirror, and no conflict/uncertainty exists, a second manual approval solely for the mechanical Local→Mirror copy is not required. This is **not** standing authorization for arbitrary future Mirror writes, unrelated files, Mirror→Local, reconciliation, conflict resolution, deletion/reset, bulk publication, or files that changed unexpectedly outside approved documentation scope.
  11. **Cursor report contract.**
      Documentation:
      - changed: YES | NO
      - affected synchronization-managed files: [...]
      - Mirror publication: NOT_APPLICABLE | IDENTICAL | PUBLISHED | PARTIAL | BLOCKED
      - blocked/conflicting files if any
      - external Google Drive status: UNKNOWN
  12. **Anti-loop invariants.** (A) Docs changed + Drive current → never recommend another sync for that revision. (B) Docs changed + Drive stale → pending once; no extra Cursor prompt solely for Drive sync. (C) PO later says Drive synchronized → ChatGPT immediately re-reads affected Drive documents. (D) Docs did not change → no automatic Drive read. (E) Mirror publication success ≠ Drive completion. (F) Stale ChatGPT conversation/cache must never override newly retrieved canonical Drive state.
- Scope: GLOBAL process/HOW for documentation-aware execution closure only. Does not change product WHAT, routing classes, or Knowledge Control sources.
- Affected Global owners: `AI_GUIDELINES.md` §24.3 (for later promotion); `MAG_DOCUMENTATION_OPERATIONS.md` §19 (for later promotion); `AI_AGENTS_RULES.md` (minimal execution-boundary wording while ACTIVE).
- Affected operational assets: `tools/docs/Update-MagDocumentationMirror.ps1`; `tools/docs/lib/MagDocumentationMirror.Common.ps1`; Mirror tests.
- Activation decision: Product Owner approved ACTIVE implementation on `2026-09-27` (create MPO-003; bounded Publish-Affected; Cursor report contract; ChatGPT post-report Drive refresh). Does **not** authorize promotion into §24.3/§19, Git publication, or direct Google Drive writes.
- Validation evidence: Isolated `MagDocumentationMirror.Tests.ps1` extended for Publish-Affected A–K plus existing CHECK/RECONCILE/path/baseline matrix (recorded in this procedure). Live production Mirror not required to activate the overlay.
- Known limitations: External Google Drive client completion remains unproven by Local↔Mirror equality. First-time missing Mirror targets remain BLOCKED (create via existing authorized populate/RECONCILE paths, not Publish-Affected). ChatGPT Drive connector availability is an executor capability, not created by this overlay.
- Promotion readiness: **not promoted**. ACTIVE for real-work validation.
- Promotion result: not promoted. Remains ACTIVE overlay. Not a seventh Global owner. Do not treat this entry as durable HOW after a future promotion; canonical owners must become self-contained then.
