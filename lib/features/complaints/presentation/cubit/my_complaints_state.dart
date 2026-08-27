import 'package:equatable/equatable.dart';

import '../../domain/entities/complaint_entity.dart';

enum MyComplaintsStatus { initial, loading, loadingMore, success, error }

enum ComplaintFilter { all, newComplaint, inProgress, resolved, rejected }

class MyComplaintsState extends Equatable {
  final MyComplaintsStatus status;
  final List<ComplaintEntity> complaints;

  final ComplaintFilter selectedFilter;

  final int currentPage;
  final int lastPage;
  final int total;

  final String? errorMessage;

  const MyComplaintsState({
    this.status = MyComplaintsStatus.initial,
    this.complaints = const [],
    this.selectedFilter = ComplaintFilter.all,
    this.currentPage = 0,
    this.lastPage = 1,
    this.total = 0,
    this.errorMessage,
  });

  bool get hasMore => currentPage < lastPage;

  List<ComplaintEntity> get filteredComplaints {
    switch (selectedFilter) {
      case ComplaintFilter.all:
        return complaints;

      case ComplaintFilter.newComplaint:
        return complaints
            .where((complaint) => complaint.status == 'new')
            .toList();

      case ComplaintFilter.inProgress:
        return complaints
            .where((complaint) => complaint.status == 'in_progress')
            .toList();

      case ComplaintFilter.resolved:
        return complaints
            .where((complaint) => complaint.status == 'resolved')
            .toList();

      case ComplaintFilter.rejected:
        return complaints
            .where((complaint) => complaint.status == 'rejected')
            .toList();
    }
  }

  MyComplaintsState copyWith({
    MyComplaintsStatus? status,
    List<ComplaintEntity>? complaints,
    ComplaintFilter? selectedFilter,
    int? currentPage,
    int? lastPage,
    int? total,
    String? errorMessage,
  }) {
    return MyComplaintsState(
      status: status ?? this.status,
      complaints: complaints ?? this.complaints,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    complaints,
    selectedFilter,
    currentPage,
    lastPage,
    total,
    errorMessage,
  ];
}
