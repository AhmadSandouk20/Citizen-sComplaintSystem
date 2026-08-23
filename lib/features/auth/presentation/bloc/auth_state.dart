import 'package:equatable/equatable.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';

sealed class AuthState extends Equatable {}

class AuthInitState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends AuthState {
  final UserModel user;

  LoginSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailState extends AuthState {
  final String message;

  LoginFailState(this.message);

  @override
  List<Object?> get props => [message];
}
