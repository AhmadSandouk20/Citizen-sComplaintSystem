import 'package:flutter/material.dart';

class AttachmentPickerButtons extends StatelessWidget {
  final VoidCallback onFiles;
  final VoidCallback onGallery;
  final VoidCallback onCamera;

  const AttachmentPickerButtons({
    super.key,
    required this.onFiles,
    required this.onGallery,
    required this.onCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: onFiles,
          icon: const Icon(Icons.attach_file),
          label: const Text('اختيار ملفات'),
        ),
        ElevatedButton.icon(
          onPressed: onGallery,
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('المعرض'),
        ),
        ElevatedButton.icon(
          onPressed: onCamera,
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('الكاميرا'),
        ),
      ],
    );
  }
}