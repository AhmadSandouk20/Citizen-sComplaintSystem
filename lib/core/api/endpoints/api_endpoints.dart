/// Paths for the agencies, staff and users groups of the API.
///
/// Relative to `AppConfig.apiBaseUrl`, which DioClient already applies.
class APIEndpoints {
  APIEndpoints._();

  static const String allAgencies = '/agencies';
  static const String allUsers = '/admin/users';
  static const String addAgency = '/agencies';

  static String agencyDetails(int id) => '/agencies/$id';
  static String updateAgency(int id) => '/agencies/$id';
  static String deleteAgency(int id) => '/agencies/$id';

  static String agencyStaff(int id) => '/agencies/$id/users';
  static String createStaff(int id) => '/agencies/$id/users';

  static String agencyComplaints(int id) => '/admin/agencies/$id/complaints';
  static String updateOrDeleteUser(int id) => '/admin/users/$id';

  /// Moves a staff member between agencies, or removes them from one.
  static String agencyStaffMember(int agencyId, int userId) =>
      '/agencies/$agencyId/users/$userId';
}
