import 'package:final_flutter/features/admin_users/domain/entities/admin_user_entity.dart';

class AdminUserModel extends AdminUserEntity {
  const AdminUserModel({
    required super.id,
    required super.name,
    required super.type,
    required super.isActive,
    super.email,
    super.phone,
    super.lastLoginAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: _asInt(json['id']) ?? 0,
      name: (json['name'] ?? '').toString(),
      type: (json['type'] ?? json['role'] ?? 'citizen').toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      lastLoginAt: DateTime.tryParse(json['last_login_at']?.toString() ?? ''),
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
