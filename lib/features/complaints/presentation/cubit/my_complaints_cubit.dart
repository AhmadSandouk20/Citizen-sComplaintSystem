import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/complaint_repository.dart';
import 'my_complaints_state.dart';

class MyComplaintsCubit extends Cubit<MyComplaintsState> {
  final ComplaintRepository repository;

  MyComplaintsCubit({required this.repository})
    : super(const MyComplaintsState());

  Future<void> getComplaints({required String token}) async {
    emit(
      state.copyWith(status: MyComplaintsStatus.loading, errorMessage: null),
    );

    try {
      final result = await repository.getComplaints(token: token, page: 1);

      emit(
        state.copyWith(
          status: MyComplaintsStatus.success,
          complaints: result.complaints,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
          errorMessage: null,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: MyComplaintsStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MyComplaintsStatus.error,
          errorMessage: 'حدث خطأ أثناء تحميل الشكاوى',
        ),
      );
    }
  }

  Future<void> refresh({required String token}) async {
    try {
      final result = await repository.getComplaints(token: token, page: 1);

      emit(
        state.copyWith(
          status: MyComplaintsStatus.success,
          complaints: result.complaints,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
          errorMessage: null,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: MyComplaintsStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MyComplaintsStatus.error,
          errorMessage: 'حدث خطأ أثناء تحديث الشكاوى',
        ),
      );
    }
  }

  Future<void> loadMore({required String token}) async {
    if (!state.hasMore) {
      return;
    }

    if (state.status == MyComplaintsStatus.loadingMore) {
      return;
    }

    emit(
      state.copyWith(
        status: MyComplaintsStatus.loadingMore,
        errorMessage: null,
      ),
    );

    try {
      final nextPage = state.currentPage + 1;

      final result = await repository.getComplaints(
        token: token,
        page: nextPage,
      );

      emit(
        state.copyWith(
          status: MyComplaintsStatus.success,
          complaints: [...state.complaints, ...result.complaints],
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
          errorMessage: null,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: MyComplaintsStatus.success,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MyComplaintsStatus.success,
          errorMessage: 'تعذر تحميل المزيد من الشكاوى',
        ),
      );
    }
  }

  void setFilter(ComplaintFilter filter) {
    if (state.selectedFilter == filter) {
      return;
    }

    emit(state.copyWith(selectedFilter: filter));
  }

  String _getErrorMessage(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 401) {
      return 'انتهت صلاحية تسجيل الدخول';
    }

    if (statusCode == 403) {
      return 'ليس لديك صلاحية لعرض الشكاوى';
    }

    if (statusCode == 429) {
      return 'تم إرسال عدد كبير من الطلبات، حاول لاحقًا';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'حدث خطأ في الخادم، حاول لاحقًا';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'تعذر الاتصال بالخادم';
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال، حاول مجددًا';
    }

    return 'تعذر تحميل الشكاوى';
  }
}
