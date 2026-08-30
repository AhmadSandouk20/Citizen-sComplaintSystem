import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/repositories/staff_complaints_repository.dart';
import 'staff_complaints_state.dart';

class StaffComplaintsCubit extends Cubit<StaffComplaintsState> {
  final StaffComplaintsRepository repository;

  StaffComplaintsCubit({required this.repository})
    : super(const StaffComplaintsState());

  Future<void> loadComplaints() async {
    emit(
      state.copyWith(status: StaffComplaintsStatus.loading, clearError: true),
    );

    try {
      final result = await repository.getComplaints(
        page: 1,
        status: state.statusFilter,
        priority: state.priorityFilter,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
      );

      emit(
        state.copyWith(
          status: StaffComplaintsStatus.success,
          complaints: result.items,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
          clearError: true,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: StaffComplaintsStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: StaffComplaintsStatus.error,
          errorMessage: 'حدث خطأ أثناء تحميل شكاوى الموظف',
        ),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final result = await repository.getComplaints(
        page: 1,
        status: state.statusFilter,
        priority: state.priorityFilter,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
      );

      emit(
        state.copyWith(
          status: StaffComplaintsStatus.success,
          complaints: result.items,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
          clearError: true,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: StaffComplaintsStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == StaffComplaintsStatus.loadingMore) {
      return;
    }

    emit(
      state.copyWith(
        status: StaffComplaintsStatus.loadingMore,
        clearError: true,
      ),
    );

    try {
      final result = await repository.getComplaints(
        page: state.currentPage + 1,
        status: state.statusFilter,
        priority: state.priorityFilter,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
      );

      emit(
        state.copyWith(
          status: StaffComplaintsStatus.success,
          complaints: [...state.complaints, ...result.items],
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
          clearError: true,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: StaffComplaintsStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> setStatusFilter(String status) async {
    emit(state.copyWith(statusFilter: status));

    await loadComplaints();
  }

  Future<void> setPriorityFilter(String priority) async {
    emit(state.copyWith(priorityFilter: priority));

    await loadComplaints();
  }

  Future<void> applyFilters({
    required String status,
    required String priority,
    required String dateFrom,
    required String dateTo,
  }) async {
    emit(
      state.copyWith(
        statusFilter: status,
        priorityFilter: priority,
        dateFrom: dateFrom,
        dateTo: dateTo,
      ),
    );

    await loadComplaints();
  }

  Future<void> clearFilters() async {
    emit(
      state.copyWith(
        statusFilter: '',
        priorityFilter: '',
        dateFrom: '',
        dateTo: '',
      ),
    );

    await loadComplaints();
  }
}
