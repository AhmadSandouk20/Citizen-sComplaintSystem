import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/files/models/selected_attachment.dart';
import '../../domain/repositories/complaint_repository.dart';
import 'create_complaint_state.dart';

class CreateComplaintCubit extends Cubit<CreateComplaintState> {
  final ComplaintRepository repository;

  CancelToken? _cancelToken;

  CreateComplaintCubit({required this.repository})
    : super(const CreateComplaintState());

  Future<void> createComplaint({
    required String token,
    required int agencyId,
    required String title,
    required String description,
    required String locationText,
    required String priority,
    List<SelectedAttachment> attachments = const [],
  }) async {
    final validationMessage = _validate(
      agencyId: agencyId,
      title: title,
      description: description,
      locationText: locationText,
      priority: priority,
    );

    if (validationMessage != null) {
      emit(
        state.copyWith(
          status: CreateComplaintStatus.error,
          errorMessage: validationMessage,
        ),
      );
      return;
    }

    _cancelToken = CancelToken();

    emit(
      const CreateComplaintState(
        status: CreateComplaintStatus.submitting,
        progress: 0,
      ),
    );

    try {
      final result = await repository.createComplaint(
        token: token,
        agencyId: agencyId,
        title: title.trim(),
        description: description.trim(),
        locationText: locationText.trim(),
        priority: priority,
        attachments: attachments,
        cancelToken: _cancelToken,
        onSendProgress: (sent, total) {
          if (total <= 0 || isClosed) {
            return;
          }

          emit(
            state.copyWith(
              status: CreateComplaintStatus.submitting,
              progress: sent / total,
            ),
          );
        },
      );

      emit(
        CreateComplaintState(
          status: CreateComplaintStatus.success,
          progress: 1,
          result: result,
        ),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        emit(
          const CreateComplaintState(
            status: CreateComplaintStatus.cancelled,
            errorMessage: 'تم إلغاء إرسال الشكوى',
          ),
        );
        return;
      }

      emit(
        CreateComplaintState(
          status: CreateComplaintStatus.error,
          errorMessage: _getDioErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        const CreateComplaintState(
          status: CreateComplaintStatus.error,
          errorMessage: 'حدث خطأ أثناء إرسال الشكوى',
        ),
      );
    }
  }

  void cancelSubmission() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('تم إلغاء إرسال الشكوى');
    }
  }

  void reset() {
    _cancelToken = null;
    emit(const CreateComplaintState());
  }

  String? _validate({
    required int agencyId,
    required String title,
    required String description,
    required String locationText,
    required String priority,
  }) {
    if (agencyId <= 0) {
      return 'يرجى اختيار جهة حكومية';
    }

    if (title.trim().isEmpty) {
      return 'عنوان الشكوى مطلوب';
    }

    if (title.trim().length > 200) {
      return 'عنوان الشكوى يجب ألا يتجاوز 200 حرف';
    }

    if (description.trim().isEmpty) {
      return 'وصف الشكوى مطلوب';
    }

    if (locationText.trim().length > 255) {
      return 'الموقع يجب ألا يتجاوز 255 حرفًا';
    }

    if (!['low', 'medium', 'high'].contains(priority)) {
      return 'الأولوية غير صحيحة';
    }

    return null;
  }

  String _getDioErrorMessage(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (statusCode == 401) {
      return 'انتهت صلاحية تسجيل الدخول';
    }

    if (statusCode == 403) {
      return 'ليس لديك صلاحية لتنفيذ هذه العملية';
    }

    if (statusCode == 422) {
      if (data is Map<String, dynamic>) {
        final errors = data['errors'];

        if (errors is Map) {
          for (final value in errors.values) {
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
          }
        }
      }

      return 'بعض بيانات الشكوى غير صحيحة';
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
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال، حاول مجددًا';
    }

    return 'حدث خطأ أثناء إرسال الشكوى';
  }

  @override
  Future<void> close() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel();
    }

    return super.close();
  }
}
