// Tests for the delete confirmation (owner 2026-11-27): deleting her record needs a ticked
// statement that it is erased for good and femio keeps no copy; Cancel keeps everything.

import 'package:femio/app.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/settings/delete_dialog.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Future<FemioController> _controller() async {
  final c = FemioController(MemoryStore(const Profile(goal: Goal.ttc, locale: 'en', periodStarts: ['2026-11-01'])));
  await c.load();
  return c;
}

Widget _app(FemioController c, String locale) => MaterialApp(
      theme: FemioTheme.light(),
      locale: Locale(locale),
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('fr'), Locale('es')],
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(onPressed: () => confirmDeleteEverything(context, c), child: const Text('open')),
          ),
        ),
      ),
    );

void main() {
  testWidgets('Delete stays disabled until she ticks that it cannot be undone', (tester) async {
    final c = await _controller();
    await tester.pumpWidget(_app(c, 'en'));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    final delete = find.widgetWithText(FilledButton, 'Delete everything');
    expect(tester.widget<FilledButton>(delete).onPressed, isNull);
    expect(find.textContaining('femio keeps no copy anywhere'), findsOneWidget);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(delete).onPressed, isNotNull);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    expect(c.profile?.periodStarts ?? const <String>[], isEmpty, reason: 'her record is gone');
  });

  testWidgets('Cancel keeps her record, even after ticking', (tester) async {
    final c = await _controller();
    await tester.pumpWidget(_app(c, 'ar'));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();
    expect(c.profile!.periodStarts, ['2026-11-01']);
  });
}
