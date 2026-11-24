// Google's search-suggestions chip under a grounded answer (ADR-078 §1).
//
// Why it exists: the Grounding with Google Search terms require showing the suggestions as
// Google renders them. Flutter cannot render that HTML, so this hosts the native WebView from
// `assistant/SearchSuggestionsView.kt`; anywhere but Android it shows nothing.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Height of the chip strip Google renders (one row of suggestion pills).
const searchSuggestionsHeight = 64.0;

/// Shows [html] unchanged in a native view.
class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key, required this.html});
  final String html;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return const SizedBox.shrink();
    return SizedBox(
      height: searchSuggestionsHeight,
      child: AndroidView(
        viewType: 'com.femioapp.femio/search-suggestions',
        creationParams: {'html': html},
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
