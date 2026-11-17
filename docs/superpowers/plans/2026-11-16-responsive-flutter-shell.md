# Responsive Flutter App Shell Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish Poket's responsive Flutter shell for iOS, Android and web, with the five documented destinations and honest placeholder states.

**Architecture:** Use Flutter's Material 3 widgets, Riverpod for app-level navigation state and dependency composition, and the documented feature-first directory boundaries. Use Flutter's built-in Navigator APIs; do not add a routing package. Keep setup, authentication, finance data and tax rules outside this shell slice.

**Tech Stack:** Installed Flutter 3.44.8 / Dart 3.12.2, `flutter_riverpod` (required by the architecture), Flutter SDK localization generation, Material 3.

**Spec:** `docs/UX_PRODUCT_DESIGN.md`, `docs/ARCHITECTURE.md`, `docs/PRODUCT_REQUIREMENTS.md`, `docs/ROADMAP.md`, `docs/SECURITY_PRIVACY.md`.

## Global Constraints

- Keep the app responsive and adaptive across iOS, Android and web.
- Primary destinations are Home, Transactions, Tax, Wallets and Settings.
- Use Riverpod; do not add Provider, Bloc or `go_router`.
- Keep selected destination state in Riverpod and synchronize it with Flutter's route information so web deep links and browser history work.
- Keep widgets free of persistence, tax-rule, financial arithmetic and encryption logic.
- Do not log or include real financial data, secrets or personal identifiers.
- Use Poket's approved calm teal and warm-neutral direction, light/dark themes, and system typography.
- Do not represent proposed stack choices or unresolved Phase 0 gates as validated or shipped capabilities.

## Review Focus

- Narrow viewport: navigation remains usable without clipping or hiding a destination.
- Tablet/desktop viewport: content remains readable and avoids stretching across the full screen.
- Keyboard and assistive technology: destination selection is named, focusable and announced.
- Dark theme and text scaling: shell controls and placeholder states remain legible.
- Browser refresh/deep link: the app starts in a valid destination without claiming persistence or authentication.

---

### Task 1: Add the Flutter project foundation and localization

**Files:**
- Create: `pubspec.yaml`, `analysis_options.yaml`, `l10n.yaml`, `lib/l10n/app_en.arb`, `lib/l10n/app_ms.arb`
- Create: Flutter platform scaffold files for Android, iOS and web without replacing repository documentation.
- Preserve: root `README.md`, existing docs and `poc/backup_recovery/`.

**Interfaces:**
- Produces: generated `AppLocalizations` for English and Bahasa Malaysia.

- [x] Inspect Flutter scaffold options and generate platform files using a safe temporary location; copy only generated app/platform configuration that does not overwrite existing project documentation.
- [x] Add the required Riverpod dependency and SDK test/lint configuration; do not add routing, icon or font packages.
- [x] Add localized shell labels and placeholder copy in English and Bahasa Malaysia.
- [x] Run `flutter pub get`, formatting and `flutter analyze`; capture exact tool versions and results.

### Task 2: Build the responsive themed navigation shell

**Files:**
- Create: `lib/main.dart`, `lib/app/poket_app.dart`, `lib/app/theme/poket_theme.dart`
- Create: `lib/app/navigation/app_destination.dart`, `lib/app/navigation/navigation_provider.dart`, `lib/app/navigation/poket_router.dart`, `lib/app/navigation/responsive_navigation_shell.dart`
- Create: `lib/features/home/presentation/home_screen.dart`
- Create: `lib/features/transactions/presentation/transactions_screen.dart`
- Create: `lib/features/tax/presentation/tax_screen.dart`
- Create: `lib/features/wallets/presentation/wallets_screen.dart`
- Create: `lib/features/settings/presentation/settings_screen.dart`

**Interfaces:**
- `AppDestination`: immutable destination metadata with localized label, icon and stable route identifier.
- `selectedDestinationProvider`: Riverpod state for the selected destination.
- `ResponsiveNavigationShell`: renders compact bottom navigation on narrow screens and an adaptive rail/navigation layout at wider breakpoints.

- [x] Add a widget test that asserts all five destinations are available and selectable.
- [x] Run the widget test and verify the initial shell state.
- [x] Implement the app bootstrap with `ProviderScope`, `MaterialApp.router`, generated localizations, system theme mode and a custom Flutter Router that synchronizes destination changes with route information.
- [x] Implement the approved teal/warm-neutral Material 3 light and dark themes using system typography.
- [x] Implement responsive navigation and simple feature placeholder screens with localized title and clear “not available yet” state.
- [x] Re-run the shell widget tests, formatter and analyzer.

### Task 3: Verify responsive and accessible shell behavior

**Files:**
- Create: `test/app/navigation/responsive_navigation_shell_test.dart`
- Create: `test/app/poket_app_test.dart`
- Modify: `test/app/navigation/app_shell_smoke_test.dart`

**Interfaces:**
- Tests consume the public app widget and destination provider; no production testing hooks are introduced.

- [x] Add tests at representative phone (390 logical px), tablet (768) and desktop (1280) widths for the expected navigation mode and absence of overflow.
- [x] Add tests for localization, selected destination semantics, and light/dark rendering.
- [x] Add tests for opening a destination from a deep link and updating the browser route after selection.
- [x] Run `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, `flutter test`, and `flutter build web`.
- [x] Record any platform build blockers; do not accept Android SDK licenses or change machine configuration as part of this slice.

## Scope exclusions

Firebase authentication, account registration, local persistence, wallet balance setup, transaction operations, tax rules/data, receipts, backup/restore, live sync, and the public search landing page remain separate slices. The app must not present these as implemented.
