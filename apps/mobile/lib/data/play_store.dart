// The two Google Play services femio uses on the phone: the rating dialog and in-app updates.
//
// Why it exists: both packages talk to the Play Store app on the device (Play Core), not to
// a server of ours, and both throw on a phone without Play (an emulator, a sideloaded APK).
// This seam keeps that behind one interface, so the app and the tests never touch Play
// directly and a failure is always silent: a missing rating dialog or update card costs
// her nothing.

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';

import '../domain/store_prompts.dart';

/// What femio asks of Google Play. Every method swallows its own failures.
abstract interface class PlayStore {
  /// Asks Play to show its rating dialog. Play alone decides whether it appears.
  Future<void> requestReview();

  /// How an update should be offered right now ([UpdatePrompt.none] when unknown).
  Future<UpdatePrompt> checkUpdate();

  /// Starts the update: Play's full-screen flow for [UpdatePrompt.immediate], otherwise a
  /// background download that installs when it finishes. Returns false if it did not start.
  Future<bool> startUpdate(UpdatePrompt mode);
}

/// No Play at all: tests, and any build where nothing should be asked.
class NoPlayStore implements PlayStore {
  const NoPlayStore();

  @override
  Future<void> requestReview() async {}

  @override
  Future<UpdatePrompt> checkUpdate() async => UpdatePrompt.none;

  @override
  Future<bool> startUpdate(UpdatePrompt mode) async => false;
}

/// The real Play services through `in_app_review` and `in_app_update`.
class GooglePlayStore implements PlayStore {
  const GooglePlayStore();

  @override
  Future<void> requestReview() async {
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) await review.requestReview();
    } catch (error) {
      debugPrint('Play review unavailable: $error');
    }
  }

  @override
  Future<UpdatePrompt> checkUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      return updatePromptFor(
        available: info.updateAvailability == UpdateAvailability.updateAvailable,
        priority: info.updatePriority,
        immediateAllowed: info.immediateUpdateAllowed,
        flexibleAllowed: info.flexibleUpdateAllowed,
      );
    } catch (error) {
      debugPrint('Play update check unavailable: $error');
      return UpdatePrompt.none;
    }
  }

  @override
  Future<bool> startUpdate(UpdatePrompt mode) async {
    try {
      if (mode == UpdatePrompt.immediate) {
        return await InAppUpdate.performImmediateUpdate() == AppUpdateResult.success;
      }
      if (await InAppUpdate.startFlexibleUpdate() != AppUpdateResult.success) return false;
      await InAppUpdate.completeFlexibleUpdate();
      return true;
    } catch (error) {
      debugPrint('Play update could not start: $error');
      return false;
    }
  }
}
