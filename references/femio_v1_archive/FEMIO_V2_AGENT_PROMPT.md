# FEMIO v2 — PREMIUM WOMEN'S HEALTH APP
## Complete Build Specification for VS Code Agent

> **Role**: You are a senior Flutter development team of 5 specialists: Lead Flutter Engineer, UI/UX Designer, Medical Content Consultant, Backend Architect, and QA Lead.
>
> **Mission**: Build Femio v2 — a **premium, production-ready, MENA-first women's health app** that surpasses Flo, Clue, and Natural Cycles in feature depth, medical accuracy, design quality, and cultural relevance.
>
> **Starting point**: Build **from scratch** in a new Flutter project. Do NOT copy old code. Reference the old project only for business logic concepts and content data.

---

## PART 0: PRE-BUILD RESEARCH REQUIREMENTS

Before building EACH feature module, you **MUST**:

1. **Search the web** for the 3 best competing web/app implementations of that feature
2. **Study their UI patterns** and note what works best
3. **Look up medical guidelines** from WHO, ACOG, RCOG, NHS or equivalent for any health-related calculations
4. **Identify gaps** — what competitors are missing that we should add
5. **Document your findings** in `docs/research/[feature_name]_research.md` before writing any code

This is non-optional. Every feature must be informed by real competitor analysis and medical literature.

---

## PART 1: PROJECT SETUP

### 1.1 Create New Flutter Project
```bash
flutter create femio_v2 --org com.femioapp --platforms android,ios
cd femio_v2
```

### 1.2 Package Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # DI
  get_it: ^7.7.0
  injectable: ^2.4.4

  # Local Database (Offline-First)
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1

  # Secure Storage
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.2.3

  # Firebase
  firebase_core: ^4.4.0
  firebase_auth: ^6.1.4
  cloud_firestore: ^6.1.2
  firebase_analytics: ^12.1.2
  firebase_crashlytics: ^5.0.7
  firebase_storage: ^12.1.0

  # Networking
  dio: ^5.7.0
  connectivity_plus: ^6.1.1

  # Charts & Visualization
  fl_chart: ^0.68.0
  syncfusion_flutter_charts: ^27.1.50  # for advanced charting (BBT, vitals)

  # UI
  flutter_svg: ^2.0.10+1
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  lottie: ^3.1.2
  flutter_animate: ^4.5.0
  smooth_page_indicator: ^1.2.0+3
  percent_indicator: ^4.2.3
  table_calendar: ^3.1.2

  # Navigation
  go_router: ^14.3.0

  # Utilities
  intl: any
  dartz: ^0.10.1
  json_annotation: ^4.9.0
  uuid: ^4.5.1
  crypto: ^3.0.3
  share_plus: ^12.0.1
  url_launcher: ^6.3.0
  path_provider: ^2.1.3

  # Media & Files
  image_picker: ^1.1.2
  pdf: ^3.11.2
  printing: ^5.13.1
  file_picker: ^8.1.4

  # Health & Wearables
  health: ^12.0.0  # Flutter Health for Apple Health + Google Fit/Health Connect

  # Notifications
  flutter_local_notifications: ^18.0.1
  timezone: ^0.10.0

  # Payments
  in_app_purchase: ^3.2.0
  revenue_cat_flutter_sdk: ^7.0.0  # better than raw IAP

  # Analytics
  mixpanel_flutter: ^2.3.4  # supplement to Firebase

  # Misc
  package_info_plus: ^8.2.0
  in_app_review: ^2.0.9
  flutter_rating_bar: ^4.0.1
  haptic_feedback: ^0.5.1+1
  local_auth: ^2.3.0  # biometric/PIN lock

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.9
  isar_generator: ^3.1.0+1
  json_serializable: ^6.8.0
  injectable_generator: ^2.6.2
  mocktail: ^1.0.4
  golden_toolkit: ^0.15.0
```

### 1.3 Project Structure (Feature-First Clean Architecture)
```
lib/
├── main.dart
├── app/
│   ├── femio_app.dart              # MaterialApp with router
│   ├── di/
│   │   └── injection_container.dart
│   ├── navigation/
│   │   ├── app_router.dart         # GoRouter configuration
│   │   └── app_routes.dart         # All route constants
│   └── theme/
│       ├── app_colors.dart
│       ├── app_dimensions.dart
│       ├── app_text_styles.dart
│       ├── app_theme.dart
│       └── app_theme_extensions.dart
│
├── core/
│   ├── constants/
│   │   ├── medical_constants.dart   # BP ranges, cycle norms, etc.
│   │   └── app_constants.dart
│   ├── database/
│   │   ├── isar_database.dart
│   │   └── firebase_sync_service.dart
│   ├── error/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── extensions/
│   ├── l10n/                        # ARB files (EN, AR, FR, ES + TR, UR planned)
│   ├── network/
│   │   └── network_info.dart
│   ├── security/
│   │   ├── encryption_service.dart
│   │   └── app_lock_service.dart
│   ├── services/
│   │   ├── analytics_service.dart
│   │   ├── crash_reporting_service.dart
│   │   ├── feature_gate_service.dart
│   │   ├── firebase_service.dart    # Graceful Firebase wrapper
│   │   ├── health_connect_service.dart
│   │   └── notification_service.dart
│   └── widgets/
│       ├── error_state_widget.dart
│       ├── empty_state_widget.dart
│       ├── shimmer_widget.dart
│       ├── gradient_button.dart
│       ├── femio_card.dart
│       └── medical_disclaimer_widget.dart
│
├── features/
│   ├── auth/                      # Firebase Auth (NEW - needed for cloud sync)
│   ├── onboarding/
│   ├── dashboard/
│   ├── cycle/                     # Period + prediction engine
│   ├── fertility/                 # Ovulation, BBT, OPK, TTC mode
│   ├── pregnancy/                 # Week-by-week tracking
│   ├── postpartum/
│   ├── perimenopause/             # NEW - based on Clue/NC research
│   ├── symptoms/
│   ├── vitals/                    # BP, weight, glucose, temp
│   ├── patterns/                  # Symptom pattern detection
│   ├── coaching/                  # Cycle phase coaching
│   ├── health_conditions/         # PCOS, Endo, PMDD, Thyroid
│   ├── calculators/
│   ├── library/                   # JSON-based health articles
│   ├── profile/
│   ├── settings/
│   ├── notifications/
│   └── monetization/
│
└── l10n/
    ├── app_en.arb
    ├── app_ar.arb
    ├── app_fr.arb
    ├── app_es.arb
    └── app_tr.arb                 # Turkish (MENA extension)

assets/
├── content/                       # All JSON data files
│   ├── library/
│   │   ├── articles/
│   │   │   ├── en/articles.json
│   │   │   ├── ar/articles.json
│   │   │   ├── fr/articles.json
│   │   │   └── es/articles.json
│   │   └── categories.json
│   ├── pregnancy/
│   │   ├── weeks_en.json
│   │   ├── weeks_ar.json
│   │   ├── weeks_fr.json
│   │   └── weeks_es.json
│   ├── postpartum/
│   │   ├── weeks_en.json
│   │   └── weeks_ar.json
│   ├── coaching/
│   │   ├── phase_content_en.json
│   │   ├── phase_content_ar.json
│   │   └── ...
│   ├── conditions/
│   │   ├── conditions_en.json
│   │   └── conditions_ar.json
│   └── symptoms/
│       └── symptom_definitions.json
├── icons/
├── illustrations/
│   └── lottie/                   # Lottie animations
└── images/
```

---

## PART 2: DESIGN SYSTEM

### 2.1 Brand Identity

**Logo**: Design a premium Femio logo combining:
- A stylized uterus/flower hybrid (fallopian tubes as petals)
- Color: gradient from #E8517A (rose) to #B5338A (deep violet)
- Clean, minimal, modern — think Clue's aesthetic but warmer
- SVG format, works on light and dark backgrounds
- Create with Flutter's CustomPaint or embed as SVG

**App Icon**: The logo mark (without wordmark) as the app icon

### 2.2 Color System (app_colors.dart)
```dart
class AppColors {
  // Primary Brand
  static const rose = Color(0xFFE8517A);
  static const violet = Color(0xFFB5338A);
  static const gradient = LinearGradient([rose, violet]);

  // Cycle Phase Colors (critical - must be beautiful)
  static const menstrualColor = Color(0xFFE8517A);     // Deep pink-red
  static const follicularColor = Color(0xFF00B4D8);    // Sky blue
  static const ovulatoryColor = Color(0xFF06D6A0);     // Vibrant teal
  static const lutealColor = Color(0xFF9B5DE5);        // Soft purple

  // Semantic
  static const success = Color(0xFF06D6A0);
  static const warning = Color(0xFFFFB703);
  static const error = Color(0xFFEF476F);
  static const info = Color(0xFF4CC9F0);

  // Vitals Status (AHA-aligned)
  static const bpNormal = Color(0xFF06D6A0);           // <120/<80
  static const bpElevated = Color(0xFFFFB703);          // 120-129/<80
  static const bpStage1 = Color(0xFFFF7B54);           // 130-139/80-89
  static const bpStage2 = Color(0xFFEF476F);           // ≥140/≥90
  static const bpCrisis = Color(0xFF9E0031);           // >180/>120

  // Confidence levels
  static const confidenceHigh = Color(0xFF06D6A0);
  static const confidenceMedium = Color(0xFFFFB703);
  static const confidenceLow = Color(0xFFFF7B54);

  // Neutral Scale
  static const neutral0 = Color(0xFFFFFFFF);
  static const neutral50 = Color(0xFFFAF5F8);
  static const neutral100 = Color(0xFFF3EBF0);
  static const neutral200 = Color(0xFFE4D4E0);
  static const neutral300 = Color(0xFFC9B4C4);
  static const neutral400 = Color(0xFFA890A2);
  static const neutral500 = Color(0xFF886E81);
  static const neutral600 = Color(0xFF6B5265);
  static const neutral700 = Color(0xFF4F3A4A);
  static const neutral800 = Color(0xFF352531);
  static const neutral900 = Color(0xFF1B1219);
  static const neutral950 = Color(0xFF0D0009);

  // Surface variants (light mode)
  static const surfaceLight = Color(0xFFFAF5F8);
  static const cardLight = Color(0xFFFFFFFF);

  // Surface variants (dark mode)
  static const surfaceDark = Color(0xFF1B1219);
  static const cardDark = Color(0xFF2A1D26);

  // OLED pure black
  static const oledBackground = Color(0xFF000000);
  static const oledCard = Color(0xFF0D0009);
}
```

### 2.3 Typography (app_text_styles.dart)
Use **Inter** (or Nunito for a softer feel) as primary font. Add **Amiri** for Arabic.
All sizes from AppDimensions. Zero inline TextStyle constructors anywhere.

### 2.4 Dimensions & Spacing (app_dimensions.dart)
```dart
class AppDimensions {
  // Spacing scale (4px base unit)
  static const space2 = 2.0;
  static const space4 = 4.0;
  static const space8 = 8.0;
  static const space12 = 12.0;
  static const space16 = 16.0;
  static const space20 = 20.0;
  static const space24 = 24.0;
  static const space32 = 32.0;
  static const space40 = 40.0;
  static const space48 = 48.0;
  static const space56 = 56.0;
  static const space64 = 64.0;

  // Border Radius
  static const radiusXs = 4.0;
  static const radiusSm = 8.0;
  static const radiusMd = 12.0;
  static const radiusLg = 16.0;
  static const radiusXl = 24.0;
  static const radiusXxl = 32.0;
  static const radiusPill = 100.0;

  // Card / Container
  static const cardElevation = 2.0;
  static const cardPadding = 16.0;

  // Icons
  static const iconSm = 16.0;
  static const iconMd = 24.0;
  static const iconLg = 32.0;
  static const iconXl = 48.0;

  // Touch targets (minimum 48x48 per accessibility)
  static const minTouchTarget = 48.0;

  // Bottom nav
  static const bottomNavHeight = 64.0;
}
```

### 2.5 Theme Modes
Support 5 theme modes (managed by ThemeBloc + SharedPreferences):
1. Light (default)
2. Dark
3. OLED (pure black)
4. Rose Gold (special feminine theme)
5. Nature Green (fertility/pregnancy focus)

### 2.6 Animations Policy
- **Page transitions**: Custom slide/fade transition via GoRouter
- **Button press**: Scale 0.95 on tap-down with 150ms spring curve
- **Card appear**: flutter_animate `fadeIn + slideY` with 50ms stagger per item
- **Tab switch**: CrossFade 200ms
- **Loading**: Shimmer (never bare CircularProgressIndicator)
- **Success states**: Lottie animation (small checkmark burst)
- **Haptics**: `HapticFeedback.lightImpact()` on all taps, `.mediumImpact()` on important actions
- **Pull-to-refresh**: RefreshIndicator on all list pages

---

## PART 3: FIREBASE & AUTHENTICATION (auth/ feature)

### Research First
Search for: "Flutter Firebase Auth best practices 2025", "Firebase Firestore offline sync Flutter", "women's health app privacy Firebase architecture"

### 3.1 Authentication Flows
```
GUEST (no account):
  - Full offline functionality using Isar
  - No cloud sync
  - Clear prompt: "Create account to backup your data, sync across devices, and access doctor reports"

REGISTERED USER:
  - Email + Password
  - Google Sign-In (Android/iOS)
  - Apple Sign-In (iOS required)
  - Anonymous upgrade path (guest → registered, data migrated)

PRO SUBSCRIBER:
  - All registered features +
  - Cloud backup/sync
  - Doctor reports
  - Advanced AI features
```

### 3.2 Firebase Graceful Wrapper
Create `FirebaseService` that checks configuration before ALL calls:
```dart
class FirebaseService {
  bool get isConfigured => _checkConfiguration();
  
  Future<T?> safeCall<T>(Future<T> Function() operation) async {
    if (!isConfigured) {
      debugPrint('[Firebase] Not configured - skipping operation');
      return null;
    }
    try {
      return await operation();
    } catch (e) {
      // Log to Crashlytics if available, else debugPrint
      return null;
    }
  }
}
```

### 3.3 Firestore Data Structure
```
users/{userId}/
  profile                          # name, dob, goals, conditions
  settings                         # theme, notifications, language
  subscription                     # tier, expiry, receipt
  
users/{userId}/cycles/{cycleId}    # Cycle records
users/{userId}/symptoms/{date}     # Daily symptom logs
users/{userId}/vitals/{entryId}    # BP, weight, glucose, temp
users/{userId}/medications/{medId} # Medication list
users/{userId}/pregnancyLogs/{wk}  # Pregnancy week logs
users/{userId}/notes/{noteId}      # Doctor visit notes
```

### 3.4 Offline-First Sync Strategy
1. ALL data written to Isar first (instant, never waits for network)
2. Background sync to Firestore when online (bi-directional)
3. Conflict resolution: last-write-wins with device timestamp
4. User can explicitly trigger sync from Settings
5. Sync status indicator in Settings page

---

## PART 4: LOCALIZATION & INTERNATIONALIZATION

### 4.1 Languages
- English (en) — source of truth
- Arabic (ar) — RTL, full translation, Hijri calendar support
- French (fr) — for North Africa (Morocco, Algeria, Tunisia)
- Spanish (es) — international reach
- Turkish (tr) — planned (stub keys ready)

### 4.2 Critical Rules
- EVERY user-facing string in ARB files — zero hardcoded text
- All 4 languages completed before any feature ships
- Arabic translation must be culturally appropriate (not Google Translate)
- Use `Directionality.of(context)` for RTL-aware padding/margins
- Numbers: use `intl` `NumberFormat` — Arabic uses Arabic-Indic numerals
- Dates: Show Gregorian + Hijri toggle in Settings
- Currency: Format per locale (SAR, AED, EGP, MAD, TND, EUR, USD)

### 4.3 Country-Specific Features
Track user's country (set during onboarding, changeable in Settings):
```dart
enum SupportedCountry {
  saudiArabia, uae, egypt, morocco, algeria, tunisia, jordan, kuwait,
  qatar, bahrain, oman, lebanon, palestine, iraq, libya, sudan,
  france, spain, uk, usa, other
}
```

Country drives:
- Emergency numbers (if user logs crisis BP, show local emergency number)
- Healthcare resource links
- Cultural content variations
- Future: self-designed regional ads

### 4.4 Hijri Calendar
When user selects Arabic locale or enables Hijri in Settings:
- Show Hijri date alongside Gregorian on Dashboard
- Calendar view shows Hijri month names
- Ramadan mode: Enable nutrition/fasting tracking adjustments during Ramadan
  - Suhoor/Iftar reminders
  - Hydration tracking emphasis
  - Cycle changes during Ramadan (documented in medical literature)

---

## PART 5: CONTENT DATA MANAGEMENT SYSTEM

### Research First
Study how apps like Clue, Flo, and BabyCenter structure their week-by-week pregnancy content. Study their article structure, categories, depth.

### 5.1 Design Philosophy
ALL health content lives in JSON files under `assets/content/`. No content is hardcoded in Dart. This allows:
- Non-developer content editors to update content
- Per-locale content
- Hot-updating via Firebase Remote Config (premium content)
- Easy review by medical advisors

### 5.2 JSON Schema Specifications

#### Library Articles Schema (assets/content/library/[locale]/articles.json)
```json
{
  "version": "1.0",
  "lastUpdated": "2026-01-01",
  "articles": [
    {
      "id": "art_001",
      "categoryId": "cat_cycle",
      "title": "Understanding Your Menstrual Cycle",
      "subtitle": "A guide to the 4 phases of your cycle",
      "authorName": "Femio Medical Team",
      "authorCredentials": "MD reviewed",
      "readTimeMinutes": 5,
      "isPro": false,
      "tags": ["cycle", "basics", "hormones"],
      "heroImageAsset": "assets/images/articles/cycle_basics.png",
      "medicalReferences": [
        "ACOG Practice Bulletin No. 128 (2012)",
        "WHO Technical Report Series 2022"
      ],
      "disclaimer": "This content is for educational purposes only. Consult your healthcare provider for medical advice.",
      "lastReviewedDate": "2025-06-01",
      "sections": [
        {
          "type": "paragraph",
          "content": "Your menstrual cycle begins on the first day of your period..."
        },
        {
          "type": "heading",
          "content": "Phase 1: Menstrual Phase (Days 1-5)"
        },
        {
          "type": "bullet_list",
          "items": ["Uterine lining sheds", "Estrogen and progesterone are low", "Normal flow: 20-80ml per cycle"]
        },
        {
          "type": "tip",
          "content": "Track heavy bleeding (changing a pad/tampon every hour for several consecutive hours) as a potential sign to discuss with your doctor."
        },
        {
          "type": "info_box",
          "title": "When to see a doctor",
          "content": "Seek immediate care if bleeding is extreme..."
        }
      ]
    }
  ],
  "categories": [
    {
      "id": "cat_cycle",
      "name": "Menstrual Cycle",
      "icon": "cycle",
      "color": "#E8517A",
      "articleCount": 25
    }
  ]
}
```

#### Pregnancy Weeks Schema (assets/content/pregnancy/weeks_[locale].json)
```json
{
  "version": "1.0",
  "weeks": [
    {
      "week": 6,
      "trimester": 1,
      "babySize": {
        "name": "lemon seed",
        "lengthMm": 6,
        "weightGrams": 0.1,
        "comparisonObject": "pomegranate seed",
        "comparisonObjectAr": "حبة رمان"
      },
      "babyDevelopment": {
        "headline": "Tiny heartbeat beginning",
        "details": "The heart is now beating at 100-160 bpm. Neural tube is forming. Arm and leg buds appear.",
        "milestones": ["Heart beating", "Brain forming", "Limb buds visible on ultrasound"]
      },
      "maternalChanges": {
        "headline": "Nausea may peak",
        "details": "Morning sickness (which can occur any time of day) often intensifies around week 6. Fatigue is common.",
        "symptoms": ["nausea", "fatigue", "breast_tenderness", "frequent_urination"]
      },
      "weeklyChecklist": [
        "Schedule first prenatal appointment (if not done)",
        "Start prenatal vitamins with folic acid 400mcg+",
        "Avoid alcohol, smoking, raw fish",
        "Limit caffeine to <200mg/day"
      ],
      "nutritionTip": "Focus on folic acid (leafy greens, lentils, fortified cereals) to support neural tube development.",
      "exerciseTip": "Light walking and swimming are safe. Avoid contact sports and overheating.",
      "warningSign": {
        "title": "When to call your doctor",
        "description": "Seek care for: heavy bleeding, severe cramping, high fever, painful urination."
      },
      "medicalBasis": "Based on ACOG, WHO, and NICE Guidelines"
    }
  ]
}
```

#### Coaching Phase Content Schema (assets/content/coaching/phase_content_[locale].json)
```json
{
  "phases": [
    {
      "phase": "menstrual",
      "cycleDays": [1, 2, 3, 4, 5],
      "headline": "Rest & Restore",
      "description": "Your body is working hard. Honor it.",
      "dailyCards": [
        {
          "day": 1,
          "categories": {
            "exercise": {
              "title": "Gentle Movement",
              "tip": "Try gentle yoga, stretching, or a slow walk. Your body is losing iron — don't push hard.",
              "duration": "15-20 mins",
              "icon": "yoga"
            },
            "nutrition": {
              "title": "Iron Restoration",
              "tip": "Eat iron-rich foods: lentils, spinach, red meat (halal), pumpkin seeds. Pair with vitamin C to boost absorption.",
              "foods": ["lentils", "spinach", "pomegranate", "dates"],
              "icon": "nutrition"
            },
            "wellness": {
              "title": "Heat Therapy",
              "tip": "A warm compress on your lower abdomen can relieve cramps better than medication for mild-moderate pain (ACOG, 2021).",
              "icon": "wellness"
            },
            "mood": {
              "title": "It's Okay to Rest",
              "tip": "Estrogen and progesterone are at their lowest. Feelings of sadness or withdrawal are hormonal. Be gentle with yourself.",
              "affirmation": "My body is wise. This cycle is complete.",
              "icon": "mood"
            }
          }
        }
      ]
    }
  ]
}
```

#### Medical Conditions Schema (assets/content/conditions/conditions_[locale].json)
```json
{
  "conditions": [
    {
      "id": "pcos",
      "name": "Polycystic Ovary Syndrome (PCOS)",
      "arabicName": "متلازمة تكيس المبيضين",
      "prevalence": "Affects ~10% of women of reproductive age (WHO)",
      "shortDescription": "A hormonal disorder causing enlarged ovaries with small cysts, irregular periods, and elevated androgens.",
      "symptoms": ["irregular_periods", "acne", "hair_loss", "weight_gain", "hirsutism", "fatigue", "mood_changes"],
      "diagnosisCriteria": "Rotterdam criteria: 2+ of: irregular periods, elevated androgens, polycystic ovaries on ultrasound",
      "trackingRecommendations": [
        "Log every cycle start/end — irregularity IS the data",
        "Track acne, hair changes, and weight weekly",
        "Note insulin resistance symptoms: sugar cravings, energy crashes after meals",
        "Log exercise and diet — lifestyle changes are first-line treatment"
      ],
      "redFlags": [
        "Periods more than 90 days apart",
        "Sudden severe pelvic pain",
        "Rapid unexplained weight changes"
      ],
      "doctorVisitPrepQuestions": [
        "What are my AMH, LH, FSH, and testosterone levels?",
        "Should I be screened for insulin resistance?",
        "What are my options for regulating my cycle?",
        "How does PCOS affect my fertility?",
        "What lifestyle changes have the strongest evidence?"
      ],
      "medicalResources": [
        {
          "title": "PCOS Awareness Association",
          "url": "https://www.pcosaa.org"
        }
      ],
      "disclaimer": "This information is for educational purposes only. A proper diagnosis requires clinical evaluation."
    }
  ]
}
```

### 5.3 Content Editor Guide
Create `docs/content/CONTENT_GUIDE.md` explaining:
- How to add a new article (JSON structure with examples)
- How to update pregnancy week data
- How to add coaching day content
- How to add/translate a medical condition
- How to add new symptom definitions
- Validation rules and required fields
- How to reference medical sources

---

## PART 6: ONBOARDING FEATURE

### Research First
Search: "best onboarding UX patterns health apps 2024", "Flo onboarding flow", "Clue signup experience". Study the question flows in each competitor.

### 6.1 Onboarding Flow Design
Multi-step onboarding that branches based on user's primary goal:

```
Screen 1: Welcome + Brand Introduction
  - Femio logo animation (Lottie)
  - Tagline: "Your health, beautifully understood"
  - "Get Started" gradient button
  - "Already have an account? Sign in"

Screen 2: What Brings You to Femio? (Primary Goal)
  Options (tap card UI, allow multiple):
  [icon] Track my period & health
  [icon] Try to get pregnant
  [icon] I'm pregnant
  [icon] Track fertility (not TTC)
  [icon] Postpartum recovery
  [icon] Perimenopause support
  [icon] General women's health

Screen 3: Basic Profile (name optional, dob required for age-appropriate content)

Screen 4: Cycle Information (branch A: period tracking goal)
  - Has your period started? (yes/no/not sure)
  - Approximate duration of your last period
  - Average cycle length (or "I don't know" option)
  - Flow intensity (light/normal/heavy/irregular)

Screen 5 (branch B: TTC): Trying to Conceive Setup
  - How long have you been trying?
  - Any known fertility conditions?
  - Tracking methods used? (OPK, BBT, etc.)

Screen 5 (branch C: pregnant): Pregnancy Setup
  - Enter due date or LMP
  - Any complications? (gestational diabetes, etc.)
  - Partner sharing? (invite partner)

Screen 6: Health Conditions (optional but valuable for personalization)
  Multi-select: PCOS / Endometriosis / PMDD / Thyroid disorder / Anemia / None / Prefer not to say

Screen 7: Notifications Preferences
  - Period reminder (X days before)
  - Fertile window alerts
  - Daily wellness tips
  - Medication reminders
  - Set notification time

Screen 8: Privacy & Data
  - "Your data never leaves your device without your consent"
  - Data stored locally
  - Optional cloud backup (requires account)
  - Biometric lock option

Screen 9: Create Account (soft gate — can skip)
  - Email + password
  - OR Google / Apple sign-in
  - OR "Continue without account" (full local functionality)

Screen 10: All Set! 
  - Summary of what's been set up
  - Personalized welcome message
  - "Let's go" → Dashboard
```

### 6.2 Skip Logic
- User can skip any optional screen
- Can complete any skipped section later in Profile
- No data lost if onboarding is interrupted

### 6.3 Re-Onboarding / Journey Switch
From Profile: user can switch primary goal (e.g., "I'm now pregnant" while previously tracking period). Smooth journey transition preserving existing data.

---

## PART 7: CYCLE TRACKING FEATURE (Most Critical Feature)

### Research First
MANDATORY: Search these resources before coding:
1. helloclue.com — study their calendar, tracking options, cycle wheel design
2. flo.health — study their prediction accuracy claims, symptom logging UI
3. Search "menstrual cycle prediction algorithm" and "fertility awareness method clinical guidelines"
4. WHO: "Medical eligibility criteria for contraceptive use" (for FAM content)
5. ACOG: "Menstruation in girls and adolescents" guidelines

### 7.1 Medical Foundation
Based on medical literature, implement:
```dart
class MedicalConstants {
  // Normal cycle ranges (ACOG guidelines)
  static const int normalCycleMin = 21;    // days
  static const int normalCycleMax = 38;    // days
  static const int normalPeriodMin = 3;    // days
  static const int normalPeriodMax = 7;    // days
  static const int normalFlowVolumeMin = 20;   // mL per cycle
  static const int normalFlowVolumeMax = 80;   // mL per cycle
  static const int heavyBleedingThreshold = 80; // mL per cycle (WHO)

  // Luteal phase (relatively fixed at 12-16 days per medical literature)
  static const int lutealPhaseMin = 12;
  static const int lutealPhaseMean = 14;
  static const int lutealPhaseMax = 16;

  // Sperm survival (for fertile window calculation)
  static const int spermSurvivalDays = 5;

  // Ovulation window estimation
  // Ovulation day = cycle length - luteal phase (12-16 days)
  // Fertile window = 5 days before ovulation + ovulation day
}
```

### 7.2 Prediction Engine (AI-Weighted Algorithm)
```
Location: lib/features/cycle/data/services/cycle_prediction_engine.dart

Algorithm:
1. Collect last N cycles (max 12 for rolling window)
2. Weighted average: more recent cycles weight higher
   Weights for 5 cycles: [0.35, 0.25, 0.20, 0.12, 0.08]
   For fewer cycles: redistribute proportionally
3. Calculate standard deviation for confidence scoring
4. Predict next period:
   nextPeriodStart = lastPeriodStart + weightedAvgCycleLength
5. Predict ovulation:
   ovulationDay = nextPeriodStart - 14 (luteal phase assumption)
   For users with tracked BBT rises, refine with actual ovulation confirmation
6. Fertile window: 5 days before ovulation through ovulation day
7. Confidence:
   High (>85%): std dev ≤ 1.5 days AND 5+ cycles
   High-Med (75-85%): std dev ≤ 2 days AND 4+ cycles
   Medium (60-75%): std dev ≤ 3 days AND 3+ cycles
   Low (<60%): < 3 cycles OR std dev > 3 days
8. Adapt after each new period logged — recalculate immediately

EDGE CASES to handle:
- Irregular cycles (PCOS): Show wider window, suggest medical consultation
- First cycle entered: Use age-based averages as prior
- Cycles entered manually vs app-logged: weight differently
- Perimenopause: Widening cycle variability — special handling
```

### 7.3 Tracking Options (120+ like Clue)
```dart
// Group symptoms logically
enum SymptomCategory {
  period,           // start/end, flow intensity, color, clots
  pain,             // cramps, headache, backache, breast tenderness, pain location
  mood,             // happy, sad, anxious, irritable, calm, sensitive, PMS mood
  energy,           // high, normal, low, exhausted
  sleep,            // hours, quality, insomnia, nightSweats
  cervicalMucus,    // dry, sticky, creamy, watery, eggWhite (fertile sign)
  cervixPosition,   // high/low, open/closed, soft/firm (advanced FAM)
  bbt,              // basal body temperature (FAM)
  opk,              // ovulation predictor kit result (positive/negative/peak)
  pregnancyTest,    // negative/positive
  sex,              // protected, unprotected, spontaneous
  skinHair,         // acne, oilySkin, drySkin, hairLoss, hirsutism
  digestion,        // bloating, constipation, diarrhea, nausea
  appetiteWeight,   // cravings, decreased appetite, weight up/down
  medical,          // fever, illness, medication change
  exercise,         // type, duration, intensity
  travel,           // timezone change (affects predictions)
  stress,           // level, cause
  custom,           // user-defined tags
}
```

### 7.4 Calendar UI Requirements
Study Clue's calendar and Flo's calendar before building. Requirements:
- **Month view** (default): Color-coded days by cycle phase
  - Red gradient: Period days
  - Blue gradient: Follicular phase
  - Green gradient: Ovulation window (fertility window)
  - Purple gradient: Luteal phase
- **Predicted days**: Shown with dotted border or slightly lighter shade
- **Today**: Prominent circle with current day number
- **Tap to log**: Tap any day → bottom sheet with quick logging options
- **Horizontal scroll**: Swipe between months
- **Week view**: Toggle to horizontal week strip at top (like Google Calendar)
- **Day detail**: Tap → see all logged items for that day
- **Zoom in/out**: Pinch gesture or toggle between month/week/day

### 7.5 Dashboard Cycle Card
The hero element on the dashboard.
```
Design: Large circular progress ring (like Apple Watch activity rings)
- Outer ring: Current cycle progress (day X of Y estimated days)
- Inner area: Dynamic content based on cycle phase
  - Phase name in large text: "Follicular Phase"
  - Days until next period: "12 days"  
  - Confidence: "Based on 6 cycles — 87% confident"
  - Current fertile status: "Not fertile today" / "Approaching fertile window"

Tap → Opens cycle home page
"Log Today" quick action button with + icon
```

### 7.6 Cycle Report Page
End-of-cycle summary (auto-generated when new period starts):
- Cycle length vs average
- Period duration
- Notable symptoms this cycle
- Mood trends
- Cycle phase activity summary
- Prediction accuracy (if this was predicted)
- Export as PDF
- Share summary (redacted text, no sensitive data)

---

## PART 8: FERTILITY & OVULATION TRACKING

### Research First
MANDATORY searches:
1. Study premom.com/fertility-app/ — BBT + LH combined charting
2. Study naturalcycles.com — how they use BBT confirmation of ovulation
3. Search "BBT charting fertility awareness" — medical guidelines  
4. Search "LH surge detection ovulation prediction" — clinical basis
5. Look at "Fertility Friend" app — specialized BBT charting

### 8.1 BBT (Basal Body Temperature) Tracking
```
Medical basis: Temperature rises 0.2-0.5°C AFTER ovulation due to progesterone
Purpose: CONFIRM ovulation has occurred (not predict it)

UI Requirements:
- Daily BBT entry with time of measurement (must be taken at same time daily)
- BBT Chart: Beautiful line chart (fl_chart)
  - X-axis: Cycle days
  - Y-axis: Temperature in °C or °F (user preference)
  - Highlight the "cover line" (manually set or auto-calculated)
  - Mark ovulation day (the last low temp before sustained rise)
  - Overlay: LH surge data, period days, cervical mucus observations
  - Different colored series for multiple cycles
- Smart reminders: "Don't forget your BBT before getting up!"
- Data analysis: Detect thermal shift (cover line method)
  After 3 consecutive temps above cover line → confirmed ovulation
  
Temperature input:
  Celsius: 35.0-38.0°C (abnormal outside this range → show warning)
  Fahrenheit: 95.0-100.4°F
  Precision: 2 decimal places required

Warnings:
  - "Temperature taken outside normal time window may be inaccurate"
  - "Illness or poor sleep can affect BBT — mark as 'disturbance'"
```

### 8.2 OPK (Ovulation Predictor Kit) Logging
```
Log results: Negative / Low / High / Peak
Show LH surge curve on chart
Integrate with BBT chart for complete fertility picture
Optional: Camera-based test reading (future feature — stub as "coming soon")
Medical context: "LH surge precedes ovulation by 24-48 hours (ACOG)"
```

### 8.3 TTC Mode (Trying to Conceive)
```
Activated when goal = pregnancy

Dashboard changes:
  - Shows "TTC Window" indicator
  - Daily conception tip
  - Intercourse timing recommendations based on fertile window
  - Pregnancy chance estimate for today (based on cycle day, LH, BBT)

Partner Sharing:
  - Invite partner via QR code or email
  - Partner sees (chosen info): fertile window, mood insights
  - Partner gets reminders: "Today is a high-fertility day for [Name]"
  - Partner mode is a couple app within the app

TTC Insights:
  - "Your most fertile days this cycle: [date range]"
  - "How many cycles have you been trying?" tracker
  - Monthly TTC report
  - "When to consider seeing a fertility specialist" guidance
    (after 12 months under 35, after 6 months over 35 — ACOG guidelines)
```

### 8.4 Fertility Chart (Key Feature)
Inspired by Premom's comprehensive chart. Show on a single chart:
- BBT trend line
- LH test results (bar graph overlay)
- Cervical mucus observations (icons on x-axis)
- Period calendar markers at top
- Predicted/confirmed ovulation marker
- Cycle comparison: overlay up to 3 previous cycles for pattern analysis

---

## PART 9: PREGNANCY TRACKING FEATURE

### Research First
MANDATORY searches:
1. Study flo.health/product-tour/pregnancy-app — their week-by-week structure
2. Study WhatToExpect.com app features
3. Study babycenter.com pregnancy tracker
4. Search ACOG, NHS, WHO pregnancy guidelines — what MUST be included medically
5. Search "fetal development week by week medical" — accurate data needed
6. Study "pregnancy app kick counter contraction timer" — UI patterns

### 9.1 Pregnancy Mode Setup
```
Activation:
  - Switch from cycle tracking in profile
  - OR select "I'm pregnant" in onboarding

Setup screen:
  - Enter LMP (last menstrual period) date
  - OR enter confirmed due date
  - OR enter current weeks pregnant
  - Optional: IVF transfer date method
  
Due date calculation:
  Naegele's rule: LMP + 280 days (40 weeks)
  OR: Transfer date + 266 days (IVF)
  Show both current gestational week and due date prominently
```

### 9.2 Week-by-Week Content (Must be medically excellent)
Each week JSON entry must include (from `assets/content/pregnancy/weeks_[locale].json`):
```
Baby Development:
  - Size comparison (use culturally relevant objects — fruits, Arabic fruits, household items)
  - Length and weight in both metric and imperial
  - Key developmental milestones this week
  - What's forming/growing
  - Baby movement patterns

Maternal Changes:
  - Physical changes expected this week
  - Common symptoms (medically reviewed)
  - Emotional changes

Weekly Checklist:
  - Medical appointments
  - Screenings and tests (culturally and regionally relevant)
  - Preparations to make

Nutrition Guide:
  - Key nutrients this week and food sources
  - Halal food alternatives highlighted
  - Foods to avoid (evidence-based)
  - Supplement guidance

Exercise Guidelines:
  - Safe exercises for this week
  - Exercises to avoid
  - Intensity guidelines

Warning Signs:
  - Symptoms requiring immediate medical attention this week
  - Country-specific emergency resources

Quiz (1 question per week):
  - Fun/educational question about pregnancy
```

### 9.3 Pregnancy Dashboard
```
Hero Card:
  - Large number: "Week 24" 
  - Baby size: "The size of an ear of corn"
  - Animated illustration of fetus size
  - Days until due date: "112 days to go"
  - Progress bar: "60% of your pregnancy"

Secondary Cards:
  - "This week in your belly" — tap for full development info
  - "How you might be feeling" — current week maternal changes
  - "Your weekly checklist" — incomplete items shown with count
  - "Today's tip" — coaching card

Quick Actions:
  - "Log symptoms"
  - "Kick counter"
  - "Contraction timer"
  - "BP Check" (important for preeclampsia monitoring)
  - "Doctor notes"
```

### 9.4 Kick Counter
```
Purpose: Count fetal movements (kicks, rolls, jabs)
Medical basis: Count 10 movements in ≤2 hours is normal (ACOG recommendation)

UI:
  - Large, satisfying button to count kicks
  - Visual ripple animation on each tap
  - Progress toward 10-kick goal
  - Timer running
  - Session history (stored in Isar)
  - "Count complete" celebration when 10 reached
  - Time recorded per session
  
History view:
  - List of past sessions
  - Average time-to-10-kicks trend
  - Calendar heatmap of logging frequency
  - WARNING: If no session logged for 24+ hours, gentle reminder

Alert:
  - If no 10 kick count in 2 hours, show gentle advisory
  - Never alarmist — "Count didn't complete in 2 hours — contact your doctor to be sure"
  - NOT a diagnostic tool — clear disclaimer
```

### 9.5 Contraction Timer
```
Purpose: Time contractions during labor
UI:
  - "Contraction Start" / "Contraction End" toggle button
  - Real-time timer showing current contraction duration
  - List of last 10 contractions: start time, duration, interval
  - Automated analysis: "Contractions are [X] min apart, lasting [Y] seconds"
  - 5-1-1 rule indicator: Contractions ≤5 mins apart, ≥1 min duration, for ≥1 hour
  - "5-1-1 Rule reached — Time to call your provider!"
  - Export/share list for hospital

Design: Dark mode preferred for labor room use. Large buttons.
```

### 9.6 Hospital Bag Checklist
Pre-populated, customizable checklist with:
- Mother items
- Baby items
- Documents (culturally adapted — insurance cards, national ID formats)
- Partner/support person items
- Optional: birth plan template

Items from `assets/content/hospital_bag.json` — localizable

---

## PART 10: VITALS MONITORING (Comprehensive)

### Research First
Search: "blood pressure tracking app women", "pregnancy BP monitoring preeclampsia app", "glucose tracking gestational diabetes", "BBT chart app", "women vitals health dashboard"

Study: Withings, Omron Connect, and Apple Health vitals screens.

### 10.1 Blood Pressure Monitoring
```
Medical Reference: American Heart Association (AHA) 2018 guidelines

BP Categories (implemented as color-coded status):
  Normal:     Systolic < 120  AND  Diastolic < 80   → Green
  Elevated:   Systolic 120-129 AND Diastolic < 80    → Yellow
  Stage 1 HTN: Systolic 130-139 OR  Diastolic 80-89  → Orange
  Stage 2 HTN: Systolic ≥ 140  OR  Diastolic ≥ 90   → Red
  Crisis:     Systolic > 180  OR  Diastolic > 120    → Deep Red + ALERT

Special handling for Pregnancy:
  Preeclampsia threshold: BP ≥ 140/90 during pregnancy
  If pregnant user logs ≥ 140/90: Show immediate advisory
  "This reading may indicate preeclampsia — contact your healthcare provider or go to the nearest emergency room immediately"

Input:
  Systolic (top), Diastolic (bottom) — both required
  Heart rate (optional)
  Which arm used (optional)
  Posture: sitting/lying
  Time of day
  Notes

Charting:
  - Dual line chart (systolic + diastolic over time)
  - Color zones behind chart matching AHA categories
  - 7-day, 30-day, 90-day, All-time views
  - Moving average line
  - Faint lines at 120/80, 130/80, 140/90 for reference
  - Summary stats: Average, Min, Max, Most common category
  - Export as PDF for doctor

BP Goal setting:
  User can set personal BP target
  Trend arrows show if trending toward or away from goal
```

### 10.2 Weight Tracking
```
Input: Weight in kg or lb (user preference, converts automatically)
Goal weight setting
BMI calculator (with caveats about limitations)
Pregnancy weight gain: Track against IOM guidelines per pre-pregnancy BMI
  [IOM 2009: Underweight: 12.5-18kg; Normal: 11.5-16kg; Overweight: 7-11.5kg; Obese: 5-9kg]

Chart: Line chart with goal line, trend line
Weekly/monthly averages
```

### 10.3 Glucose Tracking
```
For: Gestational diabetes and general health tracking
Input: mmol/L and mg/dL (user preference)
Timing: Fasting, post-meal (2 hours), random
Reference ranges:
  Fasting: 3.9-5.5 mmol/L (70-100 mg/dL) — Normal
  Fasting in pregnancy: < 5.1 mmol/L (92 mg/dL) — WHO/IADPSG
  Post-meal (2h): < 8.5 mmol/L (153) in pregnancy (IADPSG)
Color-coded status per reading
HbA1c entry (from lab results)
Chart: Scatter plot with reference band
```

### 10.4 Temperature Tracking
```
Different from BBT (that's in fertility section)
This is body temperature for illness tracking
Input: °C or °F
Fever thresholds: ≥38°C (100.4°F) = fever
Visual fever indicator
During pregnancy: fever requires medical attention (note)
```

### 10.5 Vitals Dashboard Summary
```
A comprehensive grid of current status cards:
┌──────────────┬──────────────┐
│ BP: 118/76   │ Weight: 65kg │
│ ● Normal     │ ↓ 0.5kg/wk  │
├──────────────┼──────────────┤
│ Glucose:     │ Temp: 36.8°C │
│ 5.2 mmol/L   │ ● Normal     │
│ ● Normal     │              │
└──────────────┴──────────────┘
All cards tappable → detail view
"Last updated: Today, 9:15 AM"
```

---

## PART 11: SYMPTOM LOGGING & PATTERN ENGINE

### Research First
Search: "symptom tracking app review", "Clue symptom tracking 100+", "pattern detection menstrual health", "machine learning period symptom"

### 11.1 Symptom Logging UI
Inspired by Clue's elegant multi-column selection interface:
```
Daily Logging Screen:
  1. Quick access: most recently used symptoms at top
  2. Category grid with icons (Pain, Mood, Sleep, Skin, Digestion, etc.)
  3. Tap category → expand to show individual symptoms
  4. Multi-select within categories
  5. Severity slider for pain symptoms (1-10 or 1-5)
  6. Notes field
  7. Quick log from dashboard notification
  8. Log for past dates (allows retroactive entry)

Categories (120+ total tracking points):
  Period Flow: light/normal/heavy/spotting
  Clots: small/large
  Cramps: severity 1-10 + location
  Pain: back/breast/ovarian/pelvic/headache/migraine severity
  Mood: 8 mood options + intensity
  Energy: very high/high/normal/low/exhausted
  Sleep: hours + quality + issues (insomnia/waking/nightSweats)
  Skin: acne (location/severity)/oily/dry/rash
  Hair: normal/oily/dry/loss/hirsutism
  Digestion: bloating/nausea/constipation/diarrhea/appetite
  Exercise: type + duration + intensity
  Stress: level + source
  Sex: protected/unprotected/none/libido
  Cervical mucus: dry/sticky/creamy/watery/eggWhite
  Medication: taken/missed/changed
  Custom tags: user-defined
```

### 11.2 Symptom Pattern Engine
```
Location: lib/features/patterns/

Algorithm (run weekly on 3+ cycles of data):

1. TIMING PATTERNS:
   For each symptom, check if it appears within ±2 days of same cycle day across cycles.
   If appears in ≥60% of cycles → "Headaches tend to occur on cycle days 12-14"
   
2. SEVERITY PATTERNS:
   Average symptom severity per cycle day across cycles.
   If day X has avg severity ≥ 1.5x overall average → highlight as "peak day"
   Output: "Cramps are typically most severe on day 2 of your period"
   
3. PHASE ASSOCIATIONS:
   Map all symptoms to cycle phases.
   If symptom appears predominantly in one phase → label it.
   Output: "Bloating is strongly associated with your luteal phase"
   
4. CO-OCCURRENCE PATTERNS:
   Calculate correlation between symptom pairs.
   If symptom A and B appear together in ≥70% of days when A is logged → flag.
   Output: "When you log fatigue, you also tend to log brain fog (82% of the time)"
   
5. MOOD CORRELATIONS:
   Correlate mood scores with cycle phase.
   Output: "Your mood tends to be most positive in your follicular phase"
   
6. MINIMUM DATA: 3 complete cycles before showing patterns
7. CONFIDENCE DISPLAY: Color-coded badge (green >80%, yellow 60-80%, gray <60%)
8. UPDATE FREQUENCY: Recalculate after each completed cycle
9. PRO vs FREE: 
   Free: Top 3 patterns
   Pro: All patterns + charts + correlation matrix + export
```

### 11.3 Patterns UI
```
Patterns Page:
  Header: "X patterns detected based on Y cycles"
  
  Each Pattern Card:
    [Icon for symptom] [Pattern description]
    "Headaches tend to peak on days 12-14"
    Confidence bar: ████░░ 73% | "Based on 6 cycles"
    Mini sparkline showing pattern across cycle
    [Tap to see details] → chart of all cycles with this pattern
  
  Section: Correlations
    Bubble/scatter chart showing co-occurring symptoms
    
  Section: Phase Report
    Follicular | Ovulatory | Luteal | Menstrual
    Tap each phase → most common symptoms in that phase
    
  Bottom: "More patterns unlock as you log consistently"
```

---

## PART 12: CYCLE PHASE COACHING

### Research First
Search: "menstrual cycle fitness guide", "hormone health coaching app", "cycle syncing workout nutrition", "Alisa Vitti InFlo app cycle syncing"

Medical reference: "Hormonal fluctuations across menstrual cycle and exercise performance" (journal)

### 12.1 Content Framework
4 phases × (Daily tips for each day in phase) × 4 categories = comprehensive content

All coaching content in JSON files, fully localizable.
Medical basis required for ALL health recommendations.

Daily card categories:
1. **Exercise**: Phase-appropriate movement recommendations
2. **Nutrition**: Evidence-based food focus for each phase
3. **Wellness**: Self-care, sleep, stress management
4. **Mood**: Emotional support and awareness

### 12.2 Dashboard Integration
```
Dashboard Coaching Card:
  "Today: Day 8 — Follicular Phase"
  [Category icon] "Your energy is rising this week"
  "Focus on compound movements — your pain sensitivity is lower now"
  [See full plan] → Coaching page

Coaching Full Page:
  Current day and phase
  4 tabbed categories: Exercise / Nutrition / Wellness / Mood
  Each tab shows today's card
  Scroll down: This week at a glance
  Scroll down: Next phase coming up
  
Free: Today's card in one category
Pro: All 4 categories + week view + full phase content library
```

### 12.3 Cultural Adaptation for MENA
Nutrition recommendations must include:
- **Halal food alternatives** for all protein suggestions
- **Ramadan variation**: Modified eating pattern coaching during Ramadan
- **Regional foods**: Dates (for iron + energy), pomegranate, sumac, za'atar, dried fruits, legumes used in MENA
- Culturally relevant exercise options (home-based options emphasized where appropriate)

---

## PART 13: HEALTH CONDITIONS PROFILES

### Research First
Search: "PCOS tracking app best features", "endometriosis pain tracking app", "PMDD monitoring app", "thyroid health tracking women"

### 13.1 Supported Conditions (with rich profiles)
Each with: Description, Prevalence, Symptoms to track, Red flags, Treatment overview, Doctor visit prep, Resources

1. **PCOS** - Polycystic Ovary Syndrome
2. **Endometriosis**
3. **PMDD** - Premenstrual Dysphoric Disorder
4. **PMS** - Premenstrual Syndrome
5. **Thyroid disorders** (Hypo/Hyperthyroidism, Hashimoto's)
6. **Anemia** (Iron-deficiency)
7. **Fibroids** - Uterine fibroids
8. **Adenomyosis**
9. **Gestational Diabetes** (pregnancy-specific)
10. **Preeclampsia** (pregnancy-specific)
11. **Hyperemesis Gravidarum** (pregnancy-specific)

### 13.2 Condition-Specific Tracking Overlays
When user selects a condition, the app gains context:
```
PCOS Active:
  - Dashboard: "PCOS Tracker: Logging consistently helps detect irregular patterns"
  - Extra tracking options: insulin resistance symptoms, hirsutism, acne severity
  - Cycle predictions: "Your cycles may be irregular — we'll show wider prediction range"
  - Flag: Alert if cycle > 45 days (without known reason)

Endometriosis Active:
  - Pain diary: Specialized pain location map (body front/back touch interface)
  - Pain severity journal over time
  - Flare trigger tracking
  - "Avoid missing appointments during flares" reminders

PMDD Active:
  - Mood tracking emphasis
  - Daily mood score 1-10 during luteal phase
  - Monthly PMDD severity report
  - Treatment response logging
```

### 13.3 Doctor Visit Prep Generator
```
Auto-generates from last 3-6 months of data:
  - Summary: Last 6 cycles with dates, durations, irregularities
  - Top 5 most frequent symptoms this month
  - Vitals trends
  - Medication history
  - Condition-specific questions to ask

Output: Beautiful PDF, shareable, printable
Contains: Only what user consents to share (privacy first)
One-tap share or print from app
```

---

## PART 14: SMART NOTIFICATIONS

### Research First
Search: "mobile app notification strategy health", "push notification best practices women health app", "notification fatigue mobile"

### 14.1 Notification Types
```
1. Period Reminder
   - 3 days before predicted period: "Your period is expected in 3 days. Be prepared!"
   - 1 day before: "Period expected tomorrow"
   - If period is late: "Your period is 2 days late. We've updated your predictions."

2. Fertile Window Alert (TTC or tracking)
   - 5 days before fertile window: "Fertile window opens in 5 days. Fertility signals to watch..."
   - Day of fertile window: "Today is likely a fertile day (day X of Y)"
   - Ovulation day: "Today may be ovulation day — LH surge peak expected"

3. Medication Reminder
   - User-set times: "Time to take [Medication Name]"
   - Pill-specific reminder: "Take your contraceptive pill now"
   - Missed dose: "Did you take [medication] today?"

4. Logging Nudge (opt-in)
   - Evening (default 8PM): "How are you feeling today? Log your symptoms"
   - Streak protection: "Day 14 streak! Don't break it — log something today"

5. Vitals Reminder (opt-in, per vital type)
   - BP: "Time for your daily blood pressure check"
   - BBT: "Wake up BBT reminder — before getting out of bed!"
   - Glucose: "2-hour post-meal glucose check"

6. Pregnancy Milestones
   - Week change: "You're now [X] weeks pregnant! New info in the app"
   - Kick counting reminder (after week 28)
   - Appointment reminders

7. Weekly Summary (opt-in, Sunday morning)
   - "Your week: [X] symptoms logged, cycle day [Y], [Z] day streak"
   - Quick insight: most common symptom this week

8. Milestone Achievements
   - 7-day streak logged
   - 1 month of consistent tracking
   - "5 cycles logged — predictions are now more accurate!"
```

### 14.2 Discreet Mode
When enabled, all notifications use generic text:
- "Period Reminder" → "Health Reminder"
- "Fertile Window" → "Calendar Reminder"
- "Pregnancy Milestone" → "Wellness Update"

User controls which notifications appear on lock screen.

### 14.3 Notification Implementation
```dart
// flutter_local_notifications with timezone-aware scheduling
// Store user preferences in SharedPreferences
// NotificationService manages all scheduling/cancellation
// Reschedule when predictions update
// Respect: Do Not Disturb hours (user-configured quiet hours)
// Batch notifications where possible (max 1 per category per day)
```

---

## PART 15: DOCTOR REPORT EXPORT

### Research First
Search: "doctor visit health report app", "menstrual health report PDF", "PCOS data for doctor"

### 15.1 PDF Report Structure
Generated using the `pdf` package. 5 pages for Pro, 2-page summary for Free (watermarked):

**Page 1: Patient & Report Summary**
- Patient name (optional — user writes it in export dialog)
- Report date range (user selects: 3, 6, 12 months, or custom)
- Primary goal / journey mode
- Active health conditions
- Medications
- Generated by Femio with version/date

**Page 2: Cycle History Table**
- Table of cycles: Start date, Period duration, Cycle length, Notes
- Average cycle length ± standard deviation
- Regularity assessment
- Mini line chart of cycle length trend

**Page 3: Symptom Report**
- Top 10 most frequent symptoms this period
- Occurrence count per cycle phase
- Severity trends
- Identified patterns (from pattern engine)

**Page 4: Vitals Summary**
- BP table: date, reading, category — last 30 readings
- Average and trend
- Weight trend chart
- Glucose readings (if logged)

**Page 5: Doctor Questions (Condition-Specific)**
- Auto-generated questions based on active conditions
- User can add/remove questions before export

**Export Options:**
- Share via share_plus (WhatsApp, email, etc.)
- Print directly
- Save to device

### 15.2 Pro Gating
Free: Page 1 + 2 with watermark "Generated by Femio Free — Upgrade for full report"
Pro: All 5 pages, no watermark, patient name customization, date range selection

---

## PART 16: HEALTH LIBRARY

### Research First
Study: helloclue.com/articles — how Clue structures their encyclopedia (beautiful, deep)
Study: flo.health/health-library — their categories and article depth
Assess: What topics are missing from MENA-specific women's health content

### 16.1 Library Structure
Content loaded from JSON files per locale. Categories:

```
1. Understanding Your Cycle
   - The 4 phases
   - Hormones and what they do
   - What's normal vs abnormal
   - Cycle variations (short/long, irregular)

2. Fertility & Conception
   - How conception works
   - Fertile window explained (BBT, CM, OPK)
   - Age and fertility
   - Male fertility factors
   - IVF and assisted conception basics

3. Pregnancy
   - Early pregnancy symptoms
   - Trimester by trimester guides
   - Common pregnancy concerns
   - High-risk pregnancy

4. Birth Control
   - Contraception methods overview
   - Hormonal methods
   - Non-hormonal methods
   - Emergency contraception
   - FAM (Fertility Awareness Method)
   - Islamic perspective on family planning (MENA context)

5. Health Conditions
   - PCOS guide
   - Endometriosis guide
   - PMDD/PMS explained
   - Thyroid and cycle connection
   - Anemia and periods

6. Nutrition & Lifestyle
   - Eating for your cycle
   - Iron-rich foods guide
   - Calcium and bone health
   - Exercise and hormones
   - Sleep and your cycle
   - Stress management

7. Menopause & Perimenopause
   - What to expect
   - Perimenopause symptoms
   - Menopause transition
   - HRT options

8. Sexual Health
   - STI awareness (culturally sensitive framing for MENA)
   - Sexual wellness
   - Painful sex (vaginismus, vulvodynia, endometriosis connection)

9. Mental Health
   - Hormones and mood
   - Anxiety and your cycle
   - Depression and PMDD
   - Perinatal mental health
```

### 16.2 Article Features
- Full-text search (local search across all article titles and content)
- Bookmark/save articles
- Reading progress indicator
- Related articles at bottom
- "Was this helpful?" feedback
- Share article (link only if online)
- Offline reading (all articles ship in app bundle)
- Medical review date and source citations visible
- Disclaimer on all health content

---

## PART 17: HEALTH CALCULATORS (8+ Calculators)

### Research First
Study: compete app calculators, WebMD tools, Mayo Clinic calculators for women's health

Each calculator produced by medical authorities must include:
- Medical formula and source reference
- Interpretation guide with color-coded result
- Disclaimer: "For educational purposes — not a medical diagnosis"
- "Discuss your results with your healthcare provider"

### Calculators to Build:
1. **Due Date Calculator** — Naegele's rule (LMP + 280 days) and reverse calculation
2. **Ovulation/Fertile Window Calculator** — Based on cycle length and luteal phase
3. **BMI Calculator** — With context for women (limitations noted), pregnancy weight charts
4. **Period Cycle Analyzer** — Enter 3+ cycles → regularity score, average, SD
5. **Blood Pressure Classifier** — AHA categories with advice
6. **Pregnancy Weight Gain Guide** — IOM 2009 targets by pre-pregnancy BMI
7. **Due Date by Ultrasound** — CRL or BPD-based dating
8. **Glucose Converter** — mmol/L ↔ mg/dL with pregnancy reference ranges
9. **Baby Kick Count Analyzer** — Sessions analysis, completeness rate
10. **Ovarian Reserve Estimator** (educational) — Age-based AMH expectations

---

## PART 18: PERIMENOPAUSE MODE (NEW - Not in v1)

### Research First
MANDATORY: Study Natural Cycles' perimenopause section, Flo's perimenopause features
Search: "perimenopause app features", "menopause tracking digital health", NAMS (North American Menopause Society) guidelines

### New Feature — Add This
Perimenopause is massively underserved in digital health. Based on research:
- Natural Cycles just launched their perimenopause mode
- Flo offers basic support
- Massive opportunity to serve 45-55 year old women

### Activation
- User selects "Perimenopause" as primary goal
- OR app detects significant cycle irregularity + age >40 → gentle suggestion

### Tracking Focus
```
Symptoms specific to perimenopause:
  - Hot flashes (frequency, severity, time of day)
  - Night sweats
  - Sleep disturbances
  - Brain fog
  - Vaginal dryness
  - Mood changes (specific perimenopause patterns)
  - Joint aches
  - Heart palpitations
  - Cycle changes (skipped, heavy, light)

Predictions: Show "Cycle variability is expected in perimenopause"
No regular predictions shown (misleading during perimenopausal transition)
Instead: "Tracking patterns across your transition"

Library content: Dedicated perimenopause library section
HRT information: Evidence-based, note to discuss with doctor
```

---

## PART 19: WEARABLES INTEGRATION (Foundation)

### Research First
Search: "Flutter health package Apple Health Google Health Connect", "Health Connect Android API wearable women health data", "Fitbit API period data"

### Implementation
```dart
// Use the `health` Flutter package for unified Health Connect + Apple Health

Read permissions only (NEVER write to user's health systems without explicit consent):
  - Heart rate (resting)
  - Steps
  - Sleep (duration + stages if available)
  - BBT (if device supports — Apple Watch Ultra, Oura Ring)
  - Blood glucose
  - Blood oxygen

Auto-populate:
  If sleep data available → pre-fill sleep log in symptoms
  If BBT available → pre-fill BBT for fertility tracking
  If heart rate → show in vitals dashboard

Settings page:
  "Connected Data Sources"
  [Apple Health toggle] / [Health Connect button]
  Per-data-type toggles
  Last sync timestamp
  Sync Now button

Pro feature: Wearable integration is Pro-only
Free users see the page with "Connect wearables to enhance your tracking"
Upgrade button
```

---

## PART 20: MONETIZATION (Revenue Model)

### Research First
Study: Flo pricing ($49.99/year), Clue Plus ($39.99/year), Natural Cycles ($79.99/year)

### 20.1 Pricing Strategy (Freemium)
```
FREE TIER (Generous — full core functionality):
  - Unlimited period and symptom logging
  - Basic cycle predictions
  - Pregnancy tracking (basic)
  - Full library access
  - All 10 calculators
  - Postpartum tracking
  - Top 3 symptom patterns
  - Period reminders
  - 4 languages, dark mode
  - Guest + account mode
  - BBT + OPK logging

PRO TIER: $3.99/month OR $34.99/year (save 27%)
  - AI predictions with confidence scores
  - Full symptom pattern engine (all patterns + charts)
  - Full coaching (all 4 categories daily)
  - Health condition profile + doctor visit prep
  - All smart notifications + weekly summary
  - Doctor report PDF export (5-page)
  - Wearable integration
  - Perimenopause mode
  - Cloud backup + multi-device sync
  - Partner sharing (full fertility sharing)
  - No ads
  - Priority support

PREMIUM ANNUAL: Show "Save 27%" badge — use RevenueCat for IAP management
```

### 20.2 Paywall Design
```
Pro Paywall Page:
  - Gradient header with Femio logo
  - "Unlock the full power of Femio"
  - Feature comparison: FREE vs PRO in scrollable table
    (Not too long — max 10 rows, most impactful features)
  - Pricing cards side by side: Monthly | Annual (annual highlighted)
  - Social proof: "Join X,XXX women who've upgraded"
  - Restore Purchase link (required by App Store)
  - Privacy: "Manage subscription" link
  - Close button (not hidden)
  - 7-day free trial for new users
```

### 20.3 Feature Gate Service
```dart
enum ProFeature {
  fullPatternEngine,
  confidencePredictions,
  fullCoaching,
  doctorReport,
  wearableIntegration,
  cloudSync,
  partnerSharing,
  perimenopauseMode,
  weeklyNotificationSummary,
  unlimitedHealthConditions,
}

class FeatureGateService {
  bool isPro();
  bool canAccess(ProFeature feature);
  void maybeShowPaywall(BuildContext context, ProFeature feature, {VoidCallback? onGranted});
}
```

---

## PART 21: SETTINGS & PROFILE

### 21.1 Settings Structure
```
Profile:
  - Name (optional), Date of birth
  - Primary goal / Journey (editable)
  - Health conditions (edit list)
  - Unit preferences: Metric/Imperial
  - Temperature: °C/°F
  - Calendar: Gregorian/Hijri/Both
  - Country/region

Notifications (each with toggle + time picker):
  - Period reminders (days before: 1/2/3)
  - Fertile window alerts
  - Daily symptoms reminder
  - Medication reminders
  - Pregnancy weekly milestone
  - Weekly health summary
  - App-wide Quiet Hours

Privacy & Security:
  - Biometric/PIN lock (enable/disable + set PIN)
  - Discreet mode (app icon + notification text)
  - Data export (JSON + CSV + PDF)
  - Data import (with JSON schema validation)
  - Delete all local data (with confirmation)
  - Account deletion

Display:
  - Theme: Light/Dark/OLED/Rose Gold/Nature
  - Language selector
  - Font size: Standard/Large/Extra Large

About:
  - Version info
  - Medical disclaimer
  - Privacy policy
  - Terms of service
  - Rate app
  - Contact support
  - Licenses
```

### 21.2 PIN/Biometric Lock
Full implementation:
- Local Auth for biometric
- 4-6 digit PIN as fallback
- Lock on app background (configurable: immediately / 1min / 5min)
- "Forgot PIN" → authenticate with biometrics or delete data option

---

## PART 22: CODE QUALITY RULES (Non-Negotiable)

### 22.1 Architecture Rules
```
1. CLEAN ARCHITECTURE: Every feature = domain/ + data/ + presentation/
2. BLOC PATTERN: No Cubit for complex state. Only Cubit for simple UI state.
3. DEPENDENCY INJECTION: Every class registered in injection_container.dart
4. ENTITIES: Isar entities in data layer. Domain entities are pure Dart only.
5. ERROR HANDLING: Either<String, T> throughout domain layer. Never throw raw exceptions.
6. CONSTANTS: Zero hardcoded values. Use AppColors, AppDimensions, AppTextStyles.
7. STRINGS: Zero hardcoded user-facing strings. All in ARB files.
8. NAVIGATION: GoRouter with typed routes. No Navigator.pushNamed() with strings.
9. CONST: Use const constructors everywhere possible.
10. LISTS: Always use ListView.builder() for dynamic lists. Never ListView(children:[...]) for dynamic data.
```

### 22.2 Security Rules (OWASP-aligned)
```
1. Isar encryption: Apply cryptographic key from flutter_secure_storage to Isar init.
2. No PII in logs: Never log names, dates, health data to console in release mode.
3. Input sanitization: All text inputs sanitized before storage.
4. Firebase Rules: Firestore must have security rules — users can only read/write their own data.
5. API keys: Use firebase_options.dart with environment configuration, never commit real keys.
6. Certificate pinning: Add for production (network_security_config.xml for Android).
7. Biometric: Local only — never transmit biometric data.
8. Data minimization: Collect only what's needed. Document all collected data in Privacy Policy.
9. Secure key storage: flutter_secure_storage for all sensitive values.
10. Export validation: JSON import must validate schema before applying.
```

### 22.3 Testing Requirements
```
Unit Tests (minimum coverage targets):
  - Cycle prediction engine: 90%+ coverage (critical algorithm)
  - Pattern detection service: 85%+ coverage
  - All use cases: 80%+ coverage
  - Feature gate service: 95%+ coverage
  - Medical constants and classifications: 95%+ coverage
  - BP category classifier: 100% coverage (all AHA categories)

Widget Tests:
  - Dashboard renders correctly for each journey mode
  - Cycle calendar renders with different cycle lengths
  - Each calculator produces correct output

Integration Tests:
  - Full onboarding flow completes and saves data
  - Cycle log → prediction update flow
  - Symptom log → pattern update flow

Golden Tests (visual regression):
  - Dashboard in all 5 themes
  - Cycle calendar in light and dark mode
  - Key pages in Arabic RTL layout
```

### 22.4 Performance Rules
```
- RepaintBoundary on cycle wheel (complex paint)
- RepaintBoundary on BPT chart (continuous redraw)
- Lazy load library articles (paginated, not all loaded)
- Images: CachedNetworkImage for remote, precacheImage for local
- Isar queries: Indexed fields only in .where() clauses
- BLoC: Use buildWhen to minimize rebuilds
- const widgets: Aggressively const wherever possible
- Profile with DevTools before shipping — 0 jank frames on core flows
```

### 22.5 Accessibility Rules
```
- Semantics on all interactive elements
- All images have semanticLabel
- Minimum 48x48dp touch targets (ALWAYS)  
- Test at 200% font size → zero overflow
- Color not the only indicator of status (add icons)
- VoiceOver/TalkBack compatible navigation
- High contrast ratios: 4.5:1 for body text, 3:1 for large text (WCAG AA)
```

---

## PART 23: BUILD ORDER & PHASING

Build in this exact order. Each phase must compile cleanly before proceeding.

### Phase 0: Foundation (Day 1-2)
1. New project + pubspec.yaml
2. Clean architecture folder structure
3. AppColors + AppDimensions + AppTextStyles
4. AppTheme (5 themes + theme switching)
5. GoRouter + all routes defined (empty screens)
6. GetIt DI container skeleton
7. Firebase setup + graceful wrapper
8. ARB files skeleton (EN, AR, FR, ES) — all keys defined
9. Core widgets: ShimmerWidget, EmptyStateWidget, ErrorStateWidget, GradientButton
10. Main navigation (bottom nav, 5 tabs)
11. `flutter analyze` → 0 errors

### Phase 1: Auth & Onboarding (Day 3-4)
1. Firebase Auth (email + Google + Apple)
2. Isar database setup with encryption
3. Complete onboarding flow (10 screens)
4. User profile entity + storage
5. Isar ↔ Firestore sync service (basic)
6. Tests for auth flow

### Phase 2: Dashboard (Day 5-6)
1. Dashboard page with all section blocks
2. Cycle hero card (placeholder data)
3. Quick logging button
4. Today's coaching card (placeholder)
5. Notifications summary card
6. Shimmer loading states for all sections

### Phase 3: Cycle Tracking (Days 7-10)
1. Isar entities: Cycle, DailyLog
2. Prediction engine with tests (90% coverage required)
3. Calendar page (month + week views)
4. Day logging bottom sheet (all 120+ options)
5. Cycle report page
6. Dashboard cycle card connected to real data
7. All 4 languages tested on core strings

### Phase 4: Vitals (Days 11-12)
1. BP tracking + chart + AHA classification
2. Weight tracking + chart + pregnancy weight overlay
3. Glucose tracking + chart
4. Temperature tracking
5. Vitals dashboard grid
6. Doctor report integration (vitals page 4)

### Phase 5: Symptoms + Patterns (Days 13-15)
1. Full symptom logging UI
2. Pattern detection algorithm with tests
3. Patterns page UI
4. Dashboard integration
5. Condition-specific overlays (PCOS, Endo)

### Phase 6: Fertility & TTC (Days 16-18)
1. BBT chart (beautiful, medical-grade)
2. OPK logging
3. Fertility chart (combined BBT + OPK + CM)
4. TTC mode + partner sharing infrastructure
5. Fertile window highlights on calendar

### Phase 7: Pregnancy (Days 19-22)
1. JSON data: all 40 weeks, in all 4 languages
2. Pregnancy dashboard
3. Week-by-week content pages
4. Kick counter (with history)
5. Contraction timer
6. Hospital bag checklist
7. Pregnancy symptom logging adaptations

### Phase 8: Coaching + Health Conditions (Days 23-25)
1. JSON data: coaching content all phases, all 4 languages
2. Coaching cards on dashboard
3. Full coaching page
4. Health conditions profiles from JSON
5. Doctor visit prep generator (PDF)

### Phase 9: Library + Calculators (Days 26-28)
1. JSON articles (minimum 30 per language to start)
2. Library UI with search + categories + bookmarks
3. All 10 calculators with medical references
4. Offline reading support

### Phase 10: Notifications (Days 29-30)
1. NotificationService implementation
2. All 8 notification types scheduled
3. Settings UI for notification preferences
4. Discreet mode

### Phase 11: PDF Export + Wearables (Days 31-33)
1. Doctor report PDF generator (5 pages)
2. Health Connect integration (Android)
3. Wearables settings page
4. Data sync from health sources

### Phase 12: Monetization (Day 34-35)
1. RevenueCat integration
2. Pro paywall page
3. FeatureGateService connected throughout
4. All Pro features gated correctly

### Phase 13: Settings, Polish, QA (Days 36-40)
1. Full settings page (all toggles working + persisting)
2. PIN/biometric lock
3. Data export/import with validation
4. Dark mode pass (all pages)
5. Arabic RTL pass (all pages)
6. Animation polish pass
7. Performance profiling + fixes
8. All tests passing
9. `flutter analyze` → 0 errors, 0 warnings
10. Full build: `flutter build apk --release` + `flutter build ipa` (if on Mac)

---

## PART 24: DOCUMENTATION REQUIREMENTS

Create these docs as you build (not after):

### Docs to Create:
```
docs/
├── architecture/
│   ├── ARCHITECTURE.md          # System design, data flow diagrams
│   ├── STATE_MANAGEMENT.md      # BLoC patterns used, event/state design
│   └── DATABASE_SCHEMA.md       # All Isar entities + Firestore structure
│
├── content/
│   ├── CONTENT_GUIDE.md         # How to edit JSON content files
│   ├── ARTICLE_TEMPLATE.md      # Template for new library articles
│   ├── PREGNANCY_WEEK_GUIDE.md  # How to enhance week data
│   └── MEDICAL_REVIEW_PROCESS.md # How to review and update medical content
│
├── features/
│   ├── CYCLE_PREDICTION.md      # Algorithm explanation + accuracy methodology
│   ├── PATTERN_ENGINE.md        # Pattern detection algorithm docs
│   └── NOTIFICATION_LOGIC.md    # Scheduling logic documentation
│
├── operations/
│   ├── BUILD_GUIDE.md           # How to build for Android + iOS + configure Firebase
│   ├── RELEASE_CHECKLIST.md     # Pre-release verification steps
│   ├── LOCALIZATION_GUIDE.md    # How to add/update translations
│   └── SECURITY_AUDIT.md       # Security practices and audit log
│
├── COMPETITIVE_ANALYSIS.md      # Competitor research + differentiation
└── MEDICAL_DISCLAIMERS.md       # All disclaimers used in app
```

### Code Documentation Rules:
- Public APIs must have dartdoc comments
- All medical algorithms documented with source references
- All JSON schemas have README in their directory
- CHANGELOG.md maintained

---

## PART 25: LOGO DESIGN SPECIFICATION

### Femio Logo Requirements
Design as SVG using Flutter CustomPaint or create as SVG file:

**Concept**: Abstract uterus + petals fusion
```
Primary mark concept:
  - Base shape: Stylized uterus outline (softened, abstract)
  - Fallopian tube curves extend upward forming two gentle curves
  - Ovary circles at end of each tube as accent dots
  - Optional bloom: Two small petal-like shapes framing the main form
  - Feel: Floral + anatomical + elegant

Color treatment options (provide all):
  A. Gradient: #E8517A → #B5338A (brand primary)
  B. Single color: #E8517A on white background
  C. White on gradient background
  D. Monochrome black (for dark backgrounds)

The wordmark "femio" (lowercase):
  - Font: Rounded, modern (Nunito ExtraBold or similar)
  - Tracking: slightly loose (+50)
  - Paired with the icon: Icon left, wordmark right

Deliver as:
  - assets/icons/femio_logo_full.svg (icon + wordmark)
  - assets/icons/femio_icon.svg (icon only)
  - assets/icons/femio_icon_512.png (for app icon)
```

---

## PART 26: QUALITY CHECKLIST (FINAL)

Before every feature is considered "done":
```
[ ] flutter analyze → 0 errors, 0 warnings
[ ] Unit tests written and passing for business logic
[ ] Widget renders in light mode (screenshot)
[ ] Widget renders in dark mode (screenshot)
[ ] Widget renders in OLED mode
[ ] Widget renders in Arabic RTL
[ ] All strings in ARB files (EN, AR, FR, ES)
[ ] Loading state: shimmer shown (not CircularProgressIndicator)
[ ] Empty state: illustration + text + action button
[ ] Error state: friendly message + retry
[ ] All buttons functional (zero empty onPressed)
[ ] Pro features gated via FeatureGateService
[ ] Accessibility: Semantics labels on all interactive elements
[ ] Touch targets minimum 48x48dp
[ ] Medical content has disclaimer
[ ] Medical content has citation/reference
[ ] Haptic feedback on primary actions
[ ] Data persists across app restarts
[ ] Performance: No jank on first 3 frames of any animation
```

---

## CRITICAL: STARTING INSTRUCTIONS FOR THE AGENT

**Before writing any code:**

1. **Re-read this entire document** to absorb all requirements
2. **Run web searches** for the major features — period tracking, pregnancy tracking, fertility tracking, vitals monitoring — study 2-3 competitor implementations each
3. **Create your research notes** in `docs/research/` before coding each module
4. **Set up the project** following Part 1 exactly
5. **Run `flutter analyze`** after every file created — fix issues immediately
6. **Never move to next phase** if current phase doesn't compile cleanly

**Continuous verification:**
```bash
# After every major change:
flutter analyze
flutter test
# Before any phase completion:
flutter build apk --debug
```

**If you encounter a blocker:**
- Do NOT skip the failing component
- Search for the correct implementation approach
- Ask for clarification in a code comment (TODO: awaiting clarification) if truly stuck
- Write a stub with clear TODO markers and a stub test that will fail until implemented

**This is a marathon, not a sprint.** Build quality over speed. Every feature should be production-worthy before moving on.

---

## APPENDIX A: MEDICAL REFERENCES

The app's health data must be grounded in these authoritative sources:

1. **WHO** — World Health Organization
   - Reproductive health guidelines
   - Family planning medical eligibility criteria
   - Safe motherhood guidelines

2. **ACOG** — American College of Obstetricians and Gynecologists
   - Menstrual cycle norms
   - Pregnancy weight gain recommendations
   - Preeclampsia guidelines
   - PCOS diagnosis and management

3. **AHA** — American Heart Association
   - Blood pressure categories and classification
   - Hypertension treatment stages

4. **NICE** — National Institute for Health and Care Excellence (UK)
   - Pregnancy and antenatal care guidelines
   - PCOS diagnosis

5. **IADPSG** — International Association of Diabetes in Pregnancy
   - Gestational diabetes thresholds

6. **IOM** — Institute of Medicine  
   - Pregnancy weight gain guidelines (2009)

7. **NAMS** — North American Menopause Society
   - Perimenopause management

8. **RCOG** — Royal College of Obstetricians and Gynaecologists
   - Endometriosis guidelines
   - Pregnancy guidelines

**Rule**: Every medical calculator, threshold, or health claim must cite one of these sources in both the code comments AND in the app UI.

---

## APPENDIX B: MENA-SPECIFIC CONSIDERATIONS

### Cultural Sensitivity
1. **Language**: Arabic content must be Gulf/MSA appropriate, not dialect-specific
2. **Modesty**: Health illustrations should be modest/abstract — no explicit anatomical images by default
3. **Privacy framing**: Emphasize discretion — "your data is private, not shared with anyone"
4. **Family context**: Some users may be tracking under family privacy concerns — discreet mode is a first-class feature
5. **Islamic perspective**: For family planning content, note "Consult your religious advisor for guidance aligned with your beliefs" — do NOT provide rulings
6. **Ramadan**: First-class feature, not an afterthought

### Regional Healthcare Systems
For each MENA country tracked, include in docs:
- Common health insurance systems
- MOH guidelines relevant to women's health
- Emergency numbers (for crisis BP alerts)
- National fertility treatment coverage

### Localization Depth
Arabic localization must be:
- Professionally translated (not Google Translate)
- Reviewed for medical accuracy in Arabic
- Using Arabic medical terminology standard to the region
- Culturally tested with target users

---

*End of Femio v2 Build Specification*

*Document version: 1.0 | Created: March 2026 | For use with GitHub Copilot agent in VS Code*
