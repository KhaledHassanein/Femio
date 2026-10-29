// femio Plus · the Play Billing spike (R6.9, step one).
//
// Why it exists: the premium tier will be sold through Google Play Billing because it
// is the only billing route that keeps "no account, no server" true for an Egyptian
// seller (docs/34_GROWTH_OPS/02_MONETIZATION.md §2.1). The release gate forbids the
// INTERNET permission, so before any purchase code is written this file proves, on a
// real phone, that the billing library reaches the Play Store app through the device
// (a bound service, not the network) and that the merged manifest still has no INTERNET.
//
// What it is not: a purchase flow. It never starts a purchase, never stores anything,
// and the screen that shows its result exists only in debug and profile builds.

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// The one product and its two base plans (Play Console, owner guide part I).
const plusProductId = 'femio_plus';

/// What the probe found. Every field is a fact the phone reported, never a guess.
@immutable
class BillingProbeResult {
  const BillingProbeResult({required this.available, required this.productFound, this.error});

  /// Whether the Play Store app on this phone answered the billing library at all.
  final bool available;

  /// Whether `femio_plus` exists in Play Console for this app and this account.
  /// False is expected until the owner creates the product (guide part I).
  final bool productFound;

  /// The store's own message when a query failed; null when nothing failed.
  final String? error;
}

/// Asks the device, through the billing library, whether Play Billing is reachable and
/// whether the product exists. Safe to call on any build; it only reads.
Future<BillingProbeResult> probePlayBilling({InAppPurchase? billing}) async {
  final iap = billing ?? InAppPurchase.instance;
  try {
    final available = await iap.isAvailable();
    if (!available) return const BillingProbeResult(available: false, productFound: false);
    final response = await iap.queryProductDetails({plusProductId});
    return BillingProbeResult(
      available: true,
      productFound: response.productDetails.any((p) => p.id == plusProductId),
      error: response.error?.message,
    );
  } catch (e) {
    return BillingProbeResult(available: false, productFound: false, error: e.toString());
  }
}
