// The Dart end of the home-screen widget's method channel (R9.11).
//
// Why it exists: the Android widget cannot run Dart, so the app hands it the two finished
// display strings (`domain/home_widget.dart`) and Android stores exactly those and nothing
// else. The widget never reads her sealed record. This is the only Dart file that names the
// channel, the way `assistant_channel.dart` is for the assistant; a plain method channel
// is used instead of a package so no third-party code sits between her record and the
// home screen (the privacy tripwire stays green with no new dependency).
// Failures are swallowed by the caller: a widget that did not update must never cost her
// a saved record.
library;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../domain/dates.dart';
import '../domain/home_widget.dart';
import '../l10n/app_localizations.dart';

/// What the controller needs from the widget. Swappable so tests use a recording fake.
abstract interface class HomeWidgetBridge {
  /// Replaces the strings the widget shows, and redraws it.
  Future<void> update(HomeWidgetContent content);
}

/// Does nothing. The default for tests and for platforms without the widget.
class NoHomeWidgetBridge implements HomeWidgetBridge {
  const NoHomeWidgetBridge();

  @override
  Future<void> update(HomeWidgetContent content) async {}
}

/// Sends the strings to `HomeWidgetChannel.kt` over the `femio/widget` channel.
class MethodChannelHomeWidget implements HomeWidgetBridge {
  const MethodChannelHomeWidget();

  static const _channel = MethodChannel('femio/widget');

  @override
  Future<void> update(HomeWidgetContent content) async {
    try {
      await _channel.invokeMethod<void>('update', {'title': content.title, 'line': content.line});
    } on MissingPluginException {
      // Not Android (or a test without the channel): there is no widget to update.
    }
  }
}

/// The widget's words in [languageCode] (English when the code is unknown), with dates
/// formatted for that language. Western digits in Arabic come from `configureFormatting`.
HomeWidgetTexts homeWidgetTexts(L10n l, String languageCode) {
  String day(String iso) => DateFormat.MMMd(languageCode).format(fromISO(iso));
  return HomeWidgetTexts(
    neutralLine: l.widgetNeutralLine,
    week: l.widgetWeek,
    nextPeriod: l.widgetNextPeriod,
    range: (from, to) => l.rangeValue(day(from), day(to)),
  );
}
