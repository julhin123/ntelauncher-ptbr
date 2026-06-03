import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/window_service.dart';
import '../../providers/launcher_provider.dart';
import '../widgets/custom_window_bar.dart';
import '../widgets/play_button.dart';
import '../widgets/progress_panel.dart';
import '../widgets/footer_warning.dart';
import '../widgets/game_not_found_modal.dart';
import '../widgets/settings_modal.dart';
import '../widgets/translation_removed_modal.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  final WindowService _windowService = WindowService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LauncherProvider>().initialize();
    });
  }

  void _showSettingsModal() {
    final provider = context.read<LauncherProvider>();

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => SettingsModal(
        onChangeDirectory: () async {
          final success = await provider.selectGameDirectory();
          if (!success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pasta inválida. NTEGlobalLauncher.exe não encontrado.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        onRemoveTranslation: () {
          Navigator.of(context).pop();
          _showRemoveConfirmDialog();
        },
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showRemoveConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remover Tradução?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Isso removerá todos os arquivos da tradução PT-BR do jogo. Deseja continuar?',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await context.read<LauncherProvider>().removeTranslation();
              if (mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => TranslationRemovedModal(
                    onDismiss: () => Navigator.of(context).pop(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remover',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LauncherProvider>(
      builder: (context, provider, _) {
        if (provider.showNotFoundModal) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.black.withValues(alpha: 0.7),
              builder: (_) => GameNotFoundModal(
                onSelectDirectory: () {
                  Navigator.of(context).pop();
                  provider.selectGameDirectory();
                },
                onDismiss: () {
                  Navigator.of(context).pop();
                  provider.dismissNotFoundModal();
                },
              ),
            );
          });
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  CustomWindowBar(
                    windowService: _windowService,
                    onSettingsPressed: _showSettingsModal,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 160,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 40,
                right: 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ProgressPanel(
                            progress: provider.downloadProgress,
                            currentFile: provider.currentFile,
                            autoLaunch: provider.autoLaunch,
                            onAutoLaunchChanged: (value) {
                              provider.setAutoLaunch(value ?? false);
                            },
                            state: provider.state,
                            installedVersion: provider.installedVersion,
                            latestVersion: provider.latestVersion,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Center(
                          child: PlayButton(
                            isEnabled: provider.state != LauncherState.checking && provider.state != LauncherState.downloading,
                            onPressed: provider.state != LauncherState.checking && provider.state != LauncherState.downloading
                                ? () => provider.launchGame()
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 2,
                      color: const Color(0xFF26294C),
                    ),
                    const SizedBox(height: 4),
                    const FooterWarning(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
