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

  @override
  List<Object?> get props => [id, name, role];
}
