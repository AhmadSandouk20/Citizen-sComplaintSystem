import 'package:equatable/equatable.dart';

import '../../../auth/data/models/user_role_enum.dart';

class ProfileEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final UserRole role;
  final bool isActive;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, email, phone, role, isActive];
}
