// The app root: the one shared controller (her record and language) and the MaterialApp.
//
// Why it exists: v1 has few enough screens that one ChangeNotifier is simpler than a state
// library. This file decides only which of the two worlds she sees, onboarding or the
// home shell, and wires in the theme, languages and localisation delegates.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/profile.dart';
import 'data/store.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/home/home_shell.dart';
import 'l10n/app_localizations.dart';
import 'theme/femio_theme.dart';

/// The languages Femio speaks, as ISO 639-1 codes. Arabic is first-class, not a
/// translation afterthought (product rule 6).
const supportedLanguages = ['ar', 'en', 'fr', 'es'];

/// Holds her record and the chosen language. One object, listened to by the app,
/// because v1 has two screens' worth of state and a state library would be weight.
class FemioController extends ChangeNotifier {
  /// [store] is where her record lives; [initialLocale] is the language to start in
  /// before she has chosen one (used by tests).
  FemioController(this.store, {String? initialLocale}) : _locale = initialLocale;

  /// Where her record is saved. Swappable, so tests use memory and the app uses a file.
  final FemioStore store;

  /// Her record, or null before she finishes onboarding (or after she starts over).
  Profile? profile;

  /// False until [load] has finished, so the app can wait instead of flashing onboarding.
  bool loaded = false;
  String? _locale;

  /// The language she picked, else the phone's if Femio speaks it, else English.
  Locale locale(Locale? device) {
    final code = profile?.locale ?? _locale ?? device?.languageCode;
    return Locale(supportedLanguages.contains(code) ? code! : 'en');
  }

  /// Reads her saved record, if any, and tells listeners. Failures are the store's:
  /// a missing record is simply a null [profile].
  Future<void> load() async {
    profile = await store.load();
    loaded = true;
    notifyListeners();
  }

  /// Switches the app to [code] at once. Only codes in [supportedLanguages] take
  /// effect; it is saved with the profile the next time the profile is saved.
  void setLanguage(String code) {
    _locale = code;
    if (profile != null) profile = profile!.copyWith(locale: code);
    notifyListeners();
  }

  /// Replaces her record with [p], saves it to the [store] and tells listeners.
  Future<void> save(Profile p) async {
    profile = p;
    await store.save(p);
    notifyListeners();
  }

  /// Writes one day's log (flow and terms) and saves. [date] is an ISO day. Requires
  /// a loaded [profile].
  Future<void> setDayLog(String date, DayLog log) => save(profile!.withDayLog(date, log));

  /// Deletes her record from the phone and returns to onboarding ("start over").
  Future<void> reset() async {
    await store.clear();
    profile = null;
    notifyListeners();
  }
}

/// The whole app: theme, languages and the choice between onboarding and the home
/// shell. [controller] is the shared state; [today] fixes the date in tests.
class FemioApp extends StatelessWidget {
  const FemioApp({super.key, required this.controller, this.today});
  final FemioController controller;

  /// Fixed "today" for screenshot tests; the real app reads the clock.
  final String? today;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final device = WidgetsBinding.instance.platformDispatcher.locale;
        return MaterialApp(
          title: 'femio',
          debugShowCheckedModeBanner: false,
          theme: FemioTheme.light(),
          darkTheme: FemioTheme.dark(),
          locale: controller.locale(device),
          supportedLocales: [for (final c in supportedLanguages) Locale(c)],
          localizationsDelegates: const [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: !controller.loaded
              ? const SizedBox.shrink()
              : controller.profile == null
                  ? OnboardingFlow(controller: controller, today: today)
                  : HomeShell(controller: controller, today: today),
        );
      },
    );
  }
}
