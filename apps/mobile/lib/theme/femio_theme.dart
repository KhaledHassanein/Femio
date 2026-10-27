// The Material theme built from Femio's design tokens.
//
// Why it exists: every colour, font and button shape comes from here, so the app and the
// website cannot drift apart, and no screen needs to choose a colour by hand.

import 'package:flutter/material.dart';

import 'tokens.g.dart';

/// Dusk Bloom for Flutter. Every colour comes from [FemioPalette], which is generated
/// from the website's canonical token CSS, so the app and the site cannot drift.
///
/// Type: Newsreader for display, Plus Jakarta Sans for text, IBM Plex Sans Arabic for
/// every Arabic glyph (as a fallback family, so mixed Arabic and Latin lines work).
/// All three are bundled; nothing is fetched at runtime.
class FemioTheme {
  /// Family for headlines.
  static const display = 'Newsreader';

  /// Family for body text and labels.
  static const sans = 'PlusJakartaSans';

  /// Fallback family for every Arabic glyph.
  static const arabic = 'IBMPlexSansArabic';

  /// The light theme.
  static ThemeData light() => _build(FemioPalette.light, Brightness.light);

  /// The dark theme.
  static ThemeData dark() => _build(FemioPalette.dark, Brightness.dark);

  /// Variable fonts take their weight from the `wght` axis; set both so the right
  /// instance renders whatever the engine version does with [FontWeight] alone.
  static TextStyle _style(String family, double size, FontWeight weight, Color color,
          {double? height, double letterSpacing = 0}) =>
      TextStyle(
        fontFamily: family,
        fontFamilyFallback: const [arabic],
        fontSize: size,
        fontWeight: weight,
        fontVariations: [FontVariation.weight(weight.value.toDouble())],
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  static ThemeData _build(FemioPalette p, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.primarySolid,
      onPrimary: p.onPrimarySolid,
      primaryContainer: p.primarySoft,
      onPrimaryContainer: p.primarySoftText,
      secondary: p.accentSolid,
      onSecondary: p.onAccentSolid,
      secondaryContainer: p.accentSoft,
      onSecondaryContainer: p.accentSoftText,
      error: p.danger,
      onError: p.onPrimary,
      surface: p.surface,
      onSurface: p.text,
      onSurfaceVariant: p.textMuted,
      outline: p.border,
      outlineVariant: p.border,
    );

    final text = TextTheme(
      displaySmall: _style(display, 34, FontWeight.w500, p.text, height: 1.15, letterSpacing: -0.4),
      headlineMedium: _style(display, 28, FontWeight.w500, p.text, height: 1.2, letterSpacing: -0.2),
      headlineSmall: _style(display, 24, FontWeight.w500, p.text, height: 1.25),
      titleLarge: _style(sans, 20, FontWeight.w600, p.text, height: 1.3),
      titleMedium: _style(sans, 17, FontWeight.w600, p.text, height: 1.35),
      bodyLarge: _style(sans, 17, FontWeight.w400, p.text, height: 1.5),
      bodyMedium: _style(sans, 15, FontWeight.w400, p.textMuted, height: 1.5),
      bodySmall: _style(sans, 13, FontWeight.w400, p.textMuted, height: 1.45),
      labelLarge: _style(sans, 16, FontWeight.w600, p.text),
      labelMedium: _style(sans, 13, FontWeight.w600, p.textMuted, letterSpacing: 0.6),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      // Every text style Material builds for itself (the calendar's month header, a
      // snackbar, a menu) gets Femio's type too, not just the slots set below.
      fontFamily: sans,
      fontFamilyFallback: const [arabic],
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      textTheme: text,
      extensions: [FemioColors(p)],
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: const StadiumBorder(),
          backgroundColor: p.primarySolid,
          foregroundColor: p.onPrimarySolid,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          side: BorderSide(color: p.borderStrong),
          foregroundColor: p.text,
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: p.textLink,
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

/// The full palette, for the colours Material's scheme has no slot for (phases, log
/// categories, the aurora). `Theme.of(context).extension<FemioColors>()!.p`.
class FemioColors extends ThemeExtension<FemioColors> {
  const FemioColors(this.p);
  final FemioPalette p;

  @override
  FemioColors copyWith({FemioPalette? p}) => FemioColors(p ?? this.p);

  @override
  FemioColors lerp(FemioColors? other, double t) => t < 0.5 ? this : (other ?? this);
}

/// Shortcut to the palette from any widget: `context.palette.surface`. Requires the
/// app to be built with [FemioTheme]; otherwise the null check fails at once.
extension FemioContext on BuildContext {
  FemioPalette get palette => Theme.of(this).extension<FemioColors>()!.p;
}
