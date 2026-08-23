import 'package:flutter/material.dart';

import '../../../../core/files/models/selected_attachment.dart';

class AttachmentFileList extends StatelessWidget {
  final List<SelectedAttachment> files;
  final void Function(
      SelectedAttachment attachment,
      ) onRemove;

  const AttachmentFileList({
    super.key,
    required this.files,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return const Text(
        'لم يتم اختيار أي مرفقات',
      );
    }

    return Column(
      children: files.map((attachment) {
        return Card(
          child: ListTile(
            leading: Icon(
              attachment.isPdf
                  ? Icons.picture_as_pdf_outlined
                  : attachment.isImage
                  ? Icons.image_outlined
                  : Icons.insert_drive_file_outlined,
            ),
            title: Text(
              attachment.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              _formatSize(
                attachment.size,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                onRemove(attachment);
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}