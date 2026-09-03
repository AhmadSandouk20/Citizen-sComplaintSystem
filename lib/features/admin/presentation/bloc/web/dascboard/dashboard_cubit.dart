import 'package:bloc/bloc.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  void selectAgency(int? agencyId) {
    emit(state.copyWith(selectedAgencyId: agencyId));
  }
}
