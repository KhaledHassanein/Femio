// Shows Google's search-suggestions chip under a grounded answer (ADR-078 §1).
//
// Why it exists: the Grounding with Google Search terms require the app to display the
// suggestions exactly as Google renders them (HTML and CSS in `searchEntryPoint.renderedContent`).
// Flutter has no HTML renderer, so this native WebView shows it unchanged, and a tap on a
// suggestion opens Google Search in her browser rather than inside femio.

package com.femioapp.femio.assistant

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/** View type shared with `lib/features/assistant/search_suggestions.dart`. */
const val SEARCH_SUGGESTIONS_VIEW = "com.femioapp.femio/search-suggestions"

class SearchSuggestionsFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val html = (args as? Map<*, *>)?.get("html") as? String ?: ""
        return SearchSuggestionsView(context, html)
    }
}

private class SearchSuggestionsView(context: Context, html: String) : PlatformView {
    private val webView = WebView(context).apply {
        // Google's chip needs no script of femio's; links leave the app.
        settings.javaScriptEnabled = false
        setBackgroundColor(android.graphics.Color.TRANSPARENT)
        webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView, request: WebResourceRequest): Boolean {
                val intent = Intent(Intent.ACTION_VIEW, request.url).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                view.context.startActivity(intent)
                return true
            }
        }
        loadDataWithBaseURL(null, html, "text/html", "utf-8", null)
    }

    override fun getView(): View = webView

    override fun dispose() = webView.destroy()
}

/** Opens a web source in her browser (no in-app browser, no extra dependency). */
fun openInBrowser(context: Context, url: String): Boolean {
    val uri = Uri.parse(url)
    if (uri.scheme != "https") return false
    context.startActivity(Intent(Intent.ACTION_VIEW, uri).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
    return true
}
