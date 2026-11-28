// "Ask femio": a health question answered only from trusted sources (ADR-078 §1, ADR-079).
//
// Why it exists: she wants answers, not only articles, and the owner ruled the answers must come
// from trusted sources, not from a model's memory. The flow, all decided on the phone:
//   1. the safety rules run first (danger signs open help; birth control gets the fixed answer);
//   2. the bundled registry is searched on the phone; if no passage answers, femio says
//      "not covered" and shows trusted links and guides instead of guessing;
//   3. with Gemini Nano, the passages are summarised on the phone (ONLY_ON_DEVICE), even for a
//      question about her, because nothing leaves the phone;
//   4. without Nano, and only if she switched Cloud boost on, a general question she approves
//      (a CloudSafeText) and the public passages may go to the hybrid call;
//   5. otherwise she reads the passages word for word. Every answer lists its sources.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/assistant_channel.dart' show AssistantStatus, OnDeviceModel;
import '../../data/assistant_gateway.dart';
import '../../data/guide_text.dart';
import '../../data/library.dart';
import '../../data/profile.dart';
import '../../data/trusted_registry.dart';
import '../../domain/dates.dart';
import '../../domain/assistant/cloud_consent.dart';
import '../../domain/assistant/guide_search.dart';
import '../../domain/assistant/prompts.dart';
import '../../domain/assistant/redaction.dart';
import '../../domain/assistant/diagnosis.dart';
import '../../domain/assistant/safety.dart';
import '../../domain/assistant/source_registry.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../widgets/notice_card.dart';
import '../learn/article_screen.dart';
import 'answer_card.dart';
import 'assistant_scope.dart';
import 'input_actions.dart';
import 'safety_notice.dart';
import 'save_to_record_card.dart';
import 'stage_hints.dart';
import 'visit_summary_screen.dart';

enum _Stage { asking, confirming, working, answered }

/// Wraps [s] in a left-to-right isolate (U+2066 … U+2069) so Arabic text around it does not
/// reorder its digits and dots.
String _ltrIsolate(String s) => '${String.fromCharCode(0x2066)}$s${String.fromCharCode(0x2069)}';

/// The Ask femio screen. [library] supplies the related guides; [controller] supplies her life
/// stage (for the safety rules and ranking) and her Cloud boost choice.
class AskScreen extends StatefulWidget {
  const AskScreen({super.key, required this.controller, this.library, this.registry, this.today});
  final FemioController controller;
  final Library? library;

  /// The registry to search; tests pass one, the app loads the bundled file.
  final SourceRegistry? registry;

  /// Fixes the date in tests; the app reads the clock.
  final String? today;

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final _question = TextEditingController();
  final _outgoing = TextEditingController();
  _Stage _stage = _Stage.asking;
  SafetySignal _signal = SafetySignal.none;

  /// She asked whether she has a condition: the fixed "only a clinician can tell" sentence
  /// comes before the passages (R7.14). The search still runs.
  bool _diagnosis = false;
  String? _note;

  /// The question as she asked it, and a counter that gives each answer a fresh save prompt.
  String _asked = '';
  int _round = 0;
  RegistryAnswer? _found;
  CitedAnswer? _summary;
  AnswerOrigin _origin = AnswerOrigin.verbatim;
  String _registryVersion = '';
  List<GuideHit> _guides = const [];
  Map<String, Article> _articles = const {};

  @override
  void dispose() {
    _question.dispose();
    _outgoing.dispose();
    super.dispose();
  }

  Profile? get _profile => widget.controller.profile;

  Future<void> _ask() async {
    final q = _question.text.trim();
    if (q.isEmpty) return;
    final l = L10n.of(context);
    final gateway = AssistantScope.gatewayOf(context);
    final lang = Localizations.localeOf(context).languageCode;
    final profile = _profile;
    setState(() {
      _asked = q;
      _round++;
      _signal = profile == null ? safetySignal(q, pregnant: false) : safetySignalFor(q, profile, _today());
      _diagnosis = asksForDiagnosis(q);
      _found = null;
      _summary = null;
      _note = null;
      _origin = AnswerOrigin.verbatim;
    });
    _guides = await _related(q, lang);
    if (_signal != SafetySignal.none) {
      if (mounted) setState(() => _stage = _Stage.asking);
      return;
    }
    setState(() => _stage = _Stage.working);
    final registry = widget.registry ?? await loadTrustedRegistry();
    _registryVersion = registry.version;
    var found = searchRegistry(q, registry, goal: profile?.goal.name, lang: lang);
    if (found.notCovered) {
      // The passages are in English: her words, translated on the phone, may find them.
      final english = await gateway.questionInEnglish(q, lang);
      if (english != null) found = searchRegistry(english, registry, goal: profile?.goal.name, lang: lang);
    }
    if (found.notCovered) {
      if (mounted) setState(() => (_found = found, _stage = _Stage.answered));
      return;
    }
    final status = await gateway.status();
    if (status.canRunPrivate) {
      // Her own words may be read here: ONLY_ON_DEVICE, nothing leaves the phone.
      final parsed = (await gateway.answerOnPhone(q, found.passages, lang)).value;
      if (!mounted) return;
      setState(() {
        _found = found;
        _summary = parsed;
        _origin = parsed == null ? AnswerOrigin.verbatim : AnswerOrigin.onPhone;
        _stage = _Stage.answered;
      });
      return;
    }
    final boost = profile?.settings.cloud.allows(CloudPurpose.questions) ?? false;
    final safe = toCloudSafe(q);
    final paused = gateway.cloudPaused;
    if (!mounted) return;
    setState(() {
      _found = found;
      if (boost && status.canRunHybrid && safe != null && paused == null) {
        _outgoing.text = safe.value;
        _stage = _Stage.confirming;
      } else {
        // Owner 2026-11-27: she is told why the AI did not run, never left guessing.
        _note = boost && safe == null
            ? l.askAboutYouStays
            : boost && paused != null
                ? l.askCloudUnavailable(l.cloudCheckFailed(paused))
                : _whyNoAi(l, status, profile?.settings.assistantOn ?? true);
        _stage = _Stage.answered;
      }
    });
  }

  /// Sends the general question she approved, with the public passages, to the hybrid call.
  Future<void> _send() async {
    final l = L10n.of(context);
    final found = _found;
    if (found == null) return;
    final text = _outgoing.text.trim();
    final profile = _profile;
    final signal = profile == null ? safetySignal(text, pregnant: false) : safetySignalFor(text, profile, _today());
    if (signal != SafetySignal.none) {
      setState(() => _signal = signal);
      return;
    }
    final safe = toCloudSafe(text);
    if (safe == null) {
      setState(() => _note = l.askStillPersonal);
      return;
    }
    final gateway = AssistantScope.gatewayOf(context);
    final lang = Localizations.localeOf(context).languageCode;
    setState(() => _stage = _Stage.working);
    final consent = _profile?.settings.cloud ?? const CloudConsent();
    final result = await gateway.answerWithBoost(safe, found.passages, lang, consent);
    final parsed = result.value;
    if (!mounted) return;
    setState(() {
      _summary = parsed;
      _origin = parsed == null
          ? AnswerOrigin.verbatim
          : (result.ranOn == RanOn.cloud ? AnswerOrigin.cloud : AnswerOrigin.onPhone);
      final why = gateway.lastCloudFailure;
      if (parsed == null) {
        _note = why == null || why == 'other' || why == 'empty'
            ? l.askModelFellBack
            : l.askCloudUnavailable(l.cloudCheckFailed(why));
      }
      _stage = _Stage.answered;
    });
  }

  /// Why no model summarised this answer, in her words: the AI is off, Gemini Nano is not
  /// on this phone (or not downloaded yet), or Cloud boost is off.
  String _whyNoAi(L10n l, AssistantStatus status, bool aiOn) {
    if (!aiOn) return l.askAiOffNote;
    return switch (status.onDevice) {
      OnDeviceModel.downloadable || OnDeviceModel.downloading => l.askNanoNotReady,
      _ => l.askNoAiHere,
    };
  }

  /// Shows the passages word for word instead of sending anything.
  void _skipCloud() => setState(() => _stage = _Stage.answered);

  String _today() => widget.today ?? todayISO();

  Future<List<GuideHit>> _related(String q, String lang) async {
    final library = widget.library;
    if (library == null) return const [];
    try {
      final articles = await library.articles(lang);
      _articles = {for (final a in articles) a.slug: a};
      return searchGuides(q, [for (final a in articles) guideTextOf(a)]);
    } on Object {
      return const [];
    }
  }

  void _reset() => setState(() {
    _stage = _Stage.asking;
    _signal = SafetySignal.none;
    _diagnosis = false;
    _found = null;
    _summary = null;
    _note = null;
    _guides = const [];
    _question.clear();
  });

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final found = _found;
    final done = _stage == _Stage.answered || _signal != SafetySignal.none;

    return Scaffold(
      appBar: AppBar(title: Text(l.askTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(space5, space3, space5, space8),
          children: [
            Text(l.askIntro, style: t.bodyMedium),
            const SizedBox(height: space4),
            TextField(
              controller: _question,
              minLines: 1,
              maxLines: 4,
              enabled: _stage == _Stage.asking,
              // Her question stays in full colour above the answer; a disabled grey reads as
              // if it were a hint she has not typed.
              style: t.bodyLarge?.copyWith(color: p.text),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _ask(),
              decoration: InputDecoration(
                hintText: askHintFor(l, hintStage(_profile)),
                border: const OutlineInputBorder(),
                suffixIcon: AssistantInputActions(text: _question, controller: widget.controller, today: _today(), enabled: _stage == _Stage.asking),
              ),
            ),
            if (_stage == _Stage.asking) ...[
              const SizedBox(height: space3),
              FilledButton.icon(onPressed: _ask, icon: const Icon(Icons.search_rounded), label: Text(l.askAction)),
            ],
            if (_signal != SafetySignal.none) ...[
              const SizedBox(height: space4),
              SafetyNotice(signal: _signal, library: widget.library),
            ],
            if (_stage == _Stage.confirming) ...[
              const SizedBox(height: space4),
              NoticeCard(tone: NoticeTone.quiet, heading: l.askBoostHeading, body: l.askBoostConfirm),
              const SizedBox(height: space3),
              Text(l.askWillSend, style: t.titleSmall),
              const SizedBox(height: space2),
              TextField(
                controller: _outgoing,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: space2),
              PrivacyRow(text: l.askCloudPrivacy),
              const SizedBox(height: space3),
              FilledButton.icon(onPressed: _send, icon: const Icon(Icons.cloud_outlined), label: Text(l.askSend)),
              const SizedBox(height: space2),
              OutlinedButton(onPressed: _skipCloud, child: Text(l.askReadSourcesInstead)),
            ],
            if (_stage == _Stage.working) ...[
              const SizedBox(height: space6),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: space3),
              Center(child: Text(l.askSearching, style: t.bodyMedium)),
            ],
            if (_diagnosis && _stage == _Stage.answered) ...[
              const SizedBox(height: space4),
              NoticeCard(
                tone: NoticeTone.caution,
                icon: Icons.medical_information_outlined,
                heading: l.askDiagnosisHeading,
                body: l.askDiagnosisBody,
              ),
            ],
            if (_note != null && _stage == _Stage.answered) ...[
              const SizedBox(height: space4),
              NoticeCard(tone: NoticeTone.quiet, heading: l.askTitle, body: _note!),
            ],
            if (_stage == _Stage.answered && found != null && found.notCovered) ...[
              const SizedBox(height: space4),
              NoticeCard(tone: NoticeTone.caution, heading: l.askNotCoveredHeading, body: l.askNotCovered),
              // R8.27: what femio cannot answer is often worth asking at a visit.
              if (widget.controller.profile != null) ...[
                const SizedBox(height: space2),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => VisitSummaryScreen(
                        controller: widget.controller,
                        today: widget.today,
                        initialWorry: _question.text.trim(),
                      ),
                    )),
                    icon: const Icon(Icons.assignment_outlined),
                    label: Text(l.askVisitPack),
                  ),
                ),
              ],
            ],
            if (_stage == _Stage.answered && found != null && !found.notCovered)
              AnswerCard(answer: found, summary: _summary, origin: _origin),
            if (_stage == _Stage.answered && found != null && found.links.isNotEmpty) LinksBlock(links: found.links),
            // Offered once the answer is shown; nothing is written until she ticks and taps Save.
            if (_stage == _Stage.answered && found != null && _signal == SafetySignal.none)
              SaveToRecordCard(
                key: ValueKey('save-$_round'),
                controller: widget.controller,
                question: _asked,
                answerText: found.notCovered
                    ? null
                    : (_summary?.text ?? (found.passages.isEmpty ? null : found.passages.first.text)),
                today: _today(),
              ),
            if (_guides.isNotEmpty && done) ...[
              const SizedBox(height: space5),
              Semantics(header: true, child: Text(l.askRelatedGuides, style: t.titleMedium)),
              for (final g in _guides)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.menu_book_rounded, color: p.primary),
                  title: Text(g.guide.title),
                  subtitle: Text(g.guide.excerpt, maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: _articles[g.guide.slug] == null
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => ArticleScreen(article: _articles[g.guide.slug]!)),
                        ),
                ),
            ],
            if (_stage == _Stage.answered && _registryVersion.isNotEmpty) ...[
              const SizedBox(height: space3),
              // The version is Latin digits and dots; isolate it so Arabic text does not reorder it.
              Text(l.askRegistryVersion(_ltrIsolate(_registryVersion)), style: t.bodySmall),
            ],
            if (done) ...[
              const SizedBox(height: space4),
              OutlinedButton(onPressed: _reset, child: Text(l.askSearchAgain)),
            ],
          ],
        ),
      ),
    );
  }
}
