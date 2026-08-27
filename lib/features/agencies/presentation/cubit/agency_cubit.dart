import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/agency_repository.dart';
import 'agency_state.dart';

class AgencyCubit extends Cubit<AgencyState> {
  final AgencyRepository repository;

  AgencyCubit({required this.repository}) : super(const AgencyState());

  Future<void> getAgencies() async {
    emit(state.copyWith(status: AgencyStatus.loading, errorMessage: null));

    try {
      final agencies = await repository.getAgencies();

      emit(state.copyWith(status: AgencyStatus.success, agencies: agencies));
    } catch (_) {
      emit(
        state.copyWith(
          status: AgencyStatus.error,
          errorMessage: 'تعذر تحميل الجهات',
        ),
      );
    }
  }
}
