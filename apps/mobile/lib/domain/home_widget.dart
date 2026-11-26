// What the Android home-screen widget says (R9.11): a pure function from her record to
// two display strings.
//
// Why it exists: a widget sits on the home screen, where anyone holding her phone can read
// it, so it is neutral by default (the wordmark and "Open femio", no health word at all)
// and shows more only after she turns that on in Settings. The words are decided here, in
// Dart, so they are unit-tested and follow the same prediction rules as the app (rule 3:
// a range, never a single date, nothing for irregular cycles). Only the finished strings
// cross to Android; the widget never reads the sealed record and holds nothing else.
// This file has no UI and no platform code: language and date formatting come in as
// [HomeWidgetTexts].
library;

import '../data/profile.dart';
import 'cycle_prediction.dart';
import 'pregnancy.dart';
import 'upcoming_periods.dart';

/// The wordmark: always the Latin "femio", also on an Arabic phone (rule 6).
const homeWidgetWordmark = 'femio';

/// The two lines the widget shows: the wordmark above and one line below it.
class HomeWidgetContent {
  const HomeWidgetContent({required this.title, required this.line});

  /// Always [homeWidgetWordmark].
  final String title;

  /// The neutral prompt, or, with her consent, the pregnancy week or the next-period range.
  final String line;

  @override
  bool operator ==(Object other) => other is HomeWidgetContent && other.title == title && other.line == line;

  @override
  int get hashCode => Object.hash(title, line);

  @override
  String toString() => 'HomeWidgetContent($title, $line)';
}

/// The words the widget can use, already in her language, so this file stays free of UI.
class HomeWidgetTexts {
  const HomeWidgetTexts({
    required this.neutralLine,
    required this.week,
    required this.nextPeriod,
    required this.range,
  });

  /// The neutral line, for example "Open femio".
  final String neutralLine;

  /// "Week 12" from a whole week count.
  final String Function(int weeks) week;

  /// "Next period Nov 16 – Nov 20" from a formatted range.
  final String Function(String range) nextPeriod;

  /// Formats two ISO days as one range in her language.
  final String Function(String fromIso, String toIso) range;
}

/// The widget's content for [profile] on the ISO day [today].
///
/// Neutral ([HomeWidgetTexts.neutralLine]) unless [showDetails] (her switch in Settings) is
/// on and there is something honest to say:
/// - pregnant with a due date, within the pregnancy range: "Week N";
/// - period or trying-to-conceive with a regular prediction: the next period as a range,
///   taken from `upcomingPeriods(...).first`, never the single predicted day;
/// - everything else (no data yet, irregular cycles, postpartum, menopause): neutral,
///   because the widget must never name a single date or a verdict (rule 3).
///
/// Returns the neutral content when [profile] is null. Never throws.
HomeWidgetContent homeWidgetContent(
  Profile? profile,
  String today,
  HomeWidgetTexts texts, {
  required bool showDetails,
}) {
  final neutral = HomeWidgetContent(title: homeWidgetWordmark, line: texts.neutralLine);
  if (profile == null || !showDetails) return neutral;

  switch (profile.goal) {
    case Goal.pregnant:
      if (profile.birthDate != null || profile.edd == null) return neutral;
      final progress = pregnancyProgress(profile.edd!, today);
      if (progress == null) return neutral;
      return HomeWidgetContent(title: homeWidgetWordmark, line: texts.week(progress.weeks));
    case Goal.period:
    case Goal.ttc:
      final prediction = predictNextPeriod(profile.periodStarts, profile.cycleLength);
      if (prediction == null || prediction.irregular || profile.irregular) return neutral;
      final next = upcomingPeriods(prediction).first;
      return HomeWidgetContent(
        title: homeWidgetWordmark,
        line: texts.nextPeriod(texts.range(next.windowStart, next.windowEnd)),
      );
    case Goal.menopause:
      return neutral;
  }
}
