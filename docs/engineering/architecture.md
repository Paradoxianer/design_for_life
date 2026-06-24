# DFL App – Code Architecture

This document describes the **client-side code architecture** of the DFL Flutter app:
how the codebase is organised, which patterns are used, and — most importantly — **how to implement a new feature module correctly**.

For the high-level system architecture (backend, local-first strategy, sync) see
[`docs/technical/architecture.md`](../technical/architecture.md).

---

## Table of Contents

1. [Project structure](#1-project-structure)
2. [Tech stack & key packages](#2-tech-stack--key-packages)
3. [The module pattern](#3-the-module-pattern)
4. [Core abstractions](#4-core-abstractions)
5. [State management with BLoC](#5-state-management-with-bloc)
6. [Routing](#6-routing)
7. [Theming & localisation](#7-theming--localisation)
8. [How to add a new feature module](#8-how-to-add-a-new-feature-module)
9. [Known inconsistencies & open refactors](#9-known-inconsistencies--open-refactors)

---

## 1. Project structure

```
lib/
├── core/                        # Shared infrastructure – no feature logic here
│   ├── blocs/
│   │   └── entry_list_bloc.dart # Generic base BLoC for entry-list features
│   ├── models/
│   │   ├── dfl_entry.dart       # Universal entry model (text + image + metadata)
│   │   ├── editor_stage.dart    # Enum for multi-step editors
│   │   └── shareable_content.dart
│   ├── services/
│   │   └── share_service.dart   # OS share sheet + screenshot generation
│   ├── theme/
│   │   └── app_theme.dart       # Colours, typography (Playfair Display + Inter)
│   └── widgets/
│       ├── dfl_module_scaffold.dart  # ★ Outer shell for every module screen
│       ├── dfl_module_editor.dart    # ★ Abstract base for all editor widgets
│       ├── dfl_module_result.dart    # Base for result widgets (optional)
│       ├── dfl_entry_widget.dart     # Renders a single DflEntry (text + image)
│       ├── key_takeaway_field.dart   # Three key-insight text fields
│       ├── stage_header.dart         # Progress header for multi-step modules
│       ├── stage_navigator.dart      # Step navigation bar
│       ├── share_image_generator.dart
│       └── share_selection_dialog.dart
│
├── features/                    # One subdirectory per feature module
│   ├── feedback/
│   ├── goals/
│   ├── listening_prayer/
│   ├── notes/
│   ├── spiritual_gifts/
│   ├── timeline/
│   └── values/
│
├── l10n/                        # Localisation (ARB files + generated code)
│   ├── app_de.arb
│   ├── app_en.arb
│   └── generated/
│
└── main.dart                    # App entry point, BLoC providers, GoRouter setup
```

Every feature directory follows the same internal layout:

```
features/<module>/
├── bloc/
│   ├── <module>_bloc.dart
│   ├── <module>_event.dart   (omitted when using EntryListBloc)
│   └── <module>_state.dart   (omitted when using EntryListBloc)
├── models/
│   └── <module_model>.dart
├── repositories/              (optional – only when data comes from outside)
├── screens/
│   └── <module>_screen.dart
└── widgets/
    ├── <module>_editor.dart
    └── <module>_result.dart
```

---

## 2. Tech stack & key packages

| Concern | Package | Notes |
|---|---|---|
| State management | `flutter_bloc` + `hydrated_bloc` | All BLoCs persist state automatically via HydratedBloc |
| Navigation | `go_router` | Declarative, URL-based. All routes in `main.dart` |
| Persistence | `hydrated_bloc` (local JSON) | No explicit DB calls needed for most features |
| Localisation | `flutter_localizations` + ARB | Two locales: `de`, `en` |
| Fonts | `google_fonts` | Playfair Display (headings) + Inter (body) |
| Sharing | `share_plus` + `screenshot` | Via `ShareService` |
| Image input | `image_picker` | Used in DflEntryWidget |
| Equality / immutability | `equatable` | All models and states extend Equatable |

---

## 3. The module pattern

Every feature in the app follows a three-layer pattern:

```
Screen
  └── DflModuleScaffold          ← handles edit/result toggle, AppBar, Share button
        ├── Editor (edit mode)   ← extends DflModuleEditor
        └── Result (result mode) ← read-only summary view
```

**The flow a user experiences:**

1. User opens a module → starts in **edit mode** (the `Editor` widget is visible).
2. User taps the eye icon or the "Finish" button → switches to **result mode** (the `Result` widget).
3. User can tap the edit icon to return to edit mode.
4. From result mode, the user can share selected content via the share icon.

The `DflModuleScaffold` owns this toggle logic entirely. Screens do not manage edit/result state themselves.

---

## 4. Core abstractions

### `DflModuleScaffold`

The outer shell used by every module screen. It provides:

- `AppBar` with title, edit/result toggle button, and optional share button
- `AnimatedSwitcher` between the editor and result widget
- A "Finish" button footer in edit mode (or a `customFooter` for multi-step modules)
- Share dialog integration via `ShareableContent` / `onShare`

```dart
DflModuleScaffold(
  title: title,
  initialEditMode: initialEditMode,
  editor: MyEditor(...),
  result: MyResult(...),
  // Optional:
  shareableContent: shareContent,
  onShare: (selectedItems) { ShareService.shareContent(...); },
  onWillToggleMode: () async => await _validateBeforeSwitch(),
  customFooter: Row(...),  // replaces the default "Finish" button
)
```

**Do not** reproduce the edit/result toggle logic inside a screen. Always delegate to `DflModuleScaffold`.

---

### `DflModuleEditor`

Abstract base class for all editor widgets. Handles scrolling and the optional
"Key Takeaways" section at the bottom. Subclasses implement `buildContent()`.

```dart
class MyEditor extends DflModuleEditor {
  const MyEditor({
    super.key,
    required super.takeaways,
    required super.onUpdate,
    // showTakeaways defaults to true; set false if the module has no takeaways
  });

  @override
  Widget buildContent(BuildContext context) {
    // Return the module-specific content widget tree.
    // Do NOT wrap in SingleChildScrollView – the base class handles that.
    return Column(children: [...]);
  }
}
```

---

### `EntryListBloc`

A generic, reusable `HydratedBloc` for any module whose data is a list of
`DflEntry` items (text + optional image) keyed by `sessionId`, plus optional
takeaway strings. State is persisted automatically.

Built-in events: `AddEntry`, `UpdateEntryText`, `UpdateEntryImage`,
`DeleteEntry`, `ToggleEntryCompletion`, `UpdateTakeaway`.

To create a new entry-list feature, simply extend it:

```dart
class NotesBloc extends EntryListBloc {
  NotesBloc() : super();
}
```

No additional code is needed unless the feature requires custom events.

---

### `DflEntry`

The universal content model for a single list item:

```dart
DflEntry({
  required String id,    // use DateTime.now().millisecondsSinceEpoch.toString()
  String text,           // free-text content
  String? imagePath,     // local file path
  String? metadata,      // e.g. "From: Anna" for received prayer notes
  bool isCompleted,      // for checkbox-style entries
})
```

---

## 5. State management with BLoC

All BLoCs extend `HydratedBloc` – state is automatically serialised to JSON
on every emit and restored on app restart. No manual `SharedPreferences` or
file I/O needed.

**Three BLoC archetypes in use:**

| Archetype | When to use | Example |
|---|---|---|
| `EntryListBloc` subclass | Free-form entry lists with optional takeaways | `NotesBloc`, `ListeningPrayerBloc` |
| Custom `HydratedBloc` with own events/state | Structured data with specific domain logic | `GoalsBloc`, `ValuesBloc`, `SpiritualGiftsBloc` |
| Stateless (no BLoC) | Read-only content from static data | `TimelineScreen` |

**BLoC provision:** All BLoCs are provided at the root in `main.dart` via
`MultiBlocProvider`. Do not create `BlocProvider` inside individual screens.

**Accessing state in screens:**

```dart
// Read state (triggers rebuild on change):
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) { ... },
)

// Dispatch an event (no rebuild needed):
context.read<MyBloc>().add(MyEvent(...));
```

---

## 6. Routing

All routes are defined in `main.dart` using `GoRouter`. The routing convention is:

```
/<module-slug>/<sessionId>?title=<title>&mode=<edit|result>
```

The `sessionId` allows the same module (e.g. Notes) to store separate data for
each session in the weekend schedule. The `mode` parameter lets the timeline
deep-link directly to the result view of a completed module.

When adding a new module, register it in the `GoRouter` routes list in `main.dart`
and follow the existing parameter conventions.

---

## 7. Theming & localisation

### Theme

Defined in `core/theme/app_theme.dart`. The app uses **Material 3** with a
custom colour scheme seeded from `forestGreen` (`#2D5A27`).

Key colours:
- **Primary:** `forestGreen` `#2D5A27` – main actions, AppBar
- **Secondary:** `earthBrown` `#8B5E3C`
- **Tertiary:** `sunlightGold` `#F4D03F`

Typography: `Playfair Display` for display headings, `Inter` for all other text.

Always use `Theme.of(context).colorScheme.*` – never hardcode colours in widgets.

### Localisation

Strings live in `lib/l10n/app_de.arb` and `lib/l10n/app_en.arb`.
Access via:

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.finish)
```

Every user-facing string must be in the ARB files. No hardcoded German or English
strings in widget code.

---

## 8. How to add a new feature module

Follow these steps to add a module that is consistent with the rest of the codebase.

### Step 1 – Create the feature directory

```
lib/features/<module_name>/
├── bloc/
├── models/
├── screens/
└── widgets/
```

### Step 2 – Choose and implement the BLoC

**Case A – Entry-list module** (free-form notes, prayer impressions, etc.)

```dart
// bloc/<module>_bloc.dart
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';

class MyModuleBloc extends EntryListBloc {
  MyModuleBloc() : super();
}
```

**Case B – Structured module** (specific fields, domain logic)

```dart
// bloc/<module>_bloc.dart
class MyModuleBloc extends HydratedBloc<MyModuleEvent, MyModuleState> {
  MyModuleBloc() : super(const MyModuleState()) {
    on<MyEvent>(_onMyEvent);
  }

  @override
  MyModuleState? fromJson(Map<String, dynamic> json) => MyModuleState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(MyModuleState state) => state.toJson();
}
```

### Step 3 – Register the BLoC in `main.dart`

```dart
// In the MultiBlocProvider providers list:
BlocProvider(create: (context) => MyModuleBloc()),
```

### Step 4 – Implement the Editor widget

```dart
// widgets/<module>_editor.dart
class MyModuleEditor extends DflModuleEditor {
  const MyModuleEditor({
    super.key,
    required super.takeaways,
    required super.onUpdate,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        // Module-specific fields
      ],
    );
  }
}
```

### Step 5 – Implement the Result widget

A plain `StatelessWidget` that displays the saved data read-only.
If `DflModuleResult` fits, extend it; otherwise use `StatelessWidget` directly.

### Step 6 – Implement the Screen

```dart
// screens/<module>_screen.dart
class MyModuleScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const MyModuleScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyModuleBloc, MyModuleState>(
      builder: (context, state) {
        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          editor: MyModuleEditor(
            sessionId: sessionId,
            takeaways: state.takeaways[sessionId] ?? const ['', '', ''],
            onUpdate: (index, value) {
              context.read<MyModuleBloc>().add(UpdateTakeaway(sessionId, index, value));
            },
          ),
          result: MyModuleResult(
            data: state.data[sessionId],
          ),
        );
      },
    );
  }
}
```

### Step 7 – Register the route in `main.dart`

```dart
GoRoute(
  path: '/my-module/:sessionId',
  builder: (context, state) {
    final sessionId = state.pathParameters['sessionId']!;
    final title = state.uri.queryParameters['title'] ?? 'My Module';
    final mode = state.uri.queryParameters['mode'];
    return MyModuleScreen(
      sessionId: sessionId,
      title: title,
      initialEditMode: mode != 'result',
    );
  },
),
```

### Step 8 – Add to the timeline

Add a `DflSession` entry in
`lib/features/timeline/models/static_timeline_data.dart` with the matching
route path.

### Step 9 – Add strings to ARB files

Add any new user-facing labels to both `app_de.arb` and `app_en.arb` and
regenerate via `flutter gen-l10n`.

---

## 9. Known inconsistencies & open refactors

These are tracked issues. Until resolved, follow the **recommended** approach described
in this document, not the pattern in the affected files.

| Issue | Affected files | Recommended fix |
|---|---|---|
| `NotesScreen` and `ListeningPrayerScreen` duplicate ~80% of their code | Both screen files | Extract a generic `EntryListScreen` parameterised by BLoC type and label config |
| `GoalsEditor` receives an empty `onUpdate: (i, v) {}` callback | `goals_screen.dart`, `goals_editor.dart` | Either route updates through the callback consistently, or remove the parameter from `GoalsEditor` if it dispatches directly |
| `GoalsBloc` has its own full Bloc/Event/State rather than inheriting `EntryListBloc` | `features/goals/bloc/` | Evaluate whether `Goal` data can be modelled as `DflEntry` with metadata, enabling `EntryListBloc` reuse |
| No `///` docstrings on core classes | `core/` | Add Dart doc comments to `EntryListBloc`, `DflModuleScaffold`, `DflModuleEditor`, `DflEntry` |
