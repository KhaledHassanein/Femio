// A digits-only PIN field with a submit button.
//
// Why it exists: the lock screen and the Settings PIN dialogs share one control, so
// the keyboard, the length rule and the obscuring behave the same everywhere.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/spacing.dart';

/// Obscured numeric input; [onSubmit] fires on the keyboard's done key or the button
/// once the value is between [minLength] and [maxLength] digits.
class PinField extends StatefulWidget {
  const PinField({
    super.key,
    required this.label,
    required this.minLength,
    required this.maxLength,
    required this.onSubmit,
    this.enabled = true,
    this.autofocus = true,
  });

  final String label;
  final int minLength;
  final int maxLength;
  final ValueChanged<String> onSubmit;
  final bool enabled;
  final bool autofocus;

  @override
  State<PinField> createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> {
  final _controller = TextEditingController();

  bool get _valid => _controller.text.length >= widget.minLength && _controller.text.length <= widget.maxLength;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          obscureText: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(widget.maxLength)],
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: widget.label),
          onChanged: (_) => setState(() {}),
          onSubmitted: (v) {
            if (_valid) widget.onSubmit(v);
          },
        ),
        const SizedBox(height: space4),
        FilledButton(
          onPressed: widget.enabled && _valid ? () => widget.onSubmit(_controller.text) : null,
          child: Text(l.continueLabel),
        ),
      ],
    );
  }
}
