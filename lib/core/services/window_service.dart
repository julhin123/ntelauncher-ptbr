import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../constants/app_constants.dart';

class WindowService {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(AppConstants.windowWidth, AppConstants.windowHeight),
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setResizable(false);
      await windowManager.setMinimumSize(
        const Size(AppConstants.windowWidth, AppConstants.windowHeight),
      );
      await windowManager.setMaximumSize(
        const Size(AppConstants.windowWidth, AppConstants.windowHeight),
      );
      await windowManager.show();
      await windowManager.focus();
    });
  }

  Future<void> minimize() async {
    await windowManager.minimize();
  }

  Future<void> close() async {
    await windowManager.close();
  }
}
