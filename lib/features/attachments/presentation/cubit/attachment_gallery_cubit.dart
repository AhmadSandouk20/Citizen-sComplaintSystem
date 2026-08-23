import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data_sources/attachment_gallery_remote_data_source.dart';
import 'attachment_gallery_state.dart';

class AttachmentGalleryCubit
    extends Cubit<AttachmentGalleryState> {
  final AttachmentGalleryRemoteDataSource
  remoteDataSource;

  AttachmentGalleryCubit(
      this.remoteDataSource,
      ) : super(
    const AttachmentGalleryState(),
  );

  Future<void> loadAttachments({
    required int complaintId,
    required String token,
  }) async {
    emit(
      state.copyWith(
        status: AttachmentGalleryStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final attachments =
      await remoteDataSource
          .getComplaintAttachments(
        complaintId: complaintId,
        token: token,
      );

      emit(
        state.copyWith(
          status:
          AttachmentGalleryStatus.success,
          attachments: attachments,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: AttachmentGalleryStatus.error,
          errorMessage:
          _getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AttachmentGalleryStatus.error,
          errorMessage:
          'حدث خطأ أثناء تحميل المرفقات',
        ),
      );
    }
  }

  String _getErrorMessage(
      DioException e,
      ) {
    final statusCode =
        e.response?.statusCode;

    if (statusCode == 401) {
      return 'انتهت صلاحية تسجيل الدخول';
    }

    if (statusCode == 403) {
      return 'ليس لديك صلاحية لعرض هذه الشكوى';
    }

    if (statusCode == 404) {
      return 'لم يتم العثور على الشكوى';
    }

    if (e.type ==
        DioExceptionType.connectionError) {
      return 'تعذر الاتصال بالخادم';
    }

    return 'حدث خطأ أثناء تحميل المرفقات';
  }
}