import 'package:flutter/material.dart';
import '../../providers/launcher_provider.dart';
import '../theme/app_theme.dart';

class ProgressPanel extends StatelessWidget {
  final double progress;
  final String currentFile;
  final bool autoLaunch;
  final ValueChanged<bool?> onAutoLaunchChanged;
  final LauncherState state;
  final String? installedVersion;
  final String? latestVersion;

  const ProgressPanel({
    super.key,
    required this.progress,
    required this.currentFile,
    required this.autoLaunch,
    required this.onAutoLaunchChanged,
    required this.state,
    this.installedVersion,
    this.latestVersion,
  });

  String get _title {
    switch (state) {
      case LauncherState.checking:
        return 'VERIFICANDO ATUALIZAÇÃO';
      case LauncherState.downloading:
        return 'BAIXANDO CONTEÚDO';
      case LauncherState.ready:
      case LauncherState.launching:
        return 'PRONTO';
      case LauncherState.initial:
      case LauncherState.error:
        return 'VERIFICANDO ATUALIZAÇÃO';
    }
  }

  String get _subtitle {
    switch (state) {
      case LauncherState.checking:
      case LauncherState.downloading:
        return 'Não feche o launcher durante o processo';
      case LauncherState.ready:
      case LauncherState.launching:
        return 'Tradução atualizada e pronta para jogar';
      case LauncherState.initial:
      case LauncherState.error:
        return 'Não feche o launcher durante o processo';
    }
  }

  String get _currentFileDisplay {
    if (state == LauncherState.checking || state == LauncherState.initial) {
      return 'Verificando...';
    }
    if (state == LauncherState.ready || state == LauncherState.launching) {
      return 'Concluído';
    }
    if (state == LauncherState.error) {
      return 'Erro';
    }
    return currentFile;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt().clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentFileDisplay,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: autoLaunch,
                  onChanged: onAutoLaunchChanged,
                  activeColor: AppColors.primary,
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Abrir o jogo quando terminar o download',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              if (installedVersion != null || latestVersion != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (installedVersion != null)
                      Text(
                        'Versão instalada: $installedVersion',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 11,
                        ),
                      ),
                    if (latestVersion != null)
                      Text(
                        'Última versão: $latestVersion',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
