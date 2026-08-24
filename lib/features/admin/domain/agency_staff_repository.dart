import 'package:final_flutter/features/auth/data/models/user_model.dart';

abstract class AgencyStaffRepository {
  Future<List<UserModel>> getAgencyStaff(int agencyId);
}
