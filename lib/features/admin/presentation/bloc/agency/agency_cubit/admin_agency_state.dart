import 'package:equatable/equatable.dart';
import 'package:final_flutter/features/admin/data/model/agency/agency_model/agency_model.dart';

abstract class AdminAgenciesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AgencyDetailsLoading extends AdminAgenciesState {}

class AgencyDetailsLoaded extends AdminAgenciesState {
  final AgencyModel agencyModelDetails;
  AgencyDetailsLoaded(this.agencyModelDetails);
  @override
  List<Object?> get props => [agencyModelDetails];
}

class AgencyDetailsFailed extends AdminAgenciesState {
  final String message;
  AgencyDetailsFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class AgenciesInitial extends AdminAgenciesState {}

class AgenciesLoading extends AdminAgenciesState {}

class AgenciesLoaded extends AdminAgenciesState {
  final List<AgencyModel> agencies;
  final bool hasReachedEnd;
  final int total;
  final bool isLoadingMore; // new

  AgenciesLoaded({
    required this.agencies,
    required this.hasReachedEnd,
    required this.total,
    this.isLoadingMore = false,
  });

  AgenciesLoaded copyWith({
    List<AgencyModel>? agencies,
    bool? hasReachedEnd,
    int? total,
    bool? isLoadingMore,
  }) {
    return AgenciesLoaded(
      agencies: agencies ?? this.agencies,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [agencies, hasReachedEnd, total, isLoadingMore];
}

class AgenciesError extends AdminAgenciesState {
  final String message;
  AgenciesError(this.message);
  @override
  List<Object?> get props => [message];
}
