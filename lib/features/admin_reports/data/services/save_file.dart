import 'package:final_flutter/features/admin_reports/data/services/save_file_stub.dart'
    if (dart.library.html) 'package:final_flutter/features/admin_reports/data/services/save_file_web.dart'
    if (dart.library.io) 'package:final_flutter/features/admin_reports/data/services/save_file_io.dart'
    as impl;

Future<String> saveFileBytes({
  required List<int> bytes,
  required String filename,
  required String mimeType,
}) {
  return impl.saveFileBytes(
    bytes: bytes,
    filename: filename,
    mimeType: mimeType,
  );
}
