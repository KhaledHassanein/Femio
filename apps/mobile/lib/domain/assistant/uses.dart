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

/// What a use's prompt may contain. Each value names one input of the matching prompt
/// factory (PrivatePrompt or CloudPrompt); "What the AI can see" lists them for her.
enum AssistantInput {
  /// The question she typed, read on the phone.
  herQuestion,

  /// Her question; in the cloud only the redacted version she approved (CloudSafeText).
  approvedQuestion,

  /// Passages from femio's bundled trusted-source registry: public text, not hers.
  trustedPassages,

  /// The note she typed into Say it.
  herNote,

  /// The four broad bands: life stage, cycle regularity, kinds of symptom, logging streak.
  fourBands,

  /// The ids of femio's reviewed tips or visit questions, to put in order.
  reviewedIds,

  /// The visit summary's facts: goal, cycles counted, shortest and longest cycle, last
  /// period date, regularity.
  visitFacts,
}

/// The policy for one [AssistantUse].
class AssistantPolicy {
  const AssistantPolicy({
    required this.tier,
    required this.write,
    required this.sees,
    this.consent,
    this.enabled = true,
  });

  final AssistantTier tier;
  final AssistantWrite write;

  /// Everything the use's prompt may contain; nothing else from her record reaches it.
  final List<AssistantInput> sees;

  /// The Cloud boost purpose she must have agreed to; null for phone-only uses.
  final CloudPurpose? consent;

  /// Off switches one use in a release without touching the others (kill switch 3).
  final bool enabled;
}

/// The policy table. Adding a use means adding a row here, a prompt factory, a gateway
/// method and a line in the manifest test.
const usePolicies = <AssistantUse, AssistantPolicy>{
  AssistantUse.askOnPhone: AssistantPolicy(
    tier: AssistantTier.phone,
    write: AssistantWrite.none,
    sees: [AssistantInput.herQuestion, AssistantInput.trustedPassages],
  ),
  AssistantUse.askInCloud: AssistantPolicy(
    tier: AssistantTier.hybrid,
    write: AssistantWrite.none,
    sees: [AssistantInput.approvedQuestion, AssistantInput.trustedPassages],
    consent: CloudPurpose.questions,
  ),
  AssistantUse.sayItToLog: AssistantPolicy(
    tier: AssistantTier.phone,
    write: AssistantWrite.draftSheConfirms,
    sees: [AssistantInput.herNote],
  ),
  // On the phone when Nano is there; otherwise the four bands may go to the cloud, only
  // with her Cloud boost consent for tips.
  AssistantUse.tipsOrder: AssistantPolicy(
    tier: AssistantTier.hybrid,
    write: AssistantWrite.none,
    sees: [AssistantInput.fourBands, AssistantInput.reviewedIds],
    consent: CloudPurpose.tips,
  ),
  AssistantUse.visitQuestions: AssistantPolicy(
    tier: AssistantTier.phone,
    write: AssistantWrite.none,
    sees: [AssistantInput.visitFacts, AssistantInput.reviewedIds],
  ),
};
