import 'package:equatable/equatable.dart';

import 'user_role_enum.dart';

/// The authenticated user plus the bearer token that identifies the session.
///
/// The token is part of the model on purpose: it is what `AuthCubit.token`
/// hands to the Dio interceptor and to the FCM registration call.
class UserModel extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final UserRole role;
  final bool isActive;
  final String token;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.token,
    this.email,
    this.phone,
    this.isActive = true,
  });

  /// [token] is passed separately because the login response carries it
  /// beside the user object, not inside it.
  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    required String token,
  }) {
    return UserModel(
      id: _asInt(json['id']) ?? 0,
      name: (json['name'] ?? '').toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      role: UserRole.fromApi(
        json['type']?.toString() ?? json['role']?.toString(),
      ),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      token: token,
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    bool? isActive,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      token: token,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'type': role.apiValue,
    'is_active': isActive,
  };

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @override
  List<Object?> get props => [id, name, email, phone, role, isActive, token];
}
