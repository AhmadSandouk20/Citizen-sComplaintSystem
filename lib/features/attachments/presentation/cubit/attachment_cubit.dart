import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/files/models/selected_attachment.dart';
import '../../../../core/files/services/attachment_picker_service.dart';
import '../../../../core/files/services/multipart_upload_service.dart';
import 'attachment_state.dart';

class AttachmentCubit extends Cubit<AttachmentState> {
  final AttachmentPickerService pickerService;
  final MultipartUploadService uploadService;

  CancelToken? _cancelToken;

  AttachmentCubit({required this.pickerService, required this.uploadService})
    : super(const AttachmentState());

  Future<void> pickFiles() async {
    emit(
      state.copyWith(status: AttachmentStatus.selecting, errorMessage: null),
    );

    try {
      final selectedFiles = await pickerService.pickFiles();

      if (selectedFiles.isEmpty) {
        emit(
          state.copyWith(
            status: state.files.isEmpty
                ? AttachmentStatus.initial
                : AttachmentStatus.ready,
          ),
        );
        return;
      }

      _addFiles(selectedFiles);
    } catch (e) {
      emit(
        state.copyWith(
          status: AttachmentStatus.error,
          errorMessage: _cleanError(e),
        ),
      );
    }
  }

  Future<void> pickImagesFromGallery() async {
    emit(
      state.copyWith(status: AttachmentStatus.selecting, errorMessage: null),
    );

    try {
      final images = await pickerService.pickImagesFromGallery();

      if (images.isEmpty) {
        emit(
          state.copyWith(
            status: state.files.isEmpty
                ? AttachmentStatus.initial
                : AttachmentStatus.ready,
          ),
        );
        return;
      }

      _addFiles(images);
    } catch (e) {
      emit(
        state.copyWith(
          status: AttachmentStatus.error,
          errorMessage: _cleanError(e),
        ),
      );
    }
  }

  Future<void> takePhoto() async {
    try {
      final photo = await pickerService.takePhoto();

      if (photo == null) {
        return;
      }

      _addFiles([photo]);
    } catch (e) {
      emit(
        state.copyWith(
          status: AttachmentStatus.error,
          errorMessage: _cleanError(e),
        ),
      );
    }
  }

  void _addFiles(List<SelectedAttachment> newFiles) {
    final updatedFiles = [...state.files, ...newFiles];

    emit(
      state.copyWith(
        status: AttachmentStatus.ready,
        files: updatedFiles,
        progress: 0,
        errorMessage: null,
      ),
    );
  }

  void removeFile(SelectedAttachment attachment) {
    final updatedFiles = List<SelectedAttachment>.from(state.files)
      ..remove(attachment);

    emit(
      state.copyWith(
        files: updatedFiles,
        progress: 0,
        status: updatedFiles.isEmpty
            ? AttachmentStatus.initial
            : AttachmentStatus.ready,
      ),
    );
  }

  Future<void> uploadAttachments({
    required int complaintId,
    required String token,
  }) async {
    if (state.files.isEmpty) {
      emit(
        state.copyWith(
          status: AttachmentStatus.error,
          errorMessage: 'يرجى اختيار مرفق واحد على الأقل',
        ),
      );
      return;
    }

    _cancelToken = CancelToken();

    emit(
      state.copyWith(
        status: AttachmentStatus.uploading,
        progress: 0,
        message: null,
        errorMessage: null,
      ),
    );

    try {
      await uploadService.upload(
        url: '${AppConfig.apiBaseUrl}/complaints/$complaintId/attachments',
        token: token,
        files: state.files,
        cancelToken: _cancelToken,
        onSendProgress: (sent, total) {
          if (total <= 0 || isClosed) {
            return;
          }

          emit(
            state.copyWith(
              status: AttachmentStatus.uploading,
              progress: sent / total,
            ),
          );
        },
      );

      emit(
        const AttachmentState(
          status: AttachmentStatus.success,
          files: [],
          progress: 0,
          message: 'تم رفع المرفقات بنجاح',
        ),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        emit(
          state.copyWith(
            status: AttachmentStatus.cancelled,
            errorMessage: 'تم إلغاء رفع المرفقات',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: AttachmentStatus.error,
          errorMessage: _getDioErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AttachmentStatus.error,
          errorMessage: _cleanError(e),
        ),
      );
    }
  }

  void cancelUpload() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('تم إلغاء رفع المرفقات');
    }
  }

  Future<void> retryUpload({
    required int complaintId,
    required String token,
  }) async {
    await uploadAttachments(complaintId: complaintId, token: token);
  }

  void clear() {
    _cancelToken = null;

    emit(const AttachmentState());
  }

  String _getDioErrorMessage(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (statusCode == 401) {
      return 'انتهت صلاحية تسجيل الدخول، يرجى تسجيل الدخول من جديد';
    }

    if (statusCode == 403) {
      return 'ليس لديك صلاحية لإضافة مرفقات إلى هذه الشكوى';
    }

    if (statusCode == 404) {
      return 'تعذر العثور على الشكوى أو رابط رفع المرفقات';
    }

    if (statusCode == 413) {
      return 'حجم المرفقات أكبر من الحد المسموح';
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

      return 'بعض بيانات المرفقات غير صحيحة';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'حدث خطأ في الخادم، يرجى المحاولة لاحقًا';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'تعذر الاتصال بالخادم، تحقق من اتصال الشبكة';
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال، يرجى إعادة المحاولة';
    }

    if (e.type == DioExceptionType.cancel) {
      return 'تم إلغاء رفع المرفقات';
    }

    return 'حدث خطأ أثناء رفع المرفقات، يرجى إعادة المحاولة';
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  Future<void> close() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel();
    }

    return super.close();
  }
}
