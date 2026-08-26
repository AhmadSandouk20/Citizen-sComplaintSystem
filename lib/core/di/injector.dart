import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/agencies/data/data_sources/agency_remote_data_source.dart';
import '../../features/agencies/data/repositories/agency_repository_impl.dart';
import '../../features/agencies/domain/repositories/agency_repository.dart';
import '../../features/agencies/presentation/cubit/agency_cubit.dart';

import '../../features/attachments/presentation/cubit/attachment_cubit.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';

import '../../features/complaints/data/data_sources/complaint_remote_data_source.dart';
import '../../features/complaints/data/repositories/complaint_repository_impl.dart';
import '../../features/complaints/domain/repositories/complaint_repository.dart';
import '../../features/complaints/presentation/cubit/complaint_details_cubit.dart';
import '../../features/complaints/presentation/cubit/create_complaint_cubit.dart';
import '../../features/complaints/presentation/cubit/my_complaints_cubit.dart';
import '../../features/complaints/presentation/cubit/status_history_cubit.dart';
import '../../features/complaints/presentation/cubit/track_complaint_cubit.dart';
import '../../features/complaints/presentation/cubit/update_complaint_cubit.dart';

import '../../features/locale/presentation/bloc/locale_cubit.dart';

import '../../features/location/data/services/reverse_geocoding_service.dart';
import '../../features/profile/ data/data_sources/profile_remote_data_source.dart';
import '../../features/profile/ data/repositories/profile_repository_impl.dart';
import '../../features/profile/ presentation/cubit/profile_cubit.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';

import '../../features/theme/presentation/bloc/theme_cubit.dart';

import '../files/services/attachment_picker_service.dart';
import '../files/services/multipart_upload_service.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  _registerCore();
  _registerAuth();
  _registerTheme();
  _registerLocale();
  _registerProfile();
  _registerAttachments();
  _registerComplaints();
  _registerAgencies();
  _registerLocation();
}

void _registerCore() {
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<AttachmentPickerService>(
    () => AttachmentPickerService(),
  );

  getIt.registerLazySingleton<MultipartUploadService>(
    () => MultipartUploadService(getIt<Dio>()),
  );
}

void _registerAuth() {
  getIt.registerSingleton<AuthCubit>(AuthCubit());
}

void _registerTheme() {
  getIt.registerSingleton<ThemeCubit>(ThemeCubit());
}

void _registerLocale() {
  getIt.registerSingleton<LocaleCubit>(LocaleCubit());
}

void _registerProfile() {
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getIt<ProfileRepository>()),
  );
}

void _registerAttachments() {
  getIt.registerFactory<AttachmentCubit>(
    () => AttachmentCubit(
      pickerService: getIt<AttachmentPickerService>(),
      uploadService: getIt<MultipartUploadService>(),
    ),
  );
}

void _registerComplaints() {
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
}

void _registerAgencies() {
  getIt.registerLazySingleton<AgencyRemoteDataSource>(
    () => AgencyRemoteDataSource(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<AgencyRepository>(
    () =>
        AgencyRepositoryImpl(remoteDataSource: getIt<AgencyRemoteDataSource>()),
  );

  getIt.registerFactory<AgencyCubit>(
    () => AgencyCubit(repository: getIt<AgencyRepository>()),
  );
}

void _registerLocation() {
  getIt.registerLazySingleton<ReverseGeocodingService>(
    () => ReverseGeocodingService(dio: getIt<Dio>()),
  );
}
