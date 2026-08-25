import 'package:final_flutter/features/admin_analytics/data/datasources/statistics_remote_datasource.dart';
import 'package:final_flutter/features/admin_analytics/domain/entities/statistics_entities.dart';
import 'package:final_flutter/features/admin_analytics/domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl(this._remote);

  final StatisticsRemoteDataSource _remote;

  @override
  Future<DashboardStatistics> getDashboard() async {
    final overallFuture = _remote.fetchOverall();
    final agenciesFuture = _remote.fetchByAgency();
    final byDateFuture = _remote.fetchByDate();
    final overall = await overallFuture;
    final agencies = List<AgencyStatistics>.from(await agenciesFuture);
    final byDate = await byDateFuture;
    agencies.sort((a, b) => b.resolutionRate.compareTo(a.resolutionRate));
    return DashboardStatistics(
      overall: overall,
      agencies: agencies,
      byDate: byDate,
    );
  }

  @override
  Future<PerformanceMetrics> getPerformance() => _remote.fetchPerformance();
}
