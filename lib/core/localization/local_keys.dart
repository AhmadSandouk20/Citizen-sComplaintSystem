/// Keys mirroring `assets/translations/*.json`.
///
/// Every user-facing string in the app goes through one of these — no literal
/// text inside a Widget.
class LocaleKeys {
  LocaleKeys._();

  // Shell / navigation
  static const login = 'login';
  static const email = 'email';
  static const password = 'password';
  static const complaints = 'complaints';
  static const submit = 'submit';
  static const profile = 'profile';
  static const queue = 'queue';
  static const statistics = 'statistics';
  static const users = 'users';
  static const agencies = 'agencies';
  static const reports = 'reports';
  static const logout = 'logout';
  static const ccs = 'CCS';
  static const track = 'track';
  static const agenciesQueue = 'agenciesQueue';
  static const language = 'language';
  static const theme = 'theme';
  static const dark = 'dark';
  static const light = 'light';

  // Notifications
  static const notifications = 'notifications';
  static const notificationsEmpty = 'notificationsEmpty';
  static const notificationsEmptyHint = 'notificationsEmptyHint';
  static const markAllRead = 'markAllRead';
  static const retry = 'retry';
  static const justNow = 'justNow';
  static const minutesAgo = 'minutesAgo';
  static const hoursAgo = 'hoursAgo';

  // Auth
  static const signIn = 'signIn';
  static const identifier = 'identifier';
  static const identifierRequired = 'identifierRequired';
  static const passwordRequired = 'passwordRequired';
  static const passwordTooShort = 'passwordTooShort';
  static const showPassword = 'showPassword';
  static const hidePassword = 'hidePassword';
  static const signInSubtitle = 'signInSubtitle';

  // Profile fields
  static const name = 'name';
  static const phone = 'phone';
  static const accountType = 'accountType';
  static const accountStatus = 'accountStatus';
  static const active = 'active';
  static const inactive = 'inactive';
  static const roleCitizen = 'roleCitizen';
  static const roleStaff = 'roleStaff';
  static const roleAdmin = 'roleAdmin';

  // Profile actions
  static const editProfile = 'editProfile';
  static const saveChanges = 'saveChanges';
  static const profileUpdated = 'profileUpdated';
  static const profileEmpty = 'profileEmpty';
  static const nameRequired = 'nameRequired';
  static const nameLettersOnly = 'nameLettersOnly';
  static const phoneRequired = 'phoneRequired';
  static const phoneInvalid = 'phoneInvalid';

  // Delete account
  static const deleteAccount = 'deleteAccount';
  static const deleteAccountWarning = 'deleteAccountWarning';
  static const deleteAccountConfirmTitle = 'deleteAccountConfirmTitle';
  static const deleteAccountConfirmBody = 'deleteAccountConfirmBody';
  static const deleteAccountFinalTitle = 'deleteAccountFinalTitle';
  static const deleteAccountFinalBody = 'deleteAccountFinalBody';
  static const deleteAccountDone = 'deleteAccountDone';
  static const cancel = 'cancel';
  static const back = 'back';
  static const continueAction = 'continueAction';

  // Shared
  static const genericError = 'genericError';
  static const notImplementedYet = 'notImplementedYet';
}
