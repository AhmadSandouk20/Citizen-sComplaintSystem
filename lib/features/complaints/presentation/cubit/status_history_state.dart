import 'package:equatable/equatable.dart';

import '../../data/models/status_history_model.dart';

enum StatusHistoryStatus { initial, loading, success, error }

class StatusHistoryState extends Equatable {
  final StatusHistoryStatus status;
  final List<StatusHistoryModel> history;
  final String? errorMessage;

  const StatusHistoryState({
    this.status = StatusHistoryStatus.initial,
    this.history = const [],
    this.errorMessage,
  });

  StatusHistoryState copyWith({
    StatusHistoryStatus? status,
    List<StatusHistoryModel>? history,
    String? errorMessage,
  }) {
    return StatusHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, history, errorMessage];
}
