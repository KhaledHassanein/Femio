// The two AdMob banner unit ids the app asks for, read at build time.
//
// Why it exists: real ids belong to the owner's AdMob account and must never sit in
// code or git. They live in `apps/mobile/ads.env` (git-ignored; `ads.env.example` shows
// the shape) and reach Dart through `--dart-define-from-file=ads.env` when a release is
// built. The defaults below are Google's published TEST ids, so a plain `flutter run`
// shows test ads and nothing can bill or flag the account by accident.

/// Google's published test banner unit (it serves test creatives only).
const String _googleTestBanner = 'ca-app-pub-3940256099942544/9214589741';

/// Banner under a single guide. Real id: `FEMIO_ADMOB_BANNER_ARTICLE` in `ads.env`.
const String bannerAdUnitArticle = String.fromEnvironment('FEMIO_ADMOB_BANNER_ARTICLE', defaultValue: _googleTestBanner);

/// Banner under the guide list. Real id: `FEMIO_ADMOB_BANNER_LEARN` in `ads.env`.
const String bannerAdUnitLearn = String.fromEnvironment('FEMIO_ADMOB_BANNER_LEARN', defaultValue: _googleTestBanner);
