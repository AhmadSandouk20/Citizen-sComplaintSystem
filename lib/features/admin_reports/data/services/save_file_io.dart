import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> saveFileBytes({
  required List<int> bytes,
  required String filename,
  required String mimeType,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}
