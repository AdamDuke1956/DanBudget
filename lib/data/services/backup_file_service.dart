import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Result of exporting a JSON backup file to device storage.
class BackupFileSaveResult {
  final bool saved;
  final bool cancelled;
  final String? location;
  final String? uri;

  const BackupFileSaveResult({
    required this.saved,
    this.cancelled = false,
    this.location,
    this.uri,
  });
}

/// Result of picking and reading a JSON backup file from device storage.
class BackupFilePickResult {
  final bool picked;
  final bool cancelled;
  final String? fileName;
  final String? content;

  const BackupFilePickResult({
    required this.picked,
    this.cancelled = false,
    this.fileName,
    this.content,
  });
}

/// Cross-platform bridge for saving `.json` backups outside app-private storage
/// (so backups survive app uninstall) and importing `.json` files via system pickers.
abstract final class BackupFileService {
  static const MethodChannel channel = MethodChannel(
    'com.danialduke.danbudget/backup_file',
  );

  /// Generates a sortable, filesystem-safe backup filename.
  static String buildFileName([DateTime? timestamp]) {
    final dt = timestamp ?? DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    final date = '${dt.year}${two(dt.month)}${two(dt.day)}';
    final time = '${two(dt.hour)}${two(dt.minute)}${two(dt.second)}';
    return 'danbudget-backup-$date-$time.json';
  }

  /// Saves [jsonContent] into `Downloads/DanBudget/<fileName>` on Android 10+
  /// (or opens the system Save picker on older Android / falls back to Downloads on desktop).
  static Future<BackupFileSaveResult> saveToDownloadsFolder({
    required String jsonContent,
    String? fileName,
  }) async {
    final name = fileName ?? buildFileName();

    if (!kIsWeb && Platform.isAndroid) {
      final raw = await channel.invokeMapMethod<String, dynamic>(
        'saveToDownloadsFolder',
        {
          'fileName': name,
          'content': jsonContent,
          'subfolder': 'DanBudget',
        },
      );
      return _parseSaveResult(raw);
    }

    // Desktop / non-Android fallback: save inside <Downloads|Documents>/DanBudget.
    final baseDir =
        await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    final targetDir = Directory(p.join(baseDir.path, 'DanBudget'));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }
    final targetFile = File(p.join(targetDir.path, name));
    await targetFile.writeAsString(jsonContent, flush: true);
    return BackupFileSaveResult(
      saved: true,
      location: targetFile.path,
    );
  }

  /// Opens the Android system "Save as..." picker so the user can choose any folder.
  static Future<BackupFileSaveResult> saveWithPicker({
    required String jsonContent,
    String? fileName,
  }) async {
    final name = fileName ?? buildFileName();

    if (!kIsWeb && Platform.isAndroid) {
      final raw = await channel.invokeMapMethod<String, dynamic>(
        'saveWithPicker',
        {
          'fileName': name,
          'content': jsonContent,
        },
      );
      return _parseSaveResult(raw);
    }

    return saveToDownloadsFolder(jsonContent: jsonContent, fileName: name);
  }

  /// Opens the system file picker and reads the chosen `.json` backup file.
  static Future<BackupFilePickResult> pickJsonFile() async {
    if (!kIsWeb && Platform.isAndroid) {
      final raw = await channel.invokeMapMethod<String, dynamic>('pickJsonFile');
      return _parsePickResult(raw);
    }

    throw UnsupportedError(
      'File picker is supported on Android devices; paste JSON text below on this platform.',
    );
  }

  static BackupFileSaveResult _parseSaveResult(Map<String, dynamic>? raw) {
    if (raw == null) {
      return const BackupFileSaveResult(saved: false);
    }
    return BackupFileSaveResult(
      saved: raw['saved'] == true,
      cancelled: raw['cancelled'] == true,
      location: raw['location'] as String?,
      uri: raw['uri'] as String?,
    );
  }

  static BackupFilePickResult _parsePickResult(Map<String, dynamic>? raw) {
    if (raw == null) {
      return const BackupFilePickResult(picked: false);
    }
    return BackupFilePickResult(
      picked: raw['picked'] == true,
      cancelled: raw['cancelled'] == true,
      fileName: raw['fileName'] as String?,
      content: raw['content'] as String?,
    );
  }
}
