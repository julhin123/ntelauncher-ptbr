import 'dart:io';
import '../constants/app_constants.dart';

class GameLauncherService {
  Future<void> launch(String gameDir) async {
    final exePath = '$gameDir\\${AppConstants.gameExeName}';
    final file = File(exePath);

    if (!await file.exists()) {
      throw Exception('Executável não encontrado: $exePath');
    }

    await Process.start(
      exePath,
      [],
      workingDirectory: gameDir,
      mode: ProcessStartMode.detached,
    );
  }
}
