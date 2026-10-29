// The one widget that puts an advertisement on a screen.
//
// Why it exists: every placement goes through the same three gates (ads_policy says the
// surface may carry one, femio Plus is off, a real ads runtime is in use) so a screen
// cannot show an ad by accident. While nothing is loaded it occupies no space, so there
// is never an empty box where an ad "might" go; it is labelled, so it is never mistaken
// for guide content; and a failed load simply leaves nothing behind.

import 'package:flutter/material.dart';

import '../../domain/ads_policy.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import 'ads_runtime.dart';
import 'ads_scope.dart';

/// An anchored banner for [surface], using [adUnitId]. Place it as a Scaffold's
/// `bottomNavigationBar`. [runtime] overrides the app's runtime (tests); otherwise the
/// one from [AdsScope] is used.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key, required this.surface, required this.adUnitId, this.runtime});

  /// Which screen family this banner sits on; decides, with Plus, whether it may show.
  final AdSurface surface;

  /// The AdMob banner unit (see ad_unit_ids.dart).
  final String adUnitId;

  /// Test override for the ads runtime.
  final AdsRuntime? runtime;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  LoadedBanner? _banner;
  int? _requestedWidth;

  /// Bumped whenever a pending load stops mattering (new load, banner removed, disposed).
  int _generation = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final runtime = widget.runtime ?? AdsScope.runtimeOf(context);
    final allowed = runtime.showsAds && adsAllowed(surface: widget.surface, plusActive: AdsScope.plusActiveOf(context));
    if (!allowed) {
      _discard();
      return;
    }
    final width = MediaQuery.sizeOf(context).width.truncate();
    if (width == _requestedWidth) return;
    _requestedWidth = width;
    _load(runtime, width);
  }

  Future<void> _load(AdsRuntime runtime, int width) async {
    final mine = ++_generation;
    _banner?.dispose();
    _banner = null;
    LoadedBanner? loaded;
    try {
      await runtime.initialize();
      loaded = await runtime.loadBanner(adUnitId: widget.adUnitId, width: width);
    } catch (error) {
      debugPrint('Ad banner could not load: $error');
    }
    if (!mounted || mine != _generation) {
      loaded?.dispose();
      return;
    }
    if (loaded != null) setState(() => _banner = loaded);
  }

  /// Drops any banner and cancels a load in flight.
  void _discard() {
    _generation++;
    _requestedWidth = null;
    if (_banner != null) {
      _banner!.dispose();
      _banner = null;
    }
  }

  @override
  void dispose() {
    _generation++;
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;
    if (banner == null) return const SizedBox.shrink();
    final l = L10n.of(context);
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: space1),
            child: Text(l.adLabel, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.palette.textSubtle)),
          ),
          SizedBox(height: banner.height, child: banner.build(context)),
        ],
      ),
    );
  }
}
