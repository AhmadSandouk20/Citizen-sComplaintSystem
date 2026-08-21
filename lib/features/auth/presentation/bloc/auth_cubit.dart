import 'package:bloc/bloc.dart';
import 'package:final_flutter/features/auth/domain/auth_repository.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:final_flutter/features/auth/data/auth_repository_implementation.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = AuthRepositoryImplementation();

  AuthCubit() : super(AuthInitState());

  Future<void> login(String identifier, String password) async {
    emit(AuthLoadingState());

    try {
      final user = await _authRepository.login(identifier, password);
      emit(LoginSuccessState(user));
    } catch (e) {
      emit(LoginFailState(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthInitState());
  }
}
