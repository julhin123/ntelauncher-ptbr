class AppConstants {
  static const String defaultGamePath = r'C:\Program Files\Neverness To Everness';
  static const String gameExeName = 'NTEGlobalLauncher.exe';
  static const String githubOwner = 'Luxx34';
  static const String githubRepo = 'nte-pt-br';
  static const String githubApiUrl = 'https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest';

  static const String launcherGithubOwner = 'julhin123';
  static const String launcherGithubRepo = 'ntelauncher-ptbr';
  static const String launcherGithubApiUrl = 'https://api.github.com/repos/$launcherGithubOwner/$launcherGithubRepo/releases/latest';
  static const String launcherReleasesPageUrl = 'https://github.com/$launcherGithubOwner/$launcherGithubRepo/releases/latest';
  static const String translationRepoUrl = 'https://github.com/$githubOwner/$githubRepo';
  static const String launcherRepoUrl = 'https://github.com/$launcherGithubOwner/$launcherGithubRepo';

  static const List<String> binFiles = [
    'UniversalSigBypasser.asi',
    'version.dll',
  ];

  static const List<String> pakFiles = [
    'pakchunk999-Windows_999_P.utoc',
    'pakchunk999-Windows_999_P.pak',
    'pakchunk999-Windows_999_P.ucas',
  ];

  static const String binRelativePath = r'Client\WindowsNoEditor\HT\Binaries\Win64';
  static const String pakRelativePath = r'Client\WindowsNoEditor\HT\Content\Paks';

  static const double windowWidth = 1280;
  static const double windowHeight = 720;
}
