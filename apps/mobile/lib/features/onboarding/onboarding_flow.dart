// The onboarding flow: which question comes next, what she has answered so far, and
// the saved profile at the end.
//
// Why it exists: it is the only place that knows the order of the questions. Each
// question's look lives in its own file under steps/, so a change to one screen cannot
// disturb the routing, and the routing can be read on one page.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/age_gate.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy.dart';
import 'steps/birth_year_step.dart';
import 'steps/cycle_length_step.dart';
import 'steps/due_date_step.dart';
import 'steps/due_method_step.dart';
import 'steps/eighteen_step.dart';
import 'steps/goal_step.dart';
import 'steps/last_period_step.dart';
import 'steps/meno_last_step.dart';
import 'steps/period_length_step.dart';
import 'steps/trying_step.dart';
import 'steps/under18_step.dart';
import 'steps/welcome_step.dart';

/// Every screen of the flow, in no particular order: the path she walks depends on her
/// goal (see [_OnboardingFlowState._path]).
enum _Step {
  welcome,
  goal,
  birthYear,
  eighteenCheck,
  under18,
  lastPeriod,
  periodLength,
  cycleLength,
  trying,
  dueMethod,
  dueDate,
  menoLast,
}

/// Onboarding, rebuilt to the competitor standard (04_ANDROID_APP_SPEC §3, owner
/// critique 2026-10-07): the goal first, nothing pre-selected, her last period before
/// anything else, under a minute, and a prediction at the end. Conditions are never
/// asked here; they are offered later, where they help.
///
/// [controller] receives the finished profile. [today] fixes the date in tests; the
/// real app reads the clock. With [editing] (R14.10, Settings → What femio helps with) the
/// flow starts at the goal with her answers filled in, skips the age questions she already
/// answered, keeps everything she logged ([Profile.withAnswers]) and closes when done.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key, required this.controller, this.today, this.editing = false});
  final FemioController controller;
  final String? today;
  final bool editing;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late final _history = <_Step>[widget.editing ? _Step.goal : _Step.welcome];
  _Step get _step => _history.last;

  Goal? _goal;
  int? _birthYear;
  DateTime? _lastPeriod;
  int _periodLength = 5;
  bool _periodLengthKnown = true;
  int _cycleLength = 28;
  bool _cycleKnown = true;
  bool _irregular = false;
  TryingFor? _trying;
  DueMethod? _dueMethod;
  DateTime? _dueInput;
  DateTime? _menoLast;
  bool _menoOverYear = false;

  /// Her age when none is given: the middle of the wheel, so Continue still works.
  static const _defaultAge = 28;

  /// The wheel lists birth years from this many years ago back to [_oldestAge].
  static const _youngestAge = 10;
  static const _oldestAge = 75;

  @override
  void initState() {
    super.initState();
    final p = widget.controller.profile;
    if (!widget.editing || p == null) return;
    _goal = p.goal;
    _birthYear = p.birthYear;
    _periodLength = p.periodLength ?? _periodLength;
    _periodLengthKnown = p.periodLength != null;
    _cycleLength = p.cycleLength ?? _cycleLength;
    _cycleKnown = p.cycleLength != null;
    _irregular = p.irregular;
    _trying = p.tryingFor;
    if (p.periodStarts.isNotEmpty) _lastPeriod = fromISO(p.periodStarts.last);
  }

  String get _todayISO => widget.today ?? todayISO();
  DateTime get _today => fromISO(_todayISO);

  void _go(_Step next) => setState(() => _history.add(next));
  void _back() {
    if (widget.editing && _history.length <= 1) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() {
      if (_history.length > 1) _history.removeLast();
    });
  }

  /// The questions on her path, for an honest progress bar.
  List<_Step> get _path => switch (_goal) {
        Goal.period => [_Step.goal, _Step.birthYear, _Step.lastPeriod, _Step.periodLength, _Step.cycleLength],
        Goal.ttc => [_Step.goal, _Step.birthYear, _Step.lastPeriod, _Step.periodLength, _Step.cycleLength, _Step.trying],
        Goal.pregnant => [_Step.goal, _Step.birthYear, _Step.dueMethod, _Step.dueDate],
        Goal.menopause => [_Step.goal, _Step.birthYear, _Step.menoLast],
        null => [_Step.goal, _Step.birthYear, _Step.lastPeriod, _Step.periodLength, _Step.cycleLength],
      };

  double get _progress {
    // The 18th-birthday question is part of the birth-year answer, not a step of its own.
    final i = _path.indexOf(_step == _Step.eighteenCheck ? _Step.birthYear : _step);
    return i < 0 ? 0.1 : (i + 1) / (_path.length + 1);
  }

  /// Routes the birth-year answer through the 18+ gate (MR-48, D-01): adults go on,
  /// exactly eighteen calendar years asks one question, younger sees the notice.
  void _afterBirthYear() {
    switch (ageGate(birthYear: _birthYear ?? _today.year - _defaultAge, todayYear: _today.year)) {
      case AgeGate.under18:
        return _go(_Step.under18);
      case AgeGate.askBirthday:
        return _go(_Step.eighteenCheck);
      case AgeGate.adult:
        return _afterAge();
    }
  }

  /// The first question of her goal's path once her age is settled.
  void _afterAge() {
    _go(switch (_goal!) {
      Goal.period || Goal.ttc => _Step.lastPeriod,
      Goal.pregnant => _Step.dueMethod,
      Goal.menopause => _Step.menoLast,
    });
  }

  String? get _computedEdd {
    final d = _dueInput;
    if (d == null) return null;
    final iso = toISO(d);
    return switch (_dueMethod) {
      DueMethod.known => iso,
      DueMethod.lmp => eddFromLmp(iso),
      DueMethod.conception => eddFromConception(iso),
      DueMethod.ivf3 => eddFromTransfer(iso, embryoDays: 3),
      DueMethod.ivf5 => eddFromTransfer(iso, embryoDays: 5),
      _ => null,
    };
  }

  Future<void> _finish() async {
    final goal = _goal!;
    final locale = Localizations.localeOf(context).languageCode;
    final born = _dueMethod == DueMethod.born && _dueInput != null;
    final old = widget.controller.profile;
    if (widget.editing && old != null) {
      final cycle = goal == Goal.period || goal == Goal.ttc;
      await widget.controller.save(old.withAnswers(
        goal: goal,
        periodLength: cycle ? (_periodLengthKnown ? _periodLength : null) : old.periodLength,
        cycleLength: cycle ? (_cycleKnown && !_irregular ? _cycleLength : null) : old.cycleLength,
        irregular: cycle ? _irregular : old.irregular,
        tryingFor: goal == Goal.ttc ? _trying : old.tryingFor,
        edd: goal == Goal.pregnant && !born ? (_computedEdd ?? old.edd) : old.edd,
        birthDate: born ? toISO(_dueInput!) : old.birthDate,
        lastPeriodOverYear: goal == Goal.menopause ? _menoOverYear : old.lastPeriodOverYear,
        addStarts: [
          if (cycle && _lastPeriod != null) toISO(_lastPeriod!),
          if (goal == Goal.menopause && _menoLast != null) toISO(_menoLast!),
        ],
      ));
      if (mounted) Navigator.of(context).pop();
      return;
    }
    await widget.controller.save(Profile(
      goal: goal,
      locale: locale,
      birthYear: _birthYear,
      periodStarts: switch (goal) {
        Goal.period || Goal.ttc => [if (_lastPeriod != null) toISO(_lastPeriod!)],
        Goal.menopause => [if (_menoLast != null) toISO(_menoLast!)],
        Goal.pregnant => const [],
      },
      periodLength: (goal == Goal.period || goal == Goal.ttc) && _periodLengthKnown ? _periodLength : null,
      cycleLength: (goal == Goal.period || goal == Goal.ttc) && _cycleKnown && !_irregular ? _cycleLength : null,
      irregular: _irregular,
      tryingFor: goal == Goal.ttc ? _trying : null,
      edd: goal == Goal.pregnant && !born ? _computedEdd : null,
      birthDate: born ? toISO(_dueInput!) : null,
      lastPeriodOverYear: goal == Goal.menopause && _menoOverYear,
      settings: AppSettings.defaultsFor(locale),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _history.length <= 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(key: ValueKey(_step), child: _buildStep()),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case _Step.welcome:
        return WelcomeStep(controller: widget.controller, onStart: () => _go(_Step.goal));

      case _Step.goal:
        return GoalStep(
          progress: _progress,
          onBack: _back,
          selected: _goal,
          onPick: (g) {
            setState(() => _goal = g);
            // Editing: her age was settled at first onboarding (MR-48), so it is not asked again.
            if (widget.editing && _birthYear != null) {
              _afterAge();
            } else {
              _go(_Step.birthYear);
            }
          },
        );

      case _Step.birthYear:
        final now = _today.year;
        final years = [for (var y = now - _youngestAge; y >= now - _oldestAge; y--) y];
        final initial = years.indexOf(_birthYear ?? now - _defaultAge);
        return BirthYearStep(
          progress: _progress,
          onBack: _back,
          years: years,
          initialIndex: initial,
          onYearChanged: (y) => _birthYear = y,
          onContinue: () {
            _birthYear ??= years[initial];
            _afterBirthYear();
          },
        );

      case _Step.eighteenCheck:
        return EighteenStep(progress: _progress, onBack: _back, onYes: _afterAge, onNo: () => _go(_Step.under18));

      case _Step.under18:
        return Under18Step(progress: _progress, onBack: _back);

      case _Step.lastPeriod:
        return LastPeriodStep(
          progress: _progress,
          onBack: _back,
          today: _today,
          selected: _lastPeriod,
          onChanged: (d) => setState(() => _lastPeriod = d),
          onContinue: _lastPeriod == null ? null : () => _go(_Step.periodLength),
          onDontRemember: () {
            setState(() => _lastPeriod = null);
            _go(_Step.periodLength);
          },
        );

      case _Step.periodLength:
        return PeriodLengthStep(
          progress: _progress,
          onBack: _back,
          value: _periodLength,
          onChanged: (v) => setState(() => _periodLength = v),
          onContinue: () {
            _periodLengthKnown = true;
            _go(_Step.cycleLength);
          },
          onNotSure: () {
            _periodLengthKnown = false;
            _go(_Step.cycleLength);
          },
        );

      case _Step.cycleLength:
        void next() => _goal == Goal.ttc ? _go(_Step.trying) : _finish();
        return CycleLengthStep(
          progress: _progress,
          onBack: _back,
          value: _cycleLength,
          onChanged: (v) => setState(() => _cycleLength = v),
          onContinue: () {
            _cycleKnown = true;
            _irregular = false;
            next();
          },
          onIrregular: () {
            _cycleKnown = false;
            _irregular = true;
            next();
          },
          onNotSure: () {
            _cycleKnown = false;
            _irregular = false;
            next();
          },
        );

      case _Step.trying:
        return TryingStep(
          progress: _progress,
          onBack: _back,
          selected: _trying,
          onPick: (v) {
            setState(() => _trying = v);
            _finish();
          },
          onNotSure: _finish,
        );

      case _Step.dueMethod:
        return DueMethodStep(
          progress: _progress,
          onBack: _back,
          selected: _dueMethod,
          onPick: (m) {
            setState(() {
              _dueMethod = m;
              _dueInput = null;
            });
            _go(_Step.dueDate);
          },
        );

      case _Step.dueDate:
        final method = _dueMethod!;
        final edd = _computedEdd;
        final implausible = method != DueMethod.born && edd != null && !isPlausibleEdd(edd, _todayISO);
        return DueDateStep(
          progress: _progress,
          onBack: _back,
          method: method,
          today: _today,
          selected: _dueInput,
          implausible: implausible,
          onChanged: (d) => setState(() => _dueInput = d),
          onContinue: _dueInput == null || implausible ? null : _finish,
        );

      case _Step.menoLast:
        return MenoLastStep(
          progress: _progress,
          onBack: _back,
          today: _today,
          selected: _menoLast,
          onChanged: (d) => setState(() => _menoLast = d),
          onContinue: _menoLast == null ? null : _finish,
          onOverYear: () {
            _menoLast = null;
            _menoOverYear = true;
            _finish();
          },
          onNotSure: () {
            _menoLast = null;
            _menoOverYear = false;
            _finish();
          },
        );
    }
  }
}
