// The Settings row that runs the Play Billing probe, shown in debug and profile builds
// only (release builds compile it out of the tree). It lets the owner read, on his own
// phone, "Play Billing reachable: yes / no" before any purchase code exists.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'billing_probe.dart';

/// A tile that runs [probePlayBilling] on tap and shows the result underneath.
/// Renders nothing in a release build.
class BillingProbeTile extends StatefulWidget {
  const BillingProbeTile({super.key, this.probe = probePlayBilling});

  /// Injected so a widget test can run without the Play Store.
  final Future<BillingProbeResult> Function() probe;

  @override
  State<BillingProbeTile> createState() => _BillingProbeTileState();
}

class _BillingProbeTileState extends State<BillingProbeTile> {
  BillingProbeResult? _result;
  bool _running = false;

  Future<void> _run() async {
    setState(() => _running = true);
    final result = await widget.probe();
    if (!mounted) return;
    setState(() {
      _result = result;
      _running = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) return const SizedBox.shrink();
    final l = L10n.of(context);
    final result = _result;
    final String subtitle = _running
        ? l.plusProbeRunning
        : result == null
            ? l.plusProbeSubtitle
            : [
                result.available ? l.plusProbeAvailable : l.plusProbeUnavailable,
                if (result.available) (result.productFound ? l.plusProbeProductFound : l.plusProbeProductMissing),
                if (result.error != null) result.error!,
              ].join('\n');
    return ListTile(
      leading: const Icon(Icons.workspace_premium_outlined),
      title: Text(l.plusProbeTitle),
      subtitle: Text(subtitle),
      onTap: _running ? null : _run,
    );
  }
}
