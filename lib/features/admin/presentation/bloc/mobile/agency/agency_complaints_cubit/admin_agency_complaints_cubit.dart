import 'package:bloc/bloc.dart';
import 'package:final_flutter/features/admin/domain/agency_complaints_repository.dart';
import '../../../../../../../core/error/app_exception.dart';
import '../../../../../data/model/agency/agency_complaints/agency_complaint_model/agency_complaint_model.dart';
import 'admin_agency_complaints_state.dart';

class AdminAgenciesComplaintCubit extends Cubit<AdminAgencyComplaintsState> {
  final AgencyComplaintsRepository _repository;
  int _currentPage = 1;
  bool _hasReachedEnd = false;

  AdminAgenciesComplaintCubit(this._repository)
    : super(AdminAgencyComplaintsInitial());

  void loadAgencyComplaints(int agencyId) {
    _currentPage = 1;
    _hasReachedEnd = false;
    emit(AdminAgencyComplaintsLoading());
    _fetchComplaints(agencyId, isRefresh: true);
  }

  void loadMoreAgencyComplaints(int agencyId) {
    if (_hasReachedEnd) return;
    if (state is AdminAgencyComplaintsLoading) return;
    _fetchComplaints(agencyId, isRefresh: false);
  }

  Future<void> _fetchComplaints(int agencyId, {required bool isRefresh}) async {
    try {
      final paginatedResult = await _repository.getAgencyComplaints(
        agencyId,
        page: _currentPage,
      );

      final List<AgencyComplaintModel> newComplaints = paginatedResult.data;
      final bool hasMore = _currentPage < paginatedResult.lastPage;

      if (isRefresh) {
        emit(
          AdminAgencyComplaintsLoaded(
            complaints: newComplaints,
            hasReachedEnd: !hasMore,
            currentPage: paginatedResult.currentPage,
            total: paginatedResult.total,
          ),
        );
      } else {
        final currentState = state;
        if (currentState is AdminAgencyComplaintsLoaded) {
          final updatedList = List<AgencyComplaintModel>.from(
            currentState.complaints,
          )..addAll(newComplaints);
          emit(
            AdminAgencyComplaintsLoaded(
              complaints: updatedList,
              hasReachedEnd: !hasMore,
              currentPage: paginatedResult.currentPage,
              total: paginatedResult.total,
            ),
          );
        }
      }

      _hasReachedEnd = !hasMore;
      if (!_hasReachedEnd) {
        _currentPage++;
      }
    } on AppException catch (e) {
      emit(AdminAgencyComplaintsError(e.message));
    } catch (e) {
      emit(AdminAgencyComplaintsError("something wrong happened"));
    }
  }

  void refreshComplaints(int agencyId) {
    loadAgencyComplaints(agencyId);
  }
}
