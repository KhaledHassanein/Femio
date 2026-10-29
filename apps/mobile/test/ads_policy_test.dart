// The ads policy: banners on the two guide surfaces only, never with femio Plus.
// Every surface is listed so a new one cannot slip in unclassified.

import 'package:femio/domain/ads_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const allowedFree = {AdSurface.article, AdSurface.learnIndex};

  group('adsAllowed without femio Plus', () {
    for (final surface in AdSurface.values) {
      final expected = allowedFree.contains(surface);
      test('${surface.name}: ${expected ? 'allowed' : 'never'}', () {
        expect(adsAllowed(surface: surface, plusActive: false), expected);
      });
    }
  });

  group('adsAllowed with femio Plus', () {
    for (final surface in AdSurface.values) {
      test('${surface.name}: never', () {
        expect(adsAllowed(surface: surface, plusActive: true), isFalse);
      });
    }
  });

  test('the enum has exactly the ten surfaces the policy names', () {
    expect(AdSurface.values.length, 10);
  });
}
