import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/profile.dart';
import 'data/store.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/today/today_screen.dart';
import 'l10n/app_localizations.dart';
import 'theme/femio_theme.dart';

const supportedLanguages = ['ar', 'en', 'fr', 'es'];

/// Holds her record and the chosen language. One object, listened to by the app,
/// because v1 has two screens' worth of state and a state library would be weight.
class FemioController extends ChangeNotifier {
  FemioController(this.store, {String? initialLocale}) : _locale = initialLocale;

  final FemioStore store;
  Profile? profile;
  bool loaded = false;
  String? _locale;

  /// The language she picked, else the phone's if Femio speaks it, else English.
  Locale locale(Locale? device) {
    final code = profile?.locale ?? _locale ?? device?.languageCode;
    return Locale(supportedLanguages.contains(code) ? code! : 'en');
  }

  Future<void> load() async {
    profile = await store.load();
    loaded = true;
    notifyListeners();
  }

  void setLanguage(String code) {
    _locale = code;
    if (profile != null) profile = profile!.copyWith(locale: code);
    notifyListeners();
  }

  Future<void> save(Profile p) async {
    profile = p;
    await store.save(p);
    notifyListeners();
  }

  Future<void> reset() async {
    await store.clear();
    profile = null;
    notifyListeners();
  }
}

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
                  : TodayScreen(controller: controller, today: today),
        );
      },
    );
  }
}
