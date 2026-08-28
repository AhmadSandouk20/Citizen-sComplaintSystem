import 'package:bloc/bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_role_enum.dart';
import '../../domain/auth_repository.dart';
import 'auth_state.dart';

/// Owns the session for the whole app.
///
/// Everything else reads [token] / [user] / [role] from here — the Dio
/// interceptor, the router guard, the shell, and the FCM registration.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitState());

  final AuthRepository _repository;

  /// The bearer token, held apart from the state machine.
  ///
  /// It cannot be derived from [state]: during [restoreSession] the state is
  /// `AuthRestoringState`, so a state-derived getter returns null exactly when
  /// the profile request needs the token — the request then goes out
  /// unauthenticated, 401s, and the session is wiped on every cold start.
  String? _token;

  UserModel? get user => state is LoginSuccessState
      ? (state as LoginSuccessState).user
      : null;

  String? get token => _token;

  UserRole? get role => user?.role;

  bool get isAuthenticated => user != null;

  /// Exchanges a persisted token for a user on cold start.
  ///
  /// Called once from `main()` before the first frame so the router can make
  /// its redirect decision with a settled session instead of bouncing the
  /// user to the login screen and back.
  Future<void> restoreSession() async {
    final stored = await _repository.readStoredToken();
    if (stored == null || stored.isEmpty) {
      _token = null;
      emit(const AuthInitState());
      return;
    }

    // Set before the request so the interceptor can attach it.
    _token = stored;
    emit(const AuthRestoringState());
    try {
      emit(LoginSuccessState(await _repository.getProfile(stored)));
    } catch (_) {
      // Expired or revoked token — start clean rather than showing an error
      // the user cannot act on at launch.
      _token = null;
      await _repository.clearStoredToken();
      emit(const AuthInitState());
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    emit(const AuthLoadingState());
    try {
      final user = await _repository.login(identifier, password);
      _token = user.token;
      emit(LoginSuccessState(user));
    } on AppException catch (e) {
      emit(LoginFailState(e.message, fieldErrors: e.fieldErrors));
    } catch (e) {
      emit(LoginFailState(e.toString()));
    }
  }

  /// POST /auth/register — sends an OTP; does not sign the user in.
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) => _run(
    () => _repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    ),
  );

  /// POST /auth/verify-otp — activates the account.
  Future<void> verifyOtp({
    required String contact,
    required String code,
  }) async {
    emit(const AuthLoadingState());
    try {
      await _repository.verifyOtp(contact: contact, code: code);
      emit(const OtpVerifiedState());
    } on AppException catch (e) {
      emit(LoginFailState(e.message, fieldErrors: e.fieldErrors));
    } catch (e) {
      emit(LoginFailState(e.toString()));
    }
  }

  /// POST /auth/resend-otp — codes are valid for 300 seconds.
  Future<void> resendOtp(String contact) =>
      _run(() => _repository.resendOtp(contact));

  /// POST /auth/forgot-password
  Future<void> forgotPassword(String identifier) =>
      _run(() => _repository.forgotPassword(identifier));

  /// POST /auth/reset-password
  Future<void> resetPassword({
    required String contact,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) => _run(
    () => _repository.resetPassword(
      contact: contact,
      code: code,
      password: password,
      passwordConfirmation: passwordConfirmation,
    ),
  );

  Future<void> logout() async {
    await _repository.logout();
    _token = null;
    emit(const AuthInitState());
  }

  /// Shared shape for the session-less actions: loading, then success or a
  /// failure carrying the server's message.
  Future<void> _run(Future<void> Function() action) async {
    emit(const AuthLoadingState());
    try {
      await action();
      emit(const AuthActionSuccessState());
    } on AppException catch (e) {
      emit(LoginFailState(e.message, fieldErrors: e.fieldErrors));
    } catch (e) {
      emit(LoginFailState(e.toString()));
    }
  }

  /// Drops the session locally without calling the API.
  ///
  /// Used by the 401 interceptor (the token is already invalid, so calling
  /// `/auth/logout` would just 401 again) and after account deletion.
  Future<void> clearSession() async {
    _token = null;
    await _repository.clearStoredToken();
    if (state is! AuthInitState) emit(const AuthInitState());
  }

  /// Keeps the cached user in sync after a profile edit.
  void updateUser(UserModel updated) {
    if (state is! LoginSuccessState) return;
    // A profile edit must never drop the session: carry the live token onto
    // the updated user rather than trusting whatever the caller passed.
    emit(LoginSuccessState(updated.copyWith(token: _token ?? updated.token)));
  }
}
