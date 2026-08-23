import 'dart:io';

class SelectedAttachment {
  final File file;
  final String name;
  final int size;

  const SelectedAttachment({
    required this.file,
    required this.name,
    required this.size,
  });

  String get extension {
    final parts = name.toLowerCase().split('.');

    if (parts.length < 2) {
      return '';
    }

    return parts.last;
  }

  bool get isImage {
    return [
      'jpg',
      'jpeg',
      'png',
      'webp',
    ].contains(extension);
  }

  bool get isPdf => extension == 'pdf';
}