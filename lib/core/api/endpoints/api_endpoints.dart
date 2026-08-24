class APIEndpoints {
  static const String ALL_AGENCIES = "/agencies";
  static const String ALL_USERS = "/admin/users";
  static const String ADD_AGENCY = "/agencies";

  static String AGENCY_DETAILS(int id) => "/agencies/$id";
  static String UPDATE_AGENCY(int id) => "/agencies/$id";
  static String DELETE_AGENCY(int id) => "/agencies/$id";
  static String AGENCY_STAFF(int id) => "/agencies/$id/users";
  static String AGENCY_COMPLAINTS(int id) => "/admin/agencies/$id/complaints";
  static String UPDATE_OR_DELETE_USER(int id) => "/admin/users/$id";
  static String CREATE_STAFF(int id) => "/agencies/$id/users";
  static String MOVE_S_BETWEEN_AGENCIES_OR_REMOVE_F_AGENCY(
    int agencyId,
    int userId,
  ) => "/agencies/$agencyId/users/$userId";
}
