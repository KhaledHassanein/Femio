// The free-text note on the Log screen (R9.8).
//
// Why it exists: some of a day does not fit a chip ("started the new tablets",
// "argued with my sister"). The note is typed, so like the temperature field it has its
// own widget. It saves by itself while she types (after a short pause), when she leaves
// the field and when the day changes, so there is no save button to forget. The note is
// stored in her sealed record on the phone, never sent anywhere.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../theme/femio_theme.dart';
import '../../../theme/radii.dart';
import '../../../theme/spacing.dart';

/// Longest note, in characters. A note is a line or two to jog her memory, not a diary,
/// and a cap keeps the record and the backup small.
const noteMaxLength = 500;

/// How long she must stop typing before the note is saved.
const noteSaveDelay = Duration(milliseconds: 700);

/// Visible lines before the field scrolls.
const noteMaxLines = 6;
const noteMinLines = 3;

/// A multi-line note. [initial] fills the box; [onSave] gets the note, or null when it is
/// empty or only spaces. The caller keys the widget by day so each day starts from its
/// own text. [reassurance] sits under the field.
class NoteField extends StatefulWidget {
  const NoteField({
    super.key,
    required this.initial,
    required this.hint,
    required this.reassurance,
    required this.onSave,
  });
  final String? initial;
  final String hint;
  final String reassurance;
  final ValueChanged<String?> onSave;

  @override
  State<NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends State<NoteField> {
  late final _controller = TextEditingController(text: widget.initial ?? '');
  final _focus = FocusNode();
  Timer? _timer;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _flush();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Leaving the day with unsaved typing still saves it. Deferred one microtask so the
    // record's listeners are not told while the tree is being torn down.
    if (_dirty) {
      final text = _value();
      final save = widget.onSave;
      Future.microtask(() => save(text));
    }
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  String? _value() {
    final t = _controller.text.trim();
    return t.isEmpty ? null : t;
  }

  void _flush() {
    _timer?.cancel();
    if (!_dirty) return;
    _dirty = false;
    widget.onSave(_value());
  }

  void _changed(String _) {
    _dirty = true;
    _timer?.cancel();
    _timer = Timer(noteSaveDelay, _flush);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextField(
        controller: _controller,
        focusNode: _focus,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        minLines: noteMinLines,
        maxLines: noteMaxLines,
        maxLength: noteMaxLength,
        onChanged: _changed,
        onTapOutside: (_) => _focus.unfocus(),
        decoration: InputDecoration(
          hintText: widget.hint,
          filled: true,
          fillColor: p.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMd)),
        ),
      ),
      const SizedBox(height: space1h),
      Padding(
        padding: const EdgeInsetsDirectional.only(start: space3),
        child: Text(widget.reassurance, style: theme.textTheme.bodySmall?.copyWith(color: p.textMuted)),
      ),
    ]);
  }
}
