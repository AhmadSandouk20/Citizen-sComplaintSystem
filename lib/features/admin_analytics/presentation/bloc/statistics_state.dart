import 'package:equatable/equatable.dart';
import 'package:final_flutter/features/admin_analytics/domain/entities/statistics_entities.dart';

sealed class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsInitial extends StatisticsState {
  const StatisticsInitial();
}

class StatisticsLoading extends StatisticsState {
  const StatisticsLoading();
}

class StatisticsEmpty extends StatisticsState {
  const StatisticsEmpty();
}

class StatisticsError extends StatisticsState {
  const StatisticsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class StatisticsLoaded extends StatisticsState {
  const StatisticsLoaded(this.data);

  final DashboardStatistics data;

  @override
  List<Object?> get props => [data];
}
