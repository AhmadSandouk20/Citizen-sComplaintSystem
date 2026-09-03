// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// import '../../utils/file_url_builder.dart';

// class CachedAttachmentImage extends StatelessWidget {
//   final String path;
//   final BoxFit fit;

//   const CachedAttachmentImage({
//     super.key,
//     required this.path,
//     this.fit = BoxFit.cover,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       imageUrl: FileUrlBuilder.build(path),
//       fit: fit,
//       placeholder: (_, _) {
//         return const Center(child: CircularProgressIndicator());
//       },
//       errorWidget: (_, _, _) {
//         return const Center(child: Icon(Icons.broken_image_outlined));
//       },
//     );
//   }
// }
