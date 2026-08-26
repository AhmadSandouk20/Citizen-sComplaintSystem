import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/complaint_repository.dart';
import 'status_history_state.dart';

class StatusHistoryCubit extends Cubit<StatusHistoryState> {
  final ComplaintRepository repository;

  StatusHistoryCubit({required this.repository})
    : super(const StatusHistoryState());

  Future<void> getStatusHistory({
    required String token,
    required int complaintId,
  }) async {
    emit(
      state.copyWith(status: StatusHistoryStatus.loading, errorMessage: null),
    );

    try {
      final result = await repository.getStatusHistory(
        token: token,
        complaintId: complaintId,
      );

      emit(
        state.copyWith(
          status: StatusHistoryStatus.success,
          history: result.history,
          errorMessage: null,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: StatusHistoryStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: StatusHistoryStatus.error,
          errorMessage: 'تعذر تحميل سجل حالة الشكوى',
        ),
      );
    }
  }

  String _getErrorMessage(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 401) {
      return 'انتهت صلاحية تسجيل الدخول';
    }

    if (statusCode == 403) {
      return 'ليس لديك صلاحية لعرض سجل الحالة';
    }

    if (statusCode == 404) {
      return 'لم يتم العثور على الشكوى';
    }

    if (statusCode == 429) {
      return 'تم إرسال عدد كبير من الطلبات، حاول لاحقًا';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'تعذر الاتصال بالخادم';
    }

    return 'تعذر تحميل سجل الحالة';
  }
}
