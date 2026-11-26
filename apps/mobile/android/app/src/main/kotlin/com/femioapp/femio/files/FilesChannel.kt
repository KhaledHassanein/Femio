// Draws her PDF documents and shares a document she chooses to send (R11.2, ADR-082 §2).
//
// Why it exists: a PDF is drawn here with Android's own PdfRenderer, so reading a report never
// hands it to another app. The plain copy PdfRenderer needs lives a moment in the app's private
// cache and is deleted at once. Sharing is her own act through the system sheet: the plain
// copy goes to a private cache folder that only the app she picks may read, through a
// FileProvider. The folder is emptied each time the app starts, and a copy older than a few
// minutes is deleted whenever she returns to femio or shares again (SEC-15): long enough for
// the app she picked to read it, short enough that a plain copy does not linger for days.
// No network, no permission.

package com.femioapp.femio.files

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.pdf.PdfRenderer
import android.os.Handler
import android.os.Looper
import android.os.ParcelFileDescriptor
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.util.concurrent.Executors

class FilesChannel(private val context: Context, messenger: BinaryMessenger, private val startActivity: (Intent) -> Unit) {
    private val channel = MethodChannel(messenger, "femio/files")
    private val worker = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())

    init {
        clearShared()
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "pdfPages" -> {
                    val bytes = call.argument<ByteArray>("bytes")
                    val width = call.argument<Int>("width") ?: DEFAULT_WIDTH
                    val maxPages = call.argument<Int>("maxPages") ?: DEFAULT_MAX_PAGES
                    if (bytes == null) {
                        result.error("bad_args", "bytes are required", null)
                    } else {
                        worker.execute {
                            val pages = try {
                                render(bytes, width, maxPages)
                            } catch (e: Exception) {
                                null
                            }
                            main.post {
                                if (pages == null) result.error("unreadable", "the PDF could not be drawn", null) else result.success(pages)
                            }
                        }
                    }
                }
                "share" -> {
                    val bytes = call.argument<ByteArray>("bytes")
                    val name = call.argument<String>("name")
                    val mime = call.argument<String>("mime")
                    if (bytes == null || name.isNullOrBlank() || mime.isNullOrBlank()) {
                        result.error("bad_args", "bytes, name and mime are required", null)
                    } else {
                        result.success(share(bytes, name, mime))
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    /** Draws up to [maxPages] pages of [bytes] at [width] pixels, as JPEG images. */
    private fun render(bytes: ByteArray, width: Int, maxPages: Int): List<ByteArray> {
        val dir = File(context.cacheDir, RENDER_DIR).apply { mkdirs() }
        val tmp = File.createTempFile("doc", ".pdf", dir)
        try {
            tmp.writeBytes(bytes)
            ParcelFileDescriptor.open(tmp, ParcelFileDescriptor.MODE_READ_ONLY).use { fd ->
                PdfRenderer(fd).use { renderer ->
                    val out = ArrayList<ByteArray>()
                    for (i in 0 until minOf(renderer.pageCount, maxPages)) {
                        renderer.openPage(i).use { page ->
                            val height = (width.toFloat() * page.height / page.width).toInt().coerceAtLeast(1)
                            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                            bitmap.eraseColor(Color.WHITE)
                            page.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY)
                            val stream = ByteArrayOutputStream()
                            bitmap.compress(Bitmap.CompressFormat.JPEG, JPEG_QUALITY, stream)
                            bitmap.recycle()
                            out.add(stream.toByteArray())
                        }
                    }
                    return out
                }
            }
        } finally {
            tmp.delete()
        }
    }

    /** Writes a plain copy to the private share folder and opens the system share sheet. */
    private fun share(bytes: ByteArray, name: String, mime: String): Boolean {
        clearStaleShares()
        val dir = File(context.cacheDir, SHARE_DIR).apply { mkdirs() }
        val safe = name.replace(Regex("[^\\p{L}\\p{N} ._-]"), "_").take(MAX_NAME).ifBlank { "document" }
        val file = File(dir, safe)
        file.writeBytes(bytes)
        val uri = FileProvider.getUriForFile(context, context.packageName + AUTHORITY_SUFFIX, file)
        val send = Intent(Intent.ACTION_SEND).apply {
            type = mime
            putExtra(Intent.EXTRA_STREAM, uri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        startActivity(Intent.createChooser(send, null).addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION))
        return true
    }

    /** Empties the share folder: a copy she sent lives only until the app next starts. */
    private fun clearShared() {
        File(context.cacheDir, SHARE_DIR).deleteRecursively()
        File(context.cacheDir, RENDER_DIR).deleteRecursively()
    }

    /**
     * Deletes shared copies older than [SHARE_KEEP_MS]. Called when femio returns to the front
     * and before each new share. A receiving app reads the file through the FileProvider while
     * the share sheet is open or soon after; a fresh copy is kept so a slow upload is not cut.
     */
    fun clearStaleShares() {
        val cutoff = System.currentTimeMillis() - SHARE_KEEP_MS
        File(context.cacheDir, SHARE_DIR).listFiles()?.forEach { if (it.lastModified() < cutoff) it.delete() }
        File(context.cacheDir, RENDER_DIR).listFiles()?.forEach { if (it.lastModified() < cutoff) it.delete() }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        worker.shutdown()
    }

    companion object {
        private const val SHARE_DIR = "shared"
        private const val RENDER_DIR = "render"
        private const val AUTHORITY_SUFFIX = ".files"
        private const val DEFAULT_WIDTH = 1200
        private const val DEFAULT_MAX_PAGES = 40
        private const val JPEG_QUALITY = 88
        private const val MAX_NAME = 80
        // Ten minutes: how long a shared plain copy may wait for the app she picked.
        private const val SHARE_KEEP_MS = 10 * 60 * 1000L
    }
}
