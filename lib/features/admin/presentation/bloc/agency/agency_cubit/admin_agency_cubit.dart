import 'package:bloc/bloc.dart';

import '../../../../../../core/error/app_exception.dart';
import '../../../../data/model/agency/agency_model/agency_model.dart';
import '../../../../data/model/agency/paginated_agencies_model/paginated_agencies_model.dart';
import '../../../../domain/agency_repository.dart';
import 'admin_agency_state.dart';

class AdminAgenciesCubit extends Cubit<AdminAgenciesState> {
  final AgencyRepository _repository;
  int _currentPage = 1;
  bool _hasReachedEnd = false;

  AdminAgenciesCubit(this._repository) : super(AgenciesInitial());

  Future<void> loadAgencies({bool refresh = false}) async {
    List<AgencyModel> currentList = [];
    if (!refresh && state is AgenciesLoaded) {
      currentList = (state as AgenciesLoaded).agencies;
    }

    if (refresh) {
      _currentPage = 1;
      _hasReachedEnd = false;
      currentList = [];
    }
    emit(AgenciesLoading());

    try {
      final PaginatedAgencies result = await _repository.getAgencies(
        page: _currentPage,
      );
      final newAgencies = result.agencies;
      final updatedList = [...currentList, ...newAgencies];

      _hasReachedEnd = _currentPage >= result.lastPage;
      _currentPage++;

      emit(
        AgenciesLoaded(
          agencies: updatedList,
          hasReachedEnd: _hasReachedEnd,
          total: result.total,
        ),
      );
    } catch (e) {
      emit(AgenciesError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!_hasReachedEnd && state is! AgenciesLoading) {
      await loadAgencies();
    }
  }

  Future<void> getAgencyDetails(int id) async {
    emit(AgencyDetailsLoading());

    try {
      final AgencyModel agencyDetails = await _repository.getAgencyDetails(id);
      emit(AgencyDetailsLoaded(agencyDetails));
    } on AppException catch (e) {
      emit(AgenciesError(e.message));
    } catch (e) {
      emit(AgenciesError("something wrong happened"));
    }
  }

  Future<void> deleteAgency(int id) async {
    try {
      await _repository.deleteAgency(id);
      await loadAgencies(refresh: true);
    } on AppException catch (e) {
      emit(AgenciesError(e.message));
    } catch (e) {
      emit(AgenciesError("something wrong happened"));
    }
  }

  Future<void> addAgency({
    required String name,
    required String category,
    required String city,
    required String phone,
    required String address,
  }) async {
    emit(AgenciesLoading());
    try {
      final newAgency = await _repository.addAgency(
        AgencyModel(
          id: -1,
          name: name,
          category: category,
          city: city,
          address: address,
          phone: phone,
        ),
      );
      if (state is AgenciesLoaded) {
        final curr = (state as AgenciesLoaded);
        emit(curr.copyWith(agencies: [...curr.agencies, newAgency]));
      } else {
        loadAgencies(refresh: true);
      }
    } on AppException catch (e) {
      emit(AgenciesError(e.message));
    } catch (e) {
      emit(AgenciesError("something wrong happened"));
    }
  }

  Future<void> updateAgency({
    required int id,
    required String name,
    required String category,
    required String city,
    required String phone,
    required String address,
  }) async {
    emit(AgenciesLoading());
    try {
      await _repository.updateAgency(
        id,
        AgencyModel(
          id: id,
          name: name,
          category: category,
          city: city,
          address: address,
          phone: phone,
        ),
      );
      await loadAgencies(refresh: true);
    } on AppException catch (e) {
      emit(AgenciesError(e.message));
    } catch (e) {
      emit(AgenciesError("something wrong happened"));
    }
  }
}
