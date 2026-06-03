import 'dart:io';
import '../constants/app_constants.dart';

class FileService {
  bool validateGameDirectory(String path) {
    final exePath = '$path\\${AppConstants.gameExeName}';
    return File(exePath).existsSync();
  }

  Future<void> copyFilesToGame(String gameDir, String tempDir) async {
    final binTarget = '$gameDir\\${AppConstants.binRelativePath}';
    final pakTarget = '$gameDir\\${AppConstants.pakRelativePath}';

    await Directory(binTarget).create(recursive: true);
    await Directory(pakTarget).create(recursive: true);

    for (final fileName in AppConstants.binFiles) {
      final source = '$tempDir\\$fileName';
      final destination = '$binTarget\\$fileName';
      if (File(source).existsSync()) {
        await File(source).copy(destination);
      }
    }

    for (final fileName in AppConstants.pakFiles) {
      final source = '$tempDir\\$fileName';
      final destination = '$pakTarget\\$fileName';
      if (File(source).existsSync()) {
        await File(source).copy(destination);
      }
    }
  }

  Future<void> removeTranslation(String gameDir) async {
    final binTarget = '$gameDir\\${AppConstants.binRelativePath}';
    final pakTarget = '$gameDir\\${AppConstants.pakRelativePath}';

    for (final fileName in AppConstants.binFiles) {
      final file = File('$binTarget\\$fileName');
      if (await file.exists()) {
        await file.delete();
      }
    }

    for (final fileName in AppConstants.pakFiles) {
      final file = File('$pakTarget\\$fileName');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<void> cleanupTemp(String tempDir) async {
    final dir = Directory(tempDir);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  int getInstalledVersion(String gameDir) {
    final pakFile = File('$gameDir\\${AppConstants.pakRelativePath}\\pakchunk999-Windows_999_P.utoc');
    if (pakFile.existsSync()) {
      return pakFile.lastModifiedSync().millisecondsSinceEpoch;
    }
    return 0;
  }
}
