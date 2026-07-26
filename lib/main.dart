import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/settings_service.dart';
import 'core/services/trusted_certificates_service.dart';
import 'core/services/window_service.dart';
import 'providers/launcher_provider.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/launcher_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TrustedCertificatesService.initialize();

  final windowService = WindowService();
  await windowService.init();

  final settingsService = SettingsService();
  await settingsService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LauncherProvider(settingsService),
        ),
        Provider.value(value: windowService),
      ],
      child: const NteLauncherApp(),
    ),
  );
}

class NteLauncherApp extends StatelessWidget {
  const NteLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NTE PT-BR Launcher',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LauncherScreen(),
    );
  }
}
