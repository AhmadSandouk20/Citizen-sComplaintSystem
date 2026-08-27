import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/complaint_repository.dart';
import 'update_complaint_state.dart';

class UpdateComplaintCubit extends Cubit<UpdateComplaintState> {
  final ComplaintRepository repository;

  UpdateComplaintCubit({required this.repository})
    : super(const UpdateComplaintState());

  Future<void> updateComplaint({
    required String token,
    required int complaintId,
    required int agencyId,
    required String title,
    required String description,
    required String locationText,
    required String priority,
  }) async {
    emit(
      state.copyWith(status: UpdateComplaintStatus.loading, errorMessage: null),
    );

    try {
      await repository.updateComplaint(
        token: token,
        complaintId: complaintId,
        agencyId: agencyId,
        title: title,
        description: description,
        locationText: locationText,
        priority: priority,
      );

      emit(
        state.copyWith(
          status: UpdateComplaintStatus.success,
          errorMessage: null,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: UpdateComplaintStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: UpdateComplaintStatus.error,
          errorMessage: 'حدث خطأ أثناء تعديل الشكوى',
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
      return 'لا يمكنك تعديل هذه الشكوى';
    }

    if (statusCode == 404) {
      return 'لم يتم العثور على الشكوى';
    }

    if (statusCode == 422) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        final message = data['message'];

        if (message is String && message.isNotEmpty) {
          return message;
        }
      }

      return 'يرجى التحقق من البيانات المدخلة';
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

    return 'تعذر تعديل الشكوى';
  }
}
