// Keeps text she typed in its own reading direction inside a screen of the other one.
//
// Why it exists: in an Arabic screen, a lab range typed as "0.4 - 4.0" was drawn as
// "4.0 - 0.4", and "400 mcg" came apart (owner build, 26 Nov 2026). A reversed range on
// her own report is a wrong fact. Her words are wrapped in a first-strong isolate so each
// piece keeps the direction of its own first strong letter, and fields she types in take
// the direction of what is in them.

import 'package:flutter/widgets.dart' show TextDirection;

/// Unicode FIRST STRONG ISOLATE and POP DIRECTIONAL ISOLATE.
const _fsi = '\u2068';
const _pdi = '\u2069';

/// A letter with a strong direction: Latin, or Hebrew/Arabic-script.
final _strong = RegExp(r'[A-Za-zÀ-ɏ֐-ࣿיִ-﷿ﹰ-﻿]');
final _rtl = RegExp(r'[֐-ࣿיִ-﷿ﹰ-﻿]');

/// [text] wrapped so it keeps its own direction when joined into a line of the other one.
/// Empty text stays empty.
String isolateText(String text) => text.isEmpty ? text : '$_fsi$text$_pdi';

/// The direction a field holding [text] should use: right-to-left when its first strong
/// letter is Arabic-script (or Hebrew), left-to-right when it is Latin or when it holds only
/// numbers and signs ("0.4 - 4.0"). Blank text takes [fallback], the screen's direction.
TextDirection directionOfText(String text, TextDirection fallback) {
  if (text.trim().isEmpty) return fallback;
  final first = _strong.firstMatch(text)?.group(0);
  if (first == null) return TextDirection.ltr;
  return _rtl.hasMatch(first) ? TextDirection.rtl : TextDirection.ltr;
}
