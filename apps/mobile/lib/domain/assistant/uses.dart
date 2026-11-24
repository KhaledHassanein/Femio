// Every way femio's assistant is used, and the policy each use runs under (ADR-081, R10.1).
//
// Why it exists: the owner's rule (CLAUDE.md rule 7) makes the AI a companion that never
// touches core functions or sees the whole record. One table names each use, where it may
// run, which consent it needs and whether it may suggest a change to her record. The
// gateway enforces it, the "What the AI can see" screen reads it, and tests check it.

import 'cloud_consent.dart';

/// Where a use may run. [phone] is Gemini Nano with ONLY_ON_DEVICE; [hybrid] may reach
/// Google's cloud model and so takes only a CloudPrompt, under Cloud boost consent.
enum AssistantTier { phone, hybrid }

/// What a use may do with her record: nothing, or offer a draft she confirms.
enum AssistantWrite { none, draftSheConfirms }

/// One use of the assistant.
enum AssistantUse {
  /// Ask femio: a cited summary of registry passages, her own words read on the phone.
  askOnPhone,

  /// Ask femio with Cloud boost: the general question she approved, plus public passages.
  askInCloud,

  /// Say it to log: words she typed into log terms she then ticks and saves.
  sayItToLog,

  /// Tips for you: order reviewed tips from coarse bands.
  tipsOrder,

  /// Doctor-visit pack: order reviewed questions from the summary's facts.
  visitQuestions,
}

/// The policy for one [AssistantUse].
class AssistantPolicy {
  const AssistantPolicy({required this.tier, required this.write, this.consent, this.enabled = true});

  final AssistantTier tier;
  final AssistantWrite write;

  /// The Cloud boost purpose she must have agreed to; null for phone-only uses.
  final CloudPurpose? consent;

  /// Off switches one use in a release without touching the others (kill switch 3).
  final bool enabled;
}

/// The policy table. Adding a use means adding a row here, a prompt factory, a gateway
/// method and a line in the manifest test.
const usePolicies = <AssistantUse, AssistantPolicy>{
  AssistantUse.askOnPhone: AssistantPolicy(tier: AssistantTier.phone, write: AssistantWrite.none),
  AssistantUse.askInCloud: AssistantPolicy(
    tier: AssistantTier.hybrid,
    write: AssistantWrite.none,
    consent: CloudPurpose.questions,
  ),
  AssistantUse.sayItToLog: AssistantPolicy(tier: AssistantTier.phone, write: AssistantWrite.draftSheConfirms),
  // On the phone when Nano is there; otherwise the four bands may go to the cloud, only
  // with her Cloud boost consent for tips.
  AssistantUse.tipsOrder: AssistantPolicy(
    tier: AssistantTier.hybrid,
    write: AssistantWrite.none,
    consent: CloudPurpose.tips,
  ),
  AssistantUse.visitQuestions: AssistantPolicy(tier: AssistantTier.phone, write: AssistantWrite.none),
};
