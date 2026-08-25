import 'package:bloc/bloc.dart';
import 'package:final_flutter/core/error/app_exception.dart';
import 'package:final_flutter/features/admin_analytics/domain/repositories/statistics_repository.dart';
import 'package:final_flutter/features/admin_analytics/presentation/bloc/performance_state.dart';

class PerformanceCubit extends Cubit<PerformanceState> {
  PerformanceCubit(this._repository) : super(const PerformanceLoading());

  final StatisticsRepository _repository;

  Future<void> load() async {
    emit(const PerformanceLoading());
    try {
      final data = await _repository.getPerformance();
      if (data.totalOperations == 0 && data.byLayer.isEmpty) {
        emit(const PerformanceEmpty());
        return;
      }
      emit(PerformanceLoaded(data));
    } catch (error) {
      emit(PerformanceError(_message(error)));
    }
  }

  String _message(Object error) {
    if (error is AppException) return error.message;
    return error.toString();
  }
}
