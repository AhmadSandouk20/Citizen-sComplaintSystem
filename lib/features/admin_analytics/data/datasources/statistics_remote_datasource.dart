import 'package:final_flutter/core/error/app_exception.dart';
import 'package:final_flutter/core/network/dio_client.dart';
import 'package:final_flutter/features/admin_analytics/domain/entities/statistics_entities.dart';

class StatisticsRemoteDataSource {
  StatisticsRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<OverallStatistics> fetchOverall() async {
    try {
      final response = await _dioClient.client.get('/statistics/overall');
      final data = _unwrap(response.data);
      return OverallStatistics(
        totalComplaints: _asInt(data['total_complaints']) ?? 0,
        resolvedCount: _asInt(data['resolved_count']) ?? 0,
        resolutionRate: _asDouble(data['resolution_rate']) ?? 0,
        byStatus: _asIntMap(data['by_status']),
        byPriority: _asIntMap(data['by_priority']),
        avgResolutionHours: _asDouble(data['avg_resolution_hours']),
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<List<AgencyStatistics>> fetchByAgency() async {
    try {
      final response = await _dioClient.client.get('/statistics/by-agency');
      final data = _unwrapList(response.data);
      return data.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return AgencyStatistics(
          agencyId: _asInt(map['agency_id']) ?? 0,
          agencyName: (map['agency_name'] ?? '').toString(),
          total: _asInt(map['total']) ?? 0,
          resolved: _asInt(map['resolved']) ?? 0,
          resolutionRate: _asDouble(map['resolution_rate']) ?? 0,
        );
      }).toList();
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<List<DateStatistics>> fetchByDate() async {
    try {
      final response = await _dioClient.client.get('/statistics/by-date');
      final data = _unwrapList(response.data);
      return data.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return DateStatistics(
          date: (map['date'] ?? '').toString(),
          total: _asInt(map['total']) ?? 0,
          resolved: _asInt(map['resolved']) ?? 0,
        );
      }).toList();
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<PerformanceMetrics> fetchPerformance() async {
    try {
      final response = await _dioClient.client.get('/statistics/performance');
      final data = _unwrap(response.data);
      final layers = data['by_layer'];
      final layerList = layers is List ? layers : const [];
      return PerformanceMetrics(
        totalOperations: _asInt(data['total_operations']) ?? 0,
        avgDurationMs: _asDouble(data['avg_duration_ms']) ?? 0,
        errorCount: _asInt(data['error_count']) ?? 0,
        errorRatePercent: _asDouble(data['error_rate_percent']) ?? 0,
        byLayer: layerList.map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          return LayerPerformance(
            layer: (map['layer'] ?? '').toString(),
            count: _asInt(map['count']) ?? 0,
            avgDurationMs: _asDouble(map['avg_duration_ms']) ?? 0,
          );
        }).toList(),
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Map<String, dynamic> _unwrap(dynamic raw) {
    if (raw is! Map) {
      throw const AppException('Unexpected statistics response.');
    }
    final map = Map<String, dynamic>.from(raw);
    final data = map['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return map;
  }

  List<dynamic> _unwrapList(dynamic raw) {
    if (raw is! Map) {
      throw const AppException('Unexpected statistics response.');
    }
    final data = raw['data'];
    if (data is List) return data;
    return const [];
  }

  Map<String, int> _asIntMap(dynamic raw) {
    if (raw is! Map) return {};
    return raw.map(
      (key, value) => MapEntry(key.toString(), _asInt(value) ?? 0),
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
