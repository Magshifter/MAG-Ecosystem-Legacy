# MAG Documentation Operations

- MAG-Document-ID: `MAG_DOCUMENTATION_OPERATIONS.md`
- MAG-Content-Updated: `2026-09-12T10:56:10+03:00`

## 1. Purpose and authority

This document is the Global MAG authority for documentation synchronization across managed Local Git repositories, Google Drive, ChatGPT, and Cursor.

It governs documentation identity validation, synchronization scope and commands, comparison, conflict handling, approval, execution, verification, cleanup, reporting, and Git handoff boundaries. It does not redefine substantive document authority, the MAG development lifecycle, general agent permissions, or Git development policy.

Broader material-change and evidence-invalidation principles for development validation live in [`AI_GUIDELINES.md`](AI_GUIDELINES.md) §18. This document remains canonical for documentation-sync evidence reuse, Fast Sync, and invalidation of sync-specific proven state.

The canonical writable workflow is:

```text
Resolve
→ Compare
→ Plan
→ Product Owner approval
→ Execute
→ Verify
→ Cleanup
→ Report
```

A writable `SYNC` command starts this workflow. It does **not** itself authorize writes.

## 2. Scope and supported systems

This protocol applies to synchronization-managed MAG Markdown documents in:

- managed Local Git repositories;
- Google Drive;
- ChatGPT documentation context;
- Cursor documentation context.

An operation may use only systems and locations resolved within its approved scope. Active development context follows `GLOBAL + active development identity` per `MAG_ECOSYSTEM.md`; synchronizing one registered development must not import another development's documentation.

## 3. Managed locations and canonical identity

Resolve every document by:

1. its `MAG-Document-ID`;
2. its exact canonical filename;
3. its expected authority and managed location;
4. its permanent development identity when development-scoped.

Do not guess when identity or location is ambiguous. Preserve canonical filename, Markdown type, intended location, and existing object identity where the approved operation requires them.

Canonical Markdown remains Markdown. Do not create duplicate canonical files, renamed-copy layers, or project-local copies of Global documents.

## 4. Metadata requirements and validation

Every synchronization-managed Markdown document has exactly one H1 and exactly one visible metadata block immediately below it:

The block contains exactly two bullets: `MAG-Document-ID`, followed by `MAG-Content-Updated`.

`MAG-Document-ID` must exactly match the canonical filename. `MAG-Content-Updated` must be a valid RFC 3339 timestamp with seconds and an explicit UTC offset.

`MAG-Content-Updated` records the latest established substantive revision. Update it for substantive content changes. Do not update it merely because of synchronization, copying, upload/download, transport conversion, safe formatting normalization, filesystem timestamps, or Drive timestamps.

Metadata supports identity, comparison, and conflict detection. It does not create or override substantive authority.

Missing, duplicate, malformed, mismatched, or unresolved required metadata is `INVALID_METADATA`. Stop synchronization for that document and report the exact problem. Do not invent historical timestamps; use Product Owner baseline ratification when historical evidence cannot establish the current baseline.

## 5. Document onboarding and registration

SYNC operates only on registered logical documents. The existence of a Markdown file alone does not establish registration or place it in SYNC scope.

Document registration is a distinct authority action. Registration, adoption, canonical rename, and retirement require Product Owner approval. Do not create speculative documents merely to complete a nominal documentation set.

### Registration types and experimental documents

Registration distinguishes **Stable registered document** and **Experimental registered document**. This distinction concerns document role, not a new SYNC classification. Experimental registration can have a stable approved Git baseline while its substantive findings remain experimental.

An Experimental registered document belongs to an explicit development identity (for example `#N`) and records working evidence, hypotheses, temporary procedures, or evaluation. Product Owner approval must establish its non-authoritative experimental role, canonical identity/location, development scope, and any bounded pilot exception. Registration grants synchronization eligibility only, never substantive authority. Use the existing two-bullet metadata block; do not add registration fields to it or create another registry file.

Experimental documents use the same identity, metadata, comparison, conflict, verification, and Git rules as other registered documents. Missing required metadata remains `INVALID_METADATA` for a registered document; unregistered files remain `UNREGISTERED_DOCUMENT` and excluded from writable SYNC. Neither case becomes `NEWER_LOCAL` merely because Local content changed.

Existing experimental artifacts may be adopted without assigning Global authority. In the procedures below, establishing substantive authority includes explicitly recording a non-authoritative experimental role. Approved naming/location exceptions and existing counterpart IDs are recorded in the `MAG_ECOSYSTEM.md` documentation map; physical storage does not change project scope. Ordinary discovery requires the approved Git baseline. A controlled, explicitly approved adoption may update its identified existing counterparts before the final Git handoff; this does not enable unrelated or default SYNC discovery.

Promotion is a separate substantive decision under `MAG_ECOSYSTEM.md`: evaluate evidence and limitations, select individual findings, propose changes to owning Global documents, obtain Product Owner approval, then update and verify those documents. Synchronization, registration, PASS/PARTIAL PASS, and Git finalization cannot promote an experiment.

### New document

Use this lifecycle only when the logical document does not yet exist:

```text
Approve need
→ Assign substantive authority
→ Select canonical filename
→ Select canonical Local repository/location
→ Check identity uniqueness
→ Author substantive body
→ Establish initial substantive timestamp
→ Add metadata
→ Validate
→ Register provisionally inside the controlled procedure
→ Product Owner review/approval as applicable
→ Git handoff
→ Stable registration discovery
→ SYNC CHECK
→ Missing counterpart creation through approved SYNC
→ Verify
```

The initial `MAG-Content-Updated` is the timestamp when the current substantive body is established or accepted, not when an empty file is created.

### Existing document adoption

Use adoption when a pre-existing document with an approved authoritative or non-authoritative experimental role is brought under synchronization management:

1. confirm its logical identity and substantive authority;
2. establish its canonical filename and Local location;
3. check identity collisions and existing counterparts;
4. reconstruct the latest current-body substantive timestamp from reliable Git evidence where possible, excluding later formatting-only changes;
5. otherwise obtain Product Owner baseline ratification;
6. never infer historical revision time from filesystem or Drive modified time;
7. add metadata without making the historical body appear newer merely because metadata was introduced;
8. validate body preservation;
9. provisionally adopt it only inside the controlled procedure;
10. complete the separate Git handoff for stable discovery;
11. use SYNC afterward for counterparts.

Do not treat adoption as new authorship. A concurrent substantive body edit requires a new substantive timestamp.

### New counterpart

Counterpart creation is not registration. For an already registered logical document:

```text
SYNC CHECK
→ MISSING_TARGET
→ Plan
→ Product Owner approval
→ Safe transport proof
→ Create
→ Re-read/verify
→ Report
```

Preserve the existing `MAG-Document-ID` and `MAG-Content-Updated` exactly. Copy or transport time is not substantive revision time.

### Registration authority and discovery

Do not create a separate documentation registry file.

Global registration is represented by the `MAG_ECOSYSTEM.md` Global documentation map, valid metadata, and the applicable Local authoritative state.

Stable project registration requires the approved development identity, canonical Local repository, applicable development documentation model and authority, valid metadata, and approved Git baseline. Nonstandard development documents require an explicit Product Owner-approved authoritative or non-authoritative experimental role; metadata cannot grant authority by itself.

### Provisional registration

Provisional registration exists only inside an explicit controlled Product Owner-approved registration or adoption procedure. It permits validation and review before Git handoff, but it is not default discovery state.

Ordinary `SYNC #N`, `SYNC A<N>`, or `SYNC B<N>` must not automatically include a provisional document. Unrelated procedures must not treat it as stable registration. The separately approved Git handoff establishes normal discoverability. No additional metadata field represents provisional state.

### Unregistered and orphan documents

`UNREGISTERED_DOCUMENT` is an audit and registration anomaly, not a ninth synchronization classification.

Exclude an unregistered file from writable SYNC. Do not silently adopt, overwrite, copy, rename, or delete it. Report its location, filename, metadata presence, possible authority, and identity-collision evidence, then recommend `DOC CHECK <filename>`.

A file claiming an existing `MAG-Document-ID` must additionally be reported as a duplicate-identity candidate.

### Canonical rename and retirement

A canonical rename requires Product Owner approval and changes `MAG-Document-ID` because the ID equals the canonical filename. A pure rename does not change `MAG-Content-Updated`; a concurrent substantive body change does.

Update the applicable registration map or set and managed counterparts through one controlled migration. Do not leave old and new identities simultaneously active. Preserve historical names in Git or migration history rather than active pointer files.

Document retirement requires Product Owner approval and removes the document from active registration and SYNC scope. It does not authorize deletion. Historical records remain historical, and counterpart retention or deletion requires separate authority.

Project retirement remains under `MAG_ECOSYSTEM.md` and lifecycle authority. Its permanent development identity is never reused, its documentation is not automatically deleted or rewritten, and the Product Owner determines archived/read-only or limited synchronization treatment.

### Project onboarding boundary

Documentation Operations consumes an already approved development identity. It does not approve developments, assign identities, or provide a development-creation command.

A newly approved development identity establishes that identity only. Select its documents from actual current information needs. Never automatically clone #1, #2, or a complete documentation template. Development approval and bootstrap sequencing remain governed by `MAG_ECOSYSTEM.md` and, for `#N` XenForo add-ons, `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`.

## 6. Scope resolution

Before comparison:

1. parse the requested command and any explicit natural-language narrowing;
2. establish the active Global or permanent development-identity context;
3. enumerate only stable registered canonical documents in that scope;
4. resolve each managed counterpart;
5. report ambiguity, missing sources, missing targets, unregistered/orphan files, and duplicate candidates.

Natural-language narrowing may restrict repository, project, location, direction, or exact files. It must not silently broaden scope.

A bare `SYNC` may use clearly established active context. If the context is missing or ambiguous, stop for clarification.

An explicit active controlled registration or adoption procedure may validate its own provisional document. Ordinary SYNC discovery and unrelated procedures must exclude provisional and unregistered documents.

If explicitly asked to SYNC an unregistered document:

```text
STOP → registration required
```

Recommend `DOC CHECK`, `DOC REGISTER`, or `DOC ADOPT` as appropriate. SYNC must never silently register an unknown document.

## 7. Documentation and SYNC command grammar

### `DOC CHECK <filename>`

Perform a read-only registration or adoption readiness check. Report:

- existing registration status;
- authority and naming validity;
- identity collisions;
- substantive timestamp evidence;
- canonical location;
- blockers.

Never write or register.

### `DOC REGISTER <filename>`

Use only for a genuinely new logical document. Resolve authority, identity, canonical location, uniqueness, metadata and timestamp requirements, and registration readiness. Produce a plan and stop for Product Owner approval.

The command itself does not authorize creation or registration.

### `DOC ADOPT <filename>`

Use only for a pre-existing document. Validate identity, approved authority or non-authoritative experimental role, canonical location, collisions, and historical timestamp evidence, or require Product Owner baseline ratification. Produce a plan and stop for approval. Do not treat adoption as new authorship.

### `SYNC CHECK [scope]`

Read-only:

```text
Resolve
→ Validate
→ Compare
→ Classify
→ Report
→ Stop
```

It never requests or executes writes.

### `SYNC`

Resolve the clearly established active context, compare it, and produce a synchronization plan. Stop for Product Owner approval before writing.

### `SYNC GLOBAL`

Cover all synchronization-managed Global documents, including `MAG_DOCUMENTATION_OPERATIONS.md`.

### `SYNC #1`, `SYNC #2`, `SYNC #N`, `SYNC A<N>`, and `SYNC B<N>`

Cover only the synchronization-managed documents belonging to that permanent development identity. Never copy Global documents into development scope.

### `SYNC OPERATIONS`

Cover only `MAG_DOCUMENTATION_OPERATIONS.md`.

### `SYNC AUDIT`

Perform a read-only ecosystem-wide documentation integrity audit, including identity, metadata, registration anomalies, unregistered/orphan files, duplicate-identity candidates, missing counterparts, conflicts, locations, and transport anomalies. Report without adopting files, then stop.

### `SYNC <filename>`

Cover exactly one canonical logical document. Stop if the filename or identity resolves ambiguously.

### `SYNC <file1> <file2>`

Cover the union of the explicitly named canonical documents. Resolve and classify each independently.

## 8. Executor capability preflight

Before any write, the executor must prove capability for the exact required operation in the current execution environment. Capability proven in another environment is insufficient.

The safe write path must preserve, as applicable:

- Markdown semantics and content;
- canonical filename;
- MIME type;
- intended location;
- existing object identity where required;
- complete, non-truncated content;
- deterministic read-back verification.

Prefer direct supported operations. After an initial tool failure, inspect bounded, supported direct alternatives before declaring the operation unavailable. Never invent unsupported capability, use uncontrolled retries, or use a lossy Google Docs conversion/export round-trip to bypass missing raw Markdown write capability.

If safe capability cannot be established:

```text
STOP → FAILED / NO SAFE WRITE
```

### 8.1 Capability escalation and executor limits

Distinguish clearly:

- **`OPERATION UNSAFE`** — no approved executor can perform the required operation while preserving required identity, type, location, content, and verification guarantees.
- **`CURRENT EXECUTOR LACKS CAPABILITY`** — the operation itself may be safe in another approved executor/environment, but the active executor cannot prove the required safe write path.

When the active executor lacks the required safe capability:

1. identify the exact missing capability once;
2. do not repeatedly redesign the procedure around the same limitation;
3. do not infer that the underlying operation is globally impossible;
4. route or recommend the operation to an available approved executor/environment that actually provides the required capability;
5. preserve the already established source/target state and evidence.

Use `FAILED / NO SAFE WRITE` for the current executor when appropriate, but record the capability blocker precisely. Do not use unsafe workarounds such as duplicate Drive objects, delete-and-recreate replacement, or lossy Google Docs conversion/export round-trips.

Capability proven in another environment is insufficient for the active executor to write, but established evidence from a prior executor remains reusable while its relevant source state is unchanged.

## 9. Layered content comparison

Compare in order:

1. **Raw equality** — compare retrievable bytes or reliable raw hashes.
2. **Universally safe normalization** — account only for representation differences proven not to change Markdown meaning, such as a UTF-8 BOM or CRLF/LF encoding. Do not modify either source during comparison.
3. **Explicit recognized transport profile** — apply only a documented, bounded inverse for a known transport transformation.
4. **Substantive structural comparison** — compare headings, prose, lists, tables, links, code, ordering, and other meaningful Markdown structure.

Do **not** globally normalize:

- Markdown escaping;
- trailing spaces;
- indentation;
- blank lines;
- headings;
- list syntax;
- tables;
- code syntax.

A recognized transport profile may produce `FORMAT_ONLY` only when its exact inverse yields canonical equality and no unexplained difference remains.

The prior Drive representation of `MAG_IMPLEMENTATION_PATTERNS.md`, with transport-added Markdown escaping and trailing-space inflation, is a known `FORMAT_ONLY` case. Its artifacts are not universal normalization rules.

## 10. Synchronization classifications and actions

After registration, or when a registered source expects a counterpart, use exactly one of these eight classifications per resolved document pair. `UNREGISTERED_DOCUMENT` remains an audit/registration anomaly outside this classification set.

### `IDENTICAL`

Content is equal at the applicable comparison layer. Perform no content write.

### `FORMAT_ONLY`

A recognized transport profile fully explains the difference. Report the profile and perform no automatic overwrite. A normalization write requires explicit inclusion in an approved plan.

### `NEWER_LOCAL`

Valid metadata and comparison evidence establish the Local revision as newer. Propose Local → counterpart. Product Owner approval and a proven safe write path are required.

### `NEWER_DRIVE`

Valid metadata and comparison evidence establish the Drive revision as newer. Propose Drive → Local. Product Owner approval is required; Git finalization remains a separate gate.

### `CONFLICT`

Substantive content diverges without a safe deterministic winner, including equal `MAG-Content-Updated` timestamps with substantive differences. Stop, preserve both states, and require Product Owner resolution. Never silently overwrite.

### `INVALID_METADATA`

Required metadata is missing, duplicate, malformed, mismatched, or unresolved. Stop synchronization for that document and report the exact problem.

### `MISSING_SOURCE`

The required source does not exist in the resolved scope. Stop that operation. Never infer permission to delete a counterpart.

### `MISSING_TARGET`

The source is resolved but its required counterpart does not exist. Propose creation. Product Owner approval and proven lossless transport are required.

Timestamp order informs `NEWER_LOCAL` or `NEWER_DRIVE` only when identity, metadata, and content evidence are valid. Same timestamp plus equal content is `IDENTICAL`; same timestamp plus a fully recognized transport transformation is `FORMAT_ONLY`; same timestamp plus substantive divergence is `CONFLICT`.

Git history is corroborating evidence, not an automatic authority override. If Git evidence materially contradicts apparent timestamp ordering, classify the document as `CONFLICT` unless the discrepancy can be conclusively resolved without inventing history.

### 10.1 Fast Sync Path

Use the Fast Sync Path only when **all** of the following are already established:

- canonical document identity is resolved;
- registration state is valid;
- source metadata is valid;
- source content passed validation in the immediately preceding approved procedure or checkpoint;
- source is committed or otherwise at the approved stable source state required by the procedure;
- no relevant source change occurred after that validation;
- synchronization direction is deterministically established;
- target counterpart identity is resolved;
- Product Owner authorization already covers the synchronization.

When these conditions hold, do **not** repeat:

- registration or adoption analysis;
- authority analysis;
- metadata onboarding analysis;
- historical timestamp reconstruction;
- full document audit;
- unchanged source validation;
- another planning cycle for the already-approved synchronization.

The Fast Sync Path is:

```text
Confirm proven source state
→ Confirm target identity/state
→ Confirm safe executor capability
→ Write
→ Read back
→ Compare
→ Report
```

Expand back to the full synchronization workflow only when new evidence invalidates a previously proven condition. Do not repeat documentation operations when no relevant source, metadata, identity, classification, authority, or approval state changed.

Fast Sync does not bypass conflict detection, metadata validation, identity resolution, registration checks, Product Owner approval boundaries, or required verification. It reduces repeated analysis; it does not reduce safety.

Intended Local documentation change sequence remains:

```text
edit Local
→ validate
→ synchronize Local ↔ Drive
→ verify IDENTICAL / valid FORMAT_ONLY
→ Git checkpoint
```

Do not weaken safe Drive update requirements.

### 10.2 Proven evidence reuse

A completed validation result remains reusable while its relevant source state remains unchanged.

A later executor may rely on previously established evidence such as:

- Git commit or hash;
- clean working-tree state;
- source SHA-256;
- valid metadata;
- canonical identity;
- target Drive ID or other counterpart identity;
- previous pair classification.

Do not force a new executor to reproduce an entire audit merely because execution moved between ChatGPT, Work, Cursor, MCP, or another environment. Require only the minimum confirmation necessary to prove that the referenced evidence still applies.

### 10.3 Failed executor does not reset proven state

**A failed executor attempt does not reset previously proven document state.**

If an executor fails because it lacks a required capability, preserve all still-valid evidence gathered before the failure.

Example:

```text
Local PASS
+ canonical identity resolved
+ target resolved
+ NEWER_LOCAL
→ current executor lacks raw Drive write capability
→ synchronization remains blocked at capability execution only
```

A subsequent executor starts from that established state after confirming the source has not changed. It must not automatically restart registration, authority, metadata, comparison, or planning analysis.

### 10.4 Fast Sync invalidation

Stop the Fast Sync Path and return to the full workflow when any of the following occurs:

- source content changed;
- metadata changed unexpectedly;
- Git or checkpoint evidence no longer matches;
- target identity changed;
- counterpart disappeared;
- duplicate identity appeared;
- classification is no longer deterministic;
- conflict is detected;
- authority or registration state changed;
- Product Owner-approved scope changed;
- the executor proposes a different write mechanism with materially different preservation guarantees.

## 11. Conflict handling

For `CONFLICT`:

1. stop writes for the affected document;
2. preserve all versions and diagnostic evidence;
3. report exact substantive differences, metadata, locations, and available history;
4. identify the Product Owner decision required;
5. resume only from an explicitly approved resolution.

Do not merge, choose authority, rewrite timestamps, or overwrite either side by assumption.

## 12. Synchronization plan and Product Owner approval

Before a writable execution, report for every resolved document:

- canonical identity and locations;
- metadata validity;
- comparison evidence and classification;
- proposed direction and exact action;
- executor capability requirements;
- expected identity, type, and location preservation;
- verification method;
- cleanup candidates;
- conflicts, risks, and stop conditions.

Then stop. Product Owner approval must identify the accepted plan or exact subset. Changed scope or state invalidates the approval and requires a revised plan.

## 13. Execution

Execute only the approved actions and scope.

- Revalidate source, target, metadata, classification, and executor capability immediately before writing.
- Prefer the simplest safe direct operation.
- Preserve canonical identity, type, location, and raw Markdown semantics.
- Do not create duplicate canonical documents.
- Do not change `MAG-Content-Updated` for synchronization alone.
- Record each completed, failed, skipped, or partially completed action.
- Stop when state differs from the approved plan or a safety condition fails.

## 14. Verification

Verify every important write by reading the resulting state.

Check the relevant:

- logical identity and metadata;
- filename;
- complete content;
- MIME type;
- location;
- object identity;
- expected counterpart state;
- absence of unexplained transformation or truncation.

Use raw equality when reliable. Otherwise apply the layered comparison model and report the limitation.

Never report synchronization as complete based only on generated content, a local replacement, or an unverified write result.

## 15. TEMP and intermediate-artifact cleanup

Automatic cleanup is permitted only when an artifact:

- was created by the executing AI;
- was created solely for the current procedure;
- is technical/intermediate and non-authoritative;
- has a successfully written and re-read/verified canonical target;
- can be identified unambiguously.

Never automatically delete:

- canonical documents;
- historical or audit records;
- user-created files;
- pre-existing files;
- ambiguous duplicates;
- backups;
- unrelated TEMP files;
- artifacts required to diagnose failed execution.

If execution fails before verification, preserve diagnostic state unless cleanup is independently proven safe.

## 16. Failure and recovery

On failure:

1. stop unsafe or dependent actions;
2. preserve canonical and diagnostic state;
3. determine which actions were not started, executed, verified, or failed;
4. verify the actual state of every attempted target;
5. report the concrete technical cause and affected documents;
6. require a revised plan and approval before retrying, repairing, or rolling back.

Do not conceal partial completion, perform uncontrolled retries, or infer rollback authority.

A capability failure preserves proven source, target, classification, and validation evidence unless new evidence invalidates them. Retry from the Fast Sync Path when the conditions in §10.1 still hold; otherwise return to the full workflow.

Use `FAILED / NO SAFE WRITE` when the current executor's required capability is unavailable. Record whether the blocker is `CURRENT EXECUTOR LACKS CAPABILITY` or `OPERATION UNSAFE`. Use `FAILED VERIFICATION` when a write occurred but required verification did not pass. Report `PARTIALLY COMPLETE` only when some approved independent actions were verified and others were not completed.

## 17. Reporting

The final report must state:

- resolved scope;
- preflight and capability result;
- per-document metadata, comparison, classification, direction, and action;
- Product Owner approval applied;
- execution method and result;
- verification evidence and limitations;
- cleanup actions or preserved artifacts;
- failures, conflicts, partial state, and required recovery;
- Local Git status and handoff.

Completion means every approved write was executed and verified, required cleanup was safely completed, and no unresolved failure or conflict remains.

## 18. Git handoff

SYNC authorization and Git finalization are separate authority gates.

An approved SYNC may modify only what its approved synchronization plan authorizes. It does not authorize:

- stage;
- commit;
- push;
- tag;
- release;
- rebase;
- history rewrite.

After Local writes, report Git diff and status and return control under existing Global development rules. Do not duplicate general Git policy here.

Synchronization-only completion of an already committed source does not require a new Git commit when Local content is unchanged. If Drive synchronization later succeeds without Local modifications, verify Local remains clean, report synchronization completion, and do not create an artificial Git commit.
