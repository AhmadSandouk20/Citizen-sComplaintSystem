import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/app_exception.dart';
import '../../../data/model/agency/agency_model/agency_model.dart';
import '../../../domain/staff_management_repository.dart';
import '../../../domain/agency_repository.dart';
import '../../../../auth/data/models/user_model.dart';
import 'staff_management_state.dart';

class StaffManagementCubit extends Cubit<StaffManagementState> {
  final StaffManagementRepository _staffRepo;
  final AgencyRepository _agencyRepo;

  int _agencyId = 0;
  List<UserModel> _staff = [];
  List<AgencyModel> _agencies = [];

  StaffManagementCubit(this._staffRepo, this._agencyRepo)
    : super(StaffManagementInitial());

  Future<void> loadStaff(int agencyId) async {
    _agencyId = agencyId;
    emit(StaffManagementLoading());
    try {
      _staff = await _staffRepo.getAgencyStaff(agencyId);
      emit(StaffManagementLoaded(staff: _staff, agencies: _agencies));
    } on AppException catch (e) {
      emit(StaffManagementError(e.message));
    } catch (e) {
      emit(StaffManagementError("something wrong happened"));
    }
  }

  Future<void> loadAgencies() async {
    try {
      final paginated = await _agencyRepo.getAgencies();
      _agencies = paginated.agencies;
      emit(StaffManagementLoaded(staff: _staff, agencies: _agencies));
    } on AppException catch (e) {
      emit(StaffManagementError(e.message));
    } catch (e) {
      emit(StaffManagementError("something wrong happened"));
    }
  }

  Future<void> addStaff(Map<String, dynamic> userData) async {
    try {
      await _staffRepo.createStaffForAgency(_agencyId, userData);
      await loadStaff(_agencyId);
    } on AppException catch (e) {
      emit(StaffManagementError(e.message));
    } catch (e) {
      emit(StaffManagementError("something wrong happened"));
    }
  }

  Future<void> transferStaff(int userId, int newAgencyId) async {
    try {
      await _staffRepo.transferStaff(_agencyId, userId, newAgencyId);
      await loadStaff(_agencyId);
    } on AppException catch (e) {
      emit(StaffManagementError(e.message));
    } catch (e) {
      emit(StaffManagementError("something wrong happened"));
    }
  }

  Future<void> removeStaff(int userId) async {
    try {
      await _staffRepo.removeStaffFromAgency(_agencyId, userId);
      await loadStaff(_agencyId);
    } on AppException catch (e) {
      emit(StaffManagementError(e.message));
    } catch (e) {
      emit(StaffManagementError("something wrong happened"));
    }
  }
}
