import 'package:final_flutter/features/admin_analytics/domain/entities/statistics_entities.dart';

abstract class StatisticsRepository {
  Future<DashboardStatistics> getDashboard();
  Future<PerformanceMetrics> getPerformance();
}
