import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/complaint_repository.dart';
import 'track_complaint_state.dart';

class TrackComplaintCubit extends Cubit<TrackComplaintState> {
  final ComplaintRepository repository;

  TrackComplaintCubit({required this.repository})
    : super(const TrackComplaintState());

  Future<void> trackComplaint({required String referenceCode}) async {
    final code = referenceCode.trim();

    if (code.isEmpty) {
      emit(
        state.copyWith(
          status: TrackComplaintStatus.error,
          errorMessage: 'يرجى إدخال رمز الشكوى',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: TrackComplaintStatus.loading, errorMessage: null),
    );

    try {
      final complaint = await repository.trackComplaint(referenceCode: code);

      emit(
        state.copyWith(
          status: TrackComplaintStatus.success,
          complaint: complaint,
          errorMessage: null,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: TrackComplaintStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TrackComplaintStatus.error,
          errorMessage: 'تعذر تتبع الشكوى',
        ),
      );
    }
  }

  String _getErrorMessage(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 404) {
      return 'لم يتم العثور على شكوى بهذا الرمز';
    }

    if (statusCode == 429) {
      return 'تم إرسال عدد كبير من الطلبات، حاول لاحقًا';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'تعذر الاتصال بالخادم';
    }

    return 'تعذر تتبع الشكوى';
  }
}
