class AdminUserEntity {
  const AdminUserEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    this.email,
    this.phone,
    this.lastLoginAt,
  });

  final int id;
  final String name;
  final String type;
  final bool isActive;
  final String? email;
  final String? phone;
  final DateTime? lastLoginAt;

  AdminUserEntity copyWith({
    String? type,
    bool? isActive,
  }) {
    return AdminUserEntity(
      id: id,
      name: name,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      email: email,
      phone: phone,
      lastLoginAt: lastLoginAt,
    );
  }
}
