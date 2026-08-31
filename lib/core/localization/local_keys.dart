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

  // Analytics
  static const performance = 'performance';
  static const insufficientData = 'insufficientData';
  static const insufficientDataHint = 'insufficientDataHint';
  static const totalComplaints = 'totalComplaints';
  static const resolvedCount = 'resolvedCount';
  static const resolutionRate = 'resolutionRate';
  static const avgResolution = 'avgResolution';
  static const byStatus = 'byStatus';
  static const byPriority = 'byPriority';
  static const agencyPerformance = 'agencyPerformance';
  static const timeSeries = 'timeSeries';
  static const totalOperations = 'totalOperations';
  static const avgDuration = 'avgDuration';
  static const errorRate = 'errorRate';
  static const byLayer = 'byLayer';

  // Complaint status and priority, as returned by the API
  static const statusNew = 'statusNew';
  static const statusInProgress = 'statusInProgress';
  static const statusResolved = 'statusResolved';
  static const statusRejected = 'statusRejected';
  static const priorityLow = 'priorityLow';
  static const priorityMedium = 'priorityMedium';
  static const priorityHigh = 'priorityHigh';

  // Reports
  static const reportsHint = 'reportsHint';
  static const downloadComplaintsCsv = 'downloadComplaintsCsv';
  static const downloadStatisticsCsv = 'downloadStatisticsCsv';
  static const downloadComplaintsPdf = 'downloadComplaintsPdf';
  static const downloadStarted = 'downloadStarted';

  // Admin user detail
  static const role = 'role';
  static const editUser = 'editUser';
  static const save = 'save';
  static const deleteUser = 'deleteUser';
  static const deleteUserConfirm = 'deleteUserConfirm';
  static const userUpdated = 'userUpdated';
  static const userDeleted = 'userDeleted';
  static const cannotEditSelf = 'cannotEditSelf';
  static const neverLoggedIn = 'neverLoggedIn';
  static const usersEmpty = 'usersEmpty';

  // Login / home
  static const forgotPassword = 'forgotPassword';
  static const noAccount = 'noAccount';
  static const createAccount = 'createAccount';
  static const trackWithoutLogin = 'trackWithoutLogin';
  static const welcome = 'welcome';
  static const quickActions = 'quickActions';
  static const newComplaint = 'newComplaint';
  static const myComplaintsShort = 'myComplaintsShort';
  static const viewAll = 'viewAll';
  static const recentComplaints = 'recentComplaints';

  // Complaint submitted
  static const complaintSubmitted = 'complaintSubmitted';
  static const submittedHint = 'submittedHint';
  static const trackingCode = 'trackingCode';
  static const copyCode = 'copyCode';
  static const codeCopied = 'codeCopied';
  static const done = 'done';
  static const viewComplaint = 'viewComplaint';
  static const complaintNumber = 'complaintNumber';

  static const noComplaintsFound = 'noComplaintsFound';

  // Agency workspace (staff)
  static const status = 'status';
  static const priority = 'priority';
  static const agency = 'agency';
  static const complaintTitle = 'complaintTitle';
  static const referenceNumber = 'referenceNumber';
  static const lockState = 'lockState';
  static const lockAvailable = 'lockAvailable';
  static const view = 'view';
  static const apply = 'apply';
  static const clearFilters = 'clearFilters';
  static const allStatuses = 'allStatuses';
  static const allPriorities = 'allPriorities';
  static const noMatchingResults = 'noMatchingResults';
  static const totalCount = 'totalCount';
  static const changedBy = 'changedBy';
  static const requestInfo = 'requestInfo';
  static const revisions = 'revisions';
  static const statusHistory = 'statusHistory';

  // Agency workspace — messages
  static const complaintDetails = 'complaintDetails';
  static const citizenInfo = 'citizenInfo';
  static const description = 'description';
  static const location = 'location';
  static const message = 'message';
  static const internalNote = 'internalNote';
  static const updateComplaintAction = 'updateComplaintAction';
  static const viewDetails = 'viewDetails';
  static const lockComplaint = 'lockComplaint';
  static const unlockComplaint = 'unlockComplaint';
  static const locked = 'locked';
  static const sendRequest = 'sendRequest';
  static const dateFrom = 'dateFrom';
  static const dateTo = 'dateTo';
  static const before = 'before';
  static const after = 'after';
  static const firstVersion = 'firstVersion';
  static const noVisibleChanges = 'noVisibleChanges';
  static const requestInfoHint = 'requestInfoHint';
  static const requestInfoPlaceholder = 'requestInfoPlaceholder';
  static const internalNotePlaceholder = 'internalNotePlaceholder';
  static const lockBeforeEditing = 'lockBeforeEditing';
  static const mustHoldLock = 'mustHoldLock';
  static const messageRequired = 'messageRequired';
  static const lockedOk = 'lockedOk';
  static const unlockedOk = 'unlockedOk';
  static const complaintUpdated = 'complaintUpdated';
  static const requestInfoSent = 'requestInfoSent';
  static const loadComplaintsFailed = 'loadComplaintsFailed';
  static const loadDetailsFailed = 'loadDetailsFailed';
  static const requestInfoFailed = 'requestInfoFailed';
  static const versionNumber = 'versionNumber';

  static const anotherStaff = 'anotherStaff';
  static const lockedBy = 'lockedBy';
  static const lockedByCannotEdit = 'lockedByCannotEdit';

  // Admin web dashboard
  static const add = 'add';
  static const addAgency = 'addAgency';
  static const addStaff = 'addStaff';
  static const address = 'address';
  static const agencyDetails = 'agencyDetails';
  static const category = 'category';
  static const city = 'city';
  static const editAgency = 'editAgency';
  static const editStaff = 'editStaff';
  static const error = 'error';
  static const loading = 'loading';
  static const noAgenciesFound = 'noAgenciesFound';
  static const noEmail = 'noEmail';
  static const noOtherAgencies = 'noOtherAgencies';
  static const noStaffFound = 'noStaffFound';
  static const passwordMinLength = 'passwordMinLength';
  static const remove = 'remove';
  static const removeConfirm = 'removeConfirm';
  static const requiredField = 'requiredField';
  static const selectAgency = 'selectAgency';
  static const selectAgencyRequired = 'selectAgencyRequired';
  static const selectNewAgency = 'selectNewAgency';
  static const transfer = 'transfer';
  static const update = 'update';


  // Shared
  static const genericError = 'genericError';
  static const notImplementedYet = 'notImplementedYet';
}
