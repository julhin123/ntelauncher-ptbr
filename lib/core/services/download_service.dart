import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'github_service.dart';
import 'trusted_certificates_service.dart';

class DownloadProgress {
  final double progress;
  final String currentFile;
  final int downloadedBytes;
  final int totalBytes;

  DownloadProgress({
    required this.progress,
    required this.currentFile,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
  });
}

class DownloadService {
  final Dio _dio = _createDio();

  static Dio _createDio() {
    final dio = Dio();
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: TrustedCertificatesService.createHttpClient,
    );
    return dio;
  }

  Future<void> downloadAssets({
    required List<GitHubAsset> assets,
    required String tempDir,
    required void Function(DownloadProgress progress) onProgress,
  }) async {
    final tempDirectory = Directory(tempDir);
    if (!await tempDirectory.exists()) {
      await tempDirectory.create(recursive: true);
    }

    int totalSize = assets.fold(0, (sum, a) => sum + a.size);
    int downloadedSize = 0;

    for (int i = 0; i < assets.length; i++) {
      final asset = assets[i];
      final filePath = '$tempDir\\${asset.name}';

      onProgress(DownloadProgress(
        progress: downloadedSize / totalSize,
        currentFile: asset.name,
        downloadedBytes: downloadedSize,
        totalBytes: totalSize,
      ));

      await _dio.download(
        asset.browserDownloadUrl,
        filePath,
        onReceiveProgress: (received, total) {
          final currentProgress = (downloadedSize + received) / totalSize;
          onProgress(DownloadProgress(
            progress: currentProgress.clamp(0.0, 1.0),
            currentFile: asset.name,
            downloadedBytes: downloadedSize + received,
            totalBytes: totalSize,
          ));
        },
      );

      downloadedSize += asset.size;
    }

    onProgress(DownloadProgress(
      progress: 1.0,
      currentFile: '',
      downloadedBytes: totalSize,
      totalBytes: totalSize,
    ));
  }
}
