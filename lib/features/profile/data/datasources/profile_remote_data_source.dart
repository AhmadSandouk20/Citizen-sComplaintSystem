import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dioClient.client.get('/auth/profile');
      return ProfileModel.fromJson(_unwrapUser(response.data));
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<ProfileModel> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final response = await _dioClient.client.put(
        '/auth/profile',
        data: {'name': name, 'phone': phone},
      );
      return ProfileModel.fromJson(_unwrapUser(response.data));
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  Future<void> deleteProfile() async {
    try {
      await _dioClient.client.delete('/auth/profile');
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  /// The API wraps the user in `{"user": {...}}`, but tolerate a bare object
  /// or a `data` envelope so a backend tweak does not crash the screen.
  Map<String, dynamic> _unwrapUser(dynamic body) {
    if (body is! Map) {
      throw const AppException('Unexpected profile response.');
    }
    final raw = body['user'] ?? body['data'] ?? body;
    if (raw is! Map) {
      throw const AppException('Unexpected profile response.');
    }
    return Map<String, dynamic>.from(raw);
  }
}
