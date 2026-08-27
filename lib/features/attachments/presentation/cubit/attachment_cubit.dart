import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          errorMessage: 'ظٹط±ط¬ظ‰ ط§ط®طھظٹط§ط± ظ…ط±ظپظ‚ ظˆط§ط­ط¯ ط¹ظ„ظ‰ ط§ظ„ط£ظ‚ظ„',
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
        url: '/complaints/$complaintId/attachments',
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
          message: 'طھظ… ط±ظپط¹ ط§ظ„ظ…ط±ظپظ‚ط§طھ ط¨ظ†ط¬ط§ط­',
        ),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        emit(
          state.copyWith(
            status: AttachmentStatus.cancelled,
            errorMessage: 'طھظ… ط¥ظ„ط؛ط§ط، ط±ظپط¹ ط§ظ„ظ…ط±ظپظ‚ط§طھ',
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
      _cancelToken!.cancel('طھظ… ط¥ظ„ط؛ط§ط، ط±ظپط¹ ط§ظ„ظ…ط±ظپظ‚ط§طھ');
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
      return 'ط§ظ†طھظ‡طھ طµظ„ط§ط­ظٹط© طھط³ط¬ظٹظ„ ط§ظ„ط¯ط®ظˆظ„طŒ ظٹط±ط¬ظ‰ طھط³ط¬ظٹظ„ ط§ظ„ط¯ط®ظˆظ„ ظ…ظ† ط¬ط¯ظٹط¯';
    }

    if (statusCode == 403) {
      return 'ظ„ظٹط³ ظ„ط¯ظٹظƒ طµظ„ط§ط­ظٹط© ظ„ط¥ط¶ط§ظپط© ظ…ط±ظپظ‚ط§طھ ط¥ظ„ظ‰ ظ‡ط°ظ‡ ط§ظ„ط´ظƒظˆظ‰';
    }

    if (statusCode == 404) {
      return 'طھط¹ط°ط± ط§ظ„ط¹ط«ظˆط± ط¹ظ„ظ‰ ط§ظ„ط´ظƒظˆظ‰ ط£ظˆ ط±ط§ط¨ط· ط±ظپط¹ ط§ظ„ظ…ط±ظپظ‚ط§طھ';
    }

    if (statusCode == 413) {
      return 'ط­ط¬ظ… ط§ظ„ظ…ط±ظپظ‚ط§طھ ط£ظƒط¨ط± ظ…ظ† ط§ظ„ط­ط¯ ط§ظ„ظ…ط³ظ…ظˆط­';
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

      return 'ط¨ط¹ط¶ ط¨ظٹط§ظ†ط§طھ ط§ظ„ظ…ط±ظپظ‚ط§طھ ط؛ظٹط± طµط­ظٹط­ط©';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'ط­ط¯ط« ط®ط·ط£ ظپظٹ ط§ظ„ط®ط§ط¯ظ…طŒ ظٹط±ط¬ظ‰ ط§ظ„ظ…ط­ط§ظˆظ„ط© ظ„ط§ط­ظ‚ظ‹ط§';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'طھط¹ط°ط± ط§ظ„ط§طھطµط§ظ„ ط¨ط§ظ„ط®ط§ط¯ظ…طŒ طھط­ظ‚ظ‚ ظ…ظ† ط§طھطµط§ظ„ ط§ظ„ط´ط¨ظƒط©';
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'ط§ظ†طھظ‡طھ ظ…ظ‡ظ„ط© ط§ظ„ط§طھطµط§ظ„طŒ ظٹط±ط¬ظ‰ ط¥ط¹ط§ط¯ط© ط§ظ„ظ…ط­ط§ظˆظ„ط©';
    }

    if (e.type == DioExceptionType.cancel) {
      return 'طھظ… ط¥ظ„ط؛ط§ط، ط±ظپط¹ ط§ظ„ظ…ط±ظپظ‚ط§طھ';
    }

    return 'ط­ط¯ط« ط®ط·ط£ ط£ط«ظ†ط§ط، ط±ظپط¹ ط§ظ„ظ…ط±ظپظ‚ط§طھطŒ ظٹط±ط¬ظ‰ ط¥ط¹ط§ط¯ط© ط§ظ„ظ…ط­ط§ظˆظ„ط©';
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
