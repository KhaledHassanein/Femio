// What the banner widget reads from the app without being handed it screen by screen:
// whether femio Plus is active, and which ads runtime is in use.
//
// Why it exists: ArticleScreen is opened from three places and has no controller; an
// inherited widget at the app root gives every route the same answer, and swaps in the
// do-nothing runtime for tests without touching a screen's constructor.

import 'package:flutter/widgets.dart';

import '../../app.dart';
import 'ads_runtime.dart';

/// Provides [FemioController.plusActive] and the [AdsRuntime] to the whole app. It
/// listens to the controller, so activating Plus removes every banner at once.
class AdsScope extends InheritedNotifier<FemioController> {
  const AdsScope({super.key, required FemioController controller, required this.runtime, required super.child})
      : super(notifier: controller);

  /// The runtime banners load through.
  final AdsRuntime runtime;

  /// True when femio Plus is active (false when there is no scope, as in isolated tests).
  static bool plusActiveOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AdsScope>()?.notifier?.plusActive ?? false;

  /// The runtime in scope, or [NoAdsRuntime] when there is none.
  static AdsRuntime runtimeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AdsScope>()?.runtime ?? const NoAdsRuntime();

  @override
  bool updateShouldNotify(AdsScope oldWidget) => runtime != oldWidget.runtime || super.updateShouldNotify(oldWidget);
}
