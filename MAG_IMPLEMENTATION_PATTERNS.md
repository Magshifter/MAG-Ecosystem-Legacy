# MAG Implementation Patterns

- MAG-Document-ID: `MAG_IMPLEMENTATION_PATTERNS.md`
- MAG-Content-Updated: `2026-09-24T21:30:00+03:00`

Reusable, source-backed implementation knowledge for MAG development.

This document is a Global knowledge base. It does not define product requirements and does not replace:

- `MAG_ECOSYSTEM.md`
- `AI_GUIDELINES.md`
- `AI_AGENTS_RULES.md`
- `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`
- any active project `TZ`, `Roadmap`, `Architecture`, `CLASS_MAP`, `Changelog`, or `README`

`GLOBAL defines HOW. Active development defines WHAT.`

Entries in this document are **stack-scoped** unless explicitly marked otherwise. XenForo/XFRM entries apply to `#N` products only. Do not apply XenForo patterns to `A<N>`, `B<N>`, or other non-`#N` developments without matching verified scope.

## Usage rule

Do not read this document sequentially by default.

For a concrete task:

1. Search the Index or keywords for the relevant topic.
2. Open only the matching section.
3. Check the entry status and verified scope.
4. Reuse a pattern only when the current task matches its conditions.
5. If an entry is version-specific, development-specific, or marked `Needs revalidation`, verify the current installed XenForo source or current development implementation before relying on it.
6. If this document conflicts with authoritative Global or active-development documentation, report the conflict. Do not silently choose this document.

## Index

- [Capture procedure](#capture-procedure)
- [Status model](#status-model)
- [XenForo repository short-name compatibility](#xenforo-repository-short-name-compatibility)
- [Upgrade overlays do not remove obsolete add-on PHP files](#upgrade-overlays-do-not-remove-obsolete-add-on-php-files)
- [Shipped public static assets](#shipped-public-static-assets)
- [Mutable administrator-uploaded public assets](#mutable-administrator-uploaded-public-assets)
- [Rejecting oversized images vs resizing them](#rejecting-oversized-images-vs-resizing-them)
- [XenForo Image Manager is the compatibility boundary](#xenforo-image-manager-is-the-compatibility-boundary)
- [Content-derived image type validation](#content-derived-image-type-validation)
- [Deferred external work from rendering](#deferred-external-work-from-rendering)
- [Request-level reuse and bounded background work](#request-level-reuse-and-bounded-background-work)
- [Negative cache and stale-success refresh](#negative-cache-and-stale-success-refresh)
- [Managed storage path as state source of truth](#managed-storage-path-as-state-source-of-truth)
- [Safe managed-file replacement ordering](#safe-managed-file-replacement-ordering)
- [Remote HTTP and SSRF boundary](#remote-http-and-ssrf-boundary)
- [Redirect and final-location handling](#redirect-and-final-location-handling)
- [Domain normalization as a shared identity boundary](#domain-normalization-as-a-shared-identity-boundary)
- [Prefer XenForo-native internal resources](#prefer-xenforo-native-internal-resources)
- [ACP maintenance should not perform remote acquisition](#acp-maintenance-should-not-perform-remote-acquisition)
- [Cross-version tests may need semantic rather than literal assertions](#cross-version-tests-may-need-semantic-rather-than-literal-assertions)
- [Audit-scope optimization lesson](#audit-scope-optimization-lesson)
- [XenForo add-on Release Presentation metadata](#xenforo-add-on-release-presentation-metadata)
- [Portable baseline + capability-gated acceleration](#portable-baseline--capability-gated-acceleration)
- [Server-approved resource map with a closed client URI resolver](#server-approved-resource-map-with-a-closed-client-uri-resolver)
- [Additive native configuration with ownership-aware rollback](#additive-native-configuration-with-ownership-aware-rollback)
- [Host-agnostic core with host-specific native adapters](#host-agnostic-core-with-host-specific-native-adapters)
- [Explicit confirmation over native host files](#explicit-confirmation-over-native-host-files)
- [Shared dependency resolution for security and authoring](#shared-dependency-resolution-for-security-and-authoring)
- [Batch classify-validate then transactional confirmation](#batch-classify-validate-then-transactional-confirmation)
- [One WebGL context per logical viewer group](#one-webgl-context-per-logical-viewer-group)
- [Nullable metrics — unknown is not zero](#nullable-metrics--unknown-is-not-zero)
- [Source metrics separate from derivative metrics](#source-metrics-separate-from-derivative-metrics)
- [XenForo unique Job enqueue defaults to manual](#xenforo-unique-job-enqueue-defaults-to-manual)
- [Batch-prewarm sidecar TO_ONE relations with authoritative hydrated null](#batch-prewarm-sidecar-to_one-relations-with-authoritative-hydrated-null)
- [Visibility-bounded render lifecycle](#visibility-bounded-render-lifecycle)
- [XenForo in-place overlay body replacement](#xenforo-in-place-overlay-body-replacement)
- [ACL-safe public counters and lists](#acl-safe-public-counters-and-lists)
- [Stale unique-job recovery when the job row is missing](#stale-unique-job-recovery-when-the-job-row-is-missing)
- [Explicit client teardown when framework elements lack destructors](#explicit-client-teardown-when-framework-elements-lack-destructors)
- [Presentation suppression only when an equivalent managed surface exists](#presentation-suppression-only-when-an-equivalent-managed-surface-exists)
- [One canonical client-side managed refresh implementation](#one-canonical-client-side-managed-refresh-implementation)
- [Diagnose editor bootstrap layout shift at the collapsing ancestor](#diagnose-editor-bootstrap-layout-shift-at-the-collapsing-ancestor)
- [Do not use editor lifecycle hooks merely to hide initialization layout movement](#do-not-use-editor-lifecycle-hooks-merely-to-hide-initialization-layout-movement)
- [Explicit browser-static-asset deployment boundary](#explicit-browser-static-asset-deployment-boundary)
- [Separate host eligibility from effective feature enablement](#separate-host-eligibility-from-effective-feature-enablement)
- [Partial add-on `_output` is unsafe as a development import source](#partial-add-on-_output-is-unsafe-as-a-development-import-source)
- [Source map](#source-map)

---

## Capture procedure

Use this procedure when MAG work may have produced reusable technical knowledge.

### 1. Detect

Identify whether the completed work produced a potentially reusable technical finding or solution.

Candidates may include:

- verified XenForo/XFRM behavior;
- reusable implementation patterns;
- compatibility findings;
- upgrade/install behavior;
- debugging solutions;
- recurring failure modes;
- security lessons;
- performance lessons;
- storage/lifecycle/integration patterns;
- testing or validation lessons;
- technical workflow optimizations that could materially help future MAG development.

### 2. Verify

Do not promote assumptions or speculative conclusions.

A candidate must have an appropriate evidence basis, such as:

- installed XenForo/XFRM source inspection;
- verified implementation;
- relevant tests;
- real-environment verification;
- upgrade/release verification;
- authoritative project documentation that records the evidence.

Do **not** promote as generally reusable facts:

- donor behavior;
- unverified observations;
- planned architecture;
- hypotheses;
- accidental implementation behavior.

### 3. Search existing knowledge

Before creating a new entry, search this document for an existing applicable entry.

If one already exists:

- do not duplicate it;
- update it only when the new evidence materially changes or strengthens its verified scope, status, limitations, source context, or reusable conclusion.

### 4. Classify

Use the [Status model](#status-model) below.

Possible classifications:

- Verified Fact
- Reusable Pattern
- Project-Specific
- Needs Revalidation

Use multiple classifications where appropriate.

### 5. Determine scope

Separate reusable knowledge from project-specific facts.

Keep information project-local when it only describes:

- product requirements;
- approved project architecture;
- current project code structure;
- project-specific behavior;
- project history;
- release history without a reusable technical lesson.

Do not generalize behavior from one XenForo/XFRM version to another without evidence.

Use `Needs Revalidation` where the finding is useful but version-specific, environment-specific, project-specific, or otherwise unsafe to apply universally.

### 6. Decide

Add or update Global reusable knowledge only when there is a meaningful future reuse case.

Do not add entries merely because something was discovered.

This knowledge base must remain focused and useful rather than becoming a development log.

### 7. Record

When a candidate qualifies, record it using the entry structure in [Maintenance rule](#maintenance-rule).

Preserve, where applicable:

- Status
- Verified scope
- Source context
- observed or verified behavior
- reusable pattern or conclusion
- limitations
- revalidation boundary

When adding a new section, update the [Index](#index).

### 8. Preserve authority

This document must remain a reusable technical knowledge base.

It must **not**:

- define new product requirements;
- override project TZ;
- override approved project Architecture;
- override project Roadmap;
- redefine Global development rules;
- silently resolve documentation conflicts;
- replace required current-source verification where an entry requires revalidation.

`GLOBAL defines HOW. Active development defines WHAT.`

### 9. Procedure completion integration

Reusable-knowledge evaluation is a normal completion consideration for relevant MAG work. It does not require a separate Cursor procedure.

If the current approved procedure already includes Global documentation synchronization and the knowledge update is within scope, it may be recorded as part of that procedure.

If the reusable candidate is discovered while working only within an active development repository and modifying `MAG-Ecosystem` would cross the approved repository/procedure scope:

- do not modify `MAG-Ecosystem`;
- report the reusable-knowledge candidate to the product owner;
- wait for approval for a separate Global documentation update.

### 10. Preserve user control

Discovery of reusable knowledge must not authorize:

- unrelated implementation;
- architecture changes;
- requirements changes;
- cross-project modifications;
- scope expansion;
- Git operations;
- starting another development stage.

---

## Status model

Each entry uses one of these statuses.

**Verified Fact**  
Directly demonstrated by source inspection, implementation, tests, release behavior, or real-environment verification recorded in authoritative project documentation.

**Reusable Pattern**  
A verified implementation approach that is likely useful in another MAG project when the same technical conditions apply.

**Project-Specific**  
Correct for the source project, but not automatically reusable elsewhere.

**Needs Revalidation**  
Useful evidence exists, but the behavior is XenForo-version-specific, environment-specific, or insufficiently general to be treated as a permanent rule.

A single entry may have more than one label.

---

## XenForo repository short-name compatibility

Status: **Verified Fact / Needs Revalidation**

Verified scope: **#1 GLF; XenForo 2.2.19 and 2.3.12; production behavior through GLF 1.4.2**

Source context:
- `GlobalLinksFavicons / P01__GLF__TZ.md`
- `GlobalLinksFavicons / docs/P01__GLF__CLASS_MAP.md`
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`

Observed behavior:

`XF::repository('MAG\GlobalLinksFavicons:FaviconState')` did not have a safely interchangeable class-layout strategy across the tested XenForo 2.2 and 2.3 environments.

A compatibility layout using:

`Repository\FaviconState extends FaviconStateRepository`

was introduced for XenForo 2.2 short-name resolution, but later real XenForo 2.3 alias/autoload behavior made that dual-class layout unsafe.

The stable correction used one implementation file/class:

`Repository/FaviconState.php`
`class FaviconState extends XF\Mvc\Entity\Repository`

Pattern:

Do not infer XenForo repository short-name class resolution from one XenForo branch and generalize it to another.

Before introducing compatibility aliases, wrapper subclasses, or `*Repository` naming bridges:

- inspect the installed XenForo source for every supported major/minor branch that matters;
- verify the actual class XenForo instantiates for the short repository identifier;
- test the real application path, not only direct class construction or unit tests.

Do not automatically copy the GLF one-class solution into another add-on. Revalidate the active repository lookup behavior first.

---

## Upgrade overlays do not remove obsolete add-on PHP files

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF real upgrades; 1.3.0 → 1.4.3 and production 1.4.3 upgrade**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md` §39F–39G
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md` 1.4.2–1.4.3
- `GlobalLinksFavicons / P01__GLF__TZ.md` 1.4.2–1.4.3

Observed behavior:

A normal add-on ZIP overlay left obsolete PHP files from older releases on disk. Those files remained autoloadable and caused runtime failures even though the canonical new files were correct.

The affected historical files were:

- `Admin/Controller/CacheManagementController.php`
- `Repository/FaviconStateRepository.php`

The stable fix was an explicit XenForo upgrade step that removed known obsolete files after the overlay upgrade.

Pattern:

When a release renames, replaces, or removes an autoloadable add-on PHP file, treat stale-file cleanup as part of the upgrade design.

Before release:

1. Compare the previous shipping file tree with the new tree.
2. Identify removed or renamed autoloadable files.
3. Determine whether a normal XenForo add-on upgrade removes them.
4. If not, add an explicit upgrade cleanup step for the known obsolete paths.
5. Test an actual upgrade from the relevant previous release, not only a clean install.
6. Verify the runtime route/class that previously touched the renamed file.

Do not assume a clean development tree proves upgrade safety.

---

## Shipped public static assets

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF 1.2.1+; XenForo 2.2.19 and 2.3.12**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`

Verified GLF pattern:

- ship the static public file through add-on `_files`;
- include it through `build.json` `additional_files`;
- resolve its public path with XenForo `fnBaseUrl`;
- do not copy a shipped immutable asset into `data://` merely to make it public.

Example source-project path:

`styles/default/MAG/GlobalLinksFavicons/failed-placeholder.png`

Optimization lesson recorded by #1:

Use XenForo `_files` + `additional_files` + `fnBaseUrl` for shipped public static images instead of mutable `data://` storage.

Revalidate exact packaging syntax against the active XenForo version/build process before first use in another project.

---

## Mutable administrator-uploaded public assets

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF custom FAILED placeholder**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / P01__GLF__TZ.md`

Verified GLF pattern:

- accept upload through XenForo-native upload handling;
- validate content before persistence;
- store the mutable file through XenForo abstracted storage under `data://`;
- expose it publicly through `App::applyExternalDataUrl()`;
- keep a controlled fixed storage location when only one override is permitted;
- avoid storing an arbitrary filesystem path or user-supplied URL in the Option;
- use a small add-on-controlled token for cache invalidation when appropriate;
- remove managed custom files on reset/uninstall where required;
- never overwrite the shipped built-in fallback asset.

Source-project components included:

- `XF\Http\Upload`
- `XF\Util\File`
- `App::applyExternalDataUrl()`

Pattern:

Separate immutable shipped assets from mutable administrator-managed assets. Do not use one storage lifecycle for both.

---

## Rejecting oversized images vs resizing them

Status: **Verified Fact / Needs Revalidation**

Verified scope: **#1 GLF XenForo source investigation during image-upload work**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Roadmap.md`

Recorded finding:

`Upload::setMaxImageDimensions` was unsuitable when the product requirement was to reject an oversized image, because XenForo resized instead of failing.

Pattern:

If the requirement is **reject when dimensions exceed the limit**, do not assume a helper named as a maximum-dimension setter performs rejection.

Inspect the active XenForo implementation and use explicit dimension validation when rejection semantics are required.

Revalidate before reuse because helper behavior is framework-version-specific.

---

## XenForo Image Manager is the compatibility boundary

Status: **Verified Fact / Reusable Pattern / Needs Revalidation**

Verified scope: **#1 GLF; XenForo 2.2.19 and 2.3.12**

Source context:
- `GlobalLinksFavicons / P01__GLF__TZ.md`
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`

Recorded optimization lesson:

Treat XenForo Image Manager's supported type behavior as the application compatibility boundary rather than raw PHP/GD function availability.

Verified in #1:

- PNG decoded through XenForo Image Manager on XF 2.2 and 2.3.
- JPEG/GIF could be decoded and normalized to PNG.
- WebP was supported opportunistically on XF 2.3 when the active driver supported it.
- XF 2.2 Image Manager did not support WebP even where local PHP/GD capability might exist.
- ICO required a separate bounded validator.
- SVG was not accepted as an untrusted remote favicon rasterization path.

Pattern:

For XenForo add-on image features, determine supported formats through XenForo's active image abstraction first. Do not expose a capability merely because an underlying PHP extension has a function for it.

Revalidate exact format support for the installed XenForo branch and active image driver.

---

## Content-derived image type validation

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF remote and ACP image handling**

Source context:
- `GlobalLinksFavicons / P01__GLF__TZ.md`
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`

Verified GLF rule:

Actual downloaded/uploaded bytes determine accepted image type.

The following were not treated as authoritative on their own:

- filename;
- URL extension;
- HTTP `Content-Type`;
- HTML `type=` hint.

Pattern:

For untrusted or administrator-provided image data, derive type from content and successfully decode/structurally validate the bytes before storing or serving them.

Metadata may be used as a hint, but not as the sole trust boundary.

---

## Deferred external work from rendering

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF runtime architecture**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`
- `GlobalLinksFavicons / docs/P01__GLF__Overview.md`

Historical problem:

External acquisition during normal BB-code rendering created a blocking/performance-sensitive architecture.

Stable pattern:

`render → local decision/cache lookup → enqueue unique background Job if needed → return rendered content`

The renderer performs no external HTTP and no remote acquisition filesystem write.

Pattern:

When external network work is not required to complete the current HTTP response, keep it out of presentation/rendering paths. Render with currently available local state and defer remote work through a XenForo-native background mechanism.

Do not generalize this into "all Jobs are always better". Apply it when synchronous remote work would block or multiply in a rendering request.

Related XenForo enqueue fact: `enqueueUnique()` defaults to **manual** jobs. For automatic background work, see [XenForo unique Job enqueue defaults to manual](#xenforo-unique-job-enqueue-defaults-to-manual).

---

## Request-level reuse and bounded background work

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF Stage 17**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`

Verified #1 findings:

Repeated MISSING-domain lookups were the main rendering bottleneck.

The implemented optimization used:

- request-level collaborator reuse;
- per-domain memoization;
- negative MISSING caching across renderer/cache instances;
- repeated filesystem-check elimination;
- unique Job enqueueing;
- one shared per-request budget for unique acquisition/refresh Jobs.

Recorded benchmark:

500 repeated MISSING links were reduced from 501 DB queries to 2 total queries including one Job insert. 500 unique MISSING domains were bounded to 50 Jobs. Cached SUCCESS rendering remained outside that Job budget.

Pattern:

For repeated per-item rendering work:

1. identify the repeated lookup boundary;
2. cache negative as well as positive decisions within the request when semantics permit;
3. deduplicate background work by stable identity;
4. bound new background work for high-cardinality requests;
5. do not let the enqueue budget suppress already-cached successful rendering.

The numeric budget `50` is **Project-Specific**, not a Global default.

Related XenForo enqueue fact: unique Job identity does not by itself make the job automatic. See [XenForo unique Job enqueue defaults to manual](#xenforo-unique-job-enqueue-defaults-to-manual).

---

## Negative cache and stale-success refresh

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF favicon state machine**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / P01__GLF__TZ.md`

Verified state behavior:

- fresh SUCCESS: render local value;
- expired SUCCESS: continue rendering current value while permitting one refresh;
- fresh FAILED: suppress repeated acquisition;
- expired FAILED: retry is permitted;
- MISSING: acquisition is permitted.

Pattern:

For expensive remote lookup systems, consider separating:

- availability of a currently usable value;
- freshness of that value;
- whether new background work is permitted.

A stale successful value can remain usable during refresh, while recent failures can be negatively cached to prevent retry storms.

TTL values and exact states are product requirements, not Global defaults.

---

## Managed storage path as state source of truth

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF format-aware favicon storage**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`

Verified #1 correction:

Once multiple stored file formats were possible, the persisted `storage_path` became the SUCCESS source of truth instead of recomputing a filename from the domain.

Pattern:

If a persisted object may change extension, location, storage backend, or naming strategy over time, persist the actual managed abstracted path with successful state and read through that path.

Avoid reconstructing storage location from an identity key when the representation is no longer one-to-one.

Validate that any persisted path remains inside the add-on's managed storage namespace.

---

## Safe managed-file replacement ordering

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF format switching**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`

Verified ordering:

`validate new → save new → commit/mark SUCCESS with new storage_path → delete old managed file if path changed`

Additional verified behavior:

- same-path refresh does not delete;
- a failed refresh preserves the current SUCCESS;
- cleanup failure after committed SUCCESS may leave a harmless orphan but must not convert the new SUCCESS into FAILED.

Pattern:

When replacing a currently working managed file, commit the new usable state before deleting the old file.

Cleanup should be downstream of successful replacement and should not destroy the newly committed logical success merely because old-file deletion failed.

---

## Remote HTTP and SSRF boundary

Status: **Verified Fact / Reusable Pattern / Needs Revalidation**

Verified scope: **#1 GLF external favicon acquisition; XF 2.2.19 and 2.3.12**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / P01__GLF__TZ.md`
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`

Verified #1 implementation used XenForo's untrusted HTTP reader and combined:

- destination safety/SSRF protection;
- redirect handling;
- bounded request time;
- bounded response size;
- HTTP status checks;
- candidate URL validation;
- content-derived file validation;
- bounded candidate count;
- bounded total external request count.

Pattern:

For server-side requests to user-derived or remote URLs, use XenForo's untrusted-request facilities and treat URL safety, redirects, byte limits, time limits, and content validation as one security boundary.

Do not replace the XenForo-native untrusted transport with a generic HTTP call merely because it is simpler.

Exact reader APIs and behaviors must be reverified against the installed XenForo source.

---

## Redirect and final-location handling

Status: **Verified Fact / Needs Revalidation**

Verified scope: **#1 GLF FaviconDiscovery; XenForo 2.2.19 and 2.3.12**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`

Recorded compatibility nuance:

The Reader could retain a stale `lastLocation`, so the final document URL logic could not blindly treat any existing `lastLocation` as proof that the current request redirected.

A regression test was added for stale-lastLocation behavior.

Pattern:

When framework request objects expose redirect/final-location state, verify whether that state is per-request or can survive/reuse across operations.

Do not derive security-sensitive URL resolution from a mutable transport field without confirming its lifecycle.

Revalidate before reuse.

---

## Domain normalization as a shared identity boundary

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF URL/domain identity**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / P01__GLF__TZ.md`

Verified #1 normalization centralized:

- absolute HTTP/HTTPS host extraction;
- trailing-dot removal;
- IPv4/IPv6 canonicalization;
- UTS #46 ASCII conversion;
- lowercase;
- exact leading `www.` removal;
- ports excluded from the normalized identity.

The normalized identifier was reused for state keys, storage decisions, internal-link comparison, blacklist matching, and job deduplication.

Pattern:

When several subsystems make decisions about the "same domain", centralize normalization and use the same stable identifier across those subsystems.

Do not let each consumer independently parse/canonicalize hosts.

The exact equivalence policy (`www.`, subdomains, ports, IDN handling) is product-specific and must be explicitly approved.

---

## Prefer XenForo-native internal resources

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF internal-link favicon behavior**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / P01__GLF__TZ.md`

Verified #1 design:

Internal forum links use the current style's XenForo `publicFaviconUrl`.

They do not use:

- external HTTP;
- favicon acquisition Jobs;
- external favicon cache state;
- `data://` favicon storage.

Pattern:

Before building a parallel storage/acquisition path for an internal XenForo resource, check whether XenForo already exposes the authoritative current-style/current-system value.

Prefer the native value when it satisfies the requirement.

---

## ACP maintenance should not perform remote acquisition

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#1 GLF Cache Management**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`

Verified #1 boundary:

ACP cache-management actions do not perform external favicon HTTP directly. Maintenance can change state or queue work, while acquisition remains in the existing background path.

Pattern:

Keep remote acquisition out of administrator list/action request paths when the work can be queued through the established background mechanism.

This keeps ACP actions bounded and avoids creating a second network/security implementation path.

---

## Cross-version tests may need semantic rather than literal assertions

Status: **Verified Fact / Reusable Pattern / Needs Revalidation**

Verified scope: **#1 GLF security tests; XenForo 2.2.19 and 2.3.12**

Source context:
- `GlobalLinksFavicons / P01__GLF__TZ.md`
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`

Observed difference:

A bounded `Stream::write()` interruption appeared as `false` on one tested XenForo branch and `0` on another.

The compatibility test accepted either low-level return representation while still requiring the same higher-level `Reader::ERROR_SIZE` security outcome.

Pattern:

For cross-version compatibility tests, assert the product/security semantic outcome when equivalent framework versions expose different low-level representations.

Do not weaken the important invariant merely to make versions pass.

Revalidate each discrepancy rather than broadly accepting multiple values.

---

## Audit-scope optimization lesson

Status: **Verified Fact / Reusable Pattern**

Source context:
- `GlobalLinksFavicons / docs/P01__GLF__Roadmap.md`
- Global authority remains `AI_AGENTS_RULES.md` and `AI_GUIDELINES.md` §24 for model routing.

Recorded #1 lesson:

One image-handling procedure combined XenForo source research, implementation, testing, manual verification, and documentation in a single broad Cursor procedure. The project history classified this as broader than ideal.

Reusable efficiency pattern:

For a task with uncertain XenForo behavior:

1. perform a narrow compatibility/source investigation;
2. resolve the architecture/requirement decision;
3. execute the focused implementation;
4. run the relevant validation;
5. synchronize documentation only after behavior is established.

This improves context targeting and makes repeated audits less likely.

Do not split procedures mechanically when separation would increase cost without improving clarity or verification. Global Cursor workflow remains authoritative in `AI_GUIDELINES.md` §24.

---

## XenForo add-on Release Presentation metadata

Status: **Verified Fact / Reusable Pattern**

Verified scope: **XenForo 2.3.12; verified during #2 Tag Synchronizer Release Presentation work (P02-RF02–P02-RF05); mechanism is native `addon.json` metadata plus a root-level packaged icon asset**

Source context:

- `MAG-Ecosystem / MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 8 — Release Presentation policy
- `#2 Tag Synchronizer / P02-RF02` native-mechanism audit evidence
- `#2 Tag Synchronizer / P02-RF03`–`P02-RF05` implementation and local verification evidence
- installed XenForo 2.3.12 source: `XF\AddOn\AddOn`, `XF\Service\AddOn\ReleaseBuilderService`, admin `addon_list_macros`

Observed behavior:

XenForo 2.3.12 exposes add-on Release Presentation metadata from `addon.json` in the add-on root. ACP reads these values from disk through `XF\AddOn\AddOn`; there is no separate native field for Donate or for a separate `Made in Ukraine` line.

| Presentation item | Native representation |
| --- | --- |
| Main description | `addon.json` → `"description"` (string) |
| `Made in Ukraine` separate line | append `\nMade in Ukraine` inside `"description"`; ACP renders with `nl2br` |
| Icon | `"icon": "<filename>"` plus image file at add-on root; `hasIcon()` requires the file to exist |
| Developer identity | `"dev"` |
| Developer URL | `"dev_url"` |
| Support URL | `"support_url"` |
| Donate URL | `"extra_urls"` associative object, e.g. `{"Donate": "<url>"}` |

`xf-addon:build-release` copies non-excluded add-on root files, including `addon.json` and the icon file, into `upload/src/addons/<AddOnId>/` inside the release ZIP. `hashes.json` includes packaged files such as `src/addons/<AddOnId>/<icon-file>`.

For local ACP verification before a release build, synchronize the repository `addon.json` and icon file into the installed XenForo add-on directory. XenForo reads the updated metadata from disk without a separate metadata-import step. A DB `json_hash` mismatch may show ACP **Pending changes** until a later `xf-addon:sync-json` or equivalent step; that label does not block ACP metadata display from disk.

Pattern:

For MAG Release Presentation on XenForo 2.3.x:

1. set approved metadata in repository `addon.json`;
2. copy the authoritative Global `magicon.png` unchanged to the add-on root and reference it from `"icon"`;
3. synchronize `addon.json` and the icon into the installed XenForo add-on directory before local ACP verification or a release build when local installed behavior must match repository state;
4. run `xf-addon:build-release` only after required Release Presentation data is approved and present in the build source tree.

Limitations / revalidation boundary:

- Do not copy #2 product description text or Support URL values into other projects.
- Revalidate against installed XenForo source when the XenForo major/minor version, `xf-addon:build-release` behavior, or add-on packaging layout changes.
- A prior native-mechanism audit (for example P02-RF02-style) does not need repeating when this verified scope still applies and no new uncertainty exists.

---

## Portable baseline + capability-gated acceleration

Status: **Reusable Pattern** (strong pattern; not universally mandatory)

Verified scope: **General MAG architecture/design guidance**; evidence origin **#5 XFRM 3D Model** isolated format-stack benchmark research (2026-09-15)

Source context:

- `XFRM3DModel / research/core-3d-pipeline-benchmark/` (project evidence archive)
- `XFRM3DModel / docs/P05__3DR__AUDIT.md` (measured findings summary)

### Problem

A product may need richer performance or format coverage than every host can guarantee. Hard-coding optional heavy capabilities into the only code path makes baseline functionality unavailable on minimum supported hosts.

### Principle

Keep **core functionality** available on the minimum guaranteed host/runtime baseline. Treat heavier capabilities (extra runtimes, native tools, background workers, advanced transforms) as **optional accelerations** that activate only when the host exposes suitable capability and policy allows them. Optional acceleration must not be the sole way to deliver baseline behavior.

### When to use

- baseline vs enhanced behavior depends on host tooling, extensions, or resources;
- a cheaper portable path and a faster optional path both exist;
- Architecture must decide what is mandatory vs opportunistic;
- degraded mode must remain safe and usable.

### Benefits

- broader host compatibility;
- clearer failure modes when acceleration is absent;
- easier reasoning about minimum supported configuration;
- evidence can compare baseline and accelerated paths without prematurely selecting one stack globally.

### Risks

- two paths to maintain if not bounded by clear capability gates;
- silent fallback to a weaker path may hide quality/security gaps;
- capability detection can be wrong or stale;
- optional native tooling introduces packaging, licensing, and sandbox concerns.

### Guardrails

- define baseline behavior explicitly in product Architecture;
- gate acceleration on verified capability checks and policy, not assumptions;
- never make security, permission inheritance, or authoritative download behavior depend on optional acceleration;
- record project-specific stack evidence locally; generalize only the principle to Global documentation;
- degraded mode must be explicit to operators/authors where quality differs materially.

### Limitations / revalidation boundary

This pattern is architectural guidance, not a mandate to add dual pipelines everywhere. Apply only when evidence shows a real baseline vs accelerated split. Revalidate when host guarantees, licensing, or performance budgets change.

---

## Server-approved resource map with a closed client URI resolver

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 XFRM 3D Model accepted Increments 1–11**; Forum and XFRM viewers; local package members including glTF + `.bin` sidecars

Source context:
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__TZ.md`
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`

### Problem

Embedded URIs in untrusted or author-supplied files can instruct a browser loader to fetch remote URLs, protocol-relative URLs, `file:` URLs, or path-traversal members. Trusting those URIs bypasses native ACL and can leak filesystem layout.

### Pattern / rule

The server determines the exact local resource/package members the client may resolve. Client-side loaders must resolve **only** through that server-approved map.

- membership is server-authoritative;
- the client uses a closed resolver over that map;
- reject remote, protocol-relative, `file:`, traversal, and unmapped members;
- serve allowed members through native URLs so native ACL remains in force.

### When to use

- a client loader follows URIs found inside a package (glTF, similar formats, or future MAG package types);
- files may include sidecars that must remain inside a known membership set;
- the product must not allow arbitrary browser fetches from embedded references.

### Key constraints

- do not let the client construct fetch URLs from raw embedded strings;
- do not expose internal storage paths;
- unmapped members fail closed;
- native attachment/resource download URLs remain the access path.

### Why it is safer / maintainable

It keeps useful browser loaders without trusting embedded URIs, preserves host ACL, and prevents a second unofficial fetch path.

### Proven MAG evidence

#5 glTF URI policy plus `.bin` sidecar-only package membership: viewer and authoring resolve members only when the server has already approved them.

Limitations / revalidation boundary:

This is a security/architecture pattern, not a mandate to use glTF. Exact reject lists and package formats are product Architecture. Revalidate when a new loader, CDN, or URI scheme is introduced.

---

## Additive native configuration with ownership-aware rollback

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** native attachment / XFRM resource extension management

Source context:
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__TZ.md`

### Problem

MAG add-ons often need to augment shared XenForo/native options (allowed extensions, similar host lists). Blindly writing those options on install claims values the administrator already set. Blindly stripping them on uninstall removes human configuration or values other add-ons still need.

### Pattern / rule

`Claim only what you added; never reclaim a human deletion; never uninstall-strip shared host configuration.`

When augmenting shared native configuration:

1. detect whether the native value already exists;
2. do not claim a pre-existing value as MAG-owned;
3. record ownership only when MAG actually added it;
4. rebuild/upgrade must not fight a later administrator deletion;
5. uninstall must not remove shared values blindly.

### When to use

An add-on writes into XenForo Options or other shared host configuration that humans or other add-ons also manage.

### Key constraints

- ownership is an add-on-side fact, not a reason to overwrite the native option on every rebuild;
- if an administrator later removes a MAG-added value, do not automatically restore it unless product Architecture explicitly requires a repair action;
- uninstall cleanup applies only to values MAG owns and that are safe to remove.

### Why it is safer / maintainable

It avoids fighting administrators, avoids stealing pre-existing config, and keeps uninstall from damaging the host.

### Proven MAG evidence

#5 native extension management records MAG ownership only for extensions the add-on appended; pre-existing host values stay unclaimed.

Limitations / revalidation boundary:

Do not copy #5 option IDs or extension lists. Revalidate against the specific native option format (whitespace lists, JSON, etc.) on the installed XenForo/XFRM version.

---

## Host-agnostic core with host-specific native adapters

Status: **Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** Forum + XFRM Source Package authoring and Source analysis

Source context:
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`

### Problem

Duplicating business rules against Forum entities in one path and XFRM entities in another causes the hosts to disagree about validation, grouping, or lifecycle.

### Pattern / rule

Shared product logic should operate on stable domain abstractions rather than Forum/XFRM entities directly.

Host adapters own:

- native identity;
- native file enumeration and read;
- lifecycle hooks;
- ACL / visibility;
- persistence association to the native content.

Core owns:

- grouping;
- validation;
- shared business rules.

### When to use

The same MAG product feature must run on more than one XenForo content host, or is likely to gain another host later.

### Key constraints

- adapters must not reimplement core rules with host-specific shortcuts;
- native files remain authoritative; MAG records associate to them rather than replacing them;
- ACL stays in the adapter / native permission path.

### Why it is safer / maintainable

One rule change applies to every host. Host differences stay in a thin adapter instead of leaking into every service.

### Proven MAG evidence

#5 Source Package authoring and later Source analysis share host-agnostic planners/services with Forum and XFRM native-file adapters.

Limitations / revalidation boundary:

This does not require a particular class tree. Do not treat #5 `SourceFile` / host class names as Global requirements.

---

## Explicit confirmation over native host files

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 XFRM 3D Model Increment 8+**; Forum and XFRM authoring

Source context:
- `XFRM3DModel / docs/P05__3DR__TZ.md`
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__IDEA.md`

### Problem

Silently treating every eligible native file as managed MAG content creates surprise ownership, fights host workflows, and is hard to reverse. Product-level intent is not the same as “a compatible file exists.”

### Pattern / rule

Native host files remain authoritative. MAG should not silently claim eligible files as managed product content when product-level intent is required.

Preferred flow:

native files → classify → validate → review → explicit confirmation → managed records

### When to use

MAG adds a managed layer on top of files the host already stores (attachments, resource version files, similar native blobs).

### Key constraints

- classification may be automatic; **claiming** must not be;
- unmanaged eligible files must remain valid native files;
- confirmation is the write boundary for MAG-managed records.

### Why it is safer / maintainable

Authors see what MAG will manage. Existing native content is not rewritten by side effect.

### Proven MAG evidence

#5 replaced silent attachment auto-association with explicit `Add 3D model(s)` confirmation. Historical silent association remains a removed path, not a pattern to copy.

Limitations / revalidation boundary:

The confirmation UI is product-specific. The reusable rule is explicit intent before MAG persistence, not a particular button label.

---

## Shared dependency resolution for security and authoring

Status: **Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** glTF URI/dependency inspection used by viewer security and authoring package validation

Source context:
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`

### Problem

Separate parsers for “what the viewer will fetch” and “what authoring will accept” can disagree. One path may allow a package the other later rejects, or worse, security may miss a member authoring treated as local.

### Pattern / rule

Do not maintain separate dependency parsers for runtime security and authoring package validation when they describe the same membership problem.

Use one shared dependency model/parser where practical so the system cannot disagree with itself about package membership.

### When to use

A format declares additional files by URI or similar references, and both authoring and runtime must honor the same membership/security policy.

### Key constraints

- security must not be a looser copy of the authoring parser;
- shared parser output should name members, blocked URIs, and required relative URIs consistently;
- product-specific extra checks may wrap the shared parser; they must not replace it with a second URI grammar.

### Why it is safer / maintainable

Membership bugs are fixed once. Runtime cannot silently fetch what authoring never validated.

### Proven MAG evidence

#5 reuses glTF URI/dependency inspection for viewer security and Source Package authoring.

Limitations / revalidation boundary:

Sharing a parser is required only where the membership grammar is the same. Unrelated formats may keep dedicated parsers. Do not treat glTF as the only MAG package type.

---

## Batch classify-validate then transactional confirmation

Status: **Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** batch STL/GLB/glTF authoring on Forum and XFRM

Source context:
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__TZ.md`

### Problem

Multi-file import that validates the whole batch as one unit lets one invalid package block unrelated valid items, or persist a mixed half-applied state.

### Pattern / rule

For multi-file authoring/import:

1. classify files;
2. identify primaries;
3. resolve dependencies;
4. create proposed logical items;
5. validate each item independently;
6. explicitly confirm valid items;
7. persist transactionally / idempotently.

One invalid package must not poison unrelated valid items.

### When to use

Authors attach or select multiple files that may form several independent logical items (with or without sidecars).

### Key constraints

- item-level validation results should be visible before confirmation;
- persistence of confirmed items should be idempotent on retry;
- do not require every file in the native set to become MAG-managed.

### Why it is safer / maintainable

Partial success is explainable. Retry does not duplicate already confirmed items.

### Proven MAG evidence

#5 batch Source Package authoring classifies STL/GLB/glTF (and glTF sidecars), validates proposed items independently, and confirms only valid items.

Limitations / revalidation boundary:

Supported formats and grouping UI are product Architecture. The reusable rule is independent item validation plus explicit, idempotent confirmation.

---

## One WebGL context per logical viewer group

Status: **Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** Model Set multi-item viewer

Source context:
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`

### Problem

Creating one WebGL renderer/canvas per file exhausts browser GPU contexts, leaks GPU memory, and lets stale async loads apply to the wrong item.

### Pattern / rule

When one logical content group contains multiple 3D items:

- use one renderer / canvas / WebGL context;
- switch the active model inside it;
- dispose previous geometries, materials, and textures;
- protect against stale async load completion;
- isolate per-item failure so one bad file does not destroy the group viewer.

Do not create one renderer per file unless Architecture truly requires isolated contexts.

### When to use

A MAG surface presents several GPU-rendered items as one user-facing group (tabs, playlist, set).

### Key constraints

- switch must dispose GPU resources from the previous item;
- in-flight loads must be ignored if the user has already switched away;
- item failure should show an item error, not unmount the whole group by default.

### Why it is safer / maintainable

It stays within typical browser WebGL context limits and avoids cross-item state leaks.

### Proven MAG evidence

#5 Model Set viewer uses one WebGL context and switches items inside it.

Limitations / revalidation boundary:

This is a client GPU-resource pattern, not a mandate for a particular engine (Three.js or otherwise). Non-WebGL previews are out of scope. Do not copy #5 display-name or switching UX as Global requirements.

---

## Nullable metrics — unknown is not zero

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 XFRM 3D Model Increment 11** Source Analysis / Model Info

Source context:
- `XFRM3DModel / docs/P05__3DR__TZ.md`
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`

### Problem

Persisting unknown measurements as `0` makes UI, ranking, and later optimization treat “not measured” as “empty/cheap.” Failed or unsupported analysis becomes indistinguishable from a real zero.

### Pattern / rule

Persist analysis metrics as **nullable** when the value is unknown or unavailable.

Do not invent zero values merely to simplify UI or storage.

UI and consumers must distinguish:

- measured zero;
- unknown;
- unsupported;
- failed analysis.

### When to use

MAG persists counts, sizes, estimates, or similar measurements that a given analyzer may not be able to obtain.

### Key constraints

- schema columns for optional measurements should be nullable;
- status (complete / failed / unsupported) is not a substitute for faking metric numbers;
- estimates that cannot be computed must stay null rather than a guessed number.

### Why it is safer / maintainable

Later comparison, filtering, and optimization can trust numbers that exist and ignore numbers that do not.

### Proven MAG evidence

#5 Source Analysis stores nullable source metrics and treats unknown as unknown in Model Info (for example a format may report triangles without inventing a vertex count).

Limitations / revalidation boundary:

Do not promote #5 complexity class cutoffs or memory-estimate formulas. Those remain product-local and, where documented as provisional, must not become Global defaults.

---

## Source metrics separate from derivative metrics

Status: **Reusable Pattern**

Verified scope: **#5 XFRM 3D Model Increment 11** `SourceAnalysis` persistence designed independently of future Viewer Asset / derivative metrics

Source context:
- `XFRM3DModel / docs/P05__3DR__TZ.md`
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`

### Problem

Overwriting original-file measurements with post-optimization measurements destroys the ability to compare source vs derivative honestly and makes rollback/debug impossible.

### Pattern / rule

Original/source metrics and generated/optimized derivative metrics are different data domains.

Do not overwrite source metrics with derivative metrics.

Use separate persistence or contracts so later optimization layers can compare source vs derivative without rewriting history.

### When to use

A MAG product analyzes author-supplied files and may later generate optimized/preview derivatives of those files.

### Key constraints

- source rows remain source even after a derivative exists;
- derivative metrics, if added later, get their own store or explicitly versioned contract;
- analysis failure of a derivative must not erase successful source metrics.

### Why it is safer / maintainable

Optimization quality can be measured against an unchanged source baseline.

### Proven MAG evidence

#5 persists Source metrics in a dedicated table/contract (`metrics_kind=source`) and keeps Viewer Asset / optimization metrics out of that store. Derivative metrics themselves were **not** implemented in Increments 1–11; only the separation was.

Limitations / revalidation boundary:

This pattern does **not** implement ViewerAsset, optimization, or rebuild. Do not treat #5 table names as required Global schema.

---

## XenForo unique Job enqueue defaults to manual

Status: **Verified Fact / Reusable Pattern / Needs Revalidation**

Verified scope: **XenForo Job Manager as used by #5**; installed-source finding recorded in `#5` AUDIT and applied in Increment 11 analysis Jobs. Do not generalize beyond verified XenForo `enqueueUnique()` behavior.

Source context:
- `XFRM3DModel / docs/P05__3DR__AUDIT.md` (Jobs section)
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__TZ.md`
- related Global entries: [Deferred external work from rendering](#deferred-external-work-from-rendering), [Request-level reuse and bounded background work](#request-level-reuse-and-bounded-background-work)

### Problem

Developers reasonably treat `enqueueUnique()` as “run this background job once.” On XenForo, the method defaults to **manual** execution. Unique jobs then wait for ACP/manual run instead of `job.php` / `xf:run-jobs`. Heavy work appears “queued” but never runs automatically.

### Pattern / rule

`enqueueUnique()` defaults to manual jobs.

For automatic background work, enqueue with the correct **non-manual** mode (in verified XenForo source: pass `$manual = false`).

When using this mechanism:

- use a stable unique job key;
- keep work idempotent and retry-safe;
- isolate failures per logical item;
- let the request path **queue** work only;
- keep heavy parsing off page and authoring requests.

### When to use

MAG `#N` add-ons need automatic XenForo Jobs that must not collide (analysis, acquisition, rebuild-style work) and must not block HTTP.

### Key constraints

- unique identity ≠ automatic execution;
- authoring/page success must not depend on job completion unless product Architecture requires a blocking contract;
- per-item failure must not fail unrelated items or the host content save;
- do not invent a second queue beside XenForo Jobs for the same work.

### Why it is safer / maintainable

Automatic work actually runs. HTTP stays bounded. Retry/unique keys prevent duplicate workers for the same item.

### Proven MAG evidence

#5 Viewer Item Source analysis uses `enqueueUnique(..., false)` so analysis is automatic; page/authoring only enqueue; malformed items fail in the job without breaking the viewer.

Limitations / revalidation boundary:

Revalidate `XF\Job\Manager::enqueueUnique()` signature and default `$manual` against the **installed** XenForo source before reuse. Do not assume other frameworks share this default. Numeric `jobMaxRunTime` values are environment/config, not Global defaults.

Related: [Stale unique-job recovery when the job row is missing](#stale-unique-job-recovery-when-the-job-row-is-missing).

---

## Batch-prewarm sidecar TO_ONE relations with authoritative hydrated null

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** Performance/UX P1; XenForo 2.3 entity relations on hot render paths

Source context:
- `XFRM3DModel / docs/P05__3DR__AUDIT.md` (Performance/UX)
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`
- related Global entry: [Request-level reuse and bounded background work](#request-level-reuse-and-bounded-background-work)

### Problem

A render loop that loads parent entities and then calls `findOne()` / `getBy*Id()` per child for each sidecar TO_ONE relation (analysis row, derivative row, optional profile, similar) scales as **O(items)** queries even when the parent batch was already identified.

A second failure mode: after eager-loading a TO_ONE relation as `null`, code that treats “not loaded” the same as “not queried” may issue another `findOne()` and waste a query per parent.

### Pattern / rule

On the **hot path** (page render, thread expansion, version view):

1. batch-collect the child entity IDs needed for the response;
2. eager-load sidecar TO_ONE relations in the same repository/query batch (`with()`, `fetch()` + hydrate, or equivalent);
3. consume the already-hydrated relation in services/getters;
4. treat an **eager-loaded `null`** as authoritative absence — do not re-query merely because the relation is empty.

Keep isolated `getBy*Id()` fallbacks only for **non-prewarmed** call sites (admin tools, one-off APIs, rare paths) and verify them separately.

### When to use

MAG `#N` add-ons attach optional per-item sidecar rows to entities already loaded in a loop (ViewerItem → analysis/asset, ModelSet → presentation profile, similar).

### Key constraints

- prewarm only relations actually needed for the response payload;
- `array_key_exists` / `hasLoadedRelation()` (or equivalent) must distinguish “loaded null” from “not loaded”;
- do not change payload shape or ACL semantics to save queries;
- isolated paths must remain correct when prewarm did not run.

### Why it is safer / maintainable

Render cost becomes bounded by batch size, not per-item fan-out. Negative (no row) outcomes stop generating repeat queries.

### Proven MAG evidence

#5 batches `SourceAnalysis` and `ViewerAsset` on ViewerItem loads for forum/XFRM payload build; `PresentationProfileService` treats eager `null` as authoritative.

Limitations / revalidation boundary:

Relation names, repository methods, and `with()` syntax are XenForo-version-specific. Do not copy #5 table or class names as Global requirements. Revalidate against installed XenForo entity APIs.

---

## Visibility-bounded render lifecycle

Status: **Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** Performance/UX P2; browser client viewers

Source context:
- `XFRM3DModel / docs/P05__3DR__AUDIT.md` (Performance/UX)
- related Global entry: [One WebGL context per logical viewer group](#one-webgl-context-per-logical-viewer-group)

### Problem

A GPU-backed viewer that keeps an always-on animation/render loop for every mounted instance wastes CPU/GPU when many viewers exist off-screen (thread pages, long resource views). Destroying and recreating the renderer on every scroll boundary adds churn and fights the one-context-per-group rule.

### Pattern / rule

For lazy-initialized client viewers that use a persistent renderer/context:

1. **lazy-init** on first need (viewport proximity or explicit user action);
2. **keep** the renderer/context alive while the element remains mounted;
3. **pause** the render/animation loop when off-screen (for example `IntersectionObserver`, visibility API, or equivalent);
4. **resume** on re-entry and on direct user interaction with the control surface;
5. **dispose** only on true teardown (navigation away, element removal, explicit `stop()`), not on every off-screen transition.

Do not run unbounded `requestAnimationFrame` (or equivalent) for off-screen instances.

### When to use

MAG surfaces may mount multiple GPU viewers on one page and only a subset are visible at once.

### Key constraints

- complements [One WebGL context per logical viewer group](#one-webgl-context-per-logical-viewer-group) — pause/resume is not a substitute for per-item context disposal on switch;
- stale async load tokens and resource disposal on item switch remain required;
- if the framework removes the DOM node without calling handlers, pair with [Explicit client teardown when framework elements lack destructors](#explicit-client-teardown-when-framework-elements-lack-destructors).

### Why it is safer / maintainable

Idle work drops sharply without sacrificing fast re-display when the user scrolls back.

### Proven MAG evidence

#5 Model Set viewer pauses rAF off-screen via `IntersectionObserver` while retaining one `WebGLRenderer` per group.

Limitations / revalidation boundary:

Engine-specific (Three.js or other). Thresholds, `rootMargin`, and observer availability are implementation choices, not Global defaults.

---

## XenForo in-place overlay body replacement

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** Performance/UX P3 and Hardening H3; XenForo 2.3 `XF.AjaxSubmit`

Source context:
- `XFRM3DModel / docs/P05__3DR__AUDIT.md` (Performance/UX, Hardening)
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`

### Problem

Multi-step AJAX forms inside XenForo overlays default to `XF.showOverlay()` for each server reply. Without an explicit replace target, each step stacks a child overlay, leaves stale hidden containers, and breaks in-flow error UX when controllers return native `$this->error()`.

### Pattern / rule

For multi-step in-overlay flows (authoring, review, confirm):

1. declare `data-replace` on the form so the reply replaces an **in-overlay body wrapper** (not the whole document);
2. set `data-show-replacement="false"` when the default fade would briefly duplicate the replace target;
3. return the next step (including validation errors) as the **same overlay view** with replace metadata — avoid native `$this->error()` child overlays for expected in-flow failures;
4. scope the replace selector to the active overlay container when ancestors are not reachable from `querySelector` inside the form.

Pending browser `File` inputs cannot survive a server-driven replace; disclose that constraint in copy when source switching or step replace clears selection.

### When to use

MAG `#N` add-ons implement wizard-style AJAX steps inside XenForo public or admin overlays.

### Key constraints

- replace target must be stable across steps;
- security, ACL, and host-native file authority unchanged;
- error replies must preserve enough posted state to correct and retry (review items, selection keys, similar);
- do not invent a parallel modal system when XenForo overlay + `data-replace` suffices.

### Why it is safer / maintainable

One active overlay container, predictable focus/history, and errors stay in the same flow.

### Proven MAG evidence

#5 authoring uses `data-replace` on `.js-magXfrm3dAuthoringFlow`; analyze/confirm failures route through the same overlay view instead of `$this->error()`.

Limitations / revalidation boundary:

Revalidate against installed XenForo `XF.AjaxSubmit` / overlay behavior on the target XenForo version. Selector class names and template hooks are product-local.

---

## ACL-safe public counters and lists

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** ASC-B3; public profile list, public totals, forum postbit counts

Source context:
- `XFRM3DModel / docs/P05__3DR__Architecture.md` (§27.10)
- `XFRM3DModel / docs/P05__3DR__TZ.md` (§25.27)
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`

### Problem

Reusing an unrestricted admin finder or a raw `COUNT(*)` for public surfaces (profile tab, postbit statistic, widgets) leaks existence of content the current visitor cannot view. Computing ACL per row inside a template loop does not scale and is easy to get wrong across surfaces.

A second failure mode: a derived counter (postbit badge fed from a batch prewarm) silently falls back to a per-request query on surfaces that did not run the prewarm, changing cost and sometimes semantics.

### Pattern / rule

For every **visitor-visible** list or count:

1. centralize predicates in one service/query used by **all** public surfaces that must agree (list, total, grouped count);
2. key caches by visitor identity **and** permission context (for example `user_id` + `permission_combination_id`);
3. keep administrator/unrestricted totals separate — never expose ACP totals on public templates;
4. for derived counters that depend on batch prewarm, expose a **cache-only** getter on unbatched surfaces (omit the statistic) rather than an silent on-demand fallback query.

### When to use

MAG `#N` add-ons show per-user or per-author statistics drawn from managed content governed by XenForo node/category/resource visibility.

### Key constraints

- “equivalent visibility semantics” across profile and postbit is a product requirement when both exist;
- batched `GROUP BY` counts must use the same WHERE predicates as the list finder;
- do not denormalize a globally visible total if visibility is visitor-specific.

### Why it is safer / maintainable

Security and performance stay aligned; one predicate change updates every public surface.

### Proven MAG evidence

#5 `VisibleManagedModelQuery` powers profile list/total and batched postbit counts; postbit uses a prewarmed cache-only getter omitted elsewhere.

Limitations / revalidation boundary:

Forum vs XFRM predicate details are product Architecture. Revalidate against installed XenForo/XFRM permission and visibility APIs.

---

## Stale unique-job recovery when the job row is missing

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** Hardening H2; XenForo `xf_job.unique_key`

Source context:
- `XFRM3DModel / docs/P05__3DR__AUDIT.md` (Hardening)
- related Global entry: [XenForo unique Job enqueue defaults to manual](#xenforo-unique-job-enqueue-defaults-to-manual)

### Problem

Guarding `enqueueUnique()` with “skip if status is `queued`/`processing`” prevents duplicate jobs but leaves rows stuck when the matching `xf_job` row was cancelled, deleted, or never created (PHP abort, manual job delete, failed enqueue).

### Pattern / rule

Before skipping re-enqueue for `queued`/`processing` state:

1. resolve the expected `xf_job` row by the same **unique key** used for `enqueueUnique()`;
2. if the unique job **still exists** → keep the skip (no duplicate);
3. if the unique job is **absent** → fall through to the normal enqueue path (reset to `queued`, call `enqueueUnique()` with the same key).

Keep fingerprints, payloads, ACL, and idempotent `run()` behavior unchanged.

### When to use

MAG `#N` add-ons track per-item background work in entity state **and** XenForo unique Jobs.

### Key constraints

- do not create duplicate unique jobs when the row still exists;
- recovery must be safe to run repeatedly;
- missing attachment / invalid item paths remain skip-or-fail in `run()`, not enqueue storms.

### Why it is safer / maintainable

Public “stuck processing” UI recovers without admin DB surgery.

### Proven MAG evidence

#5 `UniqueJobPresence` wraps `jobManager()->getUniqueJob()` before analysis/asset enqueue skip.

Limitations / revalidation boundary:

Revalidate `getUniqueJob()` / unique key format against installed XenForo. Table/column names are illustrative.

---

## Explicit client teardown when framework elements lack destructors

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 XFRM 3D Model** Hardening H1; XenForo 2.3 `XF.Element` handlers; in-page HTML replacement

Source context:
- `XFRM3DModel / docs/P05__3DR__AUDIT.md` (Hardening, viewer lifecycle)

### Problem

XenForo `XF.Element` handlers expose `init()` but no destructor. When AJAX or template replacement removes a managed DOM node, WebGL contexts, observers, timers, and in-flight loaders may outlive the node unless an existing `stop()` (or equivalent) is invoked.

### Pattern / rule

When a client handler owns GPU resources, observers, or cancellable async work:

1. implement a single idempotent `stop()` (or equivalent) that disposes resources and invalidates in-flight tokens;
2. register the active handler while mounted;
3. on DOM removal (`!element.isConnected`), call the existing `stop()` — typically via one shared `MutationObserver` on a stable ancestor;
4. do not duplicate disposal logic outside `stop()`;
5. pair with [Visibility-bounded render lifecycle](#visibility-bounded-render-lifecycle): off-screen pause is not teardown.

### When to use

MAG `#N` add-ons attach long-lived client handlers to nodes that XenForo may replace in-page without a full navigation.

### Key constraints

- `stop()` must be safe to call twice;
- full document navigation remains safe without special casing;
- do not unregister listeners that die with the removed node unless they hold process-wide resources.

### Why it is safer / maintainable

Prevents orphan GPU/work leaks on common XenForo AJAX update paths.

### Proven MAG evidence

#5 `magViewerRemoval` calls existing viewer `stop()` when the handler target disconnects.

Limitations / revalidation boundary:

Observer placement and handler registration are implementation details. Revalidate XenForo element lifecycle on the target version.

---

## Presentation suppression only when an equivalent managed surface exists

Status: **Reusable Pattern** (narrow UI integration rule)

Verified scope: **#5 XFRM 3D Model** ASC-B4 Forum attachment list presentation

Source context:
- `XFRM3DModel / docs/P05__3DR__TZ.md` (§25.20)
- `XFRM3DModel / docs/P05__3DR__Architecture.md`

### Problem

Hiding native host attachments globally to avoid duplicate presentation can remove files the visitor still needs (sidecars, dependencies, unrelated downloads) or hide content when MAG does not yet expose an equivalent viewer/download surface.

### Pattern / rule

Suppress native presentation of a host file **only when**:

1. MAG already exposes an equivalent managed primary surface for that same native attachment (or an explicitly mapped primary in the viewer payload); and
2. the visitor can still access required package members through the managed surface per product Architecture.

Do not hide host files merely because MAG could manage them in theory. Defer suppression for sidecar/dependency identities until package membership is explicit.

### When to use

MAG adds its own viewer or download UI alongside native XenForo attachment lists.

### Key constraints

- native attachment bytes and ACL remain authoritative;
- suppression is presentation-only unless Architecture explicitly migrates ownership;
- admin and unrelated host workflows must remain intact.

### Why it is safer / maintainable

Avoids duplicate UI without breaking package completeness or native download paths.

### Proven MAG evidence

#5 Forum `post_macros` hides attachment IDs present in `MagXfrm3dViewerPayload` managed primaries only; XFRM native download list unchanged; sidecar hiding deferred.

Limitations / revalidation boundary:

Template hook names and payload fields are product-local. This rule does not mandate hiding; it bounds when hiding is safe.

---

## One canonical client-side managed refresh implementation

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 Beyond 3D Viewer** `1.0.4` / `1000195` supporting-document and model managed-HTML refresh; XenForo 2.3 public JS

Source context:
- `Beyond3DViewer / docs/P05__3DR__AUDIT.md` (1.0.4 stabilization)
- `Beyond3DViewer / docs/P05__3DR__CLASS_MAP.md`
- `Beyond3DViewer / src/addons/MAG/Beyond3DViewer/_files/js/MAG/Beyond3DViewer/authoring.js`
- `Beyond3DViewer / src/addons/MAG/Beyond3DViewer/_files/js/MAG/Beyond3DViewer/supporting.js`

### Observed behavior

Multiple call sites (supporting overlay XF.ajax and authoring `ajax-submit:response`) consume the same server JSON keys. Two independent DOM-replacement implementations against that contract diverged in risk: a later JSON or markup change would update one path and leave the other producing duplicate hosts, missed native-row filtering, or a no-op.

### Pattern / conclusion

Multiple call sites may exist. DOM mutation logic should have **one** canonical implementation. Do not keep a second independent fallback that consumes the same server JSON contract unless runtime inspection proves it is required. Call sites should delegate to the canonical helper and only use a non-HTML attachment-manager sync when the HTML keys are absent.

### Limitations / revalidation boundary

Product-local helper names, CSS hosts, and JSON keys are not Global requirements. Separate call sites can still fire twice on one response; unifying *implementations* does not automatically collapse *call sites*. Revalidate against the installed XenForo overlay/ajax-submit behavior.

---

## Diagnose editor bootstrap layout shift at the collapsing ancestor

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 Beyond 3D Viewer** XFRM Resource Edit Froala/editor bootstrap; XenForo 2.3 overlay edit

Source context:
- `Beyond3DViewer / docs/P05__3DR__AUDIT.md` (Known Fragile Areas)
- `Beyond3DViewer / src/addons/MAG/Beyond3DViewer/_data/templates.xml`

### Observed behavior

Editor initialization collapsed an ancestor row and shifted later MAG controls. Hiding the downstream MAG actions masked the movement without fixing the collapsing element.

### Pattern / conclusion

Do not hide downstream controls to mask FOUC/layout shift. Measure the element whose height actually collapses. Reserve or layout correction belongs at that structural ancestor. Keep the correction scoped to the verified host/surface.

### Limitations / revalidation boundary

Pixel floors, class names, and which XenForo editor surface collapses are product-local. Do not promote a numeric reserve height into a Global rule. Revalidate when the host template or editor chrome changes.

---

## Do not use editor lifecycle hooks merely to hide initialization layout movement

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 Beyond 3D Viewer** Resource Edit editor bootstrap; XenForo 2.3 Froala / overlay edit

Source context:
- `Beyond3DViewer / docs/P05__3DR__AUDIT.md` (1.0.4 stabilization / FOUC)

### Observed behavior

Re-entrant editor timing or reveal hooks used only to hide initialization movement interfered with native editor bootstrap.

### Pattern / conclusion

Do not use editor lifecycle/reveal hooks merely to hide initialization layout movement. Preserve native lifecycle unless the integration actually requires a hook for a functional contract (save, replace target, ACL), not for cosmetic shift masking.

### Limitations / revalidation boundary

Does not forbid legitimate editor integration hooks. Revalidate against the installed editor and overlay version.

---

## Explicit browser-static-asset deployment boundary

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 Beyond 3D Viewer** XenForo 2.3 add-on `_files` vs live `js/` tree; `xf-addon:rebuild`

Source context:
- `Beyond3DViewer / docs/P05__3DR__AUDIT.md` (Known Fragile Areas)
- `Beyond3DViewer / docs/P05__3DR__CLASS_MAP.md`

### Observed behavior

`xf-addon:rebuild` updates addon data/templates but does not publish browser-served JS from `_files` into the web-accessible `js/` path used by the live board. Repo `_files`, live addon `_files`, and `www/js` can silently diverge.

### Pattern / conclusion

When addon rebuild does not publish browser-served assets, source/release `_files` and runtime `www/js` are distinct deployment surfaces. Deployment must copy and verify hashes explicitly. Do not assume rebuild equals browser-asset publish.

### Limitations / revalidation boundary

XenForo `js/` vs `_files` layout is version- and install-specific. Revalidate against the target board’s `development.js` / hashed JS mode. This does not replace `build.json` `additional_files` for packaged releases.

---

## Separate host eligibility from effective feature enablement

Status: **Verified Fact / Reusable Pattern**

Verified scope: **#5 Beyond 3D Viewer** Forum node / XFRM category MAG enablement; ContentGate

Source context:
- `Beyond3DViewer / docs/P05__3DR__Architecture.md`
- `Beyond3DViewer / docs/P05__3DR__AUDIT.md` (Known Fragile Areas)

### Observed behavior

Whether MAG applies to a host/content domain at all is a different question from the tri-state `inherit` / `enabled` / `disabled` effective runtime inside eligible scope. Using one as a substitute for the other mis-diagnoses empty payloads, missing authoring buttons, and permission checks.

### Pattern / conclusion

Eligibility answers whether MAG applies to the host/content domain at all. Effective `inherit` / `enabled` / `disabled` answers runtime state inside eligible scope. Do not use one concept as a substitute for the other.

### Limitations / revalidation boundary

Column names, cache fields, and ContentGate class names are product-local. Revalidate against the current enablement rebuild path.

---

## Partial add-on `_output` is unsafe as a development import source

Status: **Verified Fact / Reusable Pattern / Needs Revalidation**

Verified scope: **#5 Beyond 3D Viewer; XenForo 2.3.12; `development.enabled = true`; `xf-addon:rebuild MAG/Beyond3DViewer -n`**

Source context:
- `#5` live repair: incomplete `src/addons/MAG/Beyond3DViewer/_output` after an isolated ACP/template export
- restoration from add-on `_data/templates.xml` after deleting the incomplete `_output` tree
- this does **not** assert a confirmed XenForo vendor bug; it records a MAG development-mode workflow hazard

Observed behavior:

With XenForo development mode enabled, a partial add-on `_output` tree existed and contained only one template (`public/mag_xfrm3d_presentation_overlay.html`). `xf-addon:rebuild` followed the development import path (`xf-dev:import`) rather than the approved `_data` XML path. That partial tree became the authoritative development import source. Add-on templates absent from `_output` were orphaned/removed from live XenForo. `public:mag_xfrm3d_viewer` became unknown. After the incomplete `_output` was deleted, rebuild from `_data/templates.xml` restored all 34 MAG templates.

This is a dangerous development-mode workflow condition: presence of `_output` is enough to change the rebuild/import source, even when that tree is incomplete.

Pattern:

In XenForo development mode, a partial add-on `_output` tree may become the authoritative development import source. A rebuild/import can therefore remove add-on development data that is absent from that partial tree. Before rebuild/import, verify `_output` completeness or deliberately use the approved `_data` path. Do not assume a partial ACP-generated `_output` tree is safe.

Operational checks that match this finding:

1. Before `xf-addon:rebuild` / `xf-dev:import`, inspect whether `src/addons/<Vendor>/<AddOn>/_output` exists.
2. If it exists, confirm it is a complete approved development export, not a single-template ACP save.
3. If `_output` is absent, keep it absent unless a complete approved export is intentionally required.
4. Do not ACP-save/export one isolated template as a substitute for `_data` completeness.
5. After rebuild, verify expected template titles remain registered (including host-included public templates).

Limitations / revalidation boundary:

Verified on XenForo 2.3.12 with `development.enabled = true` for one MAG add-on. Do not treat this as a confirmed XenForo vendor defect unless installed XenForo source and a controlled reproduction prove product-level incorrectness. Revalidate the actual `xf-addon:rebuild` / `xf-dev:import` source-selection path on the target XenForo version before relying on this in another environment. Template counts and titles are project-local evidence, not a portable quota.

---

## Source map

This knowledge base was extracted from approved Global documentation plus verified project documentation.

Global authority reviewed:

- `MAG_ECOSYSTEM.md`
- `AI_GUIDELINES.md`
- `AI_AGENTS_RULES.md`

Project evidence reviewed:

- `GlobalLinksFavicons / P01__GLF__TZ.md`
- `GlobalLinksFavicons / docs/P01__GLF__Roadmap.md`
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / docs/P01__GLF__CLASS_MAP.md`
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`
- `GlobalLinksFavicons / docs/P01__GLF__Overview.md`
- `GlobalLinksFavicons / P01__GLF__README.md`
- `XFRM3DModel / research/core-3d-pipeline-benchmark/` (pattern evidence only; not product requirements)
- `XFRM3DModel / docs/P05__3DR__AUDIT.md`
- `XFRM3DModel / docs/P05__3DR__TZ.md` (accepted Increments 1–11)
- `XFRM3DModel / docs/P05__3DR__Architecture.md`
- `XFRM3DModel / docs/P05__3DR__CLASS_MAP.md`
- `XFRM3DModel / docs/P05__3DR__Changelog.md`
- `XFRM3DModel / docs/P05__3DR__IDEA.md` (local candidate list; Global promotion 2026-09-16)

Later addition (2026-09-16): reusable patterns from accepted `#5` Increments 1–11 (URI map, native-option ownership, host adapters, explicit confirmation, shared dependency parsing, batch confirmation, one WebGL context per group, nullable metrics, source vs derivative metric domains, `enqueueUnique()` manual default). Not promoted from that work: provisional complexity thresholds, product-specific Model Info UX, unimplemented ViewerAsset/optimization/rebuild, format roadmap, research candidates.

Later addition (2026-09-17): reusable patterns from accepted `#5` Performance/UX, ASC-B3/B4, and Hardening (ORM sidecar prewarm + hydrated null, visibility-bounded render lifecycle, XenForo in-place overlay replacement, ACL-safe public counters/lists, stale unique-job recovery, explicit client teardown, narrow presentation-suppression rule). Validation discipline (call-site audit, click-path + invariant regression) recorded in `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md` Phase 7. Not promoted: measured-optimization-only wording, deterministic fixture setup, Inc 12/13 storage/import lessons, small XenForo facts already covered elsewhere.

Later addition (2026-09-20): reusable patterns from `#5` `[MAG] Beyond 3D Viewer` `1.0.4` stabilization (canonical managed-HTML client refresh, editor-bootstrap layout diagnosis at the collapsing ancestor, no cosmetic editor-lifecycle masking, explicit `_files` vs `www/js` deployment boundary, eligibility vs effective enablement). Current #5 repository is `Beyond3DViewer`; historical capture paths below that say `XFRM3DModel` remain the original evidence locations from those dates.

Later addition (2026-09-21): development-mode hazard that a partial add-on `_output` tree can become the authoritative `xf-dev:import` source during `xf-addon:rebuild`. Recorded as a MAG workflow hazard, not as a confirmed XenForo vendor bug.

Excluded from this initial extraction:

- planned 1.5.0+ behavior that has not been implemented;
- project-specific product requirements that do not generalize;
- historical behavior already disproved by later real-environment verification, except where retained as a compatibility warning;
- rules already owned by Global governance documents;
- undocumented XenForo behavior not supported by the reviewed sources;
- #2 implementation/audit findings, because this pass was intentionally limited to GLOBAL + #1.

## Maintenance rule

Add a new entry only when it has a useful reuse case and a traceable source.

When adding or updating an entry:

- keep the entry focused;
- record status;
- record verified scope;
- identify source project/document;
- distinguish reusable principle from project-specific numeric values or requirements;
- downgrade to `Needs Revalidation` when framework/version behavior may have changed;
- remove or correct an entry when later verified evidence disproves it;
- do not convert this document into a second copy of Global process rules or project architecture.

Follow the [Capture procedure](#capture-procedure) before adding or materially updating an entry.

### Entry structure

Each knowledge entry should use this structure unless a narrow topic genuinely needs a shorter form:

1. **Title** — concise, searchable topic name.
2. **Status** — one or more labels from the status model.
3. **Verified scope** — project marker, XenForo/XFRM versions, release or environment boundary.
4. **Source context** — authoritative project or Global documents that contain the evidence.
5. **Observed behavior** — what was verified, not what was assumed.
6. **Pattern / conclusion** — the reusable principle or fact future work may apply.
7. **Limitations / revalidation boundary** — when the entry must not be generalized or must be reverified.

After adding a new entry, add it to the [Index](#index).
