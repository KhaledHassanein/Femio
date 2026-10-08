import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/profile.dart';
import '../../domain/dates.dart';
import '../../domain/pregnancy.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../widgets/bloom.dart';
import 'widgets.dart';

/// Onboarding, rebuilt to the competitor standard (04_ANDROID_APP_SPEC §3, owner
/// critique 2026-10-07): the goal first, nothing pre-selected, her last period before
/// anything else, under a minute, and a prediction at the end. Conditions are never
/// asked here; they are offered later, where they help.
enum _Step {
  welcome,
  goal,
  birthYear,
  under18,
  lastPeriod,
  periodLength,
  cycleLength,
  trying,
  dueMethod,
  dueDate,
  menoLast,
}

enum _DueMethod { known, lmp, conception, ivf3, ivf5, born }

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key, required this.controller, this.today});
  final FemioController controller;
  final String? today;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _history = <_Step>[_Step.welcome];
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
  _DueMethod? _dueMethod;
  DateTime? _dueInput;
  DateTime? _menoLast;
  bool _menoOverYear = false;

  String get _todayISO => widget.today ?? todayISO();
  DateTime get _today => fromISO(_todayISO);

  void _go(_Step next) => setState(() => _history.add(next));
  void _back() => setState(() {
        if (_history.length > 1) _history.removeLast();
      });

  /// The questions on her path, for an honest progress bar.
  List<_Step> get _path => switch (_goal) {
        Goal.period => [_Step.goal, _Step.birthYear, _Step.lastPeriod, _Step.periodLength, _Step.cycleLength],
        Goal.ttc => [_Step.goal, _Step.birthYear, _Step.lastPeriod, _Step.periodLength, _Step.cycleLength, _Step.trying],
        Goal.pregnant => [_Step.goal, _Step.birthYear, _Step.dueMethod, _Step.dueDate],
        Goal.menopause => [_Step.goal, _Step.birthYear, _Step.menoLast],
        null => [_Step.goal, _Step.birthYear, _Step.lastPeriod, _Step.periodLength, _Step.cycleLength],
      };

  double get _progress {
    final i = _path.indexOf(_step);
    return i < 0 ? 0.1 : (i + 1) / (_path.length + 1);
  }

  void _afterBirthYear() {
    final age = _today.year - (_birthYear ?? _today.year - 30);
    if (age < 18) return _go(_Step.under18);
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
      _DueMethod.known => iso,
      _DueMethod.lmp => eddFromLmp(iso),
      _DueMethod.conception => eddFromConception(iso),
      _DueMethod.ivf3 => eddFromTransfer(iso, embryoDays: 3),
      _DueMethod.ivf5 => eddFromTransfer(iso, embryoDays: 5),
      _ => null,
    };
  }

  Future<void> _finish() async {
    final goal = _goal!;
    final locale = Localizations.localeOf(context).languageCode;
    final born = _dueMethod == _DueMethod.born && _dueInput != null;
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
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return PopScope(
      canPop: _history.length <= 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(key: ValueKey(_step), child: _buildStep(context, l)),
      ),
    );
  }

  Widget _buildStep(BuildContext context, L10n l) {
    final p = context.palette;
    switch (_step) {
      case _Step.welcome:
        return _Welcome(controller: widget.controller, onStart: () => _go(_Step.goal));

      case _Step.goal:
        Widget goal(Goal g, IconData icon, String title, String desc, Color tint) => OptionTile(
              icon: icon,
              title: title,
              description: desc,
              tint: tint,
              selected: _goal == g,
              onTap: () {
                setState(() => _goal = g);
                _go(_Step.birthYear);
              },
            );
        return StepScaffold(
          progress: _progress,
          title: l.goalTitle,
          subtitle: l.goalSub,
          onBack: _back,
          child: Column(children: [
            goal(Goal.period, Icons.water_drop_outlined, l.goalPeriod, l.goalPeriodDesc, p.logPeriodAlt),
            goal(Goal.ttc, Icons.local_florist_outlined, l.goalTtc, l.goalTtcDesc, p.successSoft),
            goal(Goal.pregnant, Icons.child_friendly_outlined, l.goalPregnant, l.goalPregnantDesc, p.accentSoft),
            goal(Goal.menopause, Icons.nightlight_outlined, l.goalMenopause, l.goalMenopauseDesc, p.primarySoft),
          ]),
        );

      case _Step.birthYear:
        final now = _today.year;
        final years = [for (var y = now - 10; y >= now - 75; y--) y];
        final initial = years.indexOf(_birthYear ?? now - 28);
        return StepScaffold(
          progress: _progress,
          title: l.birthYearTitle,
          subtitle: l.birthYearSub,
          onBack: _back,
          primaryLabel: l.continueLabel,
          onPrimary: () {
            _birthYear ??= years[initial];
            _afterBirthYear();
          },
          child: _YearWheel(
            years: years,
            initialIndex: initial,
            onChanged: (y) => _birthYear = y,
          ),
        );

      case _Step.under18:
        return StepScaffold(
          progress: _progress,
          title: l.under18Title,
          onBack: _back,
          primaryLabel: l.back,
          onPrimary: _back,
          child: Text(l.under18Body, style: Theme.of(context).textTheme.bodyLarge),
        );

      case _Step.lastPeriod:
        return StepScaffold(
          progress: _progress,
          title: l.lastPeriodTitle,
          subtitle: l.lastPeriodSub,
          onBack: _back,
          primaryLabel: l.continueLabel,
          onPrimary: _lastPeriod == null ? null : () => _go(_Step.periodLength),
          secondary: [
            TextButton(
              onPressed: () {
                setState(() => _lastPeriod = null);
                _go(_Step.periodLength);
              },
              child: Text(l.dontRemember),
            ),
          ],
          child: DateCard(
            first: _today.subtract(const Duration(days: 120)),
            last: _today,
            selected: _lastPeriod,
            onChanged: (d) => setState(() => _lastPeriod = d),
          ),
        );

      case _Step.periodLength:
        return StepScaffold(
          progress: _progress,
          title: l.periodLengthTitle,
          onBack: _back,
          primaryLabel: l.continueLabel,
          onPrimary: () {
            _periodLengthKnown = true;
            _go(_Step.cycleLength);
          },
          secondary: [
            TextButton(
              onPressed: () {
                _periodLengthKnown = false;
                _go(_Step.cycleLength);
              },
              child: Text(l.notSure),
            ),
          ],
          child: NumberStepper(
            value: _periodLength,
            min: 2,
            max: 10,
            label: l.daysValue(_periodLength),
            onChanged: (v) => setState(() => _periodLength = v),
          ),
        );

      case _Step.cycleLength:
        void next() => _goal == Goal.ttc ? _go(_Step.trying) : _finish();
        return StepScaffold(
          progress: _progress,
          title: l.cycleLengthTitle,
          subtitle: l.cycleLengthSub,
          onBack: _back,
          primaryLabel: l.continueLabel,
          onPrimary: () {
            _cycleKnown = true;
            _irregular = false;
            next();
          },
          secondary: [
            TextButton(
              onPressed: () {
                _cycleKnown = false;
                _irregular = true;
                next();
              },
              child: Text(l.irregular),
            ),
            TextButton(
              onPressed: () {
                _cycleKnown = false;
                _irregular = false;
                next();
              },
              child: Text(l.notSure),
            ),
          ],
          child: NumberStepper(
            value: _cycleLength,
            min: 21,
            max: 45,
            label: l.daysValue(_cycleLength),
            onChanged: (v) => setState(() => _cycleLength = v),
          ),
        );

      case _Step.trying:
        Widget option(TryingFor v, String label) => OptionTile(
              icon: Icons.schedule_rounded,
              title: label,
              selected: _trying == v,
              onTap: () {
                setState(() => _trying = v);
                _finish();
              },
            );
        return StepScaffold(
          progress: _progress,
          title: l.tryingTitle,
          onBack: _back,
          secondary: [TextButton(onPressed: _finish, child: Text(l.notSure))],
          child: Column(children: [
            option(TryingFor.justStarted, l.tryingJustStarted),
            option(TryingFor.under6, l.tryingUnder6),
            option(TryingFor.sixTo12, l.trying6to12),
            option(TryingFor.over12, l.tryingOver12),
          ]),
        );

      case _Step.dueMethod:
        Widget method(_DueMethod m, IconData icon, String label) => OptionTile(
              icon: icon,
              title: label,
              selected: _dueMethod == m,
              onTap: () {
                setState(() {
                  _dueMethod = m;
                  _dueInput = null;
                });
                _go(_Step.dueDate);
              },
            );
        return StepScaffold(
          progress: _progress,
          title: l.dueMethodTitle,
          onBack: _back,
          child: Column(children: [
            method(_DueMethod.known, Icons.event_available_outlined, l.dueMethodKnown),
            method(_DueMethod.lmp, Icons.water_drop_outlined, l.dueMethodLmp),
            method(_DueMethod.conception, Icons.favorite_border_rounded, l.dueMethodConception),
            method(_DueMethod.ivf5, Icons.science_outlined, l.dueMethodIvf5),
            method(_DueMethod.ivf3, Icons.science_outlined, l.dueMethodIvf3),
            method(_DueMethod.born, Icons.child_care_outlined, l.dueMethodBorn),
          ]),
        );

      case _Step.dueDate:
        final m = _dueMethod!;
        final title = switch (m) {
          _DueMethod.known => l.dueDateTitle,
          _DueMethod.lmp => l.lastPeriodTitle,
          _DueMethod.conception => l.conceptionTitle,
          _DueMethod.ivf3 || _DueMethod.ivf5 => l.transferTitle,
          _DueMethod.born => l.birthDateTitle,
        };
        final first = m == _DueMethod.known ? _today : _today.subtract(Duration(days: m == _DueMethod.born ? 365 : 300));
        final last = m == _DueMethod.known ? _today.add(const Duration(days: 300)) : _today;
        final edd = _computedEdd;
        final implausible = m != _DueMethod.born && edd != null && !isPlausibleEdd(edd, _todayISO);
        return StepScaffold(
          progress: _progress,
          title: title,
          onBack: _back,
          primaryLabel: l.continueLabel,
          onPrimary: _dueInput == null || implausible ? null : _finish,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DateCard(
                first: first,
                last: last,
                selected: _dueInput,
                onChanged: (d) => setState(() => _dueInput = d),
              ),
              if (implausible) ...[
                const SizedBox(height: 12),
                Text(l.implausibleDue, style: TextStyle(color: p.dangerText)),
              ],
            ],
          ),
        );

      case _Step.menoLast:
        return StepScaffold(
          progress: _progress,
          title: l.menoLastTitle,
          onBack: _back,
          primaryLabel: l.continueLabel,
          onPrimary: _menoLast == null ? null : _finish,
          secondary: [
            TextButton(
              onPressed: () {
                _menoLast = null;
                _menoOverYear = true;
                _finish();
              },
              child: Text(l.menoOverYear),
            ),
            TextButton(
              onPressed: () {
                _menoLast = null;
                _menoOverYear = false;
                _finish();
              },
              child: Text(l.notSure),
            ),
          ],
          child: DateCard(
            first: _today.subtract(const Duration(days: 400)),
            last: _today,
            selected: _menoLast,
            onChanged: (d) => setState(() => _menoLast = d),
          ),
        );
    }
  }
}

class _YearWheel extends StatelessWidget {
  const _YearWheel({required this.years, required this.initialIndex, required this.onChanged});
  final List<int> years;
  final int initialIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.border),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 52,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: p.primarySoft, borderRadius: BorderRadius.circular(16)),
          ),
          ListWheelScrollView.useDelegate(
            controller: FixedExtentScrollController(initialItem: initialIndex),
            itemExtent: 52,
            diameterRatio: 1.6,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) => onChanged(years[i]),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: years.length,
              builder: (context, i) => Center(
                child: Text('${years[i]}', style: t.headlineSmall),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.controller, required this.onStart});
  final FemioController controller;
  final VoidCallback onStart;

  static const _names = {'ar': 'العربية', 'en': 'English', 'fr': 'Français', 'es': 'Español'};

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final current = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const AlignmentDirectional(0.6, -0.7).resolve(Directionality.of(context)),
            radius: 1.3,
            colors: [p.aurora1, p.aurora4, p.auroraGround],
            stops: const [0, 0.45, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Center(child: Bloom(size: 112)),
                const SizedBox(height: 20),
                // Always the English wordmark, in every language (product rule 6).
                Text('femio',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: t.displaySmall?.copyWith(color: Colors.white, fontSize: 48)),
                const SizedBox(height: 16),
                Text(l.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: t.headlineSmall?.copyWith(color: Colors.white)),
                const SizedBox(height: 12),
                Text(l.welcomeBody,
                    textAlign: TextAlign.center,
                    style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                const Spacer(),
                Semantics(
                  label: l.language,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final code in supportedLanguages)
                        _LanguagePill(
                          label: _names[code]!,
                          selected: current == code,
                          selectedText: p.auroraGround, // always on white, in both themes
                          onTap: () => controller.setLanguage(code),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: p.primarySolid,
                  ),
                  child: Text(l.getStarted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A language choice on the aurora. Drawn here rather than with `ChoiceChip`, whose
/// Material 3 colours ignored the unselected background and rendered white on white.
class _LanguagePill extends StatelessWidget {
  const _LanguagePill({
    required this.label,
    required this.selected,
    required this.selectedText,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Color selectedText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? Colors.white : Colors.white.withValues(alpha: 0.14),
        shape: StadiumBorder(side: BorderSide(color: Colors.white.withValues(alpha: selected ? 1 : 0.45))),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? selectedText : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
