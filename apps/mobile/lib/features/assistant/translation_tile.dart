// Settings > Assistant: the phone's own translator for the AI (ADR-087 §6).
//
// Why it exists: Gemini Nano is validated in English. When her app language is another one,
// this row lets her download the language file (about 30 MB, on her tap only) so femio can
// translate her question to English and the answer back, all on the phone, and remove it
// again. It shows only where it helps: a language other than English, a translator in the
// app, and a phone that can run Gemini Nano.

import 'package:flutter/material.dart';

import '../../data/assistant_gateway.dart' show englishCode;
import '../../data/translate_channel.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/spacing.dart';
import '../../theme/type_sizes.dart';
import 'assistant_scope.dart';

enum _State { checking, notReady, downloading, ready, failed }

/// The translation row; renders nothing where translation cannot help.
class TranslationTile extends StatefulWidget {
  const TranslationTile({super.key, required this.nanoPossible});

  /// Whether Gemini Nano is on this phone or can be downloaded.
  final bool nanoPossible;

  @override
  State<TranslationTile> createState() => _TranslationTileState();
}

class _TranslationTileState extends State<TranslationTile> {
  _State _state = _State.checking;
  TranslatorPort? _translator;
  String _lang = englishCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final t = AssistantScope.translatorOf(context);
    final lang = Localizations.localeOf(context).languageCode;
    if (t != _translator || lang != _lang) {
      _translator = t;
      _lang = lang;
      _check();
    }
  }

  Future<void> _check() async {
    final t = _translator;
    if (t == null || _lang == englishCode) return;
    final ready = await t.ready(_lang);
    if (mounted) setState(() => _state = ready ? _State.ready : _State.notReady);
  }

  Future<void> _download() async {
    final t = _translator;
    if (t == null) return;
    setState(() => _state = _State.downloading);
    final ok = await t.download(_lang);
    if (mounted) setState(() => _state = ok ? _State.ready : _State.failed);
  }

  Future<void> _remove() async {
    final t = _translator;
    if (t == null) return;
    await t.remove(_lang);
    await _check();
  }

  @override
  Widget build(BuildContext context) {
    if (_translator == null || _lang == englishCode || !widget.nanoPossible || _state == _State.checking) {
      return const SizedBox.shrink();
    }
    final l = L10n.of(context);
    final p = context.palette;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.translate_rounded, color: p.primary),
        title: Text(l.translateTitle),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: space1),
          child: Text(switch (_state) {
            _State.ready => l.translateReady,
            _State.downloading => l.translateDownloading,
            _State.failed => l.translateFailed,
            _ => l.translateNotReady,
          }),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: switch (_state) {
          _State.ready => TextButton(onPressed: _remove, child: Text(l.translateRemove)),
          _State.downloading => const Padding(
              padding: EdgeInsets.all(space2),
              child: SizedBox.square(dimension: iconSizeInline, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          _ => OutlinedButton.icon(
              onPressed: _download,
              icon: const Icon(Icons.download_rounded),
              label: Text(l.translateDownload),
            ),
        },
      ),
    ]);
  }
}
