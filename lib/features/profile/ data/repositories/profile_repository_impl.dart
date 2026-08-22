import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity> getProfile({
    required String token,
  }) {
    return remoteDataSource.getProfile(
      token: token,
    );
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String token,
    required String name,
    required String phone,
  }) {
    return remoteDataSource.updateProfile(
      token: token,
      name: name,
      phone: phone,
    );
  }

  @override
  Future<void> deleteProfile({
    required String token,
  }) {
    return remoteDataSource.deleteProfile(
      token: token,
    );
  }
}