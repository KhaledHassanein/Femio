// The mic on Ask femio and Say it (ADR-086): words land in the field after what she typed,
// a failure takes back the running guess and says why, and a microphone refused for good
// offers "Open settings".

import 'package:femio/data/speech_channel.dart';
import 'package:femio/features/assistant/mic_button.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Speech implements SpeechPort {
  _Speech(this.outcome, {this.partials = const []});
  final SpeechOutcome outcome;
  final List<String> partials;
  String? locale;
  int settingsOpened = 0;

  @override
  Future<SpeechOutcome> listen(String locale, void Function(String partial) onPartial) async {
    this.locale = locale;
    for (final p in partials) {
      onPartial(p);
    }
    return outcome;
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> openAppSettings() async => settingsOpened++;

  String? packAsked;

  @override
  Future<bool> downloadPack(String locale) async {
    packAsked = locale;
    return true;
  }
}

Future<TextEditingController> _pump(WidgetTester tester, SpeechPort port, {String typed = '', Locale locale = const Locale('en')}) async {
  final controller = TextEditingController(text: typed);
  await tester.pumpWidget(MaterialApp(
    theme: FemioTheme.light(),
    locale: locale,
    localizationsDelegates: L10n.localizationsDelegates,
    supportedLocales: L10n.supportedLocales,
    home: Scaffold(body: TextField(controller: controller, decoration: InputDecoration(suffixIcon: MicButton(controller: controller, port: port)))),
  ));
  await tester.pumpAndSettle();
  return controller;
}

void main() {
  test('reason codes from Kotlin map to problems; unknown codes are "other"', () {
    expect(speechProblemFrom('no_permission_settings'), SpeechProblem.noPermissionSettings);
    expect(speechProblemFrom('language'), SpeechProblem.language);
    expect(speechProblemFrom('old_android'), SpeechProblem.oldAndroid);
    expect(speechProblemFrom('whatever'), SpeechProblem.other);
  });

  testWidgets('her words go after what she typed, in her language', (tester) async {
    final port = _Speech(const SpeechOutcome.words('since this morning'), partials: ['since']);
    final c = await _pump(tester, port, typed: 'cramps', locale: const Locale('ar'));
    await tester.tap(find.byType(MicButton));
    await tester.pumpAndSettle();
    expect(c.text, 'cramps since this morning');
    expect(port.locale, 'ar');
  });

  testWidgets('no on-device recognizer: the guess is taken back and she is told why', (tester) async {
    final port = _Speech(const SpeechOutcome.failed(SpeechProblem.notAvailable), partials: ['half']);
    final c = await _pump(tester, port, typed: 'cramps');
    final l = await L10n.delegate.load(const Locale('en'));
    await tester.tap(find.byType(MicButton));
    await tester.pumpAndSettle();
    expect(c.text, 'cramps');
    expect(find.text(l.micNotAvailable), findsOneWidget);
    expect(find.text(l.notifOpenSettings), findsNothing);
  });

  testWidgets('microphone refused for good: one tap opens femio in the phone settings', (tester) async {
    final port = _Speech(const SpeechOutcome.failed(SpeechProblem.noPermissionSettings));
    await _pump(tester, port);
    final l = await L10n.delegate.load(const Locale('en'));
    await tester.tap(find.byType(MicButton));
    await tester.pumpAndSettle();
    expect(find.text(l.micNoPermissionSettings), findsOneWidget);
    await tester.tap(find.text(l.notifOpenSettings));
    expect(port.settingsOpened, 1);
  });

  testWidgets('no offline pack for her language: one tap asks Android to download it', (tester) async {
    final port = _Speech(const SpeechOutcome.failed(SpeechProblem.language));
    await _pump(tester, port, locale: const Locale('fr'));
    final l = await L10n.delegate.load(const Locale('fr'));
    await tester.tap(find.byType(MicButton));
    await tester.pumpAndSettle();
    expect(find.text(l.micLanguage), findsOneWidget);
    await tester.tap(find.text(l.micDownloadPack));
    await tester.pumpAndSettle();
    expect(port.packAsked, 'fr');
    expect(find.text(l.micDownloadStarted), findsOneWidget);
  });
}
