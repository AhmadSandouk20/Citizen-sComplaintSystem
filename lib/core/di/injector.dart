import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/admin/data/agency_complaints_repository_implementation.dart';
import '../../features/admin/data/agency_repository_implementation.dart';
import '../../features/admin/data/staff_management_repository_implementation.dart';
import '../../features/admin/data/user_management_repository_implementation.dart';
import '../../features/admin/domain/agency_complaints_repository.dart';
import '../../features/admin/domain/agency_repository.dart';
import '../../features/admin/domain/staff_management_repository.dart';
import '../../features/admin/domain/user_management_repository.dart';
import '../../features/admin/presentation/bloc/agency/agency_complaints_cubit/admin_agency_complaints_cubit.dart';
import '../../features/admin/presentation/bloc/agency/agency_cubit/admin_agency_cubit.dart';
import '../../features/admin/presentation/bloc/staff/staff_management_cubit.dart';
import '../../features/admin/presentation/bloc/user/user_management_cubit.dart';
import '../../features/admin_analytics/data/datasources/statistics_remote_datasource.dart';
import '../../features/admin_analytics/data/repositories/statistics_repository_impl.dart';
import '../../features/admin_analytics/domain/repositories/statistics_repository.dart';
import '../../features/admin_analytics/presentation/bloc/performance_cubit.dart';
import '../../features/admin_analytics/presentation/bloc/statistics_cubit.dart';
import '../../features/admin_reports/data/datasources/reports_remote_datasource.dart';
import '../../features/admin_reports/data/repositories/reports_repository_impl.dart';
import '../../features/admin_reports/domain/repositories/reports_repository.dart';
import '../../features/admin_reports/presentation/bloc/reports_cubit.dart';
import '../../features/admin_users/data/datasources/admin_users_remote_datasource.dart';
import '../../features/admin_users/data/repositories/admin_users_repository_impl.dart';
import '../../features/admin_users/domain/repositories/admin_users_repository.dart';
import '../../features/admin_users/presentation/bloc/admin_user_detail_cubit.dart';
// `AgencyRepository` exists twice: the admin track owns agency CRUD, the
// citizen track only needs the public list for the complaint form. Aliased
// so both can be registered.
import '../../features/agencies/data/data_sources/agency_remote_data_source.dart';
import '../../features/agencies/data/repositories/agency_repository_impl.dart'
    as citizen_agencies;
import '../../features/agencies/domain/repositories/agency_repository.dart'
    as citizen_agencies_domain;
import '../../features/agencies/presentation/cubit/agency_cubit.dart';
import '../../features/attachments/presentation/cubit/attachment_cubit.dart';
import '../../features/auth/data/auth_repository_implementation.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/locale/presentation/bloc/locale_cubit.dart';
import '../../features/notifications/data/datasources/notifications_remote_datasource.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/data/services/fcm_service.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/theme/presentation/bloc/theme_cubit.dart';
import '../../features/complaints/data/data_sources/complaint_remote_data_source.dart';
import '../../features/complaints/data/repositories/complaint_repository_impl.dart';
import '../../features/complaints/domain/repositories/complaint_repository.dart';
import '../../features/complaints/presentation/cubit/complaint_details_cubit.dart';
import '../../features/complaints/presentation/cubit/create_complaint_cubit.dart';
import '../../features/complaints/presentation/cubit/my_complaints_cubit.dart';
import '../../features/complaints/presentation/cubit/status_history_cubit.dart';
import '../../features/complaints/presentation/cubit/track_complaint_cubit.dart';
import '../../features/complaints/presentation/cubit/update_complaint_cubit.dart';
import '../../features/location/data/services/reverse_geocoding_service.dart';
import '../api/api_service.dart';
import '../files/services/attachment_picker_service.dart';
import '../files/services/multipart_upload_service.dart';
import '../network/dio_client.dart';

import '../../features/agency_workspace/data/data_sources/staff_complaints_remote_data_source.dart';
import '../../features/agency_workspace/data/repositories/staff_complaints_repository_impl.dart';
import '../../features/agency_workspace/domain/repositories/staff_complaints_repository.dart';
import '../../features/agency_workspace/presentation/cubit/staff_complaints_cubit.dart';
import '../../features/agency_workspace/presentation/cubit/staff_complaints_details_cubit.dart';

final GetIt getIt = GetIt.instance;

/// Wires the object graph. Called once from `main()` before `runApp`.
///
/// Order matters in one place only: [DioClient] reads the token through a
/// callback, so [AuthCubit] must already be registered when the callback
/// first fires — not when it is created.
void setupDependencies() {
  // ----------------------------- Session ------------------------------------
  // Registered first because everything below reads the token from it.
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

  // ----------------------------- Network ------------------------------------
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      tokenProvider: () => getIt<AuthCubit>().token,
      // A 401 means the token is already dead server-side, so drop the session
      // locally. The router's refreshListenable does the redirect.
      onUnauthorized: () => getIt<AuthCubit>().clearSession(),
    ),
  );

  // The admin repositories are written against APIService, which wraps the
  // one shared Dio. Registering it here keeps a single interceptor chain and
  // a single base URL instead of a second client.
  getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().client);
  getIt.registerLazySingleton<APIService>(() => APIService(getIt<Dio>()));

  // ------------------------------- Auth -------------------------------------
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImplementation(getIt<DioClient>()),
  );

  // --------------------------- Notifications --------------------------------
  getIt.registerLazySingleton(
    () => NotificationsRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(getIt<NotificationsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => NotificationsCubit(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => FcmService(getIt<NotificationsRepository>()),
  );

  // ------------------------------ Profile -----------------------------------
  getIt.registerLazySingleton(
    () => ProfileRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );
  // Singleton, not a factory: the profile, edit and delete screens are three
  // separate routes and must share one state.
  getIt.registerLazySingleton(
    () => ProfileCubit(getIt<ProfileRepository>(), getIt<AuthCubit>()),
  );

  // ------------------- Admin: agencies, staff and users ---------------------
  getIt.registerLazySingleton<AgencyRepository>(
    () => AgencyRepositoryImplementation(getIt<APIService>()),
  );
  getIt.registerLazySingleton<StaffManagementRepository>(
    () => StaffManagementRepoImplementation(getIt<APIService>()),
  );
  getIt.registerLazySingleton<AgencyComplaintsRepository>(
    () => AgencyComplaintsRepositoryImplementation(getIt<APIService>()),
  );
  getIt.registerLazySingleton<UserManagementRepository>(
    () => UserManagementRepositoryImplementation(getIt<APIService>()),
  );

  // Factories: each admin screen owns its own list state and filters.
  getIt.registerFactory<AdminAgenciesCubit>(
    () => AdminAgenciesCubit(getIt<AgencyRepository>()),
  );
  getIt.registerFactory<StaffManagementCubit>(
    () => StaffManagementCubit(
      getIt<StaffManagementRepository>(),
      getIt<AgencyRepository>(),
    ),
  );
  getIt.registerFactory<AdminAgenciesComplaintCubit>(
    () => AdminAgenciesComplaintCubit(getIt<AgencyComplaintsRepository>()),
  );
  getIt.registerFactory<UserManagementCubit>(
    () => UserManagementCubit(getIt<UserManagementRepository>()),
  );

  // ------------------- Admin: analytics and reports -------------------------
  getIt.registerLazySingleton(
    () => StatisticsRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(getIt<StatisticsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => StatisticsCubit(getIt<StatisticsRepository>()),
  );
  getIt.registerFactory(() => PerformanceCubit(getIt<StatisticsRepository>()));

  getIt.registerLazySingleton(
    () => ReportsRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ReportsRepository>(
    () => ReportsRepositoryImpl(getIt<ReportsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => ReportsCubit(getIt<ReportsRepository>()));

  // The users list is served by UserManagementCubit above; this repository
  // backs the single-user detail screen, which covers GET /admin/users/{id}.
  getIt.registerLazySingleton(
    () => AdminUsersRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AdminUsersRepository>(
    () => AdminUsersRepositoryImpl(getIt<AdminUsersRemoteDataSource>()),
  );
  getIt.registerFactory(
    () => AdminUserDetailCubit(getIt<AdminUsersRepository>()),
  );

  // ---------------------------- Attachments ---------------------------------
  // Replaces the earlier FileService: works on web (bytes, not dart:io paths)
  // and separates picking from uploading.
  getIt.registerLazySingleton<AttachmentPickerService>(
    () => AttachmentPickerService(),
  );
  getIt.registerLazySingleton<MultipartUploadService>(
    () => MultipartUploadService(getIt<Dio>()),
  );
  getIt.registerFactory<AttachmentCubit>(
    () => AttachmentCubit(
      pickerService: getIt<AttachmentPickerService>(),
      uploadService: getIt<MultipartUploadService>(),
    ),
  );

  // ------------------------- Citizen complaints -----------------------------
  getIt.registerLazySingleton<ComplaintRemoteDataSource>(
    () => ComplaintRemoteDataSource(
      dio: getIt<Dio>(),
      uploadService: getIt<MultipartUploadService>(),
    ),
  );
  getIt.registerLazySingleton<ComplaintRepository>(
    () => ComplaintRepositoryImpl(
      remoteDataSource: getIt<ComplaintRemoteDataSource>(),
    ),
  );

  // Factories: each complaint screen owns its own form or list state.
  getIt.registerFactory<CreateComplaintCubit>(
    () => CreateComplaintCubit(repository: getIt<ComplaintRepository>()),
  );
  getIt.registerFactory<MyComplaintsCubit>(
    () => MyComplaintsCubit(repository: getIt<ComplaintRepository>()),
  );
  getIt.registerFactory<ComplaintDetailsCubit>(
    () => ComplaintDetailsCubit(repository: getIt<ComplaintRepository>()),
  );
  getIt.registerFactory<UpdateComplaintCubit>(
    () => UpdateComplaintCubit(repository: getIt<ComplaintRepository>()),
  );
  getIt.registerFactory<StatusHistoryCubit>(
    () => StatusHistoryCubit(repository: getIt<ComplaintRepository>()),
  );
  getIt.registerFactory<TrackComplaintCubit>(
    () => TrackComplaintCubit(repository: getIt<ComplaintRepository>()),
  );

  // Public agency list, used by the complaint form's agency picker.
  getIt.registerLazySingleton<AgencyRemoteDataSource>(
    () => AgencyRemoteDataSource(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<citizen_agencies_domain.AgencyRepository>(
    () => citizen_agencies.AgencyRepositoryImpl(
      remoteDataSource: getIt<AgencyRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<AgencyCubit>(
    () => AgencyCubit(
      repository: getIt<citizen_agencies_domain.AgencyRepository>(),
    ),
  );

  // ------------------------------ Location ----------------------------------
  // Turns a picked map point into the free-text address the API stores in
  // complaints.location_text; the backend has no lat/lng columns.
  getIt.registerLazySingleton<ReverseGeocodingService>(
    () => ReverseGeocodingService(dio: getIt<Dio>()),
  );

  // ------------------------------- Shell ------------------------------------
  getIt.registerLazySingleton(() => ThemeCubit());
  getIt.registerLazySingleton(() => LocaleCubit());

  //-------------------------------staff----------------------------------

  getIt.registerLazySingleton<StaffComplaintsRemoteDataSource>(
    () => StaffComplaintsRemoteDataSource(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<StaffComplaintsRepository>(
    () => StaffComplaintsRepositoryImpl(
      remoteDataSource: getIt<StaffComplaintsRemoteDataSource>(),
    ),
  );

  getIt.registerFactory<StaffComplaintsCubit>(
    () => StaffComplaintsCubit(repository: getIt<StaffComplaintsRepository>()),
  );

  getIt.registerFactory<StaffComplaintDetailsCubit>(
    () => StaffComplaintDetailsCubit(
      repository: getIt<StaffComplaintsRepository>(),
    ),
  );
}
