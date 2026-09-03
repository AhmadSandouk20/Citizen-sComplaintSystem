import 'package:equatable/equatable.dart';
import 'package:final_flutter/features/admin_analytics/domain/entities/statistics_entities.dart';

sealed class PerformanceState extends Equatable {
  const PerformanceState();

  @override
  List<Object?> get props => [];
}

class PerformanceLoading extends PerformanceState {
  const PerformanceLoading();
}

class PerformanceError extends PerformanceState {
  const PerformanceError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class PerformanceEmpty extends PerformanceState {
  const PerformanceEmpty();
}

class PerformanceLoaded extends PerformanceState {
  const PerformanceLoaded(this.data);

  final PerformanceMetrics data;

  @override
  List<Object?> get props => [data];
}
