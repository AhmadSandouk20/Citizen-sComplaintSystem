import 'package:equatable/equatable.dart';

import '../../domain/entities/agency_entity.dart';

enum AgencyStatus { initial, loading, success, error }

class AgencyState extends Equatable {
  final AgencyStatus status;
  final List<AgencyEntity> agencies;
  final String? errorMessage;

  const AgencyState({
    this.status = AgencyStatus.initial,
    this.agencies = const [],
    this.errorMessage,
  });

  AgencyState copyWith({
    AgencyStatus? status,
    List<AgencyEntity>? agencies,
    String? errorMessage,
  }) {
    return AgencyState(
      status: status ?? this.status,
      agencies: agencies ?? this.agencies,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, agencies, errorMessage];
}
