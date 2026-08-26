import 'package:flutter/material.dart';

import '../../../../../core/files/models/selected_attachment.dart';

class ComplaintAttachmentsStep extends StatelessWidget {
  final List<SelectedAttachment> attachments;
  final VoidCallback onPickFiles;
  final VoidCallback onPickGallery;
  final VoidCallback onTakePhoto;
  final ValueChanged<SelectedAttachment> onRemove;

  const ComplaintAttachmentsStep({
    super.key,
    required this.attachments,
    required this.onPickFiles,
    required this.onPickGallery,
    required this.onTakePhoto,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'المرفقات',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('يمكنك إضافة صور أو ملفات تدعم الشكوى'),
        const SizedBox(height: 24),

        OutlinedButton.icon(
          onPressed: onTakePhoto,
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('التقاط صورة'),
        ),
        const SizedBox(height: 10),

        OutlinedButton.icon(
          onPressed: onPickGallery,
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('اختيار من المعرض'),
        ),
        const SizedBox(height: 10),

        OutlinedButton.icon(
          onPressed: onPickFiles,
          icon: const Icon(Icons.attach_file),
          label: const Text('اختيار ملفات'),
        ),
        const SizedBox(height: 24),

        if (attachments.isEmpty)
          const _EmptyAttachments()
        else ...[
          Text(
            'المرفقات المختارة (${attachments.length})',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          ...attachments.map(
            (attachment) => _AttachmentItem(
              attachment: attachment,
              onRemove: () {
                onRemove(attachment);
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyAttachments extends StatelessWidget {
  const _EmptyAttachments();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.attach_file, size: 40),
          SizedBox(height: 8),
          Text('لم تتم إضافة مرفقات'),
          SizedBox(height: 4),
          Text('إضافة المرفقات اختيارية'),
        ],
      ),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final SelectedAttachment attachment;
  final VoidCallback onRemove;

  const _AttachmentItem({required this.attachment, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(_getIcon()),
        title: Text(
          attachment.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(_formatFileSize(attachment.size)),
        trailing: IconButton(
          onPressed: onRemove,
          tooltip: 'حذف المرفق',
          icon: const Icon(Icons.close),
        ),
      ),
    );
  }

  IconData _getIcon() {
    final extension = attachment.extension.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Icons.image_outlined;
    }

    if (extension == 'pdf') {
      return Icons.picture_as_pdf_outlined;
    }

    return Icons.insert_drive_file_outlined;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes بايت';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} كيلوبايت';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} ميغابايت';
  }
}
