import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../core/constants/app_constants.dart';
import '../core/services/settings_service.dart';
import '../core/services/github_service.dart';
import '../core/services/download_service.dart';
import '../core/services/file_service.dart';
import '../core/services/game_launcher_service.dart';

enum LauncherState {
  initial,
  checking,
  downloading,
  ready,
  launching,
  error,
}

class LauncherProvider extends ChangeNotifier {
  final SettingsService _settingsService;
  final GitHubService _gitHubService = GitHubService();
  final DownloadService _downloadService = DownloadService();
  final FileService _fileService = FileService();
  final GameLauncherService _gameLauncherService = GameLauncherService();

  LauncherState _state = LauncherState.initial;
  String? _errorMessage;
  double _downloadProgress = 0.0;
  String _currentFile = '';
  bool _autoLaunch = false;
  String? _gameDirectory;
  String? _latestVersion;
  bool _showNotFoundModal = false;
  Timer? _checkingTimer;

  LauncherState get state => _state;
  String? get errorMessage => _errorMessage;
  double get downloadProgress => _downloadProgress;
  String get currentFile => _currentFile;
  bool get autoLaunch => _autoLaunch;
  String? get gameDirectory => _gameDirectory;
  String? get latestVersion => _latestVersion;
  String? get installedVersion => _settingsService.lastDownloadedVersion;
  bool get showNotFoundModal => _showNotFoundModal;

  LauncherProvider(this._settingsService) {
    _autoLaunch = _settingsService.autoLaunchOnFinish;
    _gameDirectory = _settingsService.gameDirectory;
  }

  Future<void> initialize() async {
    _gameDirectory = _settingsService.gameDirectory;

    if (_gameDirectory == null || !_fileService.validateGameDirectory(_gameDirectory!)) {
      final defaultPath = AppConstants.defaultGamePath;
      if (_fileService.validateGameDirectory(defaultPath)) {
        _gameDirectory = defaultPath;
        _settingsService.gameDirectory = defaultPath;
      } else {
        _showNotFoundModal = true;
        _state = LauncherState.error;
        _errorMessage = 'Jogo não encontrado';
        notifyListeners();
        return;
      }
    }

    _showNotFoundModal = false;
    await _checkForUpdates();
  }

  void _startCheckingAnimation() {
    _checkingTimer?.cancel();
    _downloadProgress = 0.0;
    _currentFile = 'Verificando atualização';
    notifyListeners();

    _checkingTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _downloadProgress += 0.02;
      if (_downloadProgress >= 1.0) {
        _downloadProgress = 1.0;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> _checkForUpdates() async {
    _state = LauncherState.checking;
    _errorMessage = null;
    _startCheckingAnimation();

    try {
      final release = await _gitHubService.getLatestRelease();
      _latestVersion = release.tagName;

      final lastVersion = _settingsService.lastDownloadedVersion;
      if (lastVersion == _latestVersion) {
        _checkingTimer?.cancel();
        _downloadProgress = 1.0;
        _currentFile = '';
        _state = LauncherState.ready;
        notifyListeners();
        if (_autoLaunch) {
          await launchGame();
        }
        return;
      }

      final assets = _gitHubService.getRequiredAssets(release);
      if (assets.length < 5) {
        throw Exception('Release não contém todos os arquivos necessários');
      }

      _checkingTimer?.cancel();
      _downloadProgress = 0.0;
      _state = LauncherState.downloading;
      notifyListeners();

      final tempDir = '${Directory.systemTemp.path}\\nte_launcher_temp';

      await _downloadService.downloadAssets(
        assets: assets,
        tempDir: tempDir,
        onProgress: (progress) {
          _downloadProgress = progress.progress;
          _currentFile = progress.currentFile;
          notifyListeners();
        },
      );

      await _fileService.copyFilesToGame(_gameDirectory!, tempDir);
      await _fileService.cleanupTemp(tempDir);

      _settingsService.lastDownloadedVersion = _latestVersion;
      _state = LauncherState.ready;
      notifyListeners();

      if (_autoLaunch) {
        await launchGame();
      }
    } catch (e) {
      _checkingTimer?.cancel();
      _state = LauncherState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> launchGame() async {
    if (_gameDirectory == null) return;

    _state = LauncherState.launching;
    notifyListeners();

    try {
      await _gameLauncherService.launch(_gameDirectory!);
    } catch (e) {
      _state = LauncherState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> selectGameDirectory() async {
    final result = await FilePicker.getDirectoryPath(
      dialogTitle: 'Selecione a pasta do jogo NTE',
    );

    if (result != null) {
      if (_fileService.validateGameDirectory(result)) {
        _gameDirectory = result;
        _settingsService.gameDirectory = result;
        _showNotFoundModal = false;
        notifyListeners();
        await _checkForUpdates();
        return true;
      } else {
        _errorMessage = 'Pasta inválida. NTEGlobalLauncher.exe não encontrado.';
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  void setAutoLaunch(bool value) {
    _autoLaunch = value;
    _settingsService.autoLaunchOnFinish = value;
    notifyListeners();
  }

  Future<void> removeTranslation() async {
    if (_gameDirectory == null) return;

    try {
      await _fileService.removeTranslation(_gameDirectory!);
      _settingsService.lastDownloadedVersion = null;
      _latestVersion = null;
      _state = LauncherState.ready;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao remover tradução: $e';
      notifyListeners();
    }
  }

  void dismissNotFoundModal() {
    _showNotFoundModal = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _checkingTimer?.cancel();
    super.dispose();
  }
}
