# Milestone 3: Technical Architecture & Scaffolding

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Clean Architecture Layers](#clean-architecture)
3. [Folder Structure](#folder-structure)
4. [State Management](#state-management)
5. [Dependency Injection](#dependency-injection)
6. [Database Implementation](#database)
7. [Firebase Setup](#firebase)
8. [Localization Architecture](#localization)
9. [Dependencies & Packages](#dependencies)
10. [Build & CI/CD](#build)

---

<a name="architecture-overview"></a>
## 1. Architecture Overview

### 1.1 Architecture Pattern: Clean Architecture (Feature-First)

**Core Principles:**
- **Separation of Concerns**: Business logic independent from UI and data sources
- **Dependency Rule**: Inner layers know nothing about outer layers
- **Testability**: Domain layer is pure Dart, easily unit testable
- **Scalability**: Features are modular, can be developed/tested independently

**Layer Structure:**
```
┌─────────────────────────────────────┐
│        Presentation Layer           │  ← UI, Widgets, Bloc/Cubit
│  (Flutter Framework, Material 3)    │
└─────────────────────────────────────┘
              ↓ depends on
┌─────────────────────────────────────┐
│         Domain Layer                │  ← Entities, Use Cases, Repository Interfaces
│     (Pure Dart, No Flutter)         │
└─────────────────────────────────────┘
              ↓ depends on
┌─────────────────────────────────────┐
│          Data Layer                 │  ← Repository Implementations, Data Sources
│  (Isar DB, Firebase, SharedPrefs)   │
└─────────────────────────────────────┘
```

---

### 1.2 Feature-First Organization

**Why Feature-First:**
- **Scalability**: Each feature is self-contained (easier to modify/remove)
- **Team Collaboration**: Different developers can work on different features
- **Domain Focus**: Features map directly to business domains (cycles, pregnancy, vitals)

**Feature Examples:**
- `features/cycle` (cycle tracking, period logging, predictions)
- `features/pregnancy` (pregnancy timeline, week content, due date)
- `features/vitals` (BP, weight, glucose tracking and charts)
- `features/symptoms` (symptom/mood logging)
- `features/settings` (user preferences, privacy, exports)

---

<a name="clean-architecture"></a>
## 2. Clean Architecture Layers Detailed

### 2.1 Domain Layer (Innermost)

**Purpose**: Core business logic, independent of frameworks and external systems.

**Components:**

#### **Entities** (Pure Dart Models)
- Represent business concepts (Cycle, Pregnancy, Vital)
- No annotations (no Isar, no JSON)
- Immutable (using `@immutable` or freezed)
- Example:

```dart
/// Domain entity for Cycle (pure business logic)
class Cycle {
  final String id;
  final DateTime periodStartDate;
  final DateTime? periodEndDate;
  final int? cycleLength;
  final FlowLevel flowLevel;
  
  const Cycle({
    required this.id,
    required this.periodStartDate,
    this.periodEndDate,
    this.cycleLength,
    required this.flowLevel,
  });
  
  // Business methods
  bool get isActive => periodEndDate == null;
  int get periodDuration => periodEndDate != null 
      ? periodEndDate!.difference(periodStartDate).inDays 
      : 0;
}

enum FlowLevel { light, medium, heavy }
```

#### **Repository Interfaces** (Contracts)
- Define what data operations are needed
- No implementation details
- Example:

```dart
/// Repository contract (domain layer)
abstract class CycleRepository {
  Future<List<Cycle>> getAllCycles();
  Future<Cycle?> getCurrentCycle();
  Future<void> saveCycle(Cycle cycle);
  Future<void> deleteCycle(String id);
  Stream<List<Cycle>> watchCycles();
}
```

#### **Use Cases** (Business Logic)
- Single-responsibility classes
- Orchestrate domain entities and repositories
- Example:

```dart
/// Use case: Calculate next period prediction
class GetPeriodPrediction {
  final CycleRepository cycleRepository;
  final PredictionRepository predictionRepository;
  
  GetPeriodPrediction(this.cycleRepository, this.predictionRepository);
  
  Future<Prediction> call() async {
    final cycles = await cycleRepository.getAllCycles();
    
    if (cycles.isEmpty) {
      return Prediction.noData();
    }
    
    // Business logic: Calculate average cycle length
    final avgCycleLength = _calculateAverage(cycles.map((c) => c.cycleLength ?? 0));
    final lastCycle = cycles.first;
    final nextPeriodMedian = lastCycle.periodStartDate.add(Duration(days: avgCycleLength));
    
    // Confidence based on cycle count
    final confidence = cycles.length >= 6 
        ? ConfidenceLevel.high 
        : cycles.length >= 3 
            ? ConfidenceLevel.medium 
            : ConfidenceLevel.low;
    
    // Range based on confidence
    final rangeDays = confidence == ConfidenceLevel.high ? 2 : confidence == ConfidenceLevel.medium ? 3 : 5;
    
    final prediction = Prediction(
      earliestDate: nextPeriodMedian.subtract(Duration(days: rangeDays)),
      latestDate: nextPeriodMedian.add(Duration(days: rangeDays)),
      medianDate: nextPeriodMedian,
      confidenceLevel: confidence,
      cyclesUsedForPrediction: cycles.length,
    );
    
    await predictionRepository.savePrediction(prediction);
    return prediction;
  }
  
  double _calculateAverage(Iterable<int> numbers) {
    return numbers.reduce((a, b) => a + b) / numbers.length;
  }
}
```

---

### 2.2 Data Layer (Outermost, Implementation)

**Purpose**: Implement repository interfaces, handle data persistence and external APIs.

**Components:**

#### **Data Models** (Isar/JSON Annotated)
- Mirror domain entities but with annotations
- Handle serialization/deserialization
- Example:

```dart
/// Data model for Cycle (Isar implementation)
import 'package:isar/isar.dart';

part 'cycle_model.g.dart'; // Generated code

@collection
class CycleModel {
  Id id = Isar.autoIncrement;
  
  @Index()
  late DateTime periodStartDate;
  
  DateTime? periodEndDate;
  int? cycleLength;
  
  @Enumerated(EnumType.name)
  late FlowLevelDb flowLevel;
  
  late DateTime createdAt;
  late DateTime updatedAt;
  
  // Convert to domain entity
  Cycle toDomain() {
    return Cycle(
      id: id.toString(),
      periodStartDate: periodStartDate,
      periodEndDate: periodEndDate,
      cycleLength: cycleLength,
      flowLevel: flowLevel.toDomain(),
    );
  }
  
  // Create from domain entity
  factory CycleModel.fromDomain(Cycle cycle) {
    return CycleModel()
      ..periodStartDate = cycle.periodStartDate
      ..periodEndDate = cycle.periodEndDate
      ..cycleLength = cycle.cycleLength
      ..flowLevel = FlowLevelDb.fromDomain(cycle.flowLevel)
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
  }
}

enum FlowLevelDb { light, medium, heavy }

extension FlowLevelDbExt on FlowLevelDb {
  FlowLevel toDomain() {
    switch (this) {
      case FlowLevelDb.light:
        return FlowLevel.light;
      case FlowLevelDb.medium:
        return FlowLevel.medium;
      case FlowLevelDb.heavy:
        return FlowLevel.heavy;
    }
  }
  
  static FlowLevelDb fromDomain(FlowLevel flowLevel) {
    switch (flowLevel) {
      case FlowLevel.light:
        return FlowLevelDb.light;
      case FlowLevel.medium:
        return FlowLevelDb.medium;
      case FlowLevel.heavy:
        return FlowLevelDb.heavy;
    }
  }
}
```

#### **Data Sources**
- **Local Data Source**: Isar database operations
- **Remote Data Source**: Firebase Firestore (Pro sync), Remote Config (content)
- **Cache**: SharedPreferences for simple key-value (user preferences)

```dart
/// Local data source (Isar)
class CycleLocalDataSource {
  final Isar isar;
  
  CycleLocalDataSource(this.isar);
  
  Future<List<CycleModel>> getCycles() async {
    return await isar.cycleModels.where().sortByPeriodStartDateDesc().findAll();
  }
  
  Future<CycleModel?> getCurrentCycle() async {
    // Get most recent cycle where periodEndDate is null
    return await isar.cycleModels
        .filter()
        .periodEndDateIsNull()
        .sortByPeriodStartDateDesc()
        .findFirst();
  }
  
  Future<void> saveCycle(CycleModel cycle) async {
    await isar.writeTxn(() async {
      await isar.cycleModels.put(cycle);
    });
  }
  
  Stream<List<CycleModel>> watchCycles() {
    return isar.cycleModels.where().watch(fireImmediately: true);
  }
}
```

#### **Repository Implementations**
- Implement domain repository interfaces
- Coordinate between data sources
- Convert data models ↔ domain entities

```dart
/// Repository implementation (data layer)
class CycleRepositoryImpl implements CycleRepository {
  final CycleLocalDataSource localDataSource;
  // Future: final CycleRemoteDataSource remoteDataSource (for Pro sync)
  
  CycleRepositoryImpl(this.localDataSource);
  
  @override
  Future<List<Cycle>> getAllCycles() async {
    final models = await localDataSource.getCycles();
    return models.map((m) => m.toDomain()).toList();
  }
  
  @override
  Future<Cycle?> getCurrentCycle() async {
    final model = await localDataSource.getCurrentCycle();
    return model?.toDomain();
  }
  
  @override
  Future<void> saveCycle(Cycle cycle) async {
    final model = CycleModel.fromDomain(cycle);
    await localDataSource.saveCycle(model);
  }
  
  @override
  Future<void> deleteCycle(String id) async {
    // Implementation
  }
  
  @override
  Stream<List<Cycle>> watchCycles() {
    return localDataSource.watchCycles().map(
      (models) => models.map((m) => m.toDomain()).toList(),
    );
  }
}
```

---

### 2.3 Presentation Layer (UI)

**Purpose**: Display data, handle user interactions, trigger business logic via use cases.

**Components:**

#### **Widgets** (UI Components)
- Reusable UI components
- Stateless where possible
- Example:

```dart
/// Reusable widget: Period prediction card
class PeriodPredictionCard extends StatelessWidget {
  final Prediction prediction;
  
  const PeriodPredictionCard({required this.prediction});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Next Period',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'In ${prediction.daysUntilEarliest}-${prediction.daysUntilLatest} days',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            ConfidenceBadge(level: prediction.confidenceLevel),
          ],
        ),
      ),
    );
  }
}
```

#### **Pages/Screens**
- Top-level screen widgets
- Contain BlocProviders and UI layout
- Example:

```dart
/// Home screen (Cycle mode)
class CycleHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CycleBloc>()..add(LoadCycleData()),
      child: Scaffold(
        appBar: AppBar(title: Text('Femio')),
        body: BlocBuilder<CycleBloc, CycleState>(
          builder: (context, state) {
            if (state is CycleLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is CycleLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    HeroCard(
                      title: 'Next Period',
                      subtitle: state.prediction != null
                          ? 'In ${state.prediction!.daysUntilEarliest}-${state.prediction!.daysUntilLatest} days'
                          : 'Log your first period to see predictions',
                    ),
                    QuickActionsRow(onLogTap: () => _showLogSheet(context)),
                    VitalsSummary(vitals: state.recentVitals),
                    TodaysTipCard(tip: state.todaysTip),
                  ],
                ),
              );
            }
            
            return Center(child: Text('Error loading data'));
          },
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 0),
      ),
    );
  }
}
```

#### **Bloc/Cubit** (State Management)
- Manage screen/feature state
- Trigger use cases
- Emit new states based on results
- Example:

```dart
/// Bloc for Cycle home screen
class CycleBloc extends Bloc<CycleEvent, CycleState> {
  final GetPeriodPrediction getPeriodPrediction;
  final GetCurrentCycle getCurrentCycle;
  
  CycleBloc({
    required this.getPeriodPrediction,
    required this.getCurrentCycle,
  }) : super(CycleInitial()) {
    on<LoadCycleData>(_onLoadCycleData);
  }
  
  Future<void> _onLoadCycleData(
    LoadCycleData event,
    Emitter<CycleState> emit,
  ) async {
    emit(CycleLoading());
    
    try {
      final prediction = await getPeriodPrediction();
      final currentCycle = await getCurrentCycle();
      
      emit(CycleLoaded(
        prediction: prediction,
        currentCycle: currentCycle,
      ));
    } catch (e) {
      emit(CycleError(message: e.toString()));
    }
  }
}

// Events
abstract class CycleEvent {}
class LoadCycleData extends CycleEvent {}

// States
abstract class CycleState {}
class CycleInitial extends CycleState {}
class CycleLoading extends CycleState {}
class CycleLoaded extends CycleState {
  final Prediction? prediction;
  final Cycle? currentCycle;
  CycleLoaded({this.prediction, this.currentCycle});
}
class CycleError extends CycleState {
  final String message;
  CycleError({required this.message});
}
```

---

<a name="folder-structure"></a>
## 3. Folder Structure (Feature-First)

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── app.dart                       # MaterialApp setup, theme, routes
│   ├── routes.dart                    # Named routes (if not using go_router)
│   └── theme/
│       ├── app_theme.dart             # Material 3 theme (light mode)
│       ├── app_colors.dart            # Color palette constants
│       ├── app_text_styles.dart       # Typography styles
│       └── app_dimensions.dart        # Spacing, radius constants
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # App-wide constants (API keys, config)
│   │   └── asset_paths.dart           # Image/icon asset paths
│   ├── error/
│   │   ├── failures.dart              # Failure types (ServerFailure, CacheFailure)
│   │   └── exceptions.dart            # Custom exceptions
│   ├── utils/
│   │   ├── date_utils.dart            # Date formatting, calculations
│   │   ├── validators.dart            # Input validators
│   │   └── logger.dart                # Logging utility (debug/release modes)
│   ├── extensions/
│   │   ├── context_extensions.dart    # BuildContext extensions (theme, navigation)
│   │   ├── datetime_extensions.dart   # DateTime extensions
│   │   └── string_extensions.dart     # String extensions (capitalization, etc.)
│   └── widgets/
│       ├── loading_indicator.dart     # Reusable loading spinner
│       ├── error_widget.dart          # Reusable error display
│       ├── custom_button.dart         # Primary/secondary button widgets
│       └── bottom_nav_bar.dart        # Bottom navigation bar (stage-aware)
│
├── features/
│   ├── onboarding/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── onboarding_stage.dart
│   │   │   ├── repositories/
│   │   │   │   └── onboarding_repository.dart (interface)
│   │   │   └── usecases/
│   │   │       ├── complete_onboarding.dart
│   │   │       └── save_stage_selection.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── onboarding_stage_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── onboarding_local_datasource.dart (SharedPreferences)
│   │   │   └── repositories/
│   │   │       └── onboarding_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── onboarding_bloc.dart
│   │       │   ├── onboarding_event.dart
│   │       │   └── onboarding_state.dart
│   │       ├── pages/
│   │       │   ├── welcome_page.dart
│   │       │   ├── language_selection_page.dart
│   │       │   ├── stage_selection_page.dart
│   │       │   ├── cycle_setup_page.dart
│   │       │   ├── pregnancy_setup_page.dart
│   │       │   └── privacy_consent_page.dart
│   │       └── widgets/
│   │           ├── welcome_slide.dart
│   │           ├── stage_card.dart
│   │           └── consent_toggle.dart
│   │
│   ├── cycle/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── cycle.dart
│   │   │   │   ├── prediction.dart
│   │   │   │   └── confidence_level.dart
│   │   │   ├── repositories/
│   │   │   │   ├── cycle_repository.dart
│   │   │   │   └── prediction_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_period_prediction.dart
│   │   │       ├── get_current_cycle.dart
│   │   │       ├── start_period.dart
│   │   │       ├── end_period.dart
│   │   │       └── get_cycle_history.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── cycle_model.dart (Isar)
│   │   │   │   └── prediction_model.dart (Isar)
│   │   │   ├── datasources/
│   │   │   │   ├── cycle_local_datasource.dart
│   │   │   │   └── prediction_local_datasource.dart
│   │   │   └── repositories/
│   │   │       ├── cycle_repository_impl.dart
│   │   │       └── prediction_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── cycle_bloc.dart
│   │       │   └── cycle_history_cubit.dart
│   │       ├── pages/
│   │       │   ├── cycle_home_page.dart
│   │       │   ├── cycle_details_page.dart
│   │       │   └── cycle_history_page.dart
│   │       └── widgets/
│   │           ├── period_prediction_card.dart
│   │           ├── cycle_phase_indicator.dart
│   │           ├── confidence_badge.dart
│   │           └── cycle_list_item.dart
│   │
│   ├── calendar/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── calendar_day.dart
│   │   │   ├── repositories/
│   │   │   │   └── calendar_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_calendar_month.dart
│   │   │       └── get_day_details.dart
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── calendar_repository_impl.dart (aggregates cycle, symptoms, vitals data)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   └── calendar_cubit.dart
│   │       ├── pages/
│   │       │   ├── calendar_page.dart
│   │       │   └── day_detail_page.dart
│   │       └── widgets/
│   │           ├── calendar_grid.dart
│   │           ├── calendar_day_cell.dart
│   │           ├── legend_modal.dart
│   │           └── month_navigator.dart
│   │
│   ├── symptoms/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── symptom.dart
│   │   │   │   └── mood.dart
│   │   │   ├── repositories/
│   │   │   │   └── symptom_repository.dart
│   │   │   └── usecases/
│   │   │       ├── log_symptoms.dart
│   │   │       ├── get_symptoms_by_date.dart
│   │   │       └── get_symptom_history.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── symptom_model.dart (Isar)
│   │   │   │   └── mood_model.dart (Isar)
│   │   │   ├── datasources/
│   │   │   │   └── symptom_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── symptom_repository_impl.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   └── symptom_log_cubit.dart
│   │       ├── pages/
│   │       │   └── symptom_history_page.dart
│   │       └── widgets/
│   │           ├── quick_log_sheet.dart (bottom sheet)
│   │           ├── symptom_chip.dart
│   │           ├── mood_selector.dart
│   │           └── symptom_list_item.dart
│   │
│   ├── fertility/ (TTC features)
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── fertility_data.dart
│   │   │   │   └── fertile_window.dart
│   │   │   ├── repositories/
│   │   │   │   └── fertility_repository.dart
│   │   │   └── usecases/
│   │   │       ├── calculate_fertile_window.dart
│   │   │       ├── log_cervical_mucus.dart
│   │   │       └── log_intercourse.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── fertility_data_model.dart (Isar)
│   │   │   ├── datasources/
│   │   │   │   └── fertility_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── fertility_repository_impl.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   └── fertility_cubit.dart
│   │       ├── pages/
│   │       │   └── ttc_home_page.dart
│   │       └── widgets/
│   │           ├── fertile_window_card.dart
│   │           ├── ovulation_indicator.dart
│   │           └── mucus_log_sheet.dart
│   │
│   ├── pregnancy/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── pregnancy.dart
│   │   │   │   ├── pregnancy_week.dart
│   │   │   │   └── weekly_content.dart
│   │   │   ├── repositories/
│   │   │   │   ├── pregnancy_repository.dart
│   │   │   │   └── content_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_current_pregnancy.dart
│   │   │       ├── calculate_gestational_age.dart
│   │   │       ├── get_week_content.dart
│   │   │       └── start_pregnancy.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── pregnancy_model.dart (Isar)
│   │   │   │   └── pregnancy_content_model.dart (Isar)
│   │   │   ├── datasources/
│   │   │   │   ├── pregnancy_local_datasource.dart
│   │   │   │   └── content_local_datasource.dart (pre-seeded data)
│   │   │   └── repositories/
│   │   │       ├── pregnancy_repository_impl.dart
│   │   │       └── content_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── pregnancy_bloc.dart
│   │       │   └── timeline_cubit.dart
│   │       ├── pages/
│   │       │   ├── pregnancy_home_page.dart
│   │       │   ├── pregnancy_timeline_page.dart
│   │       │   └── week_detail_page.dart
│   │       └── widgets/
│   │           ├── pregnancy_hero_card.dart
│   │           ├── baby_size_visual.dart
│   │           ├── week_card.dart
│   │           └── milestone_card.dart
│   │
│   ├── vitals/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── vital.dart
│   │   │   │   ├── blood_pressure.dart
│   │   │   │   └── weight.dart
│   │   │   ├── repositories/
│   │   │   │   └── vital_repository.dart
│   │   │   └── usecases/
│   │   │       ├── log_blood_pressure.dart
│   │   │       ├── log_weight.dart
│   │   │       ├── get_bp_readings.dart
│   │   │       └── get_weight_readings.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── vital_model.dart (Isar)
│   │   │   ├── datasources/
│   │   │   │   └── vital_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── vital_repository_impl.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── vital_log_cubit.dart
│   │       │   └── vital_chart_cubit.dart
│   │       ├── pages/
│   │       │   ├── vitals_dashboard_page.dart
│   │       │   ├── bp_chart_page.dart
│   │       │   └── weight_chart_page.dart
│   │       └── widgets/
│   │           ├── bp_log_sheet.dart
│   │           ├── weight_log_sheet.dart
│   │           ├── bp_chart.dart (fl_chart)
│   │           ├── weight_chart.dart
│   │           └── vital_card.dart
│   │
│   ├── appointments/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── appointment.dart
│   │   │   ├── repositories/
│   │   │   │   └── appointment_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_appointment.dart
│   │   │       ├── get_upcoming_appointments.dart
│   │   │       └── delete_appointment.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── appointment_model.dart (Isar)
│   │   │   ├── datasources/
│   │   │   │   └── appointment_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── appointment_repository_impl.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   └── appointment_cubit.dart
│   │       ├── pages/
│   │       │   └── appointments_page.dart
│   │       └── widgets/
│   │           ├── appointment_card.dart
│   │           └── appointment_form_sheet.dart
│   │
│   ├── settings/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_settings.dart
│   │   │   ├── repositories/
│   │   │   │   └── settings_repository.dart
│   │   │   └── usecases/
│   │   │       ├── update_language.dart
│   │   │       ├── toggle_discreet_mode.dart
│   │   │       ├── export_data.dart
│   │   │       └── delete_all_data.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_settings_model.dart (SharedPreferences + Isar)
│   │   │   ├── datasources/
│   │   │   │   └── settings_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── settings_repository_impl.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   └── settings_cubit.dart
│   │       ├── pages/
│   │       │   ├── settings_page.dart
│   │       │   ├── language_settings_page.dart
│   │       │   └── data_management_page.dart
│   │       └── widgets/
│   │           ├── settings_tile.dart
│   │           └── delete_confirmation_dialog.dart
│   │
│   ├── pro/ (Monetization)
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── subscription.dart
│   │   │   ├── repositories/
│   │   │   │   └── subscription_repository.dart
│   │   │   └── usecases/
│   │   │       ├── check_pro_status.dart
│   │   │       ├── purchase_subscription.dart
│   │   │       └── restore_purchase.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── subscription_model.dart
│   │   │   ├── datasources/
│   │   │   │   ├── subscription_local_datasource.dart (SharedPreferences)
│   │   │   │   └── subscription_remote_datasource.dart (Google Play Billing)
│   │   │   └── repositories/
│   │   │       └── subscription_repository_impl.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   └── pro_cubit.dart
│   │       ├── pages/
│   │       │   ├── pro_paywall_page.dart
│   │       │   └── manage_subscription_page.dart
│   │       └── widgets/
│   │           ├── benefit_list.dart
│   │           └── pricing_card.dart
│   │
│   └── ads/ (Ad integration)
│       ├── domain/
│       │   ├── entities/
│       │   │   └── ad_config.dart
│       │   └── repositories/
│       │       └── ad_repository.dart
│       ├── data/
│       │   ├── datasources/
│       │   │   └── admob_datasource.dart
│       │   └── repositories/
│       │       └── ad_repository_impl.dart
│       └── presentation/
│           └── widgets/
│               ├── banner_ad_widget.dart
│               └── native_ad_widget.dart
│
├── l10n/
│   ├── app_en.arb                     # English strings (source)
│   ├── app_ar.arb                     # Arabic strings
│   └── l10n.dart                      # Generated localization code
│
└── injection_container.dart           # Dependency injection setup (get_it)
```

---

<a name="state-management"></a>
## 4. State Management (Bloc/Cubit)

### 4.1 Why Bloc Pattern

**Advantages:**
- **Separation of business logic from UI**: Blocs manage state, widgets are dumb
- **Testability**: Blocs are pure Dart classes, easy to unit test
- **Predictability**: Explicit events → states flow
- **Community support**: Mature ecosystem (bloc_test, hydrated_bloc)

**When to use Bloc vs Cubit:**
- **Bloc**: Complex flows with multiple events (e.g., CycleBloc handles LoadCycleData, StartPeriod, EndPeriod)
- **Cubit**: Simpler state management (e.g., CalendarCubit just changes month)

---

### 4.2 Bloc Architecture Pattern

```
User Action (UI)
    ↓
Event (CycleEvent)
    ↓
Bloc (CycleBloc)
    ↓ calls
Use Case (GetPeriodPrediction)
    ↓ calls
Repository (CycleRepository)
    ↓ returns
Domain Entity (Prediction)
    ↓
Bloc emits
    ↓
New State (CycleLoaded)
    ↓
UI Rebuilds (BlocBuilder)
```

---

### 4.3 Bloc Structure Example

```dart
// Event
abstract class CycleEvent {}
class LoadCycleData extends CycleEvent {}
class StartPeriod extends CycleEvent {
  final DateTime date;
  final FlowLevel flowLevel;
  StartPeriod(this.date, this.flowLevel);
}
class EndPeriod extends CycleEvent {
  final DateTime date;
  EndPeriod(this.date);
}

// State
abstract class CycleState {}
class CycleInitial extends CycleState {}
class CycleLoading extends CycleState {}
class CycleLoaded extends CycleState {
  final Prediction? prediction;
  final Cycle? currentCycle;
  final int? currentCycleDay;
  CycleLoaded({this.prediction, this.currentCycle, this.currentCycleDay});
}
class CycleError extends CycleState {
  final String message;
  CycleError(this.message);
}

// Bloc
class CycleBloc extends Bloc<CycleEvent, CycleState> {
  final GetPeriodPrediction getPeriodPrediction;
  final GetCurrentCycle getCurrentCycle;
  final StartPeriodUseCase startPeriodUseCase;
  
  CycleBloc({
    required this.getPeriodPrediction,
    required this.getCurrentCycle,
    required this.startPeriodUseCase,
  }) : super(CycleInitial()) {
    on<LoadCycleData>(_onLoadCycleData);
    on<StartPeriod>(_onStartPeriod);
    on<EndPeriod>(_onEndPeriod);
  }
  
  Future<void> _onLoadCycleData(LoadCycleData event, Emitter<CycleState> emit) async {
    emit(CycleLoading());
    try {
      final prediction = await getPeriodPrediction();
      final currentCycle = await getCurrentCycle();
      emit(CycleLoaded(prediction: prediction, currentCycle: currentCycle));
    } catch (e) {
      emit(CycleError(e.toString()));
    }
  }
  
  Future<void> _onStartPeriod(StartPeriod event, Emitter<CycleState> emit) async {
    try {
      await startPeriodUseCase(event.date, event.flowLevel);
      // Reload data
      add(LoadCycleData());
    } catch (e) {
      emit(CycleError('Failed to start period: ${e.toString()}'));
    }
  }
  
  // ... other event handlers
}
```

---

<a name="dependency-injection"></a>
## 5. Dependency Injection (get_it)

### 5.1 Why get_it

**Advantages:**
- **Service locator pattern**: Simple, no build context needed
- **Lazy vs eager loading**: Register singletons or factories
- **Testing friendly**: Easy to mock dependencies

---

### 5.2 Injection Setup (injection_container.dart)

```dart
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External dependencies
  final isar = await Isar.open([/* schemas */]);
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<Isar>(isar);
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);
  
  // Data sources
  getIt.registerLazySingleton<CycleLocalDataSource>(
    () => CycleLocalDataSource(getIt<Isar>()),
  );
  
  // Repositories
  getIt.registerLazySingleton<CycleRepository>(
    () => CycleRepositoryImpl(getIt<CycleLocalDataSource>()),
  );
  
  // Use cases
  getIt.registerLazySingleton<GetPeriodPrediction>(
    () => GetPeriodPrediction(getIt<CycleRepository>(), getIt<PredictionRepository>()),
  );
  
  // Blocs (registered as factories - new instance per request)
  getIt.registerFactory<CycleBloc>(
    () => CycleBloc(
      getPeriodPrediction: getIt<GetPeriodPrediction>(),
      getCurrentCycle: getIt<GetCurrentCycle>(),
      startPeriodUseCase: getIt<StartPeriodUseCase>(),
    ),
  );
}
```

---

<a name="database"></a>
## 6. Database Implementation (Isar)

### 6.1 Why Isar

**Advantages over Hive:**
- **Better performance**: Faster queries, indexing, lazy loading
- **Built-in encryption**: Native AES-256 encryption
- **Query language**: Powerful filtering and sorting
- **Type-safe**: Compile-time schema validation
- **Streams**: Built-in watch() for reactive data

---

### 6.2 Isar Setup

**1. Add dependencies (pubspec.yaml):**
```yaml
dependencies:
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0 # Android/iOS support
  
dev_dependencies:
  isar_generator: ^3.1.0
  build_runner: ^2.4.6
```

**2. Define schema (example: cycle_model.dart):**
```dart
import 'package:isar/isar.dart';

part 'cycle_model.g.dart'; // Generated file

@collection
class CycleModel {
  Id id = Isar.autoIncrement;
  
  @Index()
  late DateTime periodStartDate;
  
  DateTime? periodEndDate;
  int? cycleLength;
  
  @Enumerated(EnumType.name)
  late FlowLevelDb flowLevel;
  
  late DateTime createdAt;
  late DateTime updatedAt;
}

enum FlowLevelDb { light, medium, heavy }
```

**3. Generate code:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**4. Initialize Isar (main.dart):**
```dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<Isar> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [
      CycleModelSchema,
      SymptomModelSchema,
      VitalModelSchema,
      // ... all schemas
    ],
    directory: dir.path,
    inspector: true, // Enable Isar Inspector (debug only)
    // Encryption (Pro feature or all users - recommended for all)
    // encryptionKey: await getEncryptionKey(), // 32-byte key
  );
}
```

---

### 6.3 Encryption Setup

**Option 1: Universal encryption (all users)**
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyName = 'isar_encryption_key';
final _secureStorage = FlutterSecureStorage();

Future<Uint8List> getEncryptionKey() async {
  String? keyString = await _secureStorage.read(key: _keyName);
  
  if (keyString == null) {
    // Generate new 32-byte key
    final key = Isar.generateEncryptionKey();
    keyString = base64Encode(key);
    await _secureStorage.write(key: _keyName, value: keyString);
    return key;
  }
  
  return base64Decode(keyString);
}

// In initIsar():
final isar = await Isar.open(
  schemas,
  directory: dir.path,
  encryptionKey: await getEncryptionKey(), // Encrypt all data
);
```

**Option 2: Pro-only cloud encryption (local data unencrypted, cloud data encrypted)**
- Local: No Isar encryption (faster)
- Cloud sync: Encrypt JSON payloads before uploading to Firestore (client-side encryption)
- Implementation in v1.5

---

### 6.4 Database Migrations

**Isar handles migrations automatically:**
- Adding new collections: Auto-detected
- Adding new fields: Default values used
- Removing fields: Ignored (data preserved)

**Manual migration (if needed):**
```dart
// Check Isar version, run custom migration logic
if (needsMigration) {
  // Example: Migrate old data structure
  final oldRecords = await isar.oldModels.where().findAll();
  for (final old in oldRecords) {
    final newRecord = NewModel.fromOld(old);
    await isar.writeTxn(() => isar.newModels.put(newRecord));
  }
}
```

---

<a name="firebase"></a>
## 7. Firebase Setup

### 7.1 Firebase Services Used

1. **Firebase Authentication** (v1.5 - Pro cloud sync)
   - Anonymous auth (default, no email required)
   - Email/password (optional, for Pro users who want cloud sync)

2. **Cloud Firestore** (v1.5 - Pro cloud sync)
   - Store encrypted user data (cycles, symptoms, vitals)
   - Document structure: `users/{userId}/cycles/{cycleId}`

3. **Firebase Crashlytics** (MVP)
   - Crash reporting (no PII in logs)
   - Non-fatal error tracking

4. **Firebase Analytics** (MVP)
   - Non-sensitive events only (e.g., "onboarding_completed", "period_logged")
   - No health data in event properties

5. **Firebase Remote Config** (v1.1+)
   - Content cards (tips, articles) - dynamic delivery
   - Feature flags (A/B testing, gradual rollout)

6. **Firebase In-App Messaging** (v1.5+)
   - Pro upgrade prompts (contextual, non-intrusive)

---

### 7.2 Firebase Setup Steps

**1. Create Firebase project (Android)**
- Go to https://console.firebase.google.com
- Create project: "Femio"
- Add Android app:
  - Package name: `com.femio.app` (match AndroidManifest.xml)
  - Download `google-services.json` → `android/app/`

**2. Add FlutterFire dependencies:**
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_crashlytics: ^3.4.0
  firebase_analytics: ^10.7.0
  # v1.5 (Pro):
  # firebase_auth: ^4.15.0
  # cloud_firestore: ^4.13.0
  # firebase_remote_config: ^4.3.0
```

**3. Initialize Firebase (main.dart):**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Generated by FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Enable Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  // Initialize Isar
  final isar = await initIsar();
  
  // Setup DI
  await setupDependencies();
  
  runApp(MyApp());
}
```

**4. Configure Crashlytics (no PII):**
```dart
// In error handling code:
try {
  // Risky operation
} catch (e, stackTrace) {
  // Log to Crashlytics (filter out sensitive data)
  await FirebaseCrashlytics.instance.recordError(
    e,
    stackTrace,
    reason: 'Cycle prediction failed',
    information: ['userId: ${user.id}'], // Hash or anonymize user ID
    fatal: false,
  );
}
```

**5. Configure Analytics (privacy-safe events):**
```dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  Future<void> logOnboardingCompleted(String stage) async {
    await _analytics.logEvent(
      name: 'onboarding_completed',
      parameters: {'stage': stage}, // 'cycle', 'pregnancy', etc. (not sensitive)
    );
  }
  
  Future<void> logPeriodLogged() async {
    await _analytics.logEvent(name: 'period_logged'); // No health data
  }
  
  // NEVER log sensitive data (dates, vitals values, symptoms)
}
```

---

### 7.3 Firebase Security Rules (v1.5 - Firestore)

**Firestore rules (users can only access their own data):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Subcollections (cycles, symptoms, vitals)
      match /{collection}/{docId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

---

<a name="localization"></a>
## 8. Localization Architecture

### 8.1 Localization Strategy

**Package**: `flutter_localizations` + `intl` (official Flutter approach)

**Supported languages (MVP):**
- English (en)
- Arabic (ar) - Modern Standard Arabic (MSA)

**Localization files:**
- `l10n/app_en.arb` (source)
- `l10n/app_ar.arb` (translation)

---

### 8.2 ARB File Structure

**app_en.arb (example):**
```json
{
  "@@locale": "en",
  "appTitle": "Femio",
  "@appTitle": {
    "description": "Application title"
  },
  "onboardingWelcomeTitle": "Your data, your device",
  "@onboardingWelcomeTitle": {
    "description": "Welcome screen title"
  },
  "onboardingWelcomeSubtitle": "All your health data stays on your phone, encrypted and private.",
  "nextPeriodIn": "In {days} days",
  "@nextPeriodIn": {
    "placeholders": {
      "days": {
        "type": "int",
        "example": "5"
      }
    }
  },
  "confidenceLevel": "{level} confidence",
  "@confidenceLevel": {
    "placeholders": {
      "level": {
        "type": "String",
        "example": "High"
      }
    }
  }
}
```

**app_ar.arb (example):**
```json
{
  "@@locale": "ar",
  "appTitle": "Femio",
  "onboardingWelcomeTitle": "بياناتك، جهازك",
  "onboardingWelcomeSubtitle": "تبقى جميع بياناتك الصحية على هاتفك، مشفرة وخاصة.",
  "nextPeriodIn": "خلال {days} أيام",
  "confidenceLevel": "ثقة {level}"
}
```

---

### 8.3 Localization Setup

**1. Add dependencies:**
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1

flutter:
  generate: true # Enable code generation
```

**2. Create l10n.yaml (configuration):**
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**3. Generate localization code:**
```bash
flutter gen-l10n
```

This generates `lib/l10n/app_localizations.dart` with type-safe string accessors.

**4. Use in MaterialApp:**
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:femio_app/l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      locale: _getUserSelectedLocale(), // From settings
      title: 'Femio',
      theme: AppTheme.lightTheme,
      home: OnboardingPage(),
    );
  }
}
```

**5. Use in widgets:**
```dart
import 'package:femio_app/l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.onboardingWelcomeTitle);
    // For parameterized strings:
    // Text(l10n.nextPeriodIn(5)) // "In 5 days" or "خلال 5 أيام"
  }
}
```

---

### 8.4 RTL Support

**Automatic RTL detection:**
```dart
MaterialApp(
  localizationsDelegates: [...],
  supportedLocales: [...],
  locale: Locale('ar'), // Arabic selected
  // Flutter automatically sets Directionality.rtl
  // All widgets flip: text alignment, navigation, icons
)
```

**Manual RTL testing:**
```dart
// Force RTL for testing (debug only)
Directionality(
  textDirection: TextDirection.rtl,
  child: MyApp(),
)
```

**RTL-aware widgets:**
- Use `Directionality.of(context)` to check current direction
- Test navigation drawer, back buttons, icon positioning
- Charts: Ensure x-axis labels don't overlap

---

### 8.5 Translation Workflow

**MVP (manual translation):**
1. Write all strings in `app_en.arb`
2. Send to professional Arabic translator (MSA, medical tone)
3. Translator returns `app_ar.arb`
4. Review and commit
5. Run `flutter gen-l10n`

**Post-MVP (continuous localization):**
- Use Localization Management Platform: Lokalise, Crowdin, or POEditor
- Sync ARB files via API
- Translators work in web UI
- Auto-generate PRs with updated ARB files

---

<a name="dependencies"></a>
## 9. Dependencies & Packages (pubspec.yaml)

```yaml
name: femio_app
description: Femio – Privacy-first period and pregnancy tracker for MENA women
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5 # For value equality in states/events
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Local Database
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  path_provider: ^2.1.1 # For database path
  
  # Secure Storage (encryption key)
  flutter_secure_storage: ^9.0.0
  
  # Firebase
  firebase_core: ^2.24.0
  firebase_crashlytics: ^3.4.0
  firebase_analytics: ^10.7.0
  # v1.5 Pro features:
  # firebase_auth: ^4.15.0
  # cloud_firestore: ^4.13.0
  # firebase_remote_config: ^4.3.0
  
  # Ads (AdMob)
  google_mobile_ads: ^4.0.0
  
  # In-App Purchases (Pro subscription)
  in_app_purchase: ^3.1.11
  
  # Localization
  intl: ^0.18.1
  
  # Charts
  fl_chart: ^0.65.0
  
  # UI Components
  flutter_svg: ^2.0.9 # For SVG icons/illustrations
  cached_network_image: ^3.3.0 # For remote images (content cards)
  
  # Utilities
  dartz: ^0.10.1 # Functional programming (Either for error handling)
  freezed_annotation: ^2.4.1 # For immutable entities (optional, recommended)
  json_annotation: ^4.8.1 # For JSON serialization
  
  # Date/Time
  # (no extra package needed, using built-in DateTime)
  
  # Permissions (future - notifications)
  # permission_handler: ^11.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  
  # Code Generation
  build_runner: ^2.4.6
  isar_generator: ^3.1.0
  freezed: ^2.4.5 # For freezed code generation (entities)
  json_serializable: ^6.7.1
  
  # Testing
  bloc_test: ^9.1.5 # For testing Blocs
  mocktail: ^1.0.1 # For mocking dependencies
  
  # Integration/Widget Testing
  integration_test:
    sdk: flutter

flutter:
  uses-material-design: true
  generate: true # Enable l10n generation
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/illustrations/
    # Content card images/icons
  
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
    
    - family: Cairo # Arabic font
      fonts:
        - asset: assets/fonts/Cairo-Regular.ttf
        - asset: assets/fonts/Cairo-Medium.ttf
          weight: 500
        - asset: assets/fonts/Cairo-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
```

---

<a name="build"></a>
## 10. Build & CI/CD

### 10.1 Build Configuration

**Android (android/app/build.gradle.kts):**
```kotlin
android {
    namespace = "com.femio.app"
    compileSdk = 34
    
    defaultConfig {
        applicationId = "com.femio.app"
        minSdk = 21 // Android 5.0 (covers 98%+ devices)
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }
    
    signingConfigs {
        // Release signing (use keystore)
        create("release") {
            storeFile = file(System.getenv("KEYSTORE_PATH") ?: "keystore.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD")
            keyAlias = System.getenv("KEY_ALIAS")
            keyPassword = System.getenv("KEY_PASSWORD")
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
    
    flavorDimensions += "environment"
    productFlavors {
        create("production") {
            dimension = "environment"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
        }
    }
}
```

---

### 10.2 CI/CD Setup (GitHub Actions - Optional)

**.github/workflows/flutter_ci.yml:**
```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run code generation
        run: flutter pub run build_runner build --delete-conflicting-outputs
      
      - name: Analyze code
        run: flutter analyze
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

  build_android:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build APK (staging)
        run: flutter build apk --flavor staging --release
      
      - name: Upload APK artifact
        uses: actions/upload-artifact@v3
        with:
          name: app-staging-release.apk
          path: build/app/outputs/flutter-apk/app-staging-release.apk
```

---

### 10.3 Linting & Code Quality

**analysis_options.yaml:**
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - always_use_package_imports
    - avoid_print
    - avoid_unnecessary_containers
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_single_quotes
    - sort_constructors_first
    - use_key_in_widget_constructors
    - require_trailing_commas

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    invalid_annotation_target: ignore
```

---

## 11. Milestone 3 Summary & Checklist

### Deliverables Completed ✅

1. **Architecture Overview**: ✅
   - Clean Architecture pattern explained
   - Feature-first organization justified
   - Layer diagram (Presentation → Domain → Data)

2. **Clean Architecture Layers**: ✅
   - Domain layer: Entities, repository interfaces, use cases (examples provided)
   - Data layer: Data models (Isar), data sources, repository implementations (examples provided)
   - Presentation layer: Widgets, pages, Bloc/Cubit (examples provided)

3. **Folder Structure**: ✅
   - Complete folder tree (feature-first)
   - 9 features scaffolded: onboarding, cycle, calendar, symptoms, fertility, pregnancy, vitals, appointments, settings, pro, ads
   - Core utilities, constants, widgets organized

4. **State Management**: ✅
   - Bloc pattern chosen (with rationale)
   - Bloc vs Cubit guidelines
   - Full Bloc example (CycleBloc with events, states, event handlers)

5. **Dependency Injection**: ✅
   - get_it service locator
   - Setup pattern (injection_container.dart)
   - Lazy singletons for repositories, factories for Blocs

6. **Database Implementation**: ✅
   - Isar chosen (over Hive) with advantages listed
   - Schema definition example (CycleModel with Isar annotations)
   - Encryption setup (universal or Pro-only)
   - Migration strategy (auto + manual)

7. **Firebase Setup**: ✅
   - 5 Firebase services: Auth, Firestore, Crashlytics, Analytics, Remote Config
   - Setup steps (project creation, dependencies, initialization)
   - Privacy-safe analytics (no PII/health data)
   - Firestore security rules (v1.5)

8. **Localization Architecture**: ✅
   - flutter_localizations + intl approach
   - ARB file structure (app_en.arb, app_ar.arb examples)
   - RTL support (automatic + testing)
   - Translation workflow (manual MVP, platform post-MVP)

9. **Dependencies & Packages**: ✅
   - Complete pubspec.yaml with:
     - State management: flutter_bloc, equatable
     - DI: get_it
     - Database: isar, isar_flutter_libs, flutter_secure_storage
     - Firebase: core, crashlytics, analytics (auth/firestore commented for v1.5)
     - Ads: google_mobile_ads
     - Purchases: in_app_purchase
     - Localization: intl
     - Charts: fl_chart
     - UI: flutter_svg, cached_network_image
     - Utilities: dartz, freezed, json_annotation
     - Testing: bloc_test, mocktail
   - Fonts: Poppins (English), Cairo (Arabic)

10. **Build & CI/CD**: ✅
    - Android build.gradle.kts configuration (flavors, signing)
    - GitHub Actions CI/CD workflow (test, analyze, build APK)
    - Linting: analysis_options.yaml with flutter_lints

---

### Architecture Validation Checklist

#### **Localization ✅**
- ARB files structure defined (EN/AR)
- RTL support strategy documented
- Translation workflow (manual → platform)
- Fonts included: Poppins (EN), Cairo (AR)

#### **Privacy ✅**
- Isar encryption setup (universal or Pro-only)
- Firebase Crashlytics: No PII in logs
- Firebase Analytics: Non-sensitive events only
- Firestore security rules: User-scoped access (v1.5)
- flutter_secure_storage for encryption keys

#### **Clean Architecture ✅**
- 3 layers clearly separated (Domain, Data, Presentation)
- Domain entities are pure Dart (no framework dependencies)
- Repository interfaces in domain, implementations in data
- Use cases orchestrate business logic
- Presentation depends on domain via use cases

#### **RTL Support ✅**
- MaterialApp localizationsDelegates include GlobalMaterialLocalizations (handles RTL)
- Locale switching triggers automatic Directionality.rtl
- Manual testing strategy documented
- Cairo font for Arabic (high-quality rendering)

---

### Risks & Mitigation (Technical)

**Risk 1: Isar learning curve for team**  
*Mitigation*: Provide code examples, Isar docs link, pair programming for first few features.

**Risk 2: Clean architecture over-engineering for MVP**  
*Mitigation*: Simplify for MVP (e.g., some features use Cubit instead of Bloc), refactor post-MVP.

**Risk 3: Firebase costs (Firestore reads for Pro sync)**  
*Mitigation*: Implement incremental sync (only changed documents), cache aggressively, monitor Firestore usage.

**Risk 4: Encryption performance on low-end devices**  
*Mitigation*: Profile on Snapdragon 665 (mid-range baseline); if >200ms overhead, consider lazy decryption or Pro-only encryption.

---

## Next Steps → Milestone 4 (MVP Implementation)

With technical architecture complete, we proceed to:

**Milestone 4: MVP Implementation (Step-by-Step Coding)**

**Phase 4.1: Core Setup**
- Initialize Flutter project structure
- Setup Isar database with encryption
- Configure Firebase (Crashlytics, Analytics)
- Setup localization (ARB files, generate l10n)
- Create theme (Material 3, colors, typography)
- Setup DI (injection_container.dart)

**Phase 4.2: Feature Implementation (in order)**
1. **Onboarding**: Welcome, language, stage selection, setup, consent
2. **Cycle Tracking**: Period logging, prediction algorithm, cycle history
3. **Calendar**: Visual calendar, day details, legend
4. **Home Dashboard (Cycle)**: Hero card, quick actions, vitals summary
5. **Symptoms**: Quick log sheet, symptom history
6. **Fertility/TTC**: Fertile window, mucus logging, TTC dashboard
7. **Pregnancy**: Timeline, week content (10-12 weeks), pregnancy dashboard
8. **Vitals**: BP/weight logging, charts
9. **Settings**: Language, discreet mode, export, delete data
10. **Monetization**: Ads integration, Pro paywall, subscription flow

**Phase 4.3: Integration & Testing**
- Widget tests (critical flows)
- Unit tests (prediction algorithm, use cases)
- Manual QA (10+ screens, EN/AR, RTL)
- Performance profiling (cold start, chart render)

---

**Milestone 3 Status**: ✅ **COMPLETE**

**Proceeding to Milestone 4 implementation...**
