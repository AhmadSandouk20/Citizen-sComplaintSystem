import 'package:final_flutter/features/auth/data/models/user_model.dart';

abstract class UserManagementRepository {
  Future<({List<UserModel> users, int total})> getUsers({
    required int page,
    required int perPage,
  });
  Future<void> deleteUser(int id);
  Future<UserModel> updateUser(int id, Map<String, dynamic> newData);
}
