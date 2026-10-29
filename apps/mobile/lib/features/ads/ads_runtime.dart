// The only file that talks to Google's ads SDK: consent, start-up and banner loading.
//
// Why it exists: ADR-076 allows ads on the guide screens, on one hard condition: the SDK
// never receives anything about her. Keeping every SDK call here (and nowhere else) makes
// that auditable in one read. Every request is non-personalised and carries no keywords,
// no content URL, no extras and no mediation; the content rating is capped at PG; and
// the SDK is started lazily, on the first screen where an ad is allowed, after Google's
// consent form (UMP) has had its say. Widgets depend on the abstract [AdsRuntime], so
// tests run with [NoAdsRuntime] or a fake and never load the SDK.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// A banner that has finished loading and is ready to be drawn.
abstract class LoadedBanner {
  /// The height to reserve for it, in logical pixels.
  double get height;

  /// The widget that draws the ad.
  Widget build(BuildContext context);

  /// Frees the ad. Call exactly once, when it is no longer on screen.
  void dispose();
}

/// What the banner widget needs from an ads implementation.
abstract class AdsRuntime {
  const AdsRuntime();

  /// False for the do-nothing runtime, so the widget can skip all work.
  bool get showsAds;

  /// Runs the consent flow and starts the SDK. Idempotent and never throws; after it
  /// returns, [loadBanner] returns null if consent did not allow ads.
  Future<void> initialize();

  /// Loads one anchored adaptive banner of [width] logical pixels for [adUnitId].
  /// Returns null when no ad is available (no consent, no fill, offline, any failure).
  Future<LoadedBanner?> loadBanner({required String adUnitId, required int width});
}

/// Shows nothing and loads nothing: used in tests and on every platform but Android.
class NoAdsRuntime extends AdsRuntime {
  const NoAdsRuntime();

  @override
  bool get showsAds => false;

  @override
  Future<void> initialize() async {}

  @override
  Future<LoadedBanner?> loadBanner({required String adUnitId, required int width}) async => null;
}

/// The runtime the app starts with: Google's on Android, none anywhere else (iOS has no
/// ads configuration yet, and the desktop/test hosts have no SDK).
AdsRuntime platformAdsRuntime() {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return const NoAdsRuntime();
  if (!Platform.isAndroid) return const NoAdsRuntime();
  return GoogleAdsRuntime();
}

/// The content rating ceiling sent with every request: PG keeps adult material out of a
/// women's-health app.
final String _maxContentRating = MaxAdContentRating.pg;

/// Google AdMob behind the [AdsRuntime] interface.
class GoogleAdsRuntime extends AdsRuntime {
  GoogleAdsRuntime();

  Future<bool>? _ready;

  @override
  bool get showsAds => true;

  @override
  Future<void> initialize() => _ready ??= _start();

  /// Consent first (Google's UMP form, shown only where the law requires it), then the
  /// SDK, and only if consent allows ad requests. Returns whether ads may be requested.
  Future<bool> _start() async {
    try {
      final done = Completer<void>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          await ConsentForm.loadAndShowConsentFormIfRequired((FormError? _) {});
          if (!done.isCompleted) done.complete();
        },
        (FormError _) {
          if (!done.isCompleted) done.complete();
        },
      );
      await done.future;
      if (!await ConsentInformation.instance.canRequestAds()) return false;
      await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(maxAdContentRating: _maxContentRating));
      await MobileAds.instance.initialize();
      return true;
    } catch (error) {
      debugPrint('Ads could not start: $error');
      return false;
    }
  }

  @override
  Future<LoadedBanner?> loadBanner({required String adUnitId, required int width}) async {
    if (!await (_ready ??= _start())) return null;
    try {
      final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
      if (size == null) return null;
      final done = Completer<_GoogleBanner?>();
      late final BannerAd ad;
      ad = BannerAd(
        adUnitId: adUnitId,
        size: size,
        // Non-personalised, and nothing else: no keywords, content URL, extras or mediation.
        request: const AdRequest(nonPersonalizedAds: true),
        listener: BannerAdListener(
          onAdLoaded: (_) => done.complete(_GoogleBanner(ad, size.height.toDouble())),
          onAdFailedToLoad: (failed, error) {
            failed.dispose();
            done.complete(null);
          },
        ),
      );
      await ad.load();
      return await done.future;
    } catch (error) {
      debugPrint('Ad could not load: $error');
      return null;
    }
  }
}

class _GoogleBanner implements LoadedBanner {
  _GoogleBanner(this._ad, this.height);
  final BannerAd _ad;

  @override
  final double height;

  @override
  Widget build(BuildContext context) => AdWidget(ad: _ad);

  @override
  void dispose() => _ad.dispose();
}
