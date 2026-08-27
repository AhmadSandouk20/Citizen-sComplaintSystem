import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/complaint_repository.dart';
import 'complaint_details_state.dart';

class ComplaintDetailsCubit extends Cubit<ComplaintDetailsState> {
  final ComplaintRepository repository;

  ComplaintDetailsCubit({required this.repository})
    : super(const ComplaintDetailsState());

  Future<void> getComplaintDetails({
    required String token,
    required int complaintId,
  }) async {
    emit(
      state.copyWith(
        status: ComplaintDetailsStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final complaint = await repository.getComplaintDetails(
        token: token,
        complaintId: complaintId,
      );

      emit(
        state.copyWith(
          status: ComplaintDetailsStatus.success,
          complaint: complaint,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: ComplaintDetailsStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ComplaintDetailsStatus.error,
          errorMessage: 'حدث خطأ أثناء تحميل تفاصيل الشكوى',
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
      return 'ليس لديك صلاحية لعرض هذه الشكوى';
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

    return 'تعذر تحميل تفاصيل الشكوى';
  }

  Future<void> deleteComplaint({
    required String token,
    required int complaintId,
  }) async {
    emit(
      state.copyWith(
        status: ComplaintDetailsStatus.deleting,
        errorMessage: null,
      ),
    );

    try {
      await repository.deleteComplaint(token: token, complaintId: complaintId);

      emit(state.copyWith(status: ComplaintDetailsStatus.deleted));
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: ComplaintDetailsStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ComplaintDetailsStatus.error,
          errorMessage: 'حدث خطأ أثناء حذف الشكوى',
        ),
      );
    }
  }
}
