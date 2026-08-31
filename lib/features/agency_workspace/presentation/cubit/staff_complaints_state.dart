import 'package:equatable/equatable.dart';

import '../../domain/entities/staff_complaint_entity.dart';

enum StaffComplaintsStatus { initial, loading, loadingMore, success, error }

class StaffComplaintsState extends Equatable {
  final StaffComplaintsStatus status;
  final List<StaffComplaintEntity> complaints;

  final int currentPage;
  final int lastPage;
  final int total;

  final String statusFilter;
  final String priorityFilter;

  final String dateFrom;
  final String dateTo;

  final String? errorMessage;

  const StaffComplaintsState({
    this.status = StaffComplaintsStatus.initial,
    this.complaints = const [],
    this.currentPage = 0,
    this.lastPage = 1,
    this.total = 0,
    this.statusFilter = '',
    this.priorityFilter = '',
    this.dateFrom = '',
    this.dateTo = '',
    this.errorMessage,
  });

  bool get hasMore => currentPage < lastPage;

  bool get hasFilters =>
      statusFilter.isNotEmpty ||
      priorityFilter.isNotEmpty ||
      dateFrom.isNotEmpty ||
      dateTo.isNotEmpty;

  StaffComplaintsState copyWith({
    StaffComplaintsStatus? status,
    List<StaffComplaintEntity>? complaints,
    int? currentPage,
    int? lastPage,
    int? total,
    String? statusFilter,
    String? priorityFilter,
    String? dateFrom,
    String? dateTo,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StaffComplaintsState(
      status: status ?? this.status,
      complaints: complaints ?? this.complaints,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    complaints,
    currentPage,
    lastPage,
    total,
    statusFilter,
    priorityFilter,
    dateFrom,
    dateTo,
    errorMessage,
  ];
}
