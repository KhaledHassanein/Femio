// The app once she is set up: the bottom navigation and the three tabs.
//
// Why it exists: it owns which tab is open and which day the Log tab shows, so tapping a
// calendar day can jump straight to that day's log without the tabs knowing each other.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../domain/dates.dart';
import '../../domain/store_prompts.dart';
import '../../l10n/app_localizations.dart';
import '../../data/library.dart';
import '../calendar/calendar_screen.dart';
import '../learn/learn_screen.dart';
import '../log/log_screen.dart';
import '../today/today_screen.dart';
import '../assistant/assistant_pill.dart';
import 'update_card.dart';

/// The app once she is set up: Today, Calendar, Log and Learn (spec §4). Tools joins
/// as its screen lands; nothing is a dead tab.
///
/// [controller] must be loaded with a profile. [today] fixes the date in tests.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller, this.today});
  final FemioController controller;
  final String? today;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  final _library = Library();

  /// Learn is built the first time she opens it: its guides load from assets, and
  /// nothing should be parsed (or spin) behind the Today tab.
  bool _learnOpened = false;
  late String _logDate = widget.today ?? todayISO();

  /// What Google Play said about a newer femio at this app start (R12.3).
  UpdatePrompt _update = UpdatePrompt.none;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  /// Asks Play once per app start. A high-priority release opens Play's full-screen update
  /// at once; any other shows the quiet card.
  Future<void> _checkForUpdate() async {
    final store = widget.controller.playStore;
    final mode = await store.checkUpdate();
    if (!mounted || mode == UpdatePrompt.none) return;
    if (mode == UpdatePrompt.immediate && await store.startUpdate(mode)) return;
    if (mounted) setState(() => _update = UpdatePrompt.banner);
  }

  Future<void> _startUpdate() async {
    setState(() => _update = UpdatePrompt.none);
    await widget.controller.playStore.startUpdate(UpdatePrompt.banner);
  }

  void _openLog(String date) => setState(() {
        _logDate = date;
        _tab = 2;
      });

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final today = widget.today ?? todayISO();
    return Scaffold(
      body: Column(children: [
        if (_update == UpdatePrompt.banner)
          SafeArea(
            bottom: false,
            child: UpdateCard(onUpdate: _startUpdate, onDismiss: () => setState(() => _update = UpdatePrompt.none)),
          ),
        // The card already sits below the status bar, so the tabs must not pad for it again.
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: _update == UpdatePrompt.banner,
            child: _tabs(today),
          ),
        ),
      ]),
      // R8.3: the assistant's door on every tab, unless her master switch is off.
      floatingActionButton: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) => (widget.controller.profile?.settings.assistantOn ?? true)
            ? AssistantPill(controller: widget.controller, library: _library, today: today)
            : const SizedBox.shrink(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() {
          _tab = i;
          if (i == 3) _learnOpened = true;
          if (i == 2 && _logDate.compareTo(today) > 0) _logDate = today;
        }),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.wb_sunny_outlined), selectedIcon: const Icon(Icons.wb_sunny_rounded), label: l.navToday),
          NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), selectedIcon: const Icon(Icons.calendar_month_rounded), label: l.navCalendar),
          NavigationDestination(icon: const Icon(Icons.edit_note_outlined), selectedIcon: const Icon(Icons.edit_note_rounded), label: l.navLog),
          NavigationDestination(icon: const Icon(Icons.menu_book_outlined), selectedIcon: const Icon(Icons.menu_book_rounded), label: l.navLearn),
        ],
      ),
    );
  }

  /// The four tabs, kept alive behind the navigation bar.
  Widget _tabs(String today) => IndexedStack(
        index: _tab,
        children: [
          TodayScreen(controller: widget.controller, today: today, onLog: () => _openLog(today), library: _library),
          CalendarScreen(controller: widget.controller, today: today, onDay: _openLog),
          LogScreen(
            controller: widget.controller,
            today: today,
            date: _logDate,
            onDateChanged: (d) => setState(() => _logDate = d),
          ),
          if (_learnOpened) LearnScreen(library: _library, controller: widget.controller) else const SizedBox.shrink(),
        ],
      );
}
