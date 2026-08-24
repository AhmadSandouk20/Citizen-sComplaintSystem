import 'package:dio/dio.dart';
import 'package:final_flutter/core/api/api_base.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/data/models/user_type_enum.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
    : super(
        LoginSuccessState(
          UserModel(
            id: 1,
            name: 'admin',
            type: UserType.admin,
            isActive: true,
            phone: "+963999999999",
          ),
        ),
      );

  String? get token {
    final current = state;
    if (current is LoginSuccessState) return current.user.token;
    return null;
  }

  UserModel? get user {
    final current = state;
    if (current is LoginSuccessState) return current.user;
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
          baseUrl: baseUrl,
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
        data: {'identifier': identifier.trim(), 'password': password},
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
          UserModel.fromJson(Map<String, dynamic>.from(rawUser)),
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(LoginFailState('Invalid credentials. Please check your input.'));
      } else if (e.response?.statusCode == 403) {
        emit(LoginFailState('Your account is locked. Contact support.'));
      } else if (e.response?.statusCode == 422) {
        String message = 'Validation failed.';
        if (e.response?.data is Map &&
            (e.response!.data as Map)['message'] != null) {
          message = (e.response!.data as Map)['message'].toString();
        }
        emit(LoginFailState(message));
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(LoginFailState('Connection timed out. Please try again.'));
      } else if (e.type == DioExceptionType.connectionError) {
        emit(LoginFailState('Network error. Check your connection.'));
      } else {
        emit(
          LoginFailState(
            'Server error (${e.response?.statusCode ?? 'unknown'}). Please try again later.',
          ),
        );
      }
    } on FormatException {
      emit(LoginFailState('Invalid data received from server.'));
    } catch (e) {
      emit(LoginFailState('Something went wrong. Please try again.'));
    }
  }

  void logout() {
    emit(AuthInitState());
  }
}
