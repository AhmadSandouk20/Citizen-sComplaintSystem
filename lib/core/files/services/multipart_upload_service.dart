import 'package:dio/dio.dart';

import '../models/selected_attachment.dart';

class MultipartUploadService {
  final Dio dio;

  MultipartUploadService(this.dio);

  Future<Response<dynamic>> upload({
    required String url,
    required String token,
    required List<SelectedAttachment> files,
    Map<String, dynamic>? fields,
    String fieldName = 'attachments[]',
    CancelToken? cancelToken,
    void Function(int sent, int total)?
    onSendProgress,
  }) async {
    final formData = FormData();

    if (fields != null) {
      for (final entry in fields.entries) {
        formData.fields.add(
          MapEntry(
            entry.key,
            entry.value.toString(),
          ),
        );
      }
    }

    for (final attachment in files) {
      formData.files.add(
        MapEntry(
          fieldName,
          await MultipartFile.fromFile(
            attachment.file.path,
            filename: attachment.name,
          ),
        ),
      );
    }

    return dio.post(
      url,
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}