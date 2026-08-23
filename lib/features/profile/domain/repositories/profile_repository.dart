import '../entities/profile_entity.dart';

/// Contract for `/api/auth/profile`.
///
/// No `token` parameter: the bearer header is attached by `AuthInterceptor`.
abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();

  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
  });

  Future<void> deleteProfile();
}
