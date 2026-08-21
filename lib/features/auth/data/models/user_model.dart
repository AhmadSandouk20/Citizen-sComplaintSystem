import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String type;
  final bool isActive;
  final String? lastLoginAt;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.type,
    required this.isActive,
    this.lastLoginAt,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      type: json['type'] as String,
      isActive: json['is_active'] as bool? ?? true,
      lastLoginAt: json['last_login_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'type': type,
      'is_active': isActive,
      'last_login_at': lastLoginAt,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, name, email, phone, type, isActive];
}
