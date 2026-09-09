# MAG Implementation Patterns

- MAG-Document-ID: `MAG_IMPLEMENTATION_PATTERNS.md`
- MAG-Content-Updated: `2026-09-08T00:11:06+03:00`

Reusable, source-backed implementation knowledge for MAG development.

This document is a Global knowledge base. It does not define product requirements and does not replace:

- `MAG_ECOSYSTEM.md`
- `AI_GUIDELINES.md`
- `AI_AGENTS_RULES.md`
- `CURSOR_USAGE_ANALYTICS.md`
- `MAG_ADDON_DEVELOPMENT_LIFECYCLE.md`
- any active project `TZ`, `Roadmap`, `Architecture`, `CLASS_MAP`, `Changelog`, or `README`

`GLOBAL defines HOW. #N defines WHAT.`

## Usage rule

Do not read this document sequentially by default.

For a concrete task:

1. Search the Index or keywords for the relevant topic.
2. Open only the matching section.
3. Check the entry status and verified scope.
4. Reuse a pattern only when the current task matches its conditions.
5. If an entry is version-specific, project-specific, or marked `Needs revalidation`, verify the current installed XenForo source or current project implementation before relying on it.
6. If this document conflicts with authoritative Global or active-project documentation, report the conflict. Do not silently choose this document.

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

`GLOBAL defines HOW. #N defines WHAT.`

### 9. Procedure completion integration

Reusable-knowledge evaluation is a normal completion consideration for relevant MAG work. It does not require a separate Cursor procedure.

If the current approved procedure already includes Global documentation synchronization and the knowledge update is within scope, it may be recorded as part of that procedure.

If the reusable candidate is discovered while working only within an active `#N` repository and modifying `MAG-Ecosystem` would cross the approved repository/procedure scope:

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
- `GlobalLinksFavicons / docs/P01__GLF__CURSOR_USAGE_HISTORY.md`

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
- `GlobalLinksFavicons / docs/P01__GLF__CURSOR_USAGE_HISTORY.md`

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
- `GlobalLinksFavicons / docs/P01__GLF__CURSOR_USAGE_HISTORY.md`

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
- `GlobalLinksFavicons / docs/P01__GLF__CURSOR_USAGE_HISTORY.md`
- Global authority remains `AI_AGENTS_RULES.md` and `CURSOR_USAGE_ANALYTICS.md`

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

Do not split procedures mechanically when separation would increase cost without improving clarity or verification. Global Cursor workflow and model-selection rules remain authoritative.

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

## Source map

This initial knowledge base was extracted only from approved Global documentation plus verified project #1 documentation.

Global authority reviewed:

- `MAG_ECOSYSTEM.md`
- `AI_GUIDELINES.md`
- `AI_AGENTS_RULES.md`
- `CURSOR_USAGE_ANALYTICS.md`

Project #1 evidence reviewed:

- `GlobalLinksFavicons / P01__GLF__TZ.md`
- `GlobalLinksFavicons / docs/P01__GLF__Roadmap.md`
- `GlobalLinksFavicons / docs/P01__GLF__Architecture.md`
- `GlobalLinksFavicons / docs/P01__GLF__CLASS_MAP.md`
- `GlobalLinksFavicons / docs/P01__GLF__Changelog.md`
- `GlobalLinksFavicons / docs/P01__GLF__Overview.md`
- `GlobalLinksFavicons / P01__GLF__README.md`
- `GlobalLinksFavicons / docs/P01__GLF__CURSOR_USAGE_HISTORY.md`

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
