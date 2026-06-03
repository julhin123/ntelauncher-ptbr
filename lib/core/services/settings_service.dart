import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String _boxName = 'launcher_settings';
  static const String _keyGameDir = 'gameDirectory';
  static const String _keyLastVersion = 'lastDownloadedVersion';
  static const String _keyAutoLaunch = 'autoLaunchOnFinish';

  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  String? get gameDirectory => _box.get(_keyGameDir) as String?;
  set gameDirectory(String? value) {
    if (value == null) {
      _box.delete(_keyGameDir);
    } else {
      _box.put(_keyGameDir, value);
    }
  }

  String? get lastDownloadedVersion => _box.get(_keyLastVersion) as String?;
  set lastDownloadedVersion(String? value) {
    if (value == null) {
      _box.delete(_keyLastVersion);
    } else {
      _box.put(_keyLastVersion, value);
    }
  }

  bool get autoLaunchOnFinish => _box.get(_keyAutoLaunch, defaultValue: false) as bool;
  set autoLaunchOnFinish(bool value) => _box.put(_keyAutoLaunch, value);
}
