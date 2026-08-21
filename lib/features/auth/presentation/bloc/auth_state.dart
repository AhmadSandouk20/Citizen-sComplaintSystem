import 'package:equatable/equatable.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitState extends AuthState {}

class AuthLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final UserModel user;
  const LoginSuccessState(this.user);
  @override
  List<Object?> get props => [user];
}

class LoginFailState extends AuthState {
  final String message;
  const LoginFailState(this.message);
  @override
  List<Object?> get props => [message];
}
