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

  // admin
  static const String statistics = '/admin/statistics';
  static const String users = '/admin/users';
  static const String user = '/admin/users/:id';
  static const String agencies = '/admin/agencies';
  static const String agency = '/admin/agencies/:id';
  static const String agencyUsers = '/admin/agencies/:id/users';
  static const String agencyUser = '/admin/agencies/:id/users/:userId';
  static const String reports = '/admin/reports';
  static const String performance = '/admin/Performance';
}
