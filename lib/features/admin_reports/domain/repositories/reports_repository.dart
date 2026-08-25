class DownloadedReport {
  const DownloadedReport({
    required this.bytes,
    required this.filename,
    required this.mimeType,
  });

  final List<int> bytes;
  final String filename;
  final String mimeType;
}

abstract class ReportsRepository {
  Future<DownloadedReport> downloadComplaintsCsv();
  Future<DownloadedReport> downloadComplaintsPdf();
  Future<DownloadedReport> downloadStatisticsCsv();
}
