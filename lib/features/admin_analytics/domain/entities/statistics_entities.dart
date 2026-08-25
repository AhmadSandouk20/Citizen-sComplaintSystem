class OverallStatistics {
  const OverallStatistics({
    required this.totalComplaints,
    required this.resolvedCount,
    required this.resolutionRate,
    required this.byStatus,
    required this.byPriority,
    this.avgResolutionHours,
  });

  final int totalComplaints;
  final int resolvedCount;
  final double resolutionRate;
  final Map<String, int> byStatus;
  final Map<String, int> byPriority;
  final double? avgResolutionHours;

  bool get hasInsufficientResolutionData => avgResolutionHours == null;
}

class AgencyStatistics {
  const AgencyStatistics({
    required this.agencyId,
    required this.agencyName,
    required this.total,
    required this.resolved,
    required this.resolutionRate,
  });

  final int agencyId;
  final String agencyName;
  final int total;
  final int resolved;
  final double resolutionRate;
}

class DateStatistics {
  const DateStatistics({
    required this.date,
    required this.total,
    required this.resolved,
  });

  final String date;
  final int total;
  final int resolved;
}

class LayerPerformance {
  const LayerPerformance({
    required this.layer,
    required this.count,
    required this.avgDurationMs,
  });

  final String layer;
  final int count;
  final double avgDurationMs;
}

class PerformanceMetrics {
  const PerformanceMetrics({
    required this.totalOperations,
    required this.avgDurationMs,
    required this.errorCount,
    required this.errorRatePercent,
    required this.byLayer,
  });

  final int totalOperations;
  final double avgDurationMs;
  final int errorCount;
  final double errorRatePercent;
  final List<LayerPerformance> byLayer;
}

class DashboardStatistics {
  const DashboardStatistics({
    required this.overall,
    required this.agencies,
    required this.byDate,
  });

  final OverallStatistics overall;
  final List<AgencyStatistics> agencies;
  final List<DateStatistics> byDate;
}
