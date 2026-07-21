# Femio App - M8 Complete Overhaul & New Features

You are acting as a **senior Flutter development team** consisting of: a Lead Flutter Engineer, a UI/UX Designer, a Medical Content Consultant, and a QA Lead. Your mission is to transform the Femio Flutter app into a **production-ready, top-tier women's health application** targeting MENA markets.

## CRITICAL RULES - DO NOT DEVIATE

1. **Stick to the existing architecture**: Clean Architecture with BLoC pattern, feature-first modules, Isar database, GetIt DI. Do NOT refactor the architecture.
2. **Follow this document exactly**: This is the agreed M8 milestone plan. Do not skip items or change the order.
3. **Work continuously**: Fix ALL issues in each phase before moving to the next. If you encounter a blocker, find a workaround and continue.
4. **Do not delete features**: Only fix, improve, complete, and add functionality.
5. **Test after every major change**: Run `flutter analyze` and fix all warnings/errors before moving on.
6. **Preserve all 4 languages**: EN, AR, FR, ES. Any new user-facing string MUST be added to all 4 ARB files under `lib/l10n/`.
7. **Use the existing theme system**: All colors via `AppColors`, all dimensions via `AppDimensions`, all text styles via `AppTextStyles`. Zero hardcoded values anywhere.
8. **Medical accuracy**: All health content must include disclaimers. Never present predictions as medical diagnoses. Add "Consult your healthcare provider" where appropriate.
9. **New features follow Clean Architecture**: Every new feature must have `domain/` (entities, repositories, use cases), `data/` (models, data sources, repository impl), and `presentation/` (bloc, pages, widgets) layers.
10. **Register everything in DI**: Every new BLoC, UseCase, Repository, and DataSource must be registered in `lib/injection_container.dart`.

---

## PHASE 1: CRITICAL BUG FIXES (Do these FIRST - app is broken without them)

### 1.1 Fix Dependency Injection (CRASH-LEVEL)
- **File**: `lib/injection_container.dart` (lines ~336, ~341)
- **Issue**: Fertility and Pregnancy use case registrations are commented out with TODO
- **Action**: Register ALL fertility and pregnancy dependencies (use cases, repositories, data sources) following the exact same pattern used for cycle, symptoms, and vitals features
- Verify by checking that `GetIt.instance<FertilityBloc>()` resolves without errors

### 1.2 Fix Firebase Configuration
- **File**: `lib/firebase_options.dart`
- **Issue**: All API keys are empty strings - app crashes on Firebase calls
- **Action**: Create a `FirebaseService` wrapper in `lib/core/services/firebase_service.dart` that:
  - Checks if Firebase is properly configured before making calls
  - Returns gracefully if not configured (no crashes)
  - Logs warnings for debugging
  - Wrap ALL Firebase calls throughout the app to use this service

### 1.3 Fix Settings Page (Multiple Issues)
- **File**: `lib/features/settings/presentation/pages/settings_page.dart`
- **Actions**:
  - Theme selection (light/dark/OLED) must persist across app restarts via SettingsBloc → SharedPreferences
  - Wire up PIN entry page (`pin_entry_page.dart`): Settings → Privacy → App Lock toggle → navigate to PIN setup
  - Add JSON schema validation before data import (reject malformed JSON with user-friendly error)
  - Stub notification scheduling with `flutter_local_notifications` or clear TODO markers

### 1.4 Fix All Empty/Dead Button Handlers

| File | Button | Required Action |
|------|--------|----------------|
| `kick_counter_page.dart` (~line 158) | Session History icon | Bottom sheet showing past kick sessions from Isar |
| `library_page.dart` (~line 25) | Search button | Local search filtering across article titles and content |
| `cycle_report_page.dart` (~line 317) | Share button | Use `share_plus` to share cycle summary as text |
| `cycle_report_page.dart` (~line 324) | Export PDF button | Add `pdf` package to pubspec.yaml, generate PDF with cycle stats |

### 1.5 Fix Dashboard Data
- **File**: `dashboard_page.dart` (lines ~167-168) - `hasLoggedMood: false` and `hasLoggedSleep: false` are hardcoded. Query actual data from symptom repository for today.
- **File**: `dashboard_repository_impl.dart` (~line 80) - Symptoms and vitals counts not fetched. Implement actual Isar queries.

---

## PHASE 2: VISUAL DESIGN OVERHAUL (Make every screen screenshot-worthy)

### 2.1 Eliminate ALL Hardcoded Colors
Search entire `lib/` for `Color(0x`, `Colors.` and replace with `AppColors` constants. Known offenders:
- `library_page.dart`, `calculators_page.dart`, `medication_tracker_widget.dart`

### 2.2 Eliminate ALL Hardcoded Strings
Every user-facing string must use `AppLocalizations.of(context)!` (aliased as `l10n`). Known offenders:
- `medication_tracker_widget.dart` - "Today's Medications", "Take", "Skip", "Add Medication"
- Settings helper methods using switch statements instead of l10n

### 2.3 Eliminate ALL Magic Numbers
- `cycle_home_page.dart`: `cycleLength - 14` → named constant `kOvulationDayOffset = 14`
- `dashboard_page.dart`: Fertile window days 10-16 → configurable constants
- `vitals_log_page.dart`: Validation ranges → `VitalRanges` constants class

### 2.4 Loading, Empty, and Error States
For EVERY page in the app:
- **Loading**: Replace `CircularProgressIndicator` with shimmer/skeleton effects using a reusable `ShimmerWidget` in `lib/core/widgets/`
- **Empty states**: Beautiful illustration (icon-based) + helpful text + action button. Create `EmptyStateWidget` in `lib/core/widgets/`
- **Error states**: Friendly message + retry button. Create `ErrorStateWidget` in `lib/core/widgets/`
- Every `BlocBuilder` must handle: initial, loading, loaded, and error states

### 2.5 Micro-Animations & Polish
- **Page transitions**: `FadeTransition` or `SlideTransition` for all route navigation
- **Button press**: Subtle scale animation (0.95 on press) for all primary buttons
- **Card appear**: Staggered fade-in when lists load
- **Tab switching**: Crossfade animation on bottom nav
- **Haptic feedback**: `HapticFeedback.lightImpact()` on all tab taps, toggles, and primary actions
- **Pull-to-refresh**: `RefreshIndicator` on dashboard, calendar, library

### 2.6 Typography & Spacing
- ALL text must use `AppTextStyles` - zero inline `TextStyle()` constructors
- ALL spacing must use `AppDimensions` - zero raw `SizedBox(height: 16)` or `EdgeInsets.all(8)`
- Verify RTL works correctly for Arabic locale

### 2.7 Bottom Navigation Enhancement
- Subtle crossfade animation when switching tabs
- Active tab indicator uses theme accent color
- Badge indicators: unlogged period (cycle tab), unread tips (dashboard)

### 2.8 Onboarding Polish
- Replace generic heart icon on welcome page with a composed icon illustration (use `Stack` with multiple `Icon` widgets to create a branded feel)
- Smooth animated page indicator dots
- Skip button on non-final pages
- Prominent, gradient "Get Started" button

### 2.9 Dark Mode & OLED Pass
- Go through every page and verify dark mode renders correctly (no white backgrounds, proper contrast)
- OLED mode must use pure black (`Color(0xFF000000)`) backgrounds
- Ensure charts, cards, dialogs all respect the current theme

---

## PHASE 3: AI CYCLE PREDICTIONS (New Feature)

### Architecture
Create `lib/features/cycle/data/services/cycle_prediction_engine.dart`

### How It Works
The prediction engine must:
1. **Collect history**: Use all past cycles (start dates, durations, lengths) from Isar
2. **Calculate weighted average**: Recent cycles weighted more heavily than older ones
   ```
   weights: [0.35, 0.25, 0.20, 0.12, 0.08] for last 5 cycles
   If fewer cycles available, redistribute weights proportionally
   ```
3. **Compute variability**: Standard deviation of cycle lengths
4. **Generate prediction**:
   - Predicted next period date = last period start + weighted average cycle length
   - Confidence level:
     - High (>80%): std dev ≤ 2 days AND 4+ cycles logged
     - Medium (60-80%): std dev ≤ 4 days AND 3+ cycles logged
     - Low (<60%): std dev > 4 days OR fewer than 3 cycles
   - Fertile window: 5 days before predicted ovulation through ovulation day
   - Ovulation: predicted cycle length - 14 days (luteal phase constant)

5. **Improve over time**: Each new completed cycle recalculates all predictions
6. **Show confidence**: Display percentage and "Based on X cycles" text

### UI Integration
- Replace the current simple prediction in `PeriodPrediction` entity with the engine's output
- Dashboard cycle hero card shows: "Period expected [date] ([confidence]% confident)"
- Calendar marks predicted period days with dotted/lighter styling
- Add "Prediction accuracy" section in cycle report page

### Pro vs Free
- **Free**: Basic prediction with "Period expected around [date]"
- **Pro**: Confidence percentage, fertile window prediction, ovulation day, trend analysis

### Localization
Add keys for all 4 languages:
- `predictionConfidenceHigh`, `predictionConfidenceMedium`, `predictionConfidenceLow`
- `basedOnXCycles`, `predictedPeriodDate`, `fertileWindowPrediction`

---

## PHASE 4: SYMPTOM PATTERN ENGINE (New Feature)

### Architecture
Create new feature module: `lib/features/patterns/`
```
patterns/
  domain/
    entities/symptom_pattern.dart
    entities/correlation.dart
    repositories/pattern_repository.dart
    usecases/detect_patterns.dart
    usecases/get_correlations.dart
  data/
    services/pattern_detection_service.dart
    repositories/pattern_repository_impl.dart
  presentation/
    bloc/pattern_bloc.dart
    pages/patterns_page.dart
    widgets/pattern_card.dart
    widgets/correlation_chart.dart
```

### How It Works
1. **Analyze 3+ cycles of symptom data** to find recurring patterns
2. **Detect**:
   - **Timing patterns**: "Headaches typically occur on days 12-14 of your cycle" (check if symptom appears within ±1 day window across 60%+ of cycles)
   - **Severity patterns**: "Cramps tend to be worse on day 2" (average severity by cycle day)
   - **Mood correlations**: "Your mood tends to dip 2 days before your period" (compare mood scores to cycle phase)
   - **Co-occurrence**: "When you log bloating, you also tend to log fatigue (78% of the time)"
   - **Cycle phase associations**: Map all symptoms to follicular/ovulatory/luteal/menstrual phases
3. **Confidence scoring**: Only show patterns with 60%+ confidence (appears in 60%+ of analyzed cycles)
4. **Update weekly**: Recalculate patterns when new symptom data is logged

### Pattern Entity
```dart
class SymptomPattern {
  final String id;
  final String symptomName;
  final PatternType type; // timing, severity, mood, coOccurrence, phase
  final String description; // Human-readable: "Headaches tend to peak on days 12-14"
  final double confidence; // 0.0 - 1.0
  final List<int> affectedCycleDays; // Which days this pattern occurs
  final CyclePhase phase; // follicular, ovulatory, luteal, menstrual
  final String? correlatedSymptom; // For co-occurrence patterns
}
```

### UI
- New "Patterns" page accessible from dashboard insights section and from bottom of symptoms page
- Pattern cards with:
  - Icon for symptom type
  - Human-readable description
  - Confidence badge (color-coded: green >80%, yellow >60%)
  - Mini chart showing pattern across cycle days
- Correlation chart: scatter/bubble chart showing symptom co-occurrences

### Pro vs Free
- **Free**: Top 3 patterns shown, basic descriptions
- **Pro**: All patterns, correlation charts, export, phase-specific insights

### PCOS/Endometriosis Support
- If user has PCOS in their medical conditions (from onboarding):
  - Track and highlight irregular cycle patterns
  - Flag symptom clusters common to PCOS (weight changes, acne, hair growth, irregular periods)
  - Show "Talk to your doctor about:" suggestions
- If user has Endometriosis:
  - Track pain severity trends
  - Flag concerning patterns (increasing severity, new symptom locations)
  - Show pain management tips per cycle phase

---

## PHASE 5: CYCLE PHASE COACHING (New Feature)

### Architecture
Create `lib/features/coaching/`
```
coaching/
  domain/
    entities/phase_coaching.dart
    entities/coaching_card.dart
  data/
    coaching_content_data.dart
  presentation/
    widgets/coaching_card_widget.dart
```

### Content Structure
For each of the 4 cycle phases, provide daily coaching cards:

**Menstrual Phase (Days 1-5)**:
- Exercise: "Gentle movement today - try walking, stretching, or restorative yoga"
- Nutrition: "Focus on iron-rich foods: leafy greens, lentils, red meat. Stay hydrated"
- Wellness: "Rest is productive. Your body is doing important work"
- Mood: "It's normal to feel inward-focused. Honor your need for quiet time"

**Follicular Phase (Days 6-13)**:
- Exercise: "Energy is rising! Great time for cardio, strength training, trying something new"
- Nutrition: "Fuel your rising energy with complex carbs, lean protein, fermented foods"
- Wellness: "You may feel more social and creative. Plan activities and projects"
- Mood: "Confidence and optimism tend to peak. Make important decisions now"

**Ovulatory Phase (Days 14-16)**:
- Exercise: "Peak performance window! Push your workouts, try HIIT"
- Nutrition: "Support hormone metabolism with cruciferous vegetables, fiber, light meals"
- Wellness: "Communication skills are strongest now. Great time for important conversations"
- Mood: "You may feel most confident and attractive. Enjoy social events"

**Luteal Phase (Days 17-28)**:
- Exercise: "Gradually reduce intensity. Switch to pilates, yoga, moderate walks"
- Nutrition: "Combat PMS with magnesium-rich foods: dark chocolate, nuts, bananas. Reduce salt and caffeine"
- Wellness: "Nesting instinct may kick in. Organize, plan, complete detail-oriented tasks"
- Mood: "Be gentle with yourself. Mood fluctuations are hormonal, not personal"

### UI Integration
- Show 1 coaching card on dashboard (rotates through exercise/nutrition/wellness/mood)
- Full coaching page accessible by tapping the card
- Cards use the current cycle day to determine phase
- Respect user's actual cycle length (not hardcoded 28 days)

### Pro vs Free
- **Free**: 1 tip per day on dashboard
- **Pro**: Full daily plan with all 4 categories + cycle phase calendar view

### Localization
Add ALL coaching content to all 4 ARB files. Content must be culturally appropriate for MENA audiences.

---

## PHASE 6: HEALTH CONDITION PROFILES (New Feature)

### Wire Existing Code
Files already exist but aren't connected:
- `health_condition.dart`, `condition_info_data.dart`, `condition_info_card.dart`
- `doctor_visit_prep_widget.dart`

### Create Presentation Layer
```
medical/
  presentation/
    pages/
      health_conditions_page.dart     # List of user's conditions
      condition_detail_page.dart      # Condition info + tracking
      doctor_visit_prep_page.dart     # Pre-appointment checklist
    bloc/
      medical_bloc.dart
```

### Condition Profiles to Include
Each condition gets: description, common symptoms, tracking recommendations, red flags, doctor visit prep questions.

1. **PCOS** - Irregular cycles, weight tracking, acne/hair logging, insulin resistance awareness
2. **Endometriosis** - Pain severity tracking, location mapping, flare triggers, surgery history
3. **PMDD** - Mood pattern tracking, severity scoring, treatment response logging
4. **Thyroid disorders** - Fatigue/weight/mood correlation, medication tracking, lab result logging
5. **Anemia** - Fatigue/pallor tracking, iron intake logging, heavy flow correlation

### Doctor Visit Prep
- Auto-generate a visit summary: last 3 cycles, top symptoms, vitals trends, medication list
- Suggested questions to ask (condition-specific)
- Printable/shareable via `share_plus`

### Navigation
- Access from: Settings → Profile → "My Health Conditions"
- Also from: Dashboard → Medical quick action (add one if missing)

---

## PHASE 7: SMART NOTIFICATIONS (New Feature)

### Architecture
Create `lib/core/services/notification_service.dart`

### Notification Types
1. **Period Reminder**: "Your period is expected in [X] days. Be prepared!" (3 days and 1 day before predicted period)
2. **Fertile Window**: "Your fertile window opens tomorrow" (1 day before, only if TTC or tracking fertility)
3. **Medication Reminder**: "Time to take [medication name]" (at user-set times)
4. **Logging Nudge**: "You haven't logged today. Your [X]-day streak is at risk!" (evening, if not logged)
5. **Weekly Summary**: "Last week: [X] symptoms logged, cycle day [Y]. Here's your pattern update" (weekly)
6. **Milestone**: "You've logged 30 days! Your predictions are getting more accurate" (at 7, 14, 30, 60, 90 days)

### Implementation
- Add `flutter_local_notifications` to pubspec.yaml
- Schedule notifications based on user preferences from Settings
- Respect "Discreet Mode" - use generic text like "Health reminder" instead of period-specific language
- Respect notification toggles in Settings (period reminders, fertile window, pregnancy milestones)
- Use the notification time from Settings (default 9:00 AM)

### Pro vs Free
- **Free**: Period reminders, milestone notifications
- **Pro**: All notification types, custom scheduling, weekly summary

---

## PHASE 8: DOCTOR REPORT EXPORT (New Feature)

### Architecture
Add to `lib/features/insights/data/services/report_generator_service.dart`

### PDF Report Contents
Using the `pdf` package (add to pubspec.yaml):

**Page 1: Summary**
- Patient name (optional, user-entered)
- Report date range
- Average cycle length, period duration
- Active health conditions

**Page 2: Cycle History**
- Table of last 6 cycles: start date, duration, cycle length
- Cycle length trend chart (line graph)

**Page 3: Symptom Patterns**
- Top 5 most frequent symptoms with occurrence count
- Symptom severity trends
- Cycle phase associations

**Page 4: Vitals Summary**
- Blood pressure readings with averages
- Weight trend
- Glucose readings

**Page 5: Medications**
- Current medications with dosage and frequency
- Adherence rate

### UI
- Access from: Cycle Report page → "Export Doctor Report" button
- Also from: Settings → Data Management → "Generate Doctor Report"
- Date range selector (last 3/6/12 months)
- Preview before export
- Share via `share_plus`

### Pro Feature
This is a Pro-only feature. Show preview with watermark for free users, clean PDF for Pro.

---

## PHASE 9: WEARABLE INTEGRATION FOUNDATION (New Feature)

### Architecture
Create `lib/features/wearables/`
```
wearables/
  domain/
    entities/wearable_device.dart
    entities/wearable_data.dart
    repositories/wearable_repository.dart
  data/
    services/health_connect_service.dart  # Android Health Connect
    services/healthkit_service.dart       # iOS HealthKit (stub)
    repositories/wearable_repository_impl.dart
  presentation/
    pages/wearable_settings_page.dart
    widgets/connected_device_card.dart
```

### Phase 1 Implementation (This Milestone)
- **Android**: Integrate with Health Connect API to read:
  - Basal body temperature (BBT) → auto-populate fertility tracking
  - Sleep data (duration, quality) → auto-populate sleep logging
  - Heart rate (resting) → show in vitals
  - Steps/activity → show in dashboard
- **iOS**: Create HealthKit stubs with TODO markers for future implementation
- **UI**: Settings → "Connected Devices" page with:
  - "Connect Health Connect" button (Android)
  - List of connected data types with toggles
  - Last sync timestamp
  - "Sync Now" button

### Permissions
- Request only READ permissions (never write to user's health data)
- Clear explanation dialogs before requesting access
- Granular toggles per data type

### Pro Feature
Wearable integration is Pro-only. Free users see the page with a "Upgrade to Pro" prompt.

---

## PHASE 10: MONETIZATION REFINEMENT

### Pricing Structure (Clue Model - Freemium)
Update the existing monetization feature to reflect this:

**Free Tier** (generous - better than Flo's free):
- Full cycle tracking with basic predictions
- Symptom logging (all categories)
- Vitals tracking
- All 8 calculators
- Library articles (all)
- Pregnancy/Postpartum guides (full)
- Hospital bag, kick counter, contraction timer
- Basic coaching (1 tip/day)
- Top 3 symptom patterns
- Period reminder notifications
- 4 languages, dark mode, OLED

**Pro Tier ($3.99/month or $29.99/year)**:
- Ad-free experience
- AI predictions with confidence percentages
- Full symptom pattern engine + correlation charts
- Full cycle phase coaching (all 4 daily categories)
- Health condition profiles + doctor visit prep
- All smart notifications + weekly summary
- Doctor report PDF export
- Wearable integration
- Data export (JSON + PDF)
- Priority support

### Pro Paywall Updates
- Update `lib/features/monetization/presentation/pages/pro_paywall_page.dart` with new feature list
- Update pricing to $3.99/month and $29.99/year
- Add "Save 37%" badge on yearly plan
- Show feature comparison (Free vs Pro) as a scrollable table
- Add "Restore Purchase" button prominently

### Feature Gating
Create `lib/core/services/feature_gate_service.dart`:
```dart
class FeatureGateService {
  bool canAccess(ProFeature feature) { ... }
  void showPaywallIfNeeded(BuildContext context, ProFeature feature) { ... }
}
```
Use this consistently across ALL pro-gated features.

---

## PHASE 11: CODE QUALITY & SAFETY

### 11.1 Database Encryption
- **File**: `lib/core/database/database_helper.dart` (~line 32)
- Apply the encryption key to Isar initialization (key is generated but unused)

### 11.2 Navigation Safety
- Create `lib/core/navigation/routes.dart` with all route string constants
- Add `onUnknownRoute` handler in MaterialApp
- Replace all hardcoded route strings with constants

### 11.3 Data Validation
- JSON schema validation on data import
- Input sanitization on all text fields
- Vital range validation extracted to constants class

### 11.4 Accessibility
- `Semantics` widgets on all interactive elements
- All images have `semanticLabel`
- Minimum 48x48dp touch targets
- Test with large font sizes (no overflow)

### 11.5 Performance
- `const` constructors wherever possible
- `ListView.builder` for all dynamic lists
- `RepaintBoundary` on complex static widgets
- Lazy-load pregnancy/postpartum content and library articles

---

## PHASE 12: FINAL VERIFICATION

### 12.1 App-Wide Consistency Pass
Go through EVERY page and verify:
- [ ] Uses `AppColors` exclusively (zero hardcoded colors)
- [ ] Uses `AppTextStyles` exclusively (zero inline TextStyle)
- [ ] Uses `AppDimensions` exclusively (zero magic numbers)
- [ ] All strings use l10n (zero hardcoded user-facing text)
- [ ] Empty state has illustration + text + action
- [ ] Loading state uses shimmer/skeleton
- [ ] Error state has friendly message + retry
- [ ] All buttons are functional (zero empty onPressed)
- [ ] RTL layout correct for Arabic
- [ ] Dark mode renders correctly
- [ ] OLED mode uses pure black
- [ ] Pro features show paywall for free users

### 12.2 Test Suite
```bash
flutter analyze   # Must show 0 errors, 0 warnings
flutter test      # All tests must pass (existing 61 + new tests for new features)
flutter build apk --debug   # Must build successfully
```

### 12.3 New Feature Tests
Write unit tests for:
- Cycle prediction engine (test with mock cycle data, verify weighted averages)
- Pattern detection service (test with mock symptom data across multiple cycles)
- Feature gate service (test free vs pro access)
- Notification scheduling logic

### 12.4 Final Checklist
- [ ] `flutter analyze` = 0 errors, 0 warnings
- [ ] `flutter test` = all pass
- [ ] `flutter build apk --debug` = success
- [ ] Settings page: all toggles work and persist
- [ ] Dashboard: mood/sleep reflects actual data
- [ ] All button handlers implemented
- [ ] DI container resolves all blocs
- [ ] Firebase gracefully handles missing config
- [ ] AI predictions show on dashboard with confidence
- [ ] Symptom patterns page shows detected patterns (with 3+ cycles of data)
- [ ] Coaching cards appear on dashboard (phase-appropriate)
- [ ] Health conditions page accessible and functional
- [ ] Smart notifications schedule correctly
- [ ] Doctor report PDF generates and shares
- [ ] Wearable settings page renders (with Health Connect prompt on Android)
- [ ] Pro paywall shows correct pricing and features
- [ ] Feature gates work (free users see upgrade prompts)
- [ ] Kick counter session history works
- [ ] Library search works
- [ ] Cycle report share/export works
- [ ] PIN lock can be enabled from settings
- [ ] Dark mode correct on ALL pages
- [ ] Arabic RTL correct on ALL pages

**START WITH PHASE 1 AND WORK THROUGH EACH PHASE SEQUENTIALLY. DO NOT SKIP ANY ITEM. DO NOT STOP UNTIL PHASE 12 IS COMPLETE.**
