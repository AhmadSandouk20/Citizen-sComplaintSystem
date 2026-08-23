import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../config/app_config.dart';
import '../models/selected_attachment.dart';

class AttachmentPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<List<SelectedAttachment>> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'pdf',
      ],
    );

    if (result == null) {
      return [];
    }

    final attachments = <SelectedAttachment>[];

    for (final selectedFile in result.files) {
      final path = selectedFile.path;

      if (path == null) {
        continue;
      }

      final attachment = await _prepareFile(
        File(path),
      );

      attachments.add(attachment);
    }

    return attachments;
  }

  Future<List<SelectedAttachment>>
  pickImagesFromGallery() async {
    final images =
    await _imagePicker.pickMultiImage();

    if (images.isEmpty) {
      return [];
    }

    final attachments = <SelectedAttachment>[];

    for (final image in images) {
      final attachment = await _prepareFile(
        File(image.path),
      );

      attachments.add(attachment);
    }

    return attachments;
  }

  Future<SelectedAttachment?> takePhoto() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (image == null) {
      return null;
    }

    return _prepareFile(
      File(image.path),
    );
  }

  Future<SelectedAttachment> _prepareFile(
      File file,
      ) async {
    File preparedFile = file;

    if (_isImage(file.path)) {
      preparedFile = await _compressImage(file);
    }

    final size = await preparedFile.length();

    if (size >
        AppConfig.maxAttachmentSizeInBytes) {
      throw Exception(
        'حجم الملف يجب ألا يتجاوز 10 ميغابايت',
      );
    }

    return SelectedAttachment(
      file: preparedFile,
      name: p.basename(preparedFile.path),
      size: size,
    );
  }

  Future<File> _compressImage(File file) async {
    final temporaryDirectory =
    await getTemporaryDirectory();

    final extension =
    p.extension(file.path).toLowerCase();

    final targetPath = p.join(
      temporaryDirectory.path,
      '${DateTime.now().microsecondsSinceEpoch}'
          '_compressed$extension',
    );

    final compressed =
    await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: AppConfig.imageQuality,
    );

    if (compressed == null) {
      return file;
    }

    return File(compressed.path);
  }

  bool _isImage(String path) {
    final extension =
    p.extension(path).toLowerCase();

    return [
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
    ].contains(extension);
  }
}