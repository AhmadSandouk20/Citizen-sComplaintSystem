import 'package:dio/dio.dart';
import 'package:final_flutter/core/config/app_config.dart';
import 'package:final_flutter/core/network/dio_client.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitState());

  String? get token {
    final current = state;
    if (current is LoginSuccessState) {
      return current.user.token;
    }
    return null;
  }

  UserModel? get user {
    final current = state;
    if (current is LoginSuccessState) {
      return current.user;
    }
    return null;
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    emit(LoginLoadingState());
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      final response = await dio.post(
        '/auth/login',
        data: {
          'identifier': identifier.trim(),
          'password': password,
        },
      );
      final body = response.data;
      if (body is! Map) {
        emit(LoginFailState('Unexpected login response.'));
        return;
      }
      final token = body['token']?.toString();
      final rawUser = body['user'];
      if (token == null || token.isEmpty || rawUser is! Map) {
        emit(LoginFailState('Login succeeded without a token.'));
        return;
      }
      emit(
        LoginSuccessState(
          UserModel.fromJson(
            Map<String, dynamic>.from(rawUser),
            token: token,
          ),
        ),
      );
    } catch (error) {
      emit(LoginFailState(DioClient.mapError(error).message));
    }
  }

  void logout() {
    emit(AuthInitState());
  }
}
