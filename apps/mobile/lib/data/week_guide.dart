// A pregnancy week guide split into its sections, for the "This week" card (R8.6, R9.1).
//
// Why it exists: the card must show the reviewed guide's own words, never new medical text
// (rule 1). All 148 week guides (weeks 4 to 40, four languages) put the same five sections
// first, in the same order, under their second-level headings: your body, what you may
// notice, your baby, care around now, this week's tip. Headings are worded differently per
// language, so sections are read by position; `test/week_guide_test.dart` checks every
// bundled guide still has that shape.

import 'library.dart';

/// The five sections the card shows, in the order the guides write them.
enum WeekSection { body, notice, baby, care, tip }

/// One week's guide, as plain paragraphs.
class WeekGuide {
  const WeekGuide({required this.week, required this.article, required this.intro, required this.sections});

  /// Completed weeks the guide is titled with (4 to 40).
  final int week;
  final Article article;

  /// The opening paragraph, before the first section.
  final String intro;
  final Map<WeekSection, List<String>> sections;

  /// R9.1: the lines one day at a time draws from, the first sentence of the intro and of each
  /// section. Verbatim; nothing is reworded.
  List<String> get dailyLines => [
        if (intro.isNotEmpty) firstSentence(intro),
        for (final s in WeekSection.values)
          if ((sections[s] ?? const []).isNotEmpty) firstSentence(sections[s]!.first),
      ];

  /// The line for a day [totalDays] into the pregnancy. The day within the week changes on her
  /// last-period weekday, the same turnover as the week itself (pregnancy_calendar.dart), so
  /// the line changes daily and starts again from the first each new week.
  String? dailyLine(int totalDays) {
    final lines = dailyLines;
    if (lines.isEmpty) return null;
    return lines[(totalDays % 7) % lines.length];
  }
}

/// The guide's slug for [week].
String weekGuideSlug(int week) => 'pregnancy-week-$week';

/// Splits [article] into sections. Returns null when it lacks the five sections, so the card
/// falls back to a plain link rather than showing the wrong section under a heading.
WeekGuide? weekGuideFrom(Article article, int week) {
  final root = (article.body['root'] as Map?)?['children'] as List? ?? const [];
  var intro = '';
  final parts = <List<String>>[];
  for (final node in root.whereType<Map>()) {
    final type = node['type'];
    if (type == 'heading' && node['tag'] == 'h2') {
      parts.add(<String>[]);
      continue;
    }
    if (type != 'paragraph' && type != 'list' && type != 'quote') continue;
    final text = plainText(node).trim();
    if (text.isEmpty) continue;
    if (parts.isEmpty) {
      if (intro.isEmpty) intro = text;
    } else {
      parts.last.add(text);
    }
  }
  if (parts.length < WeekSection.values.length) return null;
  return WeekGuide(
    week: week,
    article: article,
    intro: intro,
    sections: {for (final s in WeekSection.values) s: parts[s.index]},
  );
}

/// The text of a Lexical node and its children; list items become separate lines.
String plainText(Map node) {
  if (node['type'] == 'text') return (node['text'] as String?) ?? '';
  final kids = (node['children'] as List?)?.whereType<Map>() ?? const <Map>[];
  final sep = node['type'] == 'list' ? '\n' : '';
  return kids.map(plainText).join(sep);
}

/// The first sentence of [paragraph], or all of it when it has one. Ends at the first full
/// stop, question or exclamation mark (including the Arabic question mark) followed by a space.
String firstSentence(String paragraph) {
  final m = RegExp(r'^(.+?[.!?؟])(\s|$)', dotAll: true).firstMatch(paragraph);
  return (m?.group(1) ?? paragraph).trim();
}

/// Loads [week]'s guide in [locale] (English when it has no translation). Null when the guide
/// is missing or not in the expected shape.
Future<WeekGuide?> loadWeekGuide(Library library, String locale, int week) async {
  final slug = weekGuideSlug(week);
  for (final a in await library.articles(locale)) {
    if (a.slug == slug) return weekGuideFrom(a, week);
  }
  return null;
}
