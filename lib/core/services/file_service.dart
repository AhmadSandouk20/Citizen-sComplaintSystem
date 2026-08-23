import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../config/app_config.dart';

/// One attachment chosen by the user, held as bytes.
///
/// Bytes rather than a `File`: on Flutter Web `PlatformFile.path` is always
/// null, so a `dart:io` based picker silently returns nothing there. The web
/// dashboard needs attachments too, so the whole service is byte-based and
/// `dart:io` is never imported.
class PickedAttachment {
  const PickedAttachment({
    required this.name,
    required this.bytes,
    this.path,
  });

  final String name;
  final Uint8List bytes;

  /// Original path on mobile/desktop; null on the web.
  final String? path;

  int get sizeInBytes => bytes.lengthInBytes;

  String get extension => p.extension(name).replaceFirst('.', '').toLowerCase();

  /// Ready to drop into a `FormData` for `POST /complaints/{id}/attachments`.
  /// Built from bytes so the same call works on mobile and on the web.
  MultipartFile toMultipartFile() =>
      MultipartFile.fromBytes(bytes, filename: name);

  bool get isImage => const {
    'jpg',
    'jpeg',
    'png',
    'webp',
  }.contains(extension);

  bool get isWithinSizeLimit =>
      sizeInBytes <= AppConfig.maxAttachmentSizeInBytes;
}

/// Outcome of a pick: what was accepted, and what was rejected and why.
///
/// The previous version threw on the first oversized file, which aborted a
/// whole multi-file selection because of one bad item.
class PickResult {
  const PickResult({required this.accepted, required this.rejected});

  final List<PickedAttachment> accepted;

  /// File names that exceeded the size limit even after compression.
  final List<String> rejected;

  bool get hasRejections => rejected.isNotEmpty;
}

class FileService {
  FileService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'pdf',
  ];

  /// Opens the system file picker. Works on mobile and on the web.
  Future<PickResult> pickFiles({bool allowMultiple = true}) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      // Required for the web, where there is no path to read from.
      withData: true,
    );

    if (result == null) return const PickResult(accepted: [], rejected: []);

    final accepted = <PickedAttachment>[];
    final rejected = <String>[];

    for (final file in result.files) {
      final bytes = file.bytes;
      if (bytes == null) {
        rejected.add(file.name);
        continue;
      }

      var attachment = PickedAttachment(
        name: file.name,
        bytes: bytes,
        path: file.path,
      );

      // Compress first, then check the limit — the old order rejected a 12 MB
      // photo instead of shrinking it under 10 MB, which defeated the point.
      if (attachment.isImage && !attachment.isWithinSizeLimit) {
        attachment = await _compress(attachment);
      }

      if (attachment.isWithinSizeLimit) {
        accepted.add(attachment);
      } else {
        rejected.add(attachment.name);
      }
    }

    return PickResult(accepted: accepted, rejected: rejected);
  }

  Future<PickedAttachment?> pickImageFromGallery() =>
      _pickImage(ImageSource.gallery);

  Future<PickedAttachment?> takePhoto() => _pickImage(ImageSource.camera);

  Future<PickedAttachment?> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: AppConfig.imageQuality,
    );
    if (image == null) return null;

    final picked = PickedAttachment(
      name: image.name,
      bytes: await image.readAsBytes(),
      path: kIsWeb ? null : image.path,
    );

    return picked.isWithinSizeLimit ? picked : _compress(picked);
  }

  /// Re-encodes an image at [AppConfig.imageQuality].
  /// Returns the original untouched if compression is unavailable or fails.
  Future<PickedAttachment> _compress(PickedAttachment attachment) async {
    if (kIsWeb) return attachment; // Plugin has no web implementation.

    // The encoder defaults to JPEG. Without pinning the format a `.png` file
    // would come back as JPEG bytes still named `.png`, and the backend
    // validates the extension against the content.
    final format = switch (attachment.extension) {
      'png' => CompressFormat.png,
      'webp' => CompressFormat.webp,
      _ => CompressFormat.jpeg,
    };

    try {
      final compressed = await FlutterImageCompress.compressWithList(
        attachment.bytes,
        quality: AppConfig.imageQuality,
        format: format,
      );
      if (compressed.isEmpty) return attachment;

      return PickedAttachment(
        name: attachment.name,
        bytes: compressed,
        path: attachment.path,
      );
    } catch (_) {
      return attachment;
    }
  }
}
