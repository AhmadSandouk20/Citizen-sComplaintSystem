import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// No session. Also the state after logout.
class AuthInitState extends AuthState {
  const AuthInitState();
}

/// A stored token is being exchanged for a user on app start.
/// The router treats this as "undecided" and holds on the splash route.
class AuthRestoringState extends AuthState {
  const AuthRestoringState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

/// The account was activated by a valid OTP. The user still has to sign in —
/// verification does not create a session.
class OtpVerifiedState extends AuthState {
  const OtpVerifiedState();
}

/// A one-off action succeeded (register, resend, forgot, reset) and the screen
/// should move on. Carries no session.
class AuthActionSuccessState extends AuthState {
  const AuthActionSuccessState();
}

class LoginSuccessState extends AuthState {
  final UserModel user;

  const LoginSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailState extends AuthState {
  final String message;

  /// Field-level errors from a 422, keyed by field name.
  final Map<String, List<String>>? fieldErrors;

  const LoginFailState(this.message, {this.fieldErrors});

  @override
  List<Object?> get props => [message, fieldErrors];
}
