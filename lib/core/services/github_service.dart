import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class GitHubRelease {
  final String tagName;
  final String name;
  final List<GitHubAsset> assets;

  GitHubRelease({
    required this.tagName,
    required this.name,
    required this.assets,
  });

  factory GitHubRelease.fromJson(Map<String, dynamic> json) {
    return GitHubRelease(
      tagName: json['tag_name'] as String,
      name: json['name'] as String,
      assets: (json['assets'] as List)
          .map((a) => GitHubAsset.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GitHubAsset {
  final String name;
  final String browserDownloadUrl;
  final int size;

  GitHubAsset({
    required this.name,
    required this.browserDownloadUrl,
    required this.size,
  });

  factory GitHubAsset.fromJson(Map<String, dynamic> json) {
    return GitHubAsset(
      name: json['name'] as String,
      browserDownloadUrl: json['browser_download_url'] as String,
      size: json['size'] as int,
    );
  }
}

class GitHubService {
  Future<GitHubRelease> getLatestRelease() async {
    final response = await http.get(
      Uri.parse(AppConstants.githubApiUrl),
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar release: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return GitHubRelease.fromJson(json);
  }

  List<GitHubAsset> getRequiredAssets(GitHubRelease release) {
    final requiredNames = [
      ...AppConstants.binFiles,
      ...AppConstants.pakFiles,
    ];

    return release.assets
        .where((asset) => requiredNames.contains(asset.name))
        .toList();
  }
}
