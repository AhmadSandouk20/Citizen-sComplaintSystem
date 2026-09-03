// import 'package:flutter/material.dart';

// import '../../../../core/files/widgets/attachment_image_viewer.dart';
// import '../../../../core/files/widgets/attachment_pdf_viewer.dart';
// import '../../../../core/files/widgets/cached_attachment_image.dart';
// import '../../domain/entities/attachment_entity.dart';

// class AttachmentGallery extends StatelessWidget {
//   final List<AttachmentEntity> attachments;

//   const AttachmentGallery({super.key, required this.attachments});

//   @override
//   Widget build(BuildContext context) {
//     if (attachments.isEmpty) {
//       return const Center(child: Text('لا توجد مرفقات'));
//     }

//     return ListView.separated(
//       padding: const EdgeInsets.all(16),
//       itemCount: attachments.length,
//       separatorBuilder: (_, _) {
//         return const SizedBox(height: 12);
//       },
//       itemBuilder: (context, index) {
//         final attachment = attachments[index];

//         if (attachment.isImage) {
//           return _ImageAttachmentCard(attachment: attachment);
//         }

//         if (attachment.isPdf) {
//           return _PdfAttachmentCard(attachment: attachment);
//         }

//         return _UnknownAttachmentCard(attachment: attachment);
//       },
//     );
//   }
// }

// class _ImageAttachmentCard extends StatelessWidget {
//   final AttachmentEntity attachment;

//   const _ImageAttachmentCard({required this.attachment});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => AttachmentImageViewer(path: attachment.filePath),
//           ),
//         );
//       },
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: SizedBox(
//                   height: 180,
//                   width: double.infinity,
//                   child: CachedAttachmentImage(path: attachment.filePath),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 attachment.fileName,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _PdfAttachmentCard extends StatelessWidget {
//   final AttachmentEntity attachment;

//   const _PdfAttachmentCard({required this.attachment});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         leading: const Icon(Icons.picture_as_pdf_outlined, size: 36),
//         title: Text(
//           attachment.fileName,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         subtitle: const Text('ملف PDF'),
//         trailing: const Icon(Icons.open_in_new),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AttachmentPdfViewer(path: attachment.filePath),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _UnknownAttachmentCard extends StatelessWidget {
//   final AttachmentEntity attachment;

//   const _UnknownAttachmentCard({required this.attachment});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         leading: const Icon(Icons.insert_drive_file_outlined),
//         title: Text(
//           attachment.fileName,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         subtitle: const Text('نوع ملف غير مدعوم للمعاينة'),
//       ),
//     );
//   }
// }
