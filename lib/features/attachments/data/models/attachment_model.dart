import '../../domain/entities/attachment_entity.dart';

class AttachmentModel extends AttachmentEntity {
  const AttachmentModel({
    required super.id,
    required super.filePath,
    required super.fileType,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as int,
      filePath: json['file_path'] as String? ?? '',
      fileType: json['file_type'] as String? ?? '',
    );
  }
}
