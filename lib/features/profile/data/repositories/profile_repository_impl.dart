import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ProfileEntity> getProfile() => _remoteDataSource.getProfile();

  @override
  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
  }) => _remoteDataSource.updateProfile(name: name, phone: phone);

  @override
  Future<void> deleteProfile() => _remoteDataSource.deleteProfile();
}
