// The week guides keep the shape the "This week" card reads (R8.6, R9.1).
//
// Why it exists: the card picks sections by position, so a guide that gains, loses or
// reorders a section would put the wrong words under a chip. This test reads every bundled
// week guide in all four languages and fails on the first one that breaks the shape.

import 'dart:convert';
import 'dart:io';

import 'package:femio/data/library.dart';
import 'package:femio/data/week_guide.dart';
import 'package:femio/domain/pregnancy_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

List<Article> _articles(String locale) {
  final raw = jsonDecode(File('assets/content/$locale.json').readAsStringSync()) as List;
  return [for (final j in raw) Article.fromJson(Map<String, Object?>.from(j as Map), locale)];
}

void main() {
  for (final locale in ['en', 'ar', 'fr', 'es']) {
    test('every week guide splits into five non-empty sections ($locale)', () {
      final bySlug = {for (final a in _articles(locale)) a.slug: a};
      for (var week = firstGuideWeek; week <= lastGuideWeek; week++) {
        final a = bySlug[weekGuideSlug(week)];
        expect(a, isNotNull, reason: '$locale week $week is missing');
        final g = weekGuideFrom(a!, week);
        expect(g, isNotNull, reason: '$locale week $week lost a section');
        expect(g!.intro, isNotEmpty, reason: '$locale week $week');
        for (final s in WeekSection.values) {
          expect(g.sections[s], isNotEmpty, reason: '$locale week $week $s');
        }
        expect(g.dailyLines, hasLength(6), reason: '$locale week $week');
      }
    });
  }

  test('sections are the guide\'s own words, in the guide\'s order (week 10, English)', () {
    final a = _articles('en').firstWhere((a) => a.slug == 'pregnancy-week-10');
    final g = weekGuideFrom(a, 10)!;
    expect(g.sections[WeekSection.body]!.first, startsWith('Progesterone relaxes the muscles of the womb'));
    expect(g.sections[WeekSection.baby]!.first, startsWith('Around week 10, the figure given is about 30mm'));
    expect(g.sections[WeekSection.tip]!.first, startsWith('Buy or borrow one pair of trousers'));
    expect(g.intro, startsWith('Week 10 is the week trousers stop doing up'));
  });

  test('the daily line changes each day and starts again each week', () {
    final a = _articles('en').firstWhere((a) => a.slug == 'pregnancy-week-10');
    final g = weekGuideFrom(a, 10)!;
    // 10w0d is day 70: the intro's first sentence; 10w1d moves to the next section.
    expect(g.dailyLine(70), 'Week 10 is the week trousers stop doing up, usually before anything looks different to anyone else.');
    expect(g.dailyLine(71), isNot(g.dailyLine(70)));
    expect(g.dailyLine(77), g.dailyLine(70), reason: 'day 0 of the next week starts from the first line');
  });

  test('first sentence handles the Arabic question mark and a lone sentence', () {
    expect(firstSentence('هل هذا طبيعي؟ نعم، غالبًا.'), 'هل هذا طبيعي؟');
    expect(firstSentence('One sentence only'), 'One sentence only');
    expect(firstSentence('About 30mm. Then more.'), 'About 30mm.');
  });
}
