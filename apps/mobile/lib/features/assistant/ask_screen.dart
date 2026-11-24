// "Ask femio": a health question answered from trusted sources (ADR-078 §1, §3).
//
// Why it exists: she wants answers, not only articles, and the owner ruled the answers must come
// from trusted sources (WHO, NHS, CDC, the societies), not from femio's own guides. The flow:
//   1. the safety rules run first (danger signs open help; birth control gets the fixed answer);
//   2. a question about her is rewritten as a general one on the phone (Gemini Nano), or by her;
//   3. she sees, can edit, and approves the exact text before it leaves the phone;
//   4. only a [CloudSafeText] reaches the cloud model, which searches Google;
//   5. the answer shows only when a source is on femio's trusted list, with every source and
//      Google's search suggestions listed, plus femio's own guides as related reading.

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/assistant_channel.dart';
import '../../data/guide_text.dart';
import '../../data/library.dart';
import '../../data/profile.dart';
import '../../domain/assistant/guide_search.dart';
import '../../domain/assistant/prompts.dart';
import '../../domain/assistant/redaction.dart';
import '../../domain/assistant/safety.dart';
import '../../domain/assistant/trusted_sources.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import '../../theme/tokens.g.dart' show FemioPalette;
import '../../theme/type_sizes.dart';
import '../../widgets/notice_card.dart';
import '../learn/article_screen.dart';
import 'assistant_scope.dart';
import 'safety_notice.dart';
import 'search_suggestions.dart';

enum _Stage { asking, confirming, searching, answered }

/// The Ask femio screen. [library] supplies the related guides; [controller] tells the safety
/// rules whether she is pregnant.
class AskScreen extends StatefulWidget {
  const AskScreen({super.key, required this.controller, this.library});
  final FemioController controller;
  final Library? library;

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final _question = TextEditingController();
  final _outgoing = TextEditingController();
  _Stage _stage = _Stage.asking;
  SafetySignal _signal = SafetySignal.none;
  String? _note;
  String? _error;
  bool _cloud = false;
  GroundedAnswer? _answer;
  List<GuideHit> _guides = const [];

  @override
  void dispose() {
    _question.dispose();
    _outgoing.dispose();
    super.dispose();
  }

  bool get _pregnant => widget.controller.profile?.goal == Goal.pregnant;

  Future<void> _ask() async {
    final q = _question.text.trim();
    if (q.isEmpty) return;
    final l = L10n.of(context);
    final bridge = AssistantScope.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    setState(() {
      _signal = safetySignal(q, pregnant: _pregnant);
      _answer = null;
      _error = null;
      _note = null;
    });
    _guides = await _related(q, lang);
    if (_signal != SafetySignal.none) {
      setState(() => _stage = _Stage.asking);
      return;
    }
    final status = await bridge.status();
    _cloud = status.canAskCloud;
    if (!_cloud) {
      setState(() {
        _stage = _Stage.answered;
        _error = l.askNotSetUp;
      });
      return;
    }
    var outgoing = q;
    if (isAboutHer(q)) {
      final rewrite = status.canRunPrivate ? await bridge.runPrivate(generalisePrompt(q)) : null;
      final general = rewrite == null ? '' : parseGeneralised(rewrite);
      outgoing = general.isNotEmpty && !isAboutHer(general) ? general : q;
      _note = general.isNotEmpty && !isAboutHer(general) ? l.askPersonalRewritten : l.askPersonalSelf;
    }
    if (!mounted) return;
    setState(() {
      _outgoing.text = outgoing;
      _stage = _Stage.confirming;
    });
  }

  Future<void> _send() async {
    final l = L10n.of(context);
    final text = _outgoing.text.trim();
    final signal = safetySignal(text, pregnant: _pregnant);
    if (signal != SafetySignal.none) {
      setState(() => _signal = signal);
      return;
    }
    final safe = toCloudSafe(text);
    if (safe == null) {
      setState(() => _note = l.askStillPersonal);
      return;
    }
    final bridge = AssistantScope.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    setState(() => _stage = _Stage.searching);
    final answer = await bridge.askGrounded(safe, instruction: answerInstruction(lang));
    if (!mounted) return;
    setState(() {
      _stage = _Stage.answered;
      if (answer == null) {
        _error = l.askFailed;
      } else if (!hasTrustedSource(answer.sources)) {
        _error = l.askNoTrusted;
      } else {
        _answer = answer;
      }
    });
  }

  Future<List<GuideHit>> _related(String q, String lang) async {
    final library = widget.library;
    if (library == null) return const [];
    try {
      final articles = await library.articles(lang);
      final byText = {for (final a in articles) a.slug: a};
      _articles = byText;
      return searchGuides(q, [for (final a in articles) guideTextOf(a)]);
    } on Object {
      return const [];
    }
  }

  Map<String, Article> _articles = const {};

  void _reset() => setState(() {
    _stage = _Stage.asking;
    _signal = SafetySignal.none;
    _answer = null;
    _error = null;
    _note = null;
    _guides = const [];
    _question.clear();
  });

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    final bridge = AssistantScope.of(context);

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
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _ask(),
              decoration: InputDecoration(hintText: l.askHint, border: const OutlineInputBorder()),
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
              if (_note != null) ...[
                const SizedBox(height: space4),
                NoticeCard(tone: NoticeTone.quiet, heading: l.askTitle, body: _note!),
              ],
              const SizedBox(height: space4),
              Text(l.askWillSend, style: t.titleSmall),
              const SizedBox(height: space2),
              TextField(
                controller: _outgoing,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: space2),
              _privacyRow(p, t, l.askCloudPrivacy),
              const SizedBox(height: space3),
              FilledButton.icon(
                onPressed: _send,
                icon: const Icon(Icons.travel_explore_rounded),
                label: Text(l.askSend),
              ),
            ],
            if (_stage == _Stage.searching) ...[
              const SizedBox(height: space6),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: space3),
              Center(child: Text(l.askSearching, style: t.bodyMedium)),
            ],
            if (_stage == _Stage.answered && _error != null) ...[
              const SizedBox(height: space4),
              NoticeCard(tone: NoticeTone.caution, heading: l.askTitle, body: _error!),
            ],
            if (_answer != null) ..._answerBlock(context, _answer!, bridge),
            if (_guides.isNotEmpty && (_stage == _Stage.answered || _signal != SafetySignal.none)) ...[
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
            if (_stage == _Stage.answered || _signal != SafetySignal.none) ...[
              const SizedBox(height: space4),
              OutlinedButton(onPressed: _reset, child: Text(l.askSearchAgain)),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _answerBlock(BuildContext context, GroundedAnswer a, AssistantBridge bridge) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return [
      const SizedBox(height: space4),
      Container(
        padding: const EdgeInsets.all(space4),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(radiusMd),
          border: Border.all(color: p.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_rounded, size: iconSizeInline, color: p.successText),
                const SizedBox(width: space1h),
                Expanded(child: Text(l.askAnswerLabel, style: t.labelMedium)),
              ],
            ),
            const SizedBox(height: space2),
            SelectableText(a.text, style: t.bodyLarge),
            const SizedBox(height: space3),
            Text(l.askClinicianLine, style: t.bodySmall),
          ],
        ),
      ),
      if (a.suggestionsHtml != null && a.suggestionsHtml!.isNotEmpty) ...[
        const SizedBox(height: space3),
        SearchSuggestions(html: a.suggestionsHtml!),
      ],
      const SizedBox(height: space4),
      Semantics(header: true, child: Text(l.askSourcesTitle, style: t.titleMedium)),
      for (final s in a.sources)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            s.trusted ? Icons.verified_outlined : Icons.public_rounded,
            color: s.trusted ? p.successText : p.textSubtle,
          ),
          title: Text(s.title, textDirection: TextDirection.ltr),
          subtitle: Text(s.trusted ? l.askTrustedBadge : l.askOtherSource),
          onTap: () => bridge.openSource(s.uri),
        ),
    ];
  }

  Widget _privacyRow(FemioPalette p, TextTheme t, String text) => Row(
    children: [
      Icon(Icons.lock_outline_rounded, size: iconSizeInline, color: p.textSubtle),
      const SizedBox(width: space1h),
      Expanded(child: Text(text, style: t.bodySmall)),
    ],
  );
}
