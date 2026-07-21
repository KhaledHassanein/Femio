# Femio - Period & Pregnancy Tracker

Privacy-first mobile app for MENA markets. Track cycles, fertility, pregnancy, and vitals with local encryption and bilingual support (English/Arabic).

## 🎯 Project Status

**Current Phase:** Milestone 4.3 complete ✅ (continuing iterations)

### Completed Milestones
- ✅ M1: Competitive Research & Strategy
- ✅ M2: Product Requirements & UX Design
- ✅ M3: Technical Architecture
- ✅ M4.1: Core Project Setup
- ✅ M4.2: Feature Implementation
- ✅ M4.3: Integration & Testing

### Next Steps
- 🔄 Content & education iteration (pregnancy + postpartum)
- 🔄 Personalization expansion (profile-driven, content-driven rules)
- ⏳ Launch prep (QA pass, store assets, privacy review)

## 🏗️ Architecture

**Clean Architecture** with feature-first organization:
- **Domain Layer:** Entities, repository interfaces, use cases (pure Dart)
- **Data Layer:** Isar models, data sources, repository implementations
- **Presentation Layer:** Widgets, pages, Bloc/Cubit state management

**Core Technologies:**
- Flutter 3.2+ with Material 3
- State Management: flutter_bloc 8.1.6
- Database: Isar 3.1.0+1 with AES-256 encryption
- Firebase: Crashlytics, Analytics (privacy-safe)
- Localization: English + Arabic MSA with RTL support

## 📁 Project Structure

```
lib/
├── app/
│   └── theme/              # Material 3 theme, colors, text styles
├── core/
│   ├── database/           # Isar database helper with encryption
│   ├── extensions/         # Dart extensions (BuildContext, DateTime)
│   └── utils/              # Date calculations, validators
├── features/               # Feature-first organization
│   ├── onboarding/
│   ├── cycle/
│   ├── calendar/
│   ├── symptoms/
│   ├── fertility/
│   ├── pregnancy/
│   ├── vitals/
│   ├── settings/
│   └── monetization/
├── l10n/                   # Localization ARB files (EN/AR)
├── injection_container.dart  # Dependency injection setup
└── main.dart               # App entry point

docs/
├── milestone_1_research.md     # Competitive analysis & strategy
├── milestone_2_prd_ux.md       # PRD, personas, wireframes, UI guide
└── milestone_3_architecture.md # Technical architecture spec
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.2.0 or higher
- Dart SDK 3.2.0 or higher
- Android Studio / Xcode for platform builds
- (Optional) Firebase project configured (Analytics/Crashlytics)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd femio_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization code**
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔥 Firebase Setup (Android now, iOS later)

Firebase is integrated for **Analytics** and **Crashlytics**.

### Android (required steps)

1. **Firebase Console → Add Android app**
   - Package name: `com.kmdigitallabs.femio_app`
   - Download `google-services.json`

2. **Place the config file**
   - Put it at: `android/app/google-services.json`

3. **Run**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

Notes:
- This repo already applies the required Gradle plugins (`google-services`, `crashlytics`).
- Firebase initialization on Android uses the native config file (no FlutterFire CLI required).

### iOS (future)

Marked for when you’re ready to ship iOS:
- Register an iOS app in Firebase Console with your **final** iOS bundle id
- Add `GoogleService-Info.plist` to `ios/Runner/`
- Confirm iOS bundle id + signing in Xcode

If/when you want iOS enabled, share the iOS bundle id you want and it can be wired end-to-end.

## 🎨 Design System

**Color Palette:**
- Primary: #E57BA8 (Soft Pink)
- Secondary: #A28BF4 (Soft Purple)
- Hero Gradient: 135° pink → purple

**Typography:**
- English: Poppins (Regular/Medium/SemiBold/Bold)
- Arabic: Cairo (Regular/Medium/SemiBold/Bold)
- Scale: 32/24/20/18/16/14/12px

**Spacing:** 8px base system (4/8/12/16/24/32/48px)

See [docs/milestone_2_prd_ux.md](docs/milestone_2_prd_ux.md) for complete UI style guide.

## 🔒 Privacy & Security

- **Local-First:** All personal data stored on device with Isar
- **AES-256 Encryption:** Database encrypted with secure key storage
- **No Auth Required:** Zero account signup for MVP
- **Privacy-Safe Analytics:** No PII sent to Firebase
- **GDPR Ready:** Export and delete all user data

## 🌍 Localization

Supported languages:
- 🇬🇧 English
- 🇸🇦 Arabic (Modern Standard Arabic - MSA)
- 🇫🇷 French
- 🇪🇸 Spanish

Full RTL support with Cairo font for Arabic.

ARB files: `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb`, `lib/l10n/app_fr.arb`, `lib/l10n/app_es.arb`

## 📊 Key Features (MVP v1.0)

1. **Cycle Tracking:** Period logging, predictions with confidence ranges
2. **Calendar:** Visual overview of cycle phases, symptoms, vitals
3. **Fertility/TTC:** Fertile window calculator, ovulation tracking
4. **Pregnancy:** 40-week timeline, educational content, profile-based notes
5. **Symptoms & Mood:** Quick logging with customizable tags
6. **Vitals:** Blood pressure, weight, glucose charts
7. **Settings:** Language, discreet mode, data export/delete
8. **Monetization:** Pro subscription ($7.99/year), light banner ads
9. **Postpartum:** weeks 1–6 + months 1–12 timeline, educational content
10. **Case Tips:** icon-based “baby case tips” shown in pregnancy and postpartum

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter test integration_test

# Code analysis
flutter analyze
```

## 📱 Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
```

## 📚 Documentation

Detailed documentation in [docs/](docs/):
- **M1 Research:** Competitive matrix, pain points, differentiators
- **M2 PRD:** Personas, requirements, wireframes, data model
- **M3 Architecture:** Clean Architecture, state management, database setup
- **Content Authoring:** Edit pregnancy/postpartum JSON + case tips library (`docs/content_authoring.md`)
- **Roadmap:** Current milestone status + next steps (`docs/roadmap.md`)

## 🤝 Contributing

This is a milestone-driven project. See [docs/milestone_3_architecture.md](docs/milestone_3_architecture.md) Section 11 for implementation roadmap.

## 📄 License

[Add your license here]

## 🙏 Acknowledgments

- Target Markets: Egypt, KSA, UAE, Morocco, Algeria
- Medical Content: ACOG, WHO guidelines
- Privacy-First Inspiration: Apple Health, Signal

---

**Built with ❤️ for MENA women's health**
