import 'package:equatable/equatable.dart';

import 'user_role_enum.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final UserRole role;
  final String token;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    required String token,
  }) {
    return UserModel(
      id: _asInt(json['id']) ?? 0,
      name: (json['name'] ?? '').toString(),
      role: UserRoleX.fromApi(json['type']?.toString() ?? json['role']?.toString()),
      token: token,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @override
  List<Object?> get props => [id, name, role];
}

extension UserRoleX on UserRole {
  static UserRole fromApi(String? value) {
    switch (value?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'staff':
        return UserRole.staff;
      default:
        return UserRole.citizen;
    }
  }
}
