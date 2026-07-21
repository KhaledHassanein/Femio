# Femio App - Complete Overhaul Prompt for Claude Opus (VS Code)

> **INSTRUCTIONS**: Copy everything below the line into a new Claude Opus chat in VS Code.
> Open the Femio project folder first so the AI has full file access.

---

## START OF PROMPT

You are acting as a **senior Flutter development team** consisting of: a Lead Flutter Engineer, a UI/UX Designer, a Medical Content Consultant, and a QA Lead. Your mission is to transform the Femio Flutter app from its current state into a **production-ready, top-tier women's health application** targeting MENA markets.

### CRITICAL RULES - DO NOT DEVIATE

1. **Stick to the existing architecture**: Clean Architecture with BLoC pattern, feature-first modules, Isar database, GetIt DI. Do NOT refactor the architecture.
2. **Stick to the existing plan**: Follow milestones M5-M7 as documented in `docs/roadmap.md` and `docs/REVAMP_ROADMAP.md`.
3. **Complete everything in one session**: Do not stop mid-task. Fix ALL issues listed below before finishing. If you encounter a blocker, find a workaround and continue.
4. **Do not delete features**: Only fix, improve, and complete existing functionality.
5. **Test after every major change**: Run `flutter analyze` and fix all warnings/errors before moving to the next task.
6. **Preserve all 4 languages**: EN, AR, FR, ES. Any new user-facing string MUST be added to all 4 ARB files under `lib/l10n/`.
7. **Use the existing theme system**: All colors via `AppColors`, all dimensions via `AppDimensions`, all text styles via `AppTextStyles`. Zero hardcoded values.
8. **Medical accuracy matters**: All health content must include appropriate disclaimers. Never present predictions as medical diagnoses.

---

## PHASE 1: CRITICAL BUG FIXES (Do these first)

### 1.1 Fix Dependency Injection (CRASH-LEVEL)
- **File**: `lib/injection_container.dart` (lines ~336, ~341)
- **Issue**: Fertility and Pregnancy use case registrations are commented out / TODO
- **Action**: Register ALL fertility and pregnancy dependencies (use cases, repositories, data sources) following the exact same pattern used for cycle, symptoms, and vitals features
- Verify by checking that `GetIt.instance<FertilityBloc>()` resolves without errors

### 1.2 Fix Firebase Configuration
- **File**: `lib/firebase_options.dart`
- **Issue**: All API keys are empty strings - app will crash on Firebase calls
- **Action**: Wrap ALL Firebase calls throughout the app in try-catch blocks with graceful fallbacks. Add a `FirebaseService` wrapper in `lib/core/services/` that:
  - Checks if Firebase is properly configured before making calls
  - Returns gracefully if not configured (no crashes)
  - Logs warnings for debugging
  - This allows the app to run without Firebase during development

### 1.3 Fix Settings Page
- **File**: `lib/features/settings/presentation/pages/settings_page.dart`
- **Issues**:
  - Theme changes not persisting to SharedPreferences
  - Notification time picker exists but notifications are never actually scheduled
  - App Lock/PIN entry page (`pin_entry_page.dart`) exists but is not integrated into settings flow
  - Data import accepts invalid JSON without validation
- **Actions**:
  - Ensure theme selection (light/dark/OLED) persists across app restarts via SettingsBloc
  - Add JSON schema validation before importing data
  - Wire up the PIN entry page: Settings > Privacy > App Lock toggle should navigate to PIN setup
  - Add a `flutter_local_notifications` integration or stub the notification scheduling with TODO markers that clearly indicate what's needed

### 1.4 Fix All Empty/Dead Button Handlers
These buttons exist in the UI but do NOTHING when tapped:

| File | Button | Required Action |
|------|--------|----------------|
| `kick_counter_page.dart` (line ~158) | Session History icon | Implement a bottom sheet showing past kick counting sessions from Isar |
| `library_page.dart` (line ~25) | Search button | Implement local search filtering across article titles and content |
| `cycle_report_page.dart` (line ~317) | Share button | Use `share_plus` to share cycle summary as text |
| `cycle_report_page.dart` (line ~324) | Export PDF button | Generate a simple PDF using the `pdf` package (add to pubspec.yaml) with cycle statistics, or if too complex, export as formatted text file |

### 1.5 Fix Dashboard Hardcoded False Values
- **File**: `lib/features/dashboard/presentation/pages/dashboard_page.dart` (lines ~167-168)
- **Issue**: `hasLoggedMood: false` and `hasLoggedSleep: false` are hardcoded
- **Action**: Query actual mood and sleep log data from the symptom repository for today's date. Wire this into the DashboardBloc state so the Quick Log Panel reflects reality.

### 1.6 Fix Dashboard Repository
- **File**: `lib/features/dashboard/data/repositories/dashboard_repository_impl.dart` (line ~80)
- **Issue**: Symptoms and vitals counts not being fetched
- **Action**: Implement the actual count queries from Isar

---

## PHASE 2: UI/UX POLISH (Make it look world-class)

### 2.1 Eliminate ALL Hardcoded Colors
Search the entire `lib/` directory for patterns like `Color(0x`, `Colors.`, `color:` and replace every instance with the appropriate `AppColors` constant. Common offenders:
- `library_page.dart` - hardcoded greens and purples
- `calculators_page.dart` - hardcoded category colors
- `medication_tracker_widget.dart` - multiple hardcoded colors throughout

### 2.2 Eliminate ALL Hardcoded Strings
Search for any user-facing string that is not using `AppLocalizations.of(context)!.` (aliased as `l10n`). Every string must go through the localization system. Common offenders:
- `medication_tracker_widget.dart` - "Today's Medications", "Take", "Skip", "Add Medication"
- Settings page helper methods (`_languageName()`, `_fertilityGoalLabel()`, `_userStageLabel()`) that use switch statements instead of l10n

### 2.3 Eliminate ALL Magic Numbers
- `cycle_home_page.dart`: Ovulation calculated as `cycleLength - 14` - extract to a named constant `kOvulationDayOffset`
- `dashboard_page.dart`: Fertile window days 10-16 hardcoded - use configurable constants
- `vitals_log_page.dart`: Validation ranges (70-250 systolic, 20-300 weight) - extract to `VitalRanges` constants class

### 2.4 Enhance Visual Design
For each major page, ensure:
- **Smooth page transitions**: Use `Hero` widgets for shared elements, `SlideTransition` or `FadeTransition` for page navigation
- **Micro-animations**: Add subtle animations to buttons (scale on press), cards (fade in on appear), and state changes
- **Empty states**: Every list/grid that can be empty MUST have a beautiful empty state with an illustration and helpful text (use existing assets or create simple icon-based illustrations)
- **Loading states**: Every async operation must show a shimmer/skeleton loading effect, not a plain CircularProgressIndicator
- **Error states**: Every BlocBuilder must handle error states with a friendly retry UI
- **Pull-to-refresh**: Add RefreshIndicator to all scrollable list pages (dashboard, calendar, library)
- **Consistent card elevation**: Use `AppDimensions` for all card elevations and border radius values

### 2.5 Typography & Spacing Consistency
- Ensure ALL text uses `AppTextStyles` - no inline `TextStyle()` constructors
- Ensure ALL spacing uses `AppDimensions` constants - no raw `SizedBox(height: 16)` or `EdgeInsets.all(8)`
- Verify RTL support works correctly for Arabic locale - test padding, alignment, and icon directions

### 2.6 Bottom Navigation Enhancement
- Add a subtle animation when switching tabs (crossfade or slide)
- Add haptic feedback on tab tap (`HapticFeedback.lightImpact()`)
- Ensure the active tab indicator uses the theme accent color
- Badge indicators for: unlogged period (on cycle tab), unread tips (on dashboard)

### 2.7 Onboarding Page Polish
- **File**: `lib/features/onboarding/presentation/pages/onboarding_page.dart` (line ~116)
- Replace the generic heart icon on the welcome page with a proper branded illustration
- Add smooth page indicator dots with animation
- Add a skip button that goes directly to the last page
- Ensure the "Get Started" button has a prominent, inviting design

---

## PHASE 3: FEATURE COMPLETION

### 3.1 Complete Medication Tracker
- All strings must be localized (currently hardcoded English)
- Add medication reminder scheduling (stub with clear TODO if notification package not available)
- Add medication history view
- Add refill reminder functionality

### 3.2 Complete Health Conditions Tracking
- **Files exist but are not integrated**: `health_condition.dart`, `condition_info_data.dart`, `condition_info_card.dart`, `doctor_visit_prep_widget.dart`
- Wire these into the Medical feature's presentation layer
- Add a "My Health Conditions" section in the profile or medical tab
- Connect the doctor visit preparation widget to a user-accessible page

### 3.3 Complete Cycle Reports
- Implement the share functionality using `share_plus`
- Implement PDF export (add `pdf` package to pubspec.yaml) or fallback to formatted text export
- Add cycle length trend chart using `fl_chart`
- Add period duration trend chart

### 3.4 Rating Prompt Service
- The service is registered but never triggered
- Add trigger logic: show rating prompt after user has logged 7 days of data AND has been using the app for 14+ days
- Use `in_app_review` package (already in pubspec)

### 3.5 Library Search
- Implement full-text search across library articles
- Filter by category, tag, and content
- Highlight matching terms in results
- Add recent searches functionality

---

## PHASE 4: CODE QUALITY & SAFETY

### 4.1 Database Encryption
- **File**: `lib/core/database/database_helper.dart` (line ~32)
- The encryption key is generated but never applied
- Apply the encryption key to Isar database initialization
- Ensure all existing data migration works with encryption enabled

### 4.2 Data Validation
- Add JSON schema validation to the data import flow in settings
- Validate all user inputs at form boundaries (vitals ranges, dates, text lengths)
- Add input sanitization for any text fields

### 4.3 Error Handling Audit
- Every `BlocBuilder` must handle: initial, loading, loaded, and error states
- Every dialog must handle dismissal gracefully (no state corruption)
- Every async operation must have a timeout and error fallback
- Add a global error boundary widget at the app root

### 4.4 Navigation Safety
- Extract all route strings to a `Routes` constants class (e.g., `Routes.cycleDetail = '/cycle-detail'`)
- Add an `onUnknownRoute` handler in MaterialApp that shows a "Page Not Found" screen
- Verify all `Navigator.pushNamed` calls use the constants class

### 4.5 Accessibility
- Add `Semantics` widgets to all interactive elements
- Ensure all images have `semanticLabel`
- Test with large font sizes (ensure no overflow)
- Ensure minimum touch target sizes (48x48dp) for all buttons

---

## PHASE 5: FINAL POLISH

### 5.1 App-Wide Consistency Pass
Go through EVERY page in the app and verify:
- [ ] Page uses `AppColors` exclusively (no hardcoded colors)
- [ ] Page uses `AppTextStyles` exclusively (no inline TextStyle)
- [ ] Page uses `AppDimensions` exclusively (no magic numbers)
- [ ] All strings use l10n (no hardcoded user-facing text)
- [ ] Empty state is handled with illustration and text
- [ ] Loading state uses shimmer/skeleton
- [ ] Error state has retry button
- [ ] All buttons are functional (no empty onPressed)
- [ ] RTL layout works correctly
- [ ] Dark mode looks correct
- [ ] OLED mode looks correct

### 5.2 Performance Optimization
- Add `const` constructors wherever possible
- Use `ListView.builder` instead of `ListView` for all dynamic lists
- Add `RepaintBoundary` around complex widgets that don't change frequently
- Verify images use `cached_network_image` for any network images
- Lazy-load heavy pages (pregnancy week content, library articles)

### 5.3 Final Test Run
After all changes:
```bash
flutter analyze   # Must show 0 errors, 0 warnings
flutter test      # All 61+ tests must pass
flutter build apk --debug   # Must build successfully
```
Fix ANY issues that arise. Do not stop until all three commands pass cleanly.

---

## IMPORTANT CONTEXT

### Existing File Counts
- **357 Dart files** across 15 feature modules
- **9 test files** with 61 unit tests
- **4 localization files** (EN, AR, FR, ES)
- **26 dependencies** in pubspec.yaml

### Key Files to Read First
Before making any changes, read these files to understand the patterns:
1. `lib/injection_container.dart` - DI registration patterns
2. `lib/app/theme/` - All theme files for design system
3. `lib/features/cycle/` - Best-implemented feature (use as reference)
4. `lib/l10n/app_en.arb` - Localization key patterns
5. `docs/DEVELOPER_GUIDE.md` - Architecture and coding standards
6. `docs/roadmap.md` - Current milestone status and next steps

### Theme System Reference
```dart
// Colors - ALWAYS use these
AppColors.primary, AppColors.secondary, AppColors.surface, etc.

// Text Styles - ALWAYS use these
AppTextStyles.heading1, AppTextStyles.bodyLarge, etc.

// Dimensions - ALWAYS use these
AppDimensions.paddingSmall, AppDimensions.cardRadius, etc.

// Animations
AppAnimations.defaultDuration, AppAnimations.defaultCurve, etc.
```

### State Management Pattern
```dart
// BLoC pattern for complex features
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> { ... }

// Cubit pattern for simple state
class SimpleCubit extends Cubit<SimpleState> { ... }
```

### Localization Pattern
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.someKey)  // NOT Text('Some hardcoded string')
```

---

## COMPLETION CHECKLIST

Before you declare "done", verify ALL of these:

- [ ] `flutter analyze` returns 0 errors and 0 warnings
- [ ] `flutter test` - all tests pass
- [ ] `flutter build apk --debug` succeeds
- [ ] Settings page: theme toggle works and persists
- [ ] Settings page: all buttons respond to taps
- [ ] Dashboard: mood/sleep quick log reflects actual data
- [ ] All button handlers are implemented (no empty onPressed)
- [ ] No hardcoded colors in any file (all use AppColors)
- [ ] No hardcoded strings in any file (all use l10n)
- [ ] No magic numbers (all use named constants)
- [ ] DI container resolves all blocs without errors
- [ ] Firebase calls don't crash when not configured
- [ ] Empty states show friendly UI on all list pages
- [ ] Loading states use shimmer/skeleton effects
- [ ] Error states show retry UI
- [ ] Dark mode looks correct on all pages
- [ ] Arabic RTL layout works on all pages
- [ ] Kick counter session history works
- [ ] Library search works
- [ ] Cycle report share works
- [ ] PIN lock can be enabled from settings

**START WITH PHASE 1 AND WORK THROUGH EACH PHASE SEQUENTIALLY. DO NOT SKIP ANY ITEM.**

## END OF PROMPT
