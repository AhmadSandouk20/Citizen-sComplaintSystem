import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile({required String token});

  Future<ProfileEntity> updateProfile({
    required String token,
    required String name,
    required String phone,
  });

  Future<void> deleteProfile({required String token});
}
