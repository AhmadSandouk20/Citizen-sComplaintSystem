import 'package:equatable/equatable.dart';

class AttachmentEntity extends Equatable {
  final int id;
  final String filePath;
  final String fileType;

  const AttachmentEntity({
    required this.id,
    required this.filePath,
    required this.fileType,
  });

  String get fileName {
    return Uri.parse(filePath).pathSegments.last;
  }

  bool get isImage {
    return fileType.startsWith('image/');
  }

  bool get isPdf {
    return fileType == 'application/pdf';
  }

  @override
  List<Object?> get props => [id, filePath, fileType];
}
