/// The three roles defined in the backend `users.type` enum.
enum UserRole {
  admin,
  staff,
  citizen;

  /// Maps the API's `type` string onto the enum.
  /// Unknown values fall back to the least privileged role.
  static UserRole fromApi(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'admin':
        return UserRole.admin;
      case 'staff':
        return UserRole.staff;
      case 'citizen':
        return UserRole.citizen;
      default:
        return UserRole.citizen;
    }
  }

  /// The value the API expects back.
  String get apiValue => name;

  bool get isAdmin => this == UserRole.admin;
  bool get isStaff => this == UserRole.staff;
  bool get isCitizen => this == UserRole.citizen;

  /// Admins share every staff workspace route, so this is the guard used by
  /// `/agency/complaints/*` rather than `isStaff`.
  bool get canAccessAgencyWorkspace => isStaff || isAdmin;
}
