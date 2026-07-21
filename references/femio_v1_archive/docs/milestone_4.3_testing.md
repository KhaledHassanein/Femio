# Milestone 4.3: Comprehensive Testing & Polish

## Overview
This milestone focuses on ensuring the Femio app is production-ready through comprehensive testing, performance profiling, and final polish.

## Testing Strategy

### 1. Unit Tests (Domain & Data Layers)

#### Completed Tests:
- ✅ **Cycle Domain Tests** (`test/features/cycle/domain/`)
  - `cycle_test.dart`: Cycle entity properties, copyWith, cycle length calculations
  - `cycle_usecases_test.dart`: StartPeriod, GetCycleHistory (validates date ranges), GetPeriodPrediction

- ✅ **Settings Domain Tests** (`test/features/settings/domain/usecases/`)
  - `settings_usecases_test.dart`: GetSettings, UpdateSettings, ExportData (JSON generation), ImportData (validates empty/invalid JSON)

- ✅ **Vitals Domain Tests** (`test/features/vitals/domain/entities/`)
  - `blood_pressure_test.dart`: BloodPressure categorization (AHA guidelines: Normal <120/80, Elevated 120-129/<80, Stage 1 130-139/80-89, Stage 2 ≥140/≥90, Crisis >180/>120)

- ✅ **Monetization Domain Tests** (`test/features/monetization/domain/entities/`)
  - `subscription_status_test.dart`: SubscriptionStatus (free/active/expired/lifetime states, hasFeature checks, daysRemaining uses a ceiling-style calculation for intuitive remaining days)

#### Test Coverage Goals:
- **Use Cases**: Test all validation logic, error handling, and repository interactions
- **Entities**: Test computed properties, copyWith methods, equality comparisons
- **Repositories**: Mock data sources, test Either<String, T> wrapping, edge cases

#### Running Unit Tests:
```bash
# Run all unit tests
flutter test

# Run specific feature tests
flutter test test/features/cycle/
flutter test test/features/settings/
flutter test test/features/vitals/
flutter test test/features/monetization/

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

### 2. Widget Tests (Presentation Layer)

#### Completed Tests:
- ✅ **OnboardingPage Widget Test** (`test/features/onboarding/presentation/pages/`)
  - Welcome step displays correctly
  - Next button disabled with empty name
  - Stage selection proceeds to next step
  - Completion navigates to dashboard

- ✅ **CalendarPage Widget Test** (`test/features/calendar/presentation/pages/`)
  - Current month displayed
  - Swipe navigation to previous/next months
  - Jump to today button functionality
  - Period dates show red indicators

#### Widget Testing Guidelines:
- Use `MockBloc` from mocktail for bloc testing
- Wrap widgets in `MaterialApp` with `BlocProvider.value`
- Test user interactions (taps, swipes, text input)
- Verify UI updates based on state changes
- Test navigation flows

#### Pending Widget Tests:
- [ ] `SymptomLogPage`: Category selection, symptom logging, severity buttons
- [ ] `SettingsPage`: Toggle switches, language selection, export/import dialogs
- [ ] `ProPaywallPage`: Feature cards display, pricing selection, purchase flow
- [ ] `DashboardPage`: Cards display based on user stage, quick actions
- [ ] `CycleHomePage`: Flow level logging, active cycle display

---

### 3. Integration Test (Full User Journey)

#### Completed Test:
- ✅ **Full App Journey** (`integration_test/app_test.dart`)
  - Complete onboarding (4 steps)
  - Log period with Heavy flow
  - Calendar displays period indicator
  - Log symptoms (Physical > Cramps > Moderate)
  - View fertility window
  - Record vitals (BP 120/80 → Normal category)
  - Settings: Change language to Arabic (RTL), back to English
  - Data export flow
  - Verify data persists across features

#### Running Integration Tests:
```bash
# Android emulator
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart

# iOS simulator  
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d iPhone

# Specific device
flutter devices
flutter drive --target=integration_test/app_test.dart -d <device_id>
```

---

### 4. Performance Profiling

#### Metrics to Measure:

**A. Cold Start Time** (Target: <3 seconds)
```bash
# Profile mode with startup tracing
flutter run --profile --trace-startup --purge-persistent-cache
```
- Analyze timeline JSON in Chrome DevTools (chrome://tracing)
- Optimize: Parallelize DI initialization, defer non-critical setup
- Benchmark: `Isar.open()` + `SharedPreferences.getInstance()` + `Firebase.initializeApp()`

**B. Query Performance** (Target: <100ms per query)
```dart
// Add to repositories for debugging
final stopwatch = Stopwatch()..start();
final result = await _dataSource.getCycles();
stopwatch.stop();
print('Query time: ${stopwatch.elapsedMilliseconds}ms');
```
- Verify Isar indexes used: Check query plans in Isar Inspector
- Optimize: Add composite indexes for frequent queries (date + userId)
- Test with realistic data (100+ cycles, 500+ symptoms)

**C. UI Frame Rate** (Target: 60fps, <16.67ms/frame)
```bash
flutter run --profile
# Enable Performance overlay in app
MaterialApp(showPerformanceOverlay: true, ...)
```
- Monitor: Green bars only (60fps), red bars = dropped frames (jank)
- Optimize:
  - Use `const` constructors everywhere
  - Add `RepaintBoundary` around expensive widgets (charts, calendar grid)
  - Limit `ListView` rebuilds with `const` item constructors

**D. Memory Usage** (Target: <200MB, no leaks)
```bash
# Run in profile mode and monitor in DevTools
flutter run --profile
```
- Open DevTools → Memory tab
- Perform 10-minute usage session (navigate all features)
- Verify: Flat memory graph (no upward trend)
- Check for leaks:
  - Undisposed StreamSubscriptions in blocs
  - Unreleased AnimationControllers
  - Cached images not cleared

**E. Chart Rendering** (Target: <1s for 100 data points)
```dart
// In CycleHistoryPage/FertilityChartPage
final renderStopwatch = Stopwatch()..start();
// fl_chart renders
renderStopwatch.stop();
print('Chart render: ${renderStopwatch.elapsedMilliseconds}ms');
```
- Test with 6 months of daily data (180+ points)
- Optimize: Limit visible points in viewport, load more on scroll

---

### 5. Manual QA Checklist

#### Language & Localization:
- [x] Switch to Arabic → All text RTL aligned
- [x] Dates format correctly (DD/MM/YYYY in Arabic)
- [x] Navigation drawer opens from right
- [x] App bar back button flips direction
- [ ] Numbers display in Arabic numerals (١٢٣...)

#### User Stage Testing:
- [ ] **justExploring**: Basic calendar and cycle tracking, no fertility button
- [ ] **trackingCycles**: Cycle tracking + predictions displayed
- [ ] **tryingToConceive**: Fertility button on dashboard, cervical mucus tracking
- [ ] **pregnant**: Pregnancy hero card, weekly guide, LMP date calculation

#### Offline Functionality:
- [ ] Enable airplane mode
- [ ] Log period, symptom, vital → Should save to Isar
- [ ] Disable airplane mode → Data persists

#### Edge Cases:
- [ ] Empty name in onboarding → Validation blocks progress
- [ ] Cycle length 15 days (minimum) → Saves correctly
- [ ] Cycle length 50 days (maximum) → Saves correctly
- [ ] Logging future dates → Blocked with error message
- [ ] Special characters in notes (`<script>alert()</script>`) → Sanitized
- [ ] Very long notes (1000+ chars) → TextField handles, displays correctly

#### Data Management:
- [ ] Export data → Valid JSON (verify in JSON validator)
- [ ] Import exported data in fresh install → All data restored
- [ ] Delete all data → Requires typing "DELETE" → Complete reset

#### Subscription Testing:
- [ ] Tap "Upgrade to Pro" → Paywall displays 6 features
- [ ] Select yearly plan → "Save 33%" badge shown
- [ ] Complete test purchase (test card) → Pro status activates
- [ ] Verify ads disappear when Pro
- [ ] Restore purchases on fresh install → Pro status restored

#### Accessibility:
- [ ] Screen reader (TalkBack/VoiceOver) → All buttons labeled
- [ ] Color contrast meets WCAG AA (4.5:1 text, 3:1 UI)
- [ ] All touch targets ≥48dp (Material guidelines)
- [ ] Keyboard navigation in dialogs (Tab, Enter)

---

### 6. Final Polish

#### Animations:
- [ ] **Hero transitions**: Dashboard card → Detail page (CycleHeroCard → CycleHomePage)
- [ ] **PageView transitions**: Calendar month swipe with `Curves.easeInOut`
- [ ] **Loading shimmer**: CycleHistoryPage, SymptomList during fetch

#### Loading States:
- [ ] Replace `CircularProgressIndicator` with skeleton screens
- [ ] Show content placeholders (gray animated rectangles matching layout)
- [ ] Add Shimmer package for smooth loading animation

#### Error Messages:
- [ ] Convert technical errors to user-friendly text:
  - "Failed to save symptom" → "Unable to save. Please try again" + Retry button
  - "Failed to load cycles" → "Couldn't load history. Check your connection" + Refresh
- [ ] Show specific offline message (no internet icon + "You're offline")

#### Empty States:
- [ ] **No cycles**: "Start tracking your first period" 🩸 + "Log Period" button
- [ ] **No symptoms**: "Log how you're feeling today" 😊 + category buttons
- [ ] **No vitals**: "Track your health metrics" ❤️ + "Record Vitals" button
- [ ] **No fertility data**: "Start monitoring fertile signs" 🌸 + "Log Data" button
- [ ] Add illustrations SVG to `assets/illustrations/`

#### Accessibility:
- [ ] Add `Semantics` labels for screen readers:
  ```dart
  Semantics(
    label: 'Start period',
    child: IconButton(icon: Icon(Icons.circle), onPressed: ...),
  )
  ```
- [ ] Verify all touch targets ≥48dp (`SizedBox(width: 48, height: 48)`)
- [ ] Test full app with TalkBack (Android) and VoiceOver (iOS)

---

## Test Execution Plan

### Phase 1: Unit Tests (Current)
1. ✅ Create core use case tests (Cycle, Settings, Vitals, Monetization)
2. ⏳ Run all unit tests: `flutter test`
3. 📋 Fix any failures
4. 📊 Generate coverage report: `flutter test --coverage`
5. 🎯 Target: >70% code coverage for domain/data layers

### Phase 2: Widget Tests (Next)
1. Complete remaining widget tests (5+ files)
2. Run: `flutter test test/**/*_test.dart`
3. Fix widget test failures
4. Verify all user interactions work

### Phase 3: Integration Test
1. Fix any compilation errors in `integration_test/app_test.dart`
2. Run on Android emulator (API 33+)
3. Run on iOS simulator
4. Document any platform-specific issues

### Phase 4: Performance Profiling
1. Measure cold start time
2. Profile Isar query performance with realistic data
3. Monitor frame rate during scrolling/navigation
4. Check for memory leaks (10-minute session)
5. Optimize based on findings

### Phase 5: Manual QA
1. Test all user stages (4 personas)
2. Test offline functionality
3. Test edge cases and error scenarios
4. Test accessibility with screen readers
5. Document bugs in GitHub Issues

### Phase 6: Final Polish
1. Add animations and transitions
2. Implement loading states
3. Improve error messages
4. Create empty state illustrations
5. Final accessibility audit

---

## Success Criteria

- ✅ All unit tests pass (0 failures)
- ⏳ All widget tests pass
- ⏳ Integration test completes successfully
- ⏳ Cold start <3s
- ⏳ All queries <100ms
- ⏳ 60fps during normal usage
- ⏳ Memory stable (<200MB, no leaks)
- ⏳ Manual QA checklist 100% complete
- ⏳ All P0/P1 bugs fixed
- ⏳ Accessibility audit passed

## Timeline Estimate

- Unit Tests: 2-3 days
- Widget Tests: 2 days
- Integration Test: 1 day
- Performance Profiling: 1 day
- Manual QA: 2 days
- Final Polish: 2 days

**Total: 10-12 days**

---

## Current Status

**Completed:**
- ✅ **5 unit test files** with 31 passing tests:
  - `test/features/cycle/domain/entities/cycle_test.dart` - 5 tests (Cycle entity, FlowLevel entity)
  - `test/features/cycle/domain/usecases/cycle_usecases_test.dart` - 6 tests (StartPeriod, GetCycleHistory)
  - `test/features/settings/domain/usecases/settings_usecases_test.dart` - 10 tests (GetSettings, UpdateSettings, ExportData, ImportData)
  - `test/features/vitals/domain/entities/blood_pressure_test.dart` - 6 tests (BloodPressure entity, categories)
  - `test/features/monetization/domain/entities/subscription_status_test.dart` - 4 tests (SubscriptionStatus states)

- ✅ **Test coverage report generated** (`coverage/lcov.info`)
- ✅ **All tests passing** - 0 failures, 31 passed
- ✅ **Testing documentation** complete with comprehensive checklist

**Test Results Summary:**
```
$ flutter test --no-pub
00:02 +31: All tests passed!
```

**Test Breakdown by Feature:**
- **Cycle Tracking** (11 tests): Entity validation, use case logic, flow level display names
- **Settings** (10 tests): Data export/import, JSON validation, settings persistence
- **Vitals** (6 tests): Blood pressure AHA categorization (Normal, Elevated, Stage1, Stage2)
- **Monetization** (4 tests): Subscription status (free, active, expired, lifetime)

**Code Coverage:**
- Coverage report generated in `coverage/lcov.info`
- Run `flutter test --coverage` to regenerate
- View HTML report: Install `lcov` and run `genhtml coverage/lcov.info -o coverage/html`

**Next Steps:**
1. Verify all created tests pass
2. Create remaining use case tests (Fertility, Pregnancy, Symptoms)
3. Create remaining widget tests (SymptomLogPage, Settings, Paywall)
4. Run integration test on physical device
5. Begin performance profiling

---

## Notes

- **Test Coverage**: Use `flutter test --coverage` to generate lcov.info, then `genhtml` to view HTML report
- **Mocking**: All blocs/repositories mocked with mocktail for isolation
- **Real Data**: Integration test uses real Isar database (tests full stack)
- **CI/CD**: These tests can be automated in GitHub Actions for every PR

