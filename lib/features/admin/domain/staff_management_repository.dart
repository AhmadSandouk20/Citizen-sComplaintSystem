import '../../auth/data/models/user_model.dart';

abstract class StaffManagementRepository {
  Future<List<UserModel>> getAgencyStaff(int agencyId);
  Future<UserModel> createStaffForAgency(
    int agencyId,
    Map<String, dynamic> userData,
  );
  Future<void> transferStaff(int agencyId, int userId, int newAgencyId);
  Future<void> removeStaffFromAgency(int agencyId, int userId);
}
