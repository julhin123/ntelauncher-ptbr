import 'dart:io';

import 'package:flutter/services.dart';

class TrustedCertificatesService {
  static const _bundlePath = 'assets/certificates/cacert.pem';
  static Uint8List? _certificateBytes;

  static Future<void> initialize() async {
    final data = await rootBundle.load(_bundlePath);
    _certificateBytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
  }

  static HttpClient createHttpClient() {
    final certificateBytes = _certificateBytes;
    if (certificateBytes == null) {
      throw StateError(
        'TrustedCertificatesService.initialize() não foi executado.',
      );
    }

    final context = SecurityContext(withTrustedRoots: true);
    context.setTrustedCertificatesBytes(certificateBytes);
    return HttpClient(context: context);
  }
}
