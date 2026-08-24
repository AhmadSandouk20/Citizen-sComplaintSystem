class RoutePaths {
  static const String login = "/";
  static const String splashScreen = "/splash";
  static const String signup = "/signup";
  static const String aLocked = "/account-locked";
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String resendOTP = '/resend-otp';
  static const String verifyOTP = '/verify-otp';

  static const String notifications = "/notifications";
  static const String profile = '/profile';

  // citizen
  static const String cHome = '/citizen/home';
  static const String submissionSuccess = '/Submission-Success';
  static const String cComplaints = '/citizen/complaints';
  static const String cComplaintDetails = '/citizen/complaints/:id';
  static const String submit = '/citizen/submit';
  static const String cUpdate = '/citizen/update/:id';
  static const String cTrackEntry = '/citizen/track-entry';
  static const String cTrackCode = '/citizen/track/:code';
  static const String cAttachments = '/citizen/attachments/:id';

  // staff
  static const String sComplaints = '/staff/complaints';
  static const String sComplaint = '/staff/complaints/:id';
  static const String updateComplaint = '/staff/complaints/:id/update';
  static const String complaintLock = '/staff/complaints/:id/lock';
  static const String complaintUnlock = '/staff/complaints/:id/unlock';
  static const String complaintRevisions = '/staff/complaints/:id/revisions';
  static const String complaintStatusHistory =
      '/staff/complaints/:id/status-history';
  static const String staffRequestInfo = "/staff/complaints/:id/request-info";

  // admin
  static const String statistics = '/admin/statistics';
  static const String users = '/admin/users';
  static const String user = '/admin/users/:id';
  static const String agencies = '/admin/agencies';
  static const String agency = '/admin/agencies/:id';
  static const String agencyUsers = '/admin/agencies/:id/users';
  static const String addAgency = "/admin/agencies/add";
  static const String updateAgency = "/admin/agencies/:id/edit";
  static const String agencyUser = '/admin/agencies/:id/users/:userId';
  static const String reports = '/admin/reports';
  static const String performance = '/admin/Performance';
  static const String addStaff = '/admin/agencies/:id/staff/add';
  static const String updateStaff = '/admin/agencies/:id/staff/:userId/edit';
  // ----------------------------Helper methods--------------------------------

  // Citizen
  static String cComplaintDetailsPath(int id) => '/citizen/complaints/$id';
  static String cUpdatePath(int id) => '/citizen/update/$id';
  static String cAttachmentsPath(int id) => '/citizen/attachments/$id';
  static String cTrackCodePath(String code) => '/citizen/track/$code';

  // Staff
  static String sComplaintPath(int id) => '/staff/complaints/$id';
  static String updateComplaintPath(int id) => '/staff/complaints/$id/update';
  static String complaintLockPath(int id) => '/staff/complaints/$id/lock';
  static String complaintUnlockPath(int id) => '/staff/complaints/$id/unlock';
  static String complaintRevisionsPath(int id) =>
      '/staff/complaints/$id/revisions';
  static String complaintStatusHistoryPath(int id) =>
      '/staff/complaints/$id/status-history';
  static String staffRequestInfoPath(int id) =>
      "/staff/complaints/$id/request-info";

  // Admin
  static String userPath(int id) => '/admin/users/$id';
  static String updateUserPath(int id) => "/admin/users/$id/edit";
  static String agencyPath(int id) => '/admin/agencies/$id';
  static String agencyUsersPath(int id) => '/admin/agencies/$id/users';
  static String updateAgencyPath(int id) => "/admin/agencies/$id/edit";
  static String agencyUserPath(int agencyId, int userId) =>
      '/admin/agencies/$agencyId/users/$userId';
  static String addStaffPath(int agencyId) =>
      '/admin/agencies/$agencyId/staff/add';
  static String editStaffPath(int agencyId, int userId) =>
      '/admin/agencies/$agencyId/staff/$userId/edit';
}
