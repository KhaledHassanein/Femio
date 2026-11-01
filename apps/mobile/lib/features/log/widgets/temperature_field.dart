// The waking-temperature field on the Log screen.
//
// Why it exists: temperature is the one log entry that is typed, not tapped, so it needs
// its own input, its own typo guard and its own right-to-left handling. It does not
// interpret the number (product rule 1): the chart draws it, she and her clinician read it.

import 'package:flutter/material.dart';

import '../../../domain/bbt.dart';
import '../../../theme/femio_theme.dart';
import '../../../theme/spacing.dart';
import '../../../theme/radii.dart';

/// Waking temperature, typed. Rejects only what no thermometer produced (a typo guard,
/// `unitOf`); a plausible number is never commented on.
///
/// [label] is the field's spoken name (it has no visible label). [initial] fills the box. [hint] sits under it, [invalid] replaces the hint when the
/// number is rejected. [onSave] gets the number, or null when she clears it. The caller
/// keys the widget by day so each day starts from its own value.
class TemperatureField extends StatefulWidget {
  const TemperatureField({
    super.key,
    required this.label,
    required this.initial,
    required this.hint,
    required this.saveLabel,
    required this.clearLabel,
    required this.invalid,
    required this.onSave,
  });
  final String label;
  final double? initial;
  final String hint;
  final String saveLabel;
  final String clearLabel;
  final String invalid;
  final ValueChanged<double?> onSave;

  @override
  State<TemperatureField> createState() => _TemperatureFieldState();
}

class _TemperatureFieldState extends State<TemperatureField> {
  late final _controller = TextEditingController(text: widget.initial?.toString() ?? '');
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Accepts a comma or an Arabic decimal mark as the decimal point, then checks the
  /// number could come from a thermometer before saving.
  void _save() {
    final text = _controller.text.trim().replaceAll(',', '.').replaceAll('٫', '.');
    final value = double.tryParse(text);
    if (value == null || unitOf(value) == null) {
      setState(() => _error = widget.invalid);
      return;
    }
    setState(() => _error = null);
    widget.onSave(value);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final theme = Theme.of(context);
    // The hint and the error sit under the whole row, in her reading direction: the
    // field itself is LTR (numbers), and a helper inside it would be clipped to the
    // field's width and drawn left-aligned in Arabic.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Semantics(
                label: widget.label,
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: '36.5',
                    filled: true,
                    fillColor: p.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMd)),
                    enabledBorder: _error == null
                        ? null
                        : OutlineInputBorder(
                            borderRadius: BorderRadius.circular(radiusMd),
                            borderSide: BorderSide(color: theme.colorScheme.error),
                          ),
                  ),
                  onSubmitted: (_) => _save(),
                ),
              ),
            ),
            const SizedBox(width: space2),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(88, 52)),
              onPressed: _save,
              child: Text(widget.saveLabel),
            ),
            if (widget.initial != null)
              IconButton(
                tooltip: widget.clearLabel,
                onPressed: () {
                  _controller.clear();
                  widget.onSave(null);
                },
                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ),
        const SizedBox(height: space1h),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: space3),
          // A live region: a rejected number is announced as it replaces the hint.
          child: Semantics(
            liveRegion: _error != null,
            child: Text(
              _error ?? widget.hint,
              style: theme.textTheme.bodySmall?.copyWith(color: _error == null ? p.textMuted : theme.colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
