import '../../../core/error/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/token_storage.dart';
import '../domain/auth_repository.dart';
import 'models/user_model.dart';

class AuthRepositoryImplementation implements AuthRepository {
  AuthRepositoryImplementation(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<UserModel> login(String identifier, String password) async {
    try {
      final response = await _dioClient.client.post(
        '/auth/login',
        data: {'identifier': identifier.trim(), 'password': password},
      );

      final body = response.data;
      if (body is! Map) {
        throw const AppException('Unexpected login response from the server.');
      }

      final token = body['token']?.toString();
      final rawUser = body['user'];

      if (token == null || token.isEmpty || rawUser is! Map) {
        throw const AppException('The server did not return a valid session.');
      }

      // Persist before returning so a cold start can restore this session.
      await TokenStorage.saveToken(token);

      // The token travels beside the user object, not inside it, so it is
      // attached after parsing.
      return UserModel.fromJson(
        Map<String, dynamic>.from(rawUser),
      ).copyWith(token: token);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      await _dioClient.client.post(
        '/auth/register',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'password_confirmation': password,
          if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        },
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<void> verifyOtp({
    required String contact,
    required String code,
  }) async {
    try {
      await _dioClient.client.post(
        '/auth/verify-otp',
        data: {'contact': contact.trim(), 'code': code.trim()},
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<void> resendOtp(String contact) async {
    try {
      await _dioClient.client.post(
        '/auth/resend-otp',
        data: {'contact': contact.trim()},
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<void> forgotPassword(String identifier) async {
    try {
      await _dioClient.client.post(
        '/auth/forgot-password',
        data: {'identifier': identifier.trim()},
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<void> resetPassword({
    required String contact,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _dioClient.client.post(
        '/auth/reset-password',
        data: {
          'contact': contact.trim(),
          'code': code.trim(),
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.client.post('/auth/logout');
    } catch (_) {
      // A failed server-side revoke must not trap the user in the app;
      // the local token is cleared either way.
    } finally {
      await TokenStorage.deleteToken();
    }
  }

  @override
  Future<UserModel> getProfile(String token) async {
    try {
      final response = await _dioClient.client.get('/auth/profile');

      final body = response.data;
      final rawUser = body is Map ? (body['user'] ?? body['data'] ?? body) : null;

      if (rawUser is! Map) {
        throw const AppException('Unexpected profile response.');
      }

      // The token travels beside the user object, not inside it, so it is
      // attached after parsing.
      return UserModel.fromJson(
        Map<String, dynamic>.from(rawUser),
      ).copyWith(token: token);
    } catch (error) {
      throw DioClient.mapError(error);
    }
  }

  @override
  Future<String?> readStoredToken() => TokenStorage.getToken();

  @override
  Future<void> clearStoredToken() => TokenStorage.deleteToken();
}
