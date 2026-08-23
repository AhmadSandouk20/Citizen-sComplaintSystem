import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../models/attachment_model.dart';

class AttachmentGalleryRemoteDataSource {
  final Dio dio;

  AttachmentGalleryRemoteDataSource(this.dio);

  Future<List<AttachmentModel>> getComplaintAttachments({
    required int complaintId,
    required String token,
  }) async {
    final response = await dio.get(
      '${AppConfig.apiBaseUrl}/complaints/$complaintId',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;

    final attachmentsJson =
        data['attachments'] as List? ?? [];

    return attachmentsJson
        .map(
          (item) => AttachmentModel.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}
