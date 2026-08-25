import 'package:bloc/bloc.dart';
import 'package:final_flutter/core/error/app_exception.dart';
import 'package:final_flutter/features/admin_analytics/domain/repositories/statistics_repository.dart';
import 'package:final_flutter/features/admin_analytics/presentation/bloc/statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this._repository) : super(const StatisticsInitial());

  final StatisticsRepository _repository;

  Future<void> load({bool refresh = false}) async {
    if (!refresh && state is StatisticsLoaded) return;
    emit(const StatisticsLoading());
    try {
      final data = await _repository.getDashboard();
      if (data.overall.totalComplaints == 0 && data.agencies.isEmpty) {
        emit(const StatisticsEmpty());
        return;
      }
      emit(StatisticsLoaded(data));
    } catch (error) {
      emit(StatisticsError(_message(error)));
    }
  }

  String _message(Object error) {
    if (error is AppException) return error.message;
    return error.toString();
  }
}
