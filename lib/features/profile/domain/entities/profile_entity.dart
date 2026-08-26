import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String type;
  final bool isActive;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, email, phone, type, isActive];
}
