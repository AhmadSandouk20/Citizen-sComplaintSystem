import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../utils/file_url_builder.dart';

class AttachmentImageViewer extends StatelessWidget {
  final String path;

  const AttachmentImageViewer({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عرض الصورة')),
      body: PhotoView(
        imageProvider: NetworkImage(FileUrlBuilder.build(path)),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 4,
      ),
    );
  }
}
