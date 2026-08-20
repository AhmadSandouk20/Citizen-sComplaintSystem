import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../config/app_config.dart';

class FileService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<List<File>> pickFiles({
    bool allowMultiple = true,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
      ],
    );

    if (result == null) {
      return [];
    }

    final files = <File>[];

    for (final platformFile in result.files) {
      final path = platformFile.path;

      if (path == null) {
        continue;
      }

      final file = File(path);

      _validateFileSize(file);

      files.add(file);
    }

    return files;
  }

  Future<File?> pickImageFromGallery() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return null;
    }

    final file = File(image.path);

    _validateFileSize(file);

    return _compressImage(file);
  }

  Future<File?> takePhoto() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (image == null) {
      return null;
    }

    final file = File(image.path);

    _validateFileSize(file);

    return _compressImage(file);
  }

  Future<File> _compressImage(File file) async {
    final extension = p.extension(file.path);

    final targetPath =
        '${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}_compressed$extension';

    final compressedFile =
    await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: AppConfig.imageQuality,
    );

    if (compressedFile == null) {
      return file;
    }

    final result = File(compressedFile.path);

    _validateFileSize(result);

    return result;
  }

  void _validateFileSize(File file) {
    final fileSize = file.lengthSync();

    if (fileSize > AppConfig.maxAttachmentSizeInBytes) {
      throw Exception(
        'File size must not exceed 10 MB.',
      );
    }
  }
}