import 'package:final_flutter/core/network/dio_client.dart';
import 'package:final_flutter/core/network/token_storage.dart';
import 'package:final_flutter/features/auth/domain/auth_repository.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';

import 'package:dio/dio.dart';

class AuthRepositoryImplementation implements AuthRepository {
  @override
  Future<UserModel> login(String identifier, String password) async {
    try {
      final response = await DioClient.instance.post(
        '/auth/login',
        data: {'identifier': identifier, 'password': password},
      );

      if (response.statusCode == 200) {
        final String token = response.data['token'];
        await TokenStorage.saveToken(token);

        final userJson = response.data['user'];
        return UserModel.fromJson(userJson);
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> register(String name, String email, String password) {
    throw UnimplementedError('register not yet implemented');
  }

  @override
  Future<void> verifyOtp(String contact, String code) {
    throw UnimplementedError('verifyOtp not yet implemented');
  }

  @override
  Future<void> resendOtp(String contact) {
    throw UnimplementedError('resendOtp not yet implemented');
  }

  @override
  Future<void> logout() async {
    await TokenStorage.deleteToken();
  }

  @override
  Future<UserModel> getProfile() async {
    throw UnimplementedError('getProfile not yet implemented');
  }
}
