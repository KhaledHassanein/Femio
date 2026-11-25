// "Why am I seeing this?" for a tip on Today (R10.3, U12).
//
// Why it exists: she should be able to see, in plain words, which facts from her own record
// made a tip fit, and how the tips were put in order. The facts come from
// `domain/assistant/tip_reasons.dart`; this file only words them. No AI is involved.

import 'package:flutter/material.dart';

import '../../domain/assistant/personal_triggers.dart';
import '../../domain/assistant/tip_reasons.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/log_labels.g.dart';
import '../../widgets/lines_sheet.dart';
import '../assistant/visit_pack.dart' show tryingForLabel;

/// One reason in her language.
String tipReasonText(L10n l, TipReason r) => switch (r) {
      StageReason(:final stage) => l.tipWhyStage(stage.name),
      TermReason(:final term, :final days, :final windowDays) =>
        l.tipWhyTerm(logLabel(l, term), l.daysValue(days), l.daysValue(windowDays)),
      PregnancyWeekReason(:final week) => l.tipWhyPregnancyWeek(week),
      PostpartumWeekReason(:final weeks) => l.tipWhyPostpartumWeeks(weeks),
      TryingForReason(:final tryingFor) => l.tipWhyTryingFor(tryingForLabel(l, tryingFor)),
      IrregularReason(:final irregular) => irregular ? l.tipWhyIrregular : l.tipWhyRegular,
      AgeReason(:final from) => l.tipWhyAge(from),
    };

/// The sheet's sentences, in reading order. Exposed for tests.
List<String> tipWhyLines(L10n l, PersonalItem tip, TriggerContext c, {required bool cloudOrdered}) => [
      for (final r in tipReasons(tip.trigger, c)) tipReasonText(l, r),
      l.tipWhyFootnote,
      cloudOrdered ? l.tipsOrderedCloud : l.tipsChosenOnPhone,
      l.tipsSource(tip.publisher),
    ];

/// Opens the sheet for [tip].
Future<void> showTipWhySheet(BuildContext context, PersonalItem tip, TriggerContext c, {required bool cloudOrdered}) {
  final l = L10n.of(context);
  return showLinesSheet(context, l.tipWhyTitle, tipWhyLines(l, tip, c, cloudOrdered: cloudOrdered));
}
