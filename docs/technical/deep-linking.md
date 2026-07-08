# Deep Linking – URL Scheme

**Status:** Implemented (Phase 6, #49 / #42).
**Code:** `lib/core/services/deep_link_service.dart` (parsing), `lib/main.dart` (`_handleDeepLinkAction`, dispatch/navigation).

## Why this exists

The app has no backend (see `docs/technical/architecture.md` for the aspirational backend design - none of it exists today; state is 100% local via `hydrated_bloc`). Deep links are therefore the only way to hand the app external context - which modules to show, or an external assessment's answers - without a server in between. Everything a link carries has to fit in the URL itself.

## Base URL

Links are built on **`https://paradoxianer.github.io/design_for_life/`** (`DeepLinkService.webLinkBase`), the GitHub Pages build auto-deployed on every push to `main` (`.github/workflows/deploy.yml`). This is a deliberate "for now" choice:

- No app-store presence yet, so there's nothing for a native install link to open on most recipients' phones.
- No real Android `applicationId` or release-keystore SHA256 fingerprint, and no real iOS bundle id / Apple Team ID yet (still Flutter template placeholders, see #37) - both are prerequisites for real, OS-verified Universal/App Links.
- A plain `https://` link to the web build works everywhere immediately: click it, it opens in a browser, no install/verification required.

The custom scheme `dfl://open?...` is also registered (Android intent-filter, iOS `CFBundleURLTypes`) and parsed identically, for whenever native distribution exists. Swap `webLinkBase` (and the link builders that use it) over once that's in place.

## Supported schemes

`DeepLinkService.parse(Uri uri)` accepts `dfl`, `http`, and `https` - anything else is ignored (returns `null`).

`http`/`https` support isn't just about the production base URL above - it's also what makes the whole flow testable locally. On Flutter Web, the `app_links` package has no OS-level deep-link event to listen to; `app_links_web` simply reports the page's own `window.location.href` once, at load. So running `flutter run -d chrome` and pasting a URL with the right query string into the address bar (full navigation, i.e. press Enter - editing a route within the already-loaded app does *not* re-trigger this) reproduces exactly the same code path a real link tap would. On Android/iOS, `https://` is currently unreachable in practice, since only the `dfl://` scheme has an intent-filter/URL type registered - no `https` Associated Domains/App Links entry exists yet (blocked on #37 for the reasons above).

## Actions

All actions are read from the URL's **query parameters**, regardless of scheme/host/path.

### 1. Restrict visible timeline modules

```
?modules=session_1,session_3&date=2026-08-01&location=Tagungshaus
```

| Param | Required | Notes |
|---|---|---|
| `modules` | yes | Comma-separated `DflSession.id` values. Whitespace around entries and empty entries are trimmed/dropped. |
| `date` | no | Free-form string, shown as-is under the timeline header. |
| `location` | no | Free-form string, shown as-is under the timeline header. |

**Semantics - not a lock, a filter.** Handled by `TimelineModuleFilterBloc` (`SetAllowedModules` event). If `modules` is ever provided, the timeline shows **only** those sessions - everything else is simply absent, not shown as a greyed-out/locked placeholder. The point of a "stripped-down DFL" is that people don't need to know what else they could have filled out. Without ever receiving such a link, the full timeline shows as normal (`allowedSessionIds == null`).

Each new link **replaces** the previous restriction; it does not merge with it. `date`/`location` persist independently if a later link omits them.

Persisted via `hydrated_bloc`, so the restriction survives app restarts.

### 2. Invite an external "Referenz" assessment (#42)

```
?flow=gift-reference&assessmentId=ref_1735689600000000
```

Opens `GiftReferenceScreen`, a standalone mini-flow showing only the spiritual-gifts test's R-type ("Referenz") questions for the reviewer to answer about someone else. Does **not** touch the reviewer's own `SpiritualGiftsBloc`/self-assessment state (see `GiftReferenceAnswerBloc`, keyed by `assessmentId`, kept entirely separate).

`assessmentId` has no required format; the app generates `ref_<microsecondsSinceEpoch>` when building the invite link (`GiftReferenceLinkService.buildInviteLink`), just used as an opaque key so multiple concurrent references don't collide.

### 3. Import a "Referenz" result (#42)

```
?flow=gift-reference-result&assessmentId=ref_1735689600000000&answers=36:503021...&label=Anna
```

| Param | Required | Notes |
|---|---|---|
| `assessmentId` | yes | Must match the id from the invite link, so the answers land under the right entry. |
| `answers` | yes | `count:digits` - see encoding below. |
| `label` | no | Optional reviewer-entered display name, shown only to the inviter locally. |

Decoded via `GiftReferenceLinkService.decodeAnswers` (needs the current gifts data for the question order - loaded fresh via `GiftsRepository`, not through the shared `SpiritualGiftsBloc`, so this never disturbs an in-progress self-assessment on the importing device either). On success, dispatches `SubmitReferenceAssessment` to `SpiritualGiftsBloc` and navigates to the gifts result screen.

#### Answers encoding

One digit (`0`-`5`) per R-type question, in the deterministic order `SpiritualGiftsState.getReferenceQuestionOrder()` produces (gifts in JSON file order, then each gift's R-questions in their JSON order), prefixed with the question count:

```
36:5030211453...
^  ^
|  36 characters, one per question, 'x' = unanswered
count (must equal questionOrder.length on decode, else the payload is rejected)
```

Chosen over JSON/base64 for size (no backend to fall back on, so this has to travel through a URL/share-sheet message) and because it needs no extra encoding step (digits are already URL-safe). The leading count is a cheap guard against decoding against a mismatched question set (e.g. gifts data changed between invite and import) - a mismatch returns `null` rather than silently misassigning scores to the wrong questions.

## Testing locally

```
flutter run -d chrome --web-port=8901
```

Then, in the address bar (full navigation - type/paste and press Enter):

- Module filter: `http://localhost:8901/?modules=session_1&date=2026-08-01&location=Testort`
- Gift-reference invite: `http://localhost:8901/?flow=gift-reference&assessmentId=test1`
- Gift-reference result import: complete the mini-flow above, copy everything **after the `?`** from the generated link, and paste it after `http://localhost:8901/?` instead (the generated link itself uses the production `https://paradoxianer.github.io/...` host, which isn't your local build).

## Known limitations / future work

- **Replace, not merge**, for the module filter (see above) - if a multi-stage program needs an *additive* model (e.g. a second link should add sessions without dropping the first link's set), this needs to change.
- **No real Universal/App Links** until #37 (real Android `applicationId` + release signing, real iOS bundle id + Apple Team ID) is resolved.
- **No server-side validation of anything** - `modules`/`answers`/`assessmentId` are trusted client-side. Fine for this app's stakes (no monetization/access-control gating), but worth remembering if that ever changes.
