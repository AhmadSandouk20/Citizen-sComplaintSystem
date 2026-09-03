import 'package:final_flutter/features/admin_reports/data/datasources/reports_remote_datasource.dart';
import 'package:final_flutter/features/admin_reports/domain/repositories/reports_repository.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl(this._remote);

  final ReportsRemoteDataSource _remote;

  @override
  Future<DownloadedReport> downloadComplaintsCsv() =>
      _remote.fetchComplaintsCsv();

  @override
  Future<DownloadedReport> downloadComplaintsPdf() =>
      _remote.fetchComplaintsPdf();

  @override
  Future<DownloadedReport> downloadStatisticsCsv() =>
      _remote.fetchStatisticsCsv();
}
