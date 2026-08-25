import 'package:dio/dio.dart';
import 'package:final_flutter/core/network/dio_client.dart';
import 'package:final_flutter/features/admin_reports/domain/repositories/reports_repository.dart';

class ReportsRemoteDataSource {
  ReportsRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<DownloadedReport> fetchComplaintsCsv() {
    return _download(
      '/reports/complaints/csv',
      'complaints.csv',
      'text/csv',
    );
  }

  Future<DownloadedReport> fetchComplaintsPdf() {
    return _download(
      '/reports/complaints/pdf',
      'complaints.pdf',
      'application/pdf',
    );
  }

  Future<DownloadedReport> fetchStatisticsCsv() {
    return _download(
      '/reports/statistics/csv',
      'statistics.csv',
      'text/csv',
    );
  }

  Future<DownloadedReport> _download(
    String path,
    String fallbackName,
    String fallbackMime,
  ) async {
    try {
      final response = await _dioClient.client.get<List<int>>(
        path,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60),
          headers: const {'Accept': '*/*'},
        ),
      );
      final bytes = response.data ?? const <int>[];
      final disposition = response.headers.value('content-disposition');
      final mime = response.headers.value('content-type') ?? fallbackMime;
      return DownloadedReport(
        bytes: bytes,
        filename: _filenameFrom(disposition, fallbackName),
        mimeType: mime.split(';').first,
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  String _filenameFrom(String? disposition, String fallback) {
    if (disposition == null || disposition.isEmpty) return fallback;
    final match = RegExp(r'filename="?([^";]+)"?').firstMatch(disposition);
    return match?.group(1) ?? fallback;
  }
}
