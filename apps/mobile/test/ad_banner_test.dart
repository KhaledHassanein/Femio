// The banner widget: nothing without a real runtime, nothing with femio Plus, nothing
// on a surface the policy forbids, a labelled box only once an ad has loaded, and the
// SDK is touched only when an ad is actually allowed (lazy start).

import 'package:femio/app.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/ads_policy.dart';
import 'package:femio/features/ads/ad_banner.dart';
import 'package:femio/features/ads/ads_runtime.dart';
import 'package:femio/features/ads/ads_scope.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _bannerKey = Key('fake-banner');
const _bannerHeight = 50.0;

class _FakeBanner implements LoadedBanner {
  _FakeBanner(this.onDispose);
  final void Function() onDispose;

  @override
  double get height => _bannerHeight;

  @override
  Widget build(BuildContext context) => const SizedBox(key: _bannerKey, width: double.infinity, height: _bannerHeight);

  @override
  void dispose() => onDispose();
}

/// An ads runtime that "loads" instantly and counts what the widget asked of it.
class _FakeAdsRuntime extends AdsRuntime {
  int initialized = 0;
  int loads = 0;
  int disposed = 0;
  String? lastUnit;

  @override
  bool get showsAds => true;

  @override
  Future<void> initialize() async => initialized++;

  @override
  Future<LoadedBanner?> loadBanner({required String adUnitId, required int width}) async {
    loads++;
    lastUnit = adUnitId;
    return _FakeBanner(() => disposed++);
  }
}

Future<void> _pump(
  WidgetTester tester, {
  required AdsRuntime runtime,
  required FemioController controller,
  AdSurface surface = AdSurface.article,
  String locale = 'en',
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: FemioTheme.light(),
      locale: Locale(locale),
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: AdsScope(
        controller: controller,
        runtime: runtime,
        child: Scaffold(
          body: const SizedBox.expand(),
          bottomNavigationBar: AdBanner(surface: surface, adUnitId: 'unit-test'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late FemioController controller;
  setUp(() => controller = FemioController(MemoryStore()));

  testWidgets('with the do-nothing runtime an article shows no ad and takes no space', (tester) async {
    await _pump(tester, runtime: const NoAdsRuntime(), controller: controller);
    expect(find.text('Advertisement'), findsNothing);
    expect(find.byKey(_bannerKey), findsNothing);
    expect(tester.getSize(find.byType(AdBanner)).height, 0);
  });

  testWidgets('a loaded ad is labelled in English and reserves its height only then', (tester) async {
    final runtime = _FakeAdsRuntime();
    await _pump(tester, runtime: runtime, controller: controller);
    expect(find.text('Advertisement'), findsOneWidget);
    expect(find.byKey(_bannerKey), findsOneWidget);
    expect(tester.getSize(find.byKey(_bannerKey)).height, _bannerHeight);
    expect(runtime.initialized, 1);
    expect(runtime.loads, 1);
    expect(runtime.lastUnit, 'unit-test');
  });

  testWidgets('the label reads in Arabic', (tester) async {
    await _pump(tester, runtime: _FakeAdsRuntime(), controller: controller, locale: 'ar');
    expect(find.text('إعلان'), findsOneWidget);
    expect(find.byKey(_bannerKey), findsOneWidget);
  });

  testWidgets('with femio Plus active nothing renders and the runtime is never touched', (tester) async {
    controller.plusActive = true;
    final runtime = _FakeAdsRuntime();
    await _pump(tester, runtime: runtime, controller: controller);
    expect(find.text('Advertisement'), findsNothing);
    expect(find.byKey(_bannerKey), findsNothing);
    expect(runtime.initialized, 0);
    expect(runtime.loads, 0);
  });

  testWidgets('a surface the policy forbids never starts the SDK', (tester) async {
    final runtime = _FakeAdsRuntime();
    for (final surface in AdSurface.values.where((s) => s != AdSurface.article && s != AdSurface.learnIndex)) {
      await _pump(tester, runtime: runtime, controller: controller, surface: surface);
      expect(find.byKey(_bannerKey), findsNothing, reason: surface.name);
    }
    expect(runtime.initialized, 0, reason: 'lazy start: only an allowed surface may initialise the SDK');
    expect(runtime.loads, 0);
  });

  testWidgets('activating Plus removes a showing ad and frees it', (tester) async {
    final runtime = _FakeAdsRuntime();
    await _pump(tester, runtime: runtime, controller: controller);
    expect(find.byKey(_bannerKey), findsOneWidget);
    controller.plusActive = true;
    controller.notifyListeners();
    await tester.pumpAndSettle();
    expect(find.byKey(_bannerKey), findsNothing);
    expect(runtime.disposed, 1);
  });

  testWidgets('leaving the screen disposes the ad', (tester) async {
    final runtime = _FakeAdsRuntime();
    await _pump(tester, runtime: runtime, controller: controller);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(runtime.disposed, 1);
  });
}
