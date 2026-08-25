import 'package:bloc/bloc.dart';
import 'package:final_flutter/core/error/app_exception.dart';
import 'package:final_flutter/features/admin_reports/data/services/save_file.dart';
import 'package:final_flutter/features/admin_reports/domain/repositories/reports_repository.dart';
import 'package:final_flutter/features/admin_reports/presentation/bloc/reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this._repository) : super(const ReportsIdle());

  final ReportsRepository _repository;

  Future<void> downloadComplaintsCsv() {
    return _run('csv', _repository.downloadComplaintsCsv);
  }

  Future<void> downloadComplaintsPdf() {
    return _run('pdf', _repository.downloadComplaintsPdf);
  }

  Future<void> downloadStatisticsCsv() {
    return _run('stats', _repository.downloadStatisticsCsv);
  }

  Future<void> _run(
    String kind,
    Future<DownloadedReport> Function() loader,
  ) async {
    emit(ReportsDownloading(kind));
    try {
      final file = await loader();
      final path = await saveFileBytes(
        bytes: file.bytes,
        filename: file.filename,
        mimeType: file.mimeType,
      );
      emit(ReportsSuccess(path));
      emit(const ReportsIdle());
    } catch (error) {
      emit(ReportsError(_message(error)));
      emit(const ReportsIdle());
    }
  }

  String _message(Object error) {
    if (error is AppException) return error.message;
    return error.toString();
  }
}
