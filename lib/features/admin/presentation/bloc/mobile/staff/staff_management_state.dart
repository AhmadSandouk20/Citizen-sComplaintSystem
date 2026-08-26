import '../../../../../auth/data/models/user_model.dart';
import '../../../../data/model/agency/agency_model/agency_model.dart';

abstract class StaffManagementState {}

class StaffManagementInitial extends StaffManagementState {}

class StaffManagementLoading extends StaffManagementState {}

class StaffManagementLoaded extends StaffManagementState {
  final List<UserModel> staff;
  final List<AgencyModel> agencies;

  StaffManagementLoaded({required this.staff, required this.agencies});
}

class StaffManagementError extends StaffManagementState {
  final String message;
  StaffManagementError(this.message);
}
