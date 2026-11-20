package com.danialduke.danbudget

import android.app.Activity
import android.content.ContentValues
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader
import java.nio.charset.StandardCharsets

class MainActivity : FlutterFragmentActivity() {
    companion object {
        private const val CHANNEL = "com.danialduke.danbudget/backup_file"
        private const val REQ_CREATE_DOCUMENT = 9101
        private const val REQ_OPEN_DOCUMENT = 9102
    }

    private var pendingResult: MethodChannel.Result? = null
    private var pendingSaveContent: String? = null
    private var pendingFileName: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveToDownloadsFolder" -> {
                    val fileName = call.argument<String>("fileName") ?: "danbudget-backup.json"
                    val content = call.argument<String>("content") ?: ""
                    val subfolder = call.argument<String>("subfolder") ?: "DanBudget"
                    handleSaveToDownloads(fileName, content, subfolder, result)
                }
                "saveWithPicker" -> {
                    val fileName = call.argument<String>("fileName") ?: "danbudget-backup.json"
                    val content = call.argument<String>("content") ?: ""
                    launchCreateDocumentPicker(fileName, content, result)
                }
                "pickJsonFile" -> {
                    launchOpenDocumentPicker(result)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun handleSaveToDownloads(
        fileName: String,
        content: String,
        subfolder: String,
        result: MethodChannel.Result
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            var insertedUri: Uri? = null
            try {
                val relativePath = if (subfolder.isNotBlank()) {
                    "${Environment.DIRECTORY_DOWNLOADS}/$subfolder"
                } else {
                    Environment.DIRECTORY_DOWNLOADS
                }
                val values = ContentValues().apply {
                    put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                    put(MediaStore.MediaColumns.MIME_TYPE, "application/json")
                    put(MediaStore.MediaColumns.RELATIVE_PATH, relativePath)
                    put(MediaStore.MediaColumns.IS_PENDING, 1)
                }
                val resolver = applicationContext.contentResolver
                val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                    ?: throw IllegalStateException("Could not create file in Downloads/$subfolder")
                insertedUri = uri

                resolver.openOutputStream(uri)?.use { out ->
                    out.write(content.toByteArray(StandardCharsets.UTF_8))
                    out.flush()
                } ?: throw IllegalStateException("Could not open output stream for backup file")

                val doneValues = ContentValues().apply {
                    put(MediaStore.MediaColumns.IS_PENDING, 0)
                }
                resolver.update(uri, doneValues, null, null)

                val displayLocation = if (subfolder.isNotBlank()) {
                    "Downloads/$subfolder/$fileName"
                } else {
                    "Downloads/$fileName"
                }
                result.success(
                    mapOf(
                        "saved" to true,
                        "cancelled" to false,
                        "location" to displayLocation,
                        "uri" to uri.toString()
                    )
                )
            } catch (e: Exception) {
                insertedUri?.let { uri ->
                    try {
                        applicationContext.contentResolver.delete(uri, null, null)
                    } catch (_: Exception) {
                    }
                }
                result.error("SAVE_FAILED", e.message ?: "Failed to save backup file", null)
            }
        } else {
            // Android 6-9 (API 23-28): use Storage Access Framework so no storage permissions are needed.
            launchCreateDocumentPicker(fileName, content, result)
        }
    }

    private fun launchCreateDocumentPicker(
        fileName: String,
        content: String,
        result: MethodChannel.Result
    ) {
        if (pendingResult != null) {
            result.error("BUSY", "Another file operation is already in progress", null)
            return
        }
        pendingResult = result
        pendingSaveContent = content
        pendingFileName = fileName
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "application/json"
            putExtra(Intent.EXTRA_TITLE, fileName)
        }
        @Suppress("DEPRECATION")
        startActivityForResult(intent, REQ_CREATE_DOCUMENT)
    }

    private fun launchOpenDocumentPicker(result: MethodChannel.Result) {
        if (pendingResult != null) {
            result.error("BUSY", "Another file operation is already in progress", null)
            return
        }
        pendingResult = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(
                Intent.EXTRA_MIME_TYPES,
                arrayOf("application/json", "text/plain", "application/octet-stream")
            )
        }
        @Suppress("DEPRECATION")
        startActivityForResult(intent, REQ_OPEN_DOCUMENT)
    }

    @Deprecated("Required for FlutterFragmentActivity startActivityForResult compatibility")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode != REQ_CREATE_DOCUMENT && requestCode != REQ_OPEN_DOCUMENT) {
            super.onActivityResult(requestCode, resultCode, data)
            return
        }

        val resultCallback = pendingResult
        val contentToWrite = pendingSaveContent
        val fallbackName = pendingFileName
        pendingResult = null
        pendingSaveContent = null
        pendingFileName = null

        if (resultCallback == null) {
            super.onActivityResult(requestCode, resultCode, data)
            return
        }

        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            if (requestCode == REQ_CREATE_DOCUMENT) {
                resultCallback.success(mapOf("saved" to false, "cancelled" to true))
            } else {
                resultCallback.success(mapOf("picked" to false, "cancelled" to true))
            }
            return
        }

        val uri = data.data!!
        if (requestCode == REQ_CREATE_DOCUMENT) {
            try {
                contentResolver.openOutputStream(uri)?.use { out ->
                    out.write((contentToWrite ?: "").toByteArray(StandardCharsets.UTF_8))
                    out.flush()
                } ?: throw IllegalStateException("Could not open destination file")

                val displayName = queryDisplayName(uri) ?: fallbackName ?: "danbudget-backup.json"
                resultCallback.success(
                    mapOf(
                        "saved" to true,
                        "cancelled" to false,
                        "location" to displayName,
                        "uri" to uri.toString()
                    )
                )
            } catch (e: Exception) {
                resultCallback.error("SAVE_FAILED", e.message ?: "Failed to write backup file", null)
            }
        } else {
            try {
                val content = contentResolver.openInputStream(uri)?.use { stream ->
                    BufferedReader(InputStreamReader(stream, StandardCharsets.UTF_8)).readText()
                } ?: throw IllegalStateException("Could not read selected file")
                val displayName = queryDisplayName(uri) ?: "backup.json"
                resultCallback.success(
                    mapOf(
                        "picked" to true,
                        "cancelled" to false,
                        "fileName" to displayName,
                        "content" to content
                    )
                )
            } catch (e: Exception) {
                resultCallback.error("READ_FAILED", e.message ?: "Failed to read selected file", null)
            }
        }
    }

    private fun queryDisplayName(uri: Uri): String? {
        return try {
            contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val idx = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                    if (idx >= 0) cursor.getString(idx) else null
                } else {
                    null
                }
            }
        } catch (_: Exception) {
            null
        }
    }
}
