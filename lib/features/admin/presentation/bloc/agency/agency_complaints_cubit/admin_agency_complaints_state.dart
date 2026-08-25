import 'package:equatable/equatable.dart';

import '../../../../data/model/agency/agency_complaints/agency_complaint_model/agency_complaint_model.dart';

abstract class AdminAgencyComplaintsState extends Equatable {
  const AdminAgencyComplaintsState();
  @override
  List<Object?> get props => [];
}

class AdminAgencyComplaintsInitial extends AdminAgencyComplaintsState {}

class AdminAgencyComplaintsLoading extends AdminAgencyComplaintsState {}

class AdminAgencyComplaintsLoaded extends AdminAgencyComplaintsState {
  final List<AgencyComplaintModel> complaints;
  final bool hasReachedEnd;
  final int currentPage;
  final int total;

  const AdminAgencyComplaintsLoaded({
    required this.complaints,
    this.hasReachedEnd = false,
    required this.currentPage,
    required this.total,
  });

  @override
  List<Object?> get props => [complaints, hasReachedEnd, currentPage, total];
}

class AdminAgencyComplaintsError extends AdminAgencyComplaintsState {
  final String message;
  const AdminAgencyComplaintsError(this.message);
  @override
  List<Object?> get props => [message];
}
