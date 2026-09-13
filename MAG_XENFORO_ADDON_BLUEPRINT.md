# MAG XenForo Add-on Blueprint

- MAG-Document-ID: `MAG_XENFORO_ADDON_BLUEPRINT.md`
- MAG-Content-Updated: `2026-09-13T10:08:03+00:00`

## Purpose, scope, and authority

A supporting operational asset for new MAG XenForo `#N` projects: GLOBAL → Blueprint → concrete project. GLOBAL defines HOW; `#N` defines WHAT. This Blueprint supplies reusable structure and working frames, not a new Global authority, product specification, implementation permission, or universal application lifecycle.

Consume currently ACTIVE Process Overlay Pool entries for HOW. This Blueprint does not own those overlays and cannot create overlay rules. While MPO-001 is ACTIVE, apply the two-level bootstrap authority model from `MAG_PROCESS_OVERLAY_POOL.md` during package execution. Drive-First is a normal Level 1 pause with Local/Git pending, not an exception.

Use current authorities from `MAG-Ecosystem`: MAG_ECOSYSTEM.md (identity and document ownership); MAG_PROCESS_OVERLAY_POOL.md (ACTIVE HOW overlays only); AI_GUIDELINES.md (development, localization, closure and ChatGPT coordination); AI_AGENTS_RULES.md (execution and Git boundaries); CURSOR_USAGE_ANALYTICS.md (telemetry); MAG_ADDON_DEVELOPMENT_LIFECYCLE.md (phases and gates); MAG_IMPLEMENTATION_PATTERNS.md (applicable verified knowledge); MAG_DOCUMENTATION_OPERATIONS.md (onboarding and transport). Read these owners instead of treating this asset as a replacement for their detailed rules. Report a conflict and stop the affected work.

## Operating principles

- **Minimum Interaction:** one approved bootstrap scope covers routine package preparation, validation, applicable writes, and whole-package verification. Do not request nine approvals or reconfirm a known decision.
- **Exception-Driven Intervention:** surface conflicts, critical ambiguity, failed validation, unsafe writes, identity collisions, Git/Drive divergence, new product or architecture decisions, and Global conflicts. Existing separate gates and Git authorizations still apply.
- **No Repeated Work:** reuse current context, approvals, existing documents, and still-valid evidence. Resume at the interrupted step after resolution.
- **No Speculative Content:** state what is unknown or absent. Creation does not imply requirements approval, implementation, a passed gate, or a release.
- **Existing-Documentation / Existing-Code First:** inspect the relevant existing state before creating or changing it. Reuse applicable verified patterns without copying another project's WHAT.

## Identity and substitution

After Project Approval, resolve the permanent `#N`, stable code, product name, repository identity, and current mode from evidence. Verify uniqueness through MAG_ECOSYSTEM.md; never allocate from an example or reuse an identity. Ask only for critical missing information.

Template asset prefix `P0N__XXX` is a filename marker. Instantiate it as `P<NN>__<CODE>` using the actual project number and approved code; replace every angle-bracket placeholder in the body and metadata. Use the canonical filename as MAG-Document-ID and the actual substantive establishment/acceptance time as MAG-Content-Updated. Do not use transport time or fabricate history. Unknown product facts may remain explicitly "Not yet defined" rather than unresolved identity placeholders.

The templates are supporting template assets under MAG_DOCUMENTATION_OPERATIONS.md §4. They are not registered project documents. Ordinary project-document validation begins after instantiation. This Blueprint is a registered Global operational asset with real metadata. Package approval permits controlled pre-checkpoint transfer, not a claim of a completed Git baseline. Template assets are not included in ordinary SYNC GLOBAL discovery; this Blueprint file may be.

## Canonical package and ownership

Instantiate all nine assets from `templates/xenforo-addon/` into `docs/`, preserving the approved suffix casing:

| Asset suffix | Canonical project filename | Owner |
| --- | --- | --- |
| README | `P<NN>__<CODE>__README.md` | Internal entry/navigation; link current lifecycle facts to Roadmap. |
| TZ | `P<NN>__<CODE>__TZ.md` | Approved product WHAT; creation alone does not approve it. |
| Roadmap | `P<NN>__<CODE>__Roadmap.md` | Lifecycle, sequencing, gates, A/I progress, release state, next approved step. |
| Architecture | `P<NN>__<CODE>__Architecture.md` | Approved product HOW and architecture decisions. |
| CLASS_MAP | `P<NN>__<CODE>__CLASS_MAP.md` | Implemented/current structure only. |
| Changelog | `P<NN>__<CODE>__Changelog.md` | Historical staged/released product changes, not plans. |
| IDEA | `P<NN>__<CODE>__IDEA.md` | Non-authoritative product exploration, Phase 0 reasoning/evaluation, alternatives, historical/superseded concepts, and future concepts. |
| CURSOR_USAGE_HISTORY | `P<NN>__<CODE>__CURSOR_USAGE_HISTORY.md` | Procedure and telemetry history under Global analytics. |
| AUDIT | `P<NN>__<CODE>__AUDIT.md` | Research/evidence parent. |

Maintain each fact in its owner; use references elsewhere. An explicitly required bootstrap-pending notice may appear in internal README with a link to the detailed Roadmap record. A mandatory container is not mandatory substantive work. Empty substantive domains receive honest current-state text, not fabricated entries. Creation does not imply approval, implementation, a performed audit, or telemetry. No OVERVIEW or automatic child-audit templates are included.

AUDIT may hold evidence directly. When evidence complexity justifies a child, use a prefixed NATIVE_SOURCE_AUDIT, DONOR_AUDIT, SECURITY_AUDIT, PERFORMANCE_AUDIT, or another evidence-specific document. The parent records its link, purpose, scope, status, principal result, and relationship to decisions; do not duplicate the child's full content. Findings do not authorize architecture or implementation.

## Repository and public README

Default layout, created only as each part becomes justified:

```text
<repository>/
  README.md
  docs/
    <nine canonical project documents>
  src/addons/MAG/<AddOnName>/
  tests/                         (only when justified)
```

The root README is public/product-facing source for GitHub, forum publication, release presentation, catalogs, installation, and usage. The internal MAG README lives in docs/. Neither owns requirements or independent release status; derive public facts from approved/current owners.

Recommended root README structure: H1 `[MAG] <Product Name>`, a short verified value statement, then Overview; Features; Requirements / Compatibility; Installation; Usage; Screenshots / Examples; Current Version; Support; License; Releases. Omit unavailable claims or identify their pending state. Do not invent screenshots, support URLs, licensing decisions, installation commands, or released versions. Apply lifecycle Release Presentation rules when producing release-facing copy.

The add-on skeleton is the verified native structure needed by the approved bootstrap scope, not prebuilt product behavior. Use only resolved identity and applicable native mechanisms. Create no speculative classes, integrations, or tests. If skeleton work requires a new product/architecture decision or separately gated implementation, report it and leave that part pending.

## Full Bootstrap

Use MAG_ADDON_DEVELOPMENT_LIFECYCLE.md Phase 1, MAG_DOCUMENTATION_OPERATIONS.md §5, and currently ACTIVE overlay MPO-001. Full Bootstrap is Level 1 then Level 2 without interruption.

Project Approval → Product Owner creates/provides the approved GitHub repository → verify identity → establish Local structure → instantiate nine documents → prepare public README → establish the authorized native skeleton → validate → Product Owner-controlled Git checkpoint → synchronize applicable Drive counterparts → verify whole package → complete stable registration → report.

Reuse an existing repository or counterpart. This is a typical sequence, not an extra checkpoint rule: a separately approved pre-checkpoint Drive batch is also governed by Documentation Operations. Stable completion requires all applicable prerequisites, including the approved Git baseline. Do not silently downgrade unavailable steps.

## Drive-First Bootstrap

Drive-First is a normal bootstrap state (MPO-001 Level 1, Local/Git pending), not an exception.

Project Approval → resolve permanent identity/code → prepare and create the canonical Drive package in one approved batch → verify → continue approved IDEA, TZ, Roadmap, Architecture, and AUDIT work under the normal substantive gates.

Record **Bootstrap Incomplete — Local/Git Pending** in internal README and Roadmap. Drive is the current authoritative source for this controlled bootstrap. Do not simulate a repository, Git checkpoint, skeleton, or stable registration. Lack of Local/Git does not invalidate completed documentation work.

## Resume Bootstrap

Resume Bootstrap continues an existing Level 1 state into Level 2 when Local/Git is available and Product Owner authorizes it.

Re-fetch and reuse the same Drive IDs, identity, documents, approvals, and evidence → inspect Local availability and divergence → create/complete the approved repository and /docs/ → reconcile current canonical Drive bodies into Local → prepare remaining public README/skeleton as authorized → validate → Product Owner-controlled Git baseline → verify applicable counterparts and complete stable registration.

Preserve existing Local work and stop affected overwrites on conflict. Do not restart IDEA, TZ, Architecture, AUDIT, or Roadmap because the device changed. Resume the substantive phase already reached; report remaining prerequisites accurately.

## Git/GitHub and Drive execution

The Product Owner controls repository publication, commit, push, tag, and release. Provide exact commands using verified repository paths, branch/remotes, and an explicit file list at the appropriate checkpoint. Do not run them automatically. Check the index and diff first; exclude unrelated work. A template or finished bootstrap does not grant Git or implementation authorization.

For Drive, resolve the approved project folder and all nine intended counterparts before writes. Use the controlled batch workflow in MAG_DOCUMENTATION_OPERATIONS.md §5, including safe transport and complete readback; preserve existing IDs and create only proven missing files. Report partial execution honestly and resume only unresolved actions. Do not redefine normal SYNC classifications or safeguards here.

This supporting package lives locally at the repository root plus templates/xenforo-addon and on Drive under MAG Projects / Operations with the same relative layout. Transfer templates as supporting template assets under MAG_DOCUMENTATION_OPERATIONS.md §4, not as instantiated project metadata. Package transfer is a separately approved operation and does not change the seven-file Global authority set.

## Architecture blocks and implementation increments

Within a project, recommend AD1, AD2, AD3 for Architecture Decisions and I1, I2, I3 for executable Implementation Increments. Do not use A1, A2, A3 for architecture decisions: `A<N>` is the permanent Desktop / Development Application identity namespace. Qualify AD/I references with the project and document. Do not rename historical project identifiers or fragment a simple decision into artificial blocks.

Architecture owns each decision; Roadmap references its approval and sequencing. Roadmap owns executable increment scope/progress. Approval of an architecture block does not itself authorize an implementation increment.

### Architecture Decision Frame

- ID: <project-qualified AD identifier>
- Objective: <decision to resolve>
- Confirmed evidence/facts: <references and applicability>
- Chosen approach: <approved approach or Not yet approved>
- Relevant constraints: <requirements and native constraints>
- Material alternatives: <only real alternatives; N/A with reason if none>
- Risks / unresolved questions: <known uncertainties>
- Approval state: <actual Product Owner decision/reference>

### Implementation Increment Frame

- ID: <project-qualified I identifier>
- Objective: <bounded outcome>
- Approved architecture reference: <decision and approval evidence>
- Relevant existing implementation: <verified current state or no implementation>
- Allowed scope: <authorized work>
- Likely affected files/areas: <grounded locations>
- Required behavior: <approved requirements references>
- Validation criteria: <observable completion evidence>
- Must-not-change boundaries: <protected behavior/files>
- Stop conditions: <material uncertainties or scope boundaries>
- Expected execution report: <changes, performed validation, findings, remaining work>

## Localization baseline

Use MAG-Ecosystem / AI_GUIDELINES.md §16 and the Lifecycle requirements, architecture, and validation sections. TZ considers user/admin-facing text; Architecture accounts for native XenForo phrases; CLASS_MAP records only implemented phrase/localization assets. Hardcoded UI strings are not the normal path. Validate applicable phrase coverage/resolution and changed localization assets under the owning rules. Multiple translations are not required at bootstrap.

## Adaptive Validation Matrix

The matrix records applicability and evidence required by owning Global rules and applicable ACTIVE overlays; it does not independently define or waive validation requirements. Place an applicable instance with the evidence owner, normally AUDIT; Roadmap references the result. Select checks based on actual change/risk and reuse valid evidence. Blank fields below are a form, never proof of execution.

| Area | Applicable | Reason | Evidence | Result |
| --- | --- | --- | --- | --- |
| Source/static | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| Automated tests | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| XenForo rebuild | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| Runtime | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| ACP/UI | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| Localization | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| Permissions/security | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| Upgrade | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| Regression | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| Package | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| Product Owner practical verification | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |
| PRV (Post-Release Verification) | `<yes/no>` | `<reason>` | `<reference>` | `<actual result>` |

N/A is valid with a reason where the owning Global rules permit it. This matrix cannot waive mandatory Product Owner Practical Acceptance or treat post-release checks as pre-release proof.

### Product Owner Practical Acceptance

Use at the lifecycle's mandatory acceptance point; technical validation cannot substitute for the Product Owner's result. Record evidence in AUDIT and reference the status from Roadmap.

- Workflow / Feature: <approved scope>
- Expected Behavior: <requirements reference>
- Manual Action: <actual user/admin exercise>
- Observed Result: <observed evidence>
- PASS / FAIL: <actual result; pending until performed>
- Finding / Follow-up: <issue and affected next action>

### Release Evidence

Use within the owning project documents, with Roadmap linking the evidence and authoritative release state. This form does not authorize finalization/publication or replace the lifecycle release gates.

- Version: <verified target>
- Validation state: <evidence reference>
- Practical Acceptance state: <Product Owner result>
- Release readiness state: <gate result>
- Package identity: <actual artifact>
- Hash/package evidence: <verified evidence>
- Documentation state: <comparison/closure evidence>
- Git state: <inspected state>
- Tag/release state: <actual state>
- Known findings: <unresolved limitations>
- Product Owner decision: <authorization or pending decision>

## ChatGPT coordination and exception reporting

Reuse known context; ask only for missing critical information. Coordinate the approved package as one operation, not a file-by-file interview. Do not reconfirm decisions, silently reduce missing work, or delegate product/architecture decisions to Cursor/Codex. Follow AI_GUIDELINES.md for prompts and review and CURSOR_USAGE_ANALYTICS.md for measurements; never invent telemetry.

Report a real exception promptly in this form:

- Issue: <specific failed or unresolved condition>
- Why it matters: <effect on the requested outcome>
- Required Product Owner decision/action: <minimum necessary resolution>

Preserve the last confirmed state and unaffected work. After resolution, resume the interrupted step; do not restart. Required gates, new decisions, unsafe writes, and Git control remain real boundaries even during a coherent operation.

## Bootstrap Completion report

Use a compact report, not a new permanent Bootstrap Completion file:

- GitHub: <verified repository / pending>
- Local repository: <verified path / pending>
- Google Drive: <folder, counterpart verification / pending>
- Core documentation: <nine files, metadata and content verification>
- Add-on skeleton: <verified authorized state / pending>
- Registration: <actual provisional or stable state>
- Current lifecycle phase: <Roadmap reference>
- Material pending items: <remaining action, owner, blocker>
- Result: <supported classification and next approved step>

Report Drive-First incompleteness explicitly. Full completion requires verified applicable prerequisites; a prepared package alone is not a stable project.

## Blueprint boundary

The package contains this document and nine templates only. Operational frames stay here and are instantiated in their existing project owners when needed. No automatic child audits, OVERVIEW, separate increment/decision/matrix/acceptance/release/checklist files, speculative directories, or real project are created by publishing this asset. It does not change Global authority, bypass approval, grant implementation scope, or authorize Git/release actions.
