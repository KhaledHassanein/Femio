# Femio App - Developer Guide

> **Document Version**: 1.0  
> **Created**: February 25, 2026  
> **Purpose**: Technical guide for developers working on the Femio codebase

---

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Project Structure](#project-structure)
3. [Theme System](#theme-system)
4. [Adding New Features](#adding-new-features)
5. [Content Management](#content-management)
6. [Localization](#localization)
7. [State Management](#state-management)
8. [Testing](#testing)

---

## Architecture Overview

### Clean Architecture Layers

Femio follows Clean Architecture with three distinct layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  (Pages, Widgets, BLoCs, Cubits)                            │
│  • UI components • State management • User interactions      │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                            │
│  (Entities, Use Cases, Repository Interfaces)               │
│  • Business logic • App-specific rules • Pure Dart          │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                             │
│  (Models, Repositories, Data Sources)                       │
│  • API calls • Database • External services                 │
└─────────────────────────────────────────────────────────────┘
```

### Key Technologies
- **State Management**: BLoC pattern (flutter_bloc)
- **Database**: Isar (local, offline-first)
- **DI Container**: get_it
- **Routing**: Named routes in main.dart
- **Localization**: flutter_localizations with ARB files
- **Analytics**: Firebase Analytics + Crashlytics
- **Ads**: Google Mobile Ads

---

## Project Structure

```
lib/
├── app/                          # App-wide configuration
│   ├── navigation/               # MainNavigationPage, route config
│   ├── presentation/             # App-level widgets
│   └── theme/                    # Theme system
│       ├── app_colors.dart       # Color constants
│       ├── app_dimensions.dart   # Spacing, sizing
│       ├── app_text_styles.dart  # Typography
│       ├── app_theme.dart        # ThemeData generation
│       ├── app_theme_type.dart   # 5 theme types enum
│       └── theme_generator.dart  # Theme factory
│
├── core/                         # Shared utilities
│   ├── constants/                # App-wide constants
│   ├── database/                 # Isar database helper
│   ├── entities/                 # Shared entities (Country)
│   ├── extensions/               # Dart extensions
│   ├── navigation/               # Navigator observers
│   ├── services/                 # Core services
│   ├── utils/                    # Utility functions
│   └── widgets/                  # Shared widgets
│
├── features/                     # Feature modules
│   ├── calculators/              # 8 health calculators
│   ├── calendar/                 # Calendar & day views
│   ├── cycle/                    # Cycle tracking
│   ├── dashboard/                # Home dashboard
│   ├── fertility/                # Fertility tracking, BBT, OPK
│   ├── insights/                 # Daily tips, achievements, streaks
│   ├── library/                  # Health articles
│   ├── medical/                  # Conditions, medications, doctor prep
│   ├── monetization/             # Ads, subscriptions
│   ├── onboarding/               # User setup flow
│   ├── postpartum/               # Postpartum guides
│   ├── pregnancy/                # Pregnancy tracking
│   ├── profile/                  # User profile
│   ├── settings/                 # App settings, privacy
│   ├── symptoms/                 # Symptom logging
│   └── vitals/                   # Vitals tracking
│
├── l10n/                         # Localization
│   ├── app_en.arb                # English (source)
│   ├── app_ar.arb                # Arabic
│   ├── app_fr.arb                # French
│   └── app_es.arb                # Spanish
│
├── injection_container.dart      # Dependency injection setup
└── main.dart                     # App entry point
```

### Feature Module Structure

Each feature follows this pattern:

```
feature_name/
├── data/
│   ├── datasources/              # Local/remote data sources
│   ├── models/                   # Data models (JSON serializable)
│   ├── repositories/             # Repository implementations
│   └── services/                 # Feature-specific services
│
├── domain/
│   ├── entities/                 # Business objects
│   ├── repositories/             # Repository interfaces
│   └── usecases/                 # Business logic operations
│
└── presentation/
    ├── bloc/                     # BLoC/Cubit classes
    ├── pages/                    # Full-screen pages
    └── widgets/                  # Reusable UI components
```

---

## Theme System

### Available Themes (5 total)

| Theme | Primary Color | Description |
|-------|---------------|-------------|
| **Vibrant Bloom** (default) | `#E91E63` | Bold pinks, corals, purples - Modern, energetic |
| **Soft Blush** | `#F48FB1` | Soft pastels - Gentle, calming |
| **Nature's Touch** | `#4CAF50` | Greens, earth tones - Organic, grounded |
| **Ocean Calm** | `#00BCD4` | Blues, teals, aquas - Serene, peaceful |
| **Sunset Glow** | `#FF9800` | Oranges, peaches, golds - Warm, optimistic |

### Theme Files

**`lib/app/theme/app_theme_type.dart`**
```dart
enum AppThemeType {
  vibrantBloom,  // Default
  softBlush,
  naturesTouch,
  oceanCalm,
  sunsetGlow,
}
```

**`lib/app/theme/theme_generator.dart`**
- `generateLightTheme(AppThemeType)` - Creates light theme
- `generateDarkTheme(AppThemeType)` - Creates dark theme

### Using Themes

```dart
// Get current theme from settings bloc
final settingsState = context.read<SettingsBloc>().state;
final themeType = settingsState.settings.themeType;

// Generate theme
final theme = ThemeGenerator.generateLightTheme(themeType);
```

### Theme Colors Access

```dart
// From ThemeColors class
ThemeColors.getPrimary(AppThemeType.vibrantBloom)
ThemeColors.getSecondary(AppThemeType.vibrantBloom)
ThemeColors.getBackground(AppThemeType.vibrantBloom)

// From extension
AppThemeType.vibrantBloom.primaryColor
AppThemeType.vibrantBloom.secondaryColor
AppThemeType.vibrantBloom.previewColors  // For theme picker
```

### Adding Theme to Settings

The `ThemeSelectorWidget` is already integrated in the Settings page:

```dart
// In settings_page.dart
ThemeSelectorWidget(
  currentTheme: state.settings.themeType,
  onThemeChanged: (theme) {
    context.read<SettingsBloc>().add(UpdateThemeEvent(theme));
  },
),
```

---

## Adding New Features

### 1. Create Feature Module

```bash
lib/features/new_feature/
├── data/
│   ├── datasources/new_feature_local_data_source.dart
│   ├── models/new_feature_model.dart
│   └── repositories/new_feature_repository_impl.dart
├── domain/
│   ├── entities/new_feature.dart
│   ├── repositories/new_feature_repository.dart
│   └── usecases/get_new_feature.dart
└── presentation/
    ├── bloc/
    │   ├── new_feature_bloc.dart
    │   ├── new_feature_event.dart
    │   └── new_feature_state.dart
    ├── pages/new_feature_page.dart
    └── widgets/new_feature_widget.dart
```

### 2. Register in DI Container

**`lib/injection_container.dart`**
```dart
// Repository
sl.registerLazySingleton<NewFeatureRepository>(
  () => NewFeatureRepositoryImpl(localDataSource: sl()),
);

// BLoC
sl.registerFactory(() => NewFeatureBloc(repository: sl()));
```

### 3. Add Route

**`lib/main.dart`**
```dart
routes: {
  '/new-feature': (context) => BlocProvider(
    create: (context) => di.sl<NewFeatureBloc>(),
    child: const NewFeaturePage(),
  ),
}
```

### 4. Add Localization Keys

**`lib/l10n/app_en.arb`**
```json
{
  "newFeatureTitle": "New Feature",
  "newFeatureDescription": "Description"
}
```

Run `flutter gen-l10n` to regenerate.

---

## Adding New Calculators

### 1. Create Calculator Page

**`lib/features/calculators/presentation/pages/my_calculator_page.dart`**
```dart
class MyCalculatorPage extends StatefulWidget {
  const MyCalculatorPage({super.key});

  @override
  State<MyCalculatorPage> createState() => _MyCalculatorPageState();
}

class _MyCalculatorPageState extends State<MyCalculatorPage> {
  // Input controllers
  final _inputController = TextEditingController();
  
  // Result state
  double? _result;

  void _calculate() {
    // Your calculation logic
    setState(() {
      _result = /* calculation */;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myCalculator)),
      body: // Your UI
    );
  }
}
```

### 2. Add Route

```dart
'/calc/my-calculator': (context) => const MyCalculatorPage(),
```

### 3. Add to Calculators Page

**`lib/features/calculators/presentation/pages/calculators_page.dart`**
```dart
_CalculatorCard(
  icon: Icons.calculate,
  title: l10n.myCalculator,
  description: l10n.myCalculatorDesc,
  route: '/calc/my-calculator',
),
```

### 4. Add Localization

```json
{
  "myCalculator": "My Calculator",
  "myCalculatorDesc": "Calculate something useful"
}
```

---

## Content Management

### Daily Tips Location

**`lib/features/insights/data/daily_tips_data.dart`**
- Contains `DailyTip` objects organized by journey mode
- Tips have: id, titleKey, bodyKey, category, journeyMode, cycleDay/week

### Pregnancy Weekly Guides

**`assets/pregnancy/weeks.json`**
```json
{
  "weeks": [
    {
      "weekNumber": 1,
      "babySizeEmoji": "🌱",
      "babySizeName": "Poppy Seed",
      "babyDevelopment": ["Development point 1"],
      "momSymptoms": ["Symptom 1"],
      "momTips": ["Tip 1"]
    }
  ]
}
```

### Library Articles

**`assets/content/library_articles.json`**
```json
{
  "articles": [
    {
      "id": "article_1",
      "categoryId": "menstrual_health",
      "titleKey": "articleTitle",
      "summaryKey": "articleSummary",
      "content": [
        {"type": "heading", "text": "Section Title"},
        {"type": "paragraph", "text": "Content..."},
        {"type": "list", "items": ["Item 1", "Item 2"]}
      ],
      "readTimeMinutes": 5,
      "sources": ["Mayo Clinic"]
    }
  ]
}
```

### Targeted Content (Personalization)

**`assets/content/targeted_content.json`**
- Rules-based content delivery
- See [content_authoring.md](content_authoring.md) for full documentation

---

## Localization

### Adding New Strings

1. Add to **`lib/l10n/app_en.arb`** (source file):
```json
{
  "newKey": "English text",
  "@newKey": {
    "description": "Description for translators"
  }
}
```

2. Add translations to other ARB files (app_ar.arb, app_fr.arb, app_es.arb)

3. Run: `flutter gen-l10n`

### Using Localized Strings

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.newKey);
```

### Parameterized Strings

```json
{
  "welcomeUser": "Welcome, {name}!",
  "@welcomeUser": {
    "placeholders": {
      "name": {"type": "String"}
    }
  }
}
```

```dart
Text(l10n.welcomeUser('Sarah'));
```

### Dynamic Key Lookup

For keys stored in data:
```dart
final l10n = AppLocalizations.of(context);
l10n.localizeKey('dynamicKeyName');  // Uses extension method
```

---

## State Management

### BLoC Pattern

**Events** - User actions or triggers
```dart
abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
}

class LoadDataEvent extends FeatureEvent {
  @override
  List<Object?> get props => [];
}
```

**States** - UI states
```dart
abstract class FeatureState extends Equatable {
  const FeatureState();
}

class FeatureLoading extends FeatureState { ... }
class FeatureLoaded extends FeatureState { ... }
class FeatureError extends FeatureState { ... }
```

**BLoC** - Business logic
```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final Repository _repository;
  
  FeatureBloc({required Repository repository})
      : _repository = repository,
        super(FeatureInitial()) {
    on<LoadDataEvent>(_onLoadData);
  }
  
  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<FeatureState> emit,
  ) async {
    emit(FeatureLoading());
    final result = await _repository.getData();
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data) => emit(FeatureLoaded(data)),
    );
  }
}
```

### Cubit (Simpler Alternative)

For simple state without events:
```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

---

## Testing

### Unit Tests

```dart
// test/features/cycle/domain/usecases/calculate_prediction_test.dart
void main() {
  late CalculatePrediction useCase;
  late MockCycleRepository mockRepository;

  setUp(() {
    mockRepository = MockCycleRepository();
    useCase = CalculatePrediction(mockRepository);
  });

  test('should return prediction from repository', () async {
    // Arrange
    when(mockRepository.calculatePrediction())
        .thenAnswer((_) async => Right(testPrediction));
    
    // Act
    final result = await useCase();
    
    // Assert
    expect(result, Right(testPrediction));
    verify(mockRepository.calculatePrediction());
  });
}
```

### Widget Tests

```dart
// test/features/dashboard/presentation/widgets/cycle_wheel_widget_test.dart
void main() {
  testWidgets('CycleWheelWidget displays current day', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CycleWheelWidget(
          currentDay: 14,
          cycleLength: 28,
        ),
      ),
    );

    expect(find.text('Day 14'), findsOneWidget);
  });
}
```

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/features/cycle/domain/usecases/calculate_prediction_test.dart

# With coverage
flutter test --coverage
```

---

## Useful Commands

```bash
# Generate localizations
flutter gen-l10n

# Analyze code
flutter analyze

# Format code
dart format lib/

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release

# Run on device
flutter run
```

---

## Common Patterns

### Error Handling with Either

```dart
import 'package:dartz/dartz.dart';

Future<Either<Failure, Success>> doSomething() async {
  try {
    final result = await someOperation();
    return Right(result);
  } catch (e) {
    return Left(Failure(e.toString()));
  }
}

// Usage
final result = await doSomething();
result.fold(
  (failure) => showError(failure.message),
  (success) => showSuccess(success),
);
```

### Repository Pattern

```dart
// Domain layer - interface
abstract class FeatureRepository {
  Future<Either<Failure, List<Item>>> getItems();
  Future<Either<Failure, void>> saveItem(Item item);
}

// Data layer - implementation
class FeatureRepositoryImpl implements FeatureRepository {
  final LocalDataSource _localDataSource;
  
  @override
  Future<Either<Failure, List<Item>>> getItems() async {
    try {
      final models = await _localDataSource.getAll();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
```

---

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Library](https://bloclibrary.dev/)
- [Isar Database](https://isar.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

*For content authoring (pregnancy weeks, tips, articles), see [content_authoring.md](content_authoring.md)*
