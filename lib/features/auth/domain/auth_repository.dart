import '../data/models/user_model.dart';

/// Contract for `/api/auth/*`.
///
/// Screens are owned by the auth track, but this interface is the shared
/// surface every other feature codes against.
abstract class AuthRepository {
  /// POST /auth/login — `identifier` accepts an email or a phone number.
  Future<UserModel> login(String identifier, String password);

  /// POST /auth/register — sends an OTP to [email], does not log the user in.
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  /// POST /auth/verify-otp — activates the account.
  Future<void> verifyOtp({required String contact, required String code});

  /// POST /auth/resend-otp — codes are valid for 300 seconds.
  Future<void> resendOtp(String contact);

  /// POST /auth/forgot-password
  Future<void> forgotPassword(String identifier);

  /// POST /auth/reset-password
  Future<void> resetPassword({
    required String contact,
    required String code,
    required String password,
    required String passwordConfirmation,
  });

  /// POST /auth/logout — revokes the token server-side.
  Future<void> logout();

  /// GET /auth/profile — used to restore a session from a stored token.
  Future<UserModel> getProfile(String token);

  /// Reads the persisted token, if any.
  Future<String?> readStoredToken();

  /// Clears the persisted token.
  Future<void> clearStoredToken();
}
