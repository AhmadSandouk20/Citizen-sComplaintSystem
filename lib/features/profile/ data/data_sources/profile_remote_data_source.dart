import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSource(this.dio);

  Future<ProfileModel> getProfile({required String token}) async {
    final response = await dio.get(
      '${AppConfig.apiBaseUrl}/auth/profile',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>;

    return ProfileModel.fromJson(user);
  }

  Future<ProfileModel> updateProfile({
    required String token,
    required String name,
    required String phone,
  }) async {
    final response = await dio.put(
      '${AppConfig.apiBaseUrl}/auth/profile',
      data: {'name': name, 'phone': phone},
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>;

    return ProfileModel.fromJson(user);
  }

  Future<void> deleteProfile({required String token}) async {
    await dio.delete(
      '${AppConfig.apiBaseUrl}/auth/profile',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
