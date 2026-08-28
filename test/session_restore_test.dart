import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:final_flutter/features/auth/domain/auth_repository.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records what the interceptor would have seen at each call.
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.stored, this.profileFails = false});

  String? stored;
  bool profileFails;

  /// The token visible to the Dio interceptor when getProfile ran.
  String? tokenDuringProfileCall;
  late String? Function() tokenProbe;

  bool cleared = false;

  @override
  Future<String?> readStoredToken() async => stored;

  @override
  Future<void> clearStoredToken() async {
    cleared = true;
    stored = null;
  }

  @override
  Future<UserModel> getProfile(String token) async {
    tokenDuringProfileCall = tokenProbe();
    if (profileFails) throw Exception('401');
    return UserModel(
      id: 5,
      name: 'Ahmed Mohamed',
      role: UserRole.citizen,
      token: token,
    );
  }

  @override
  Future<UserModel> login(String identifier, String password) async =>
      const UserModel(
        id: 5,
        name: 'Ahmed',
        role: UserRole.citizen,
        token: 'fresh-token',
      );

  @override
  Future<void> logout() async {}

  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  test('restoreSession exposes the token BEFORE fetching the profile', () async {
    final repo = _FakeAuthRepository(stored: 'stored-token-123');
    final cubit = AuthCubit(repo);
    // Mirrors what AuthInterceptor does: read cubit.token at request time.
    repo.tokenProbe = () => cubit.token;

    await cubit.restoreSession();

    // This is the regression: it used to be null, so the request went out
    // unauthenticated, 401'd, and wiped the session on every launch.
    expect(repo.tokenDuringProfileCall, 'stored-token-123');
    expect(cubit.state, isA<LoginSuccessState>());
    expect(cubit.token, 'stored-token-123');
    expect(repo.cleared, isFalse);
  });

  test('a genuinely invalid token is cleared', () async {
    final repo = _FakeAuthRepository(
      stored: 'expired-token',
      profileFails: true,
    );
    final cubit = AuthCubit(repo);
    repo.tokenProbe = () => cubit.token;

    await cubit.restoreSession();

    expect(cubit.state, isA<AuthInitState>());
    expect(cubit.token, isNull);
    expect(repo.cleared, isTrue);
  });

  test('no stored token means no session and no API call', () async {
    final repo = _FakeAuthRepository(stored: null);
    final cubit = AuthCubit(repo);
    repo.tokenProbe = () => cubit.token;

    await cubit.restoreSession();

    expect(cubit.state, isA<AuthInitState>());
    expect(repo.tokenDuringProfileCall, isNull);
  });

  test('login publishes the token for the interceptor', () async {
    final repo = _FakeAuthRepository();
    final cubit = AuthCubit(repo);
    repo.tokenProbe = () => cubit.token;

    await cubit.login(identifier: 'a@b.c', password: 'password123');

    expect(cubit.token, 'fresh-token');
    expect(cubit.isAuthenticated, isTrue);
  });

  test('logout drops the token', () async {
    final repo = _FakeAuthRepository();
    final cubit = AuthCubit(repo);
    repo.tokenProbe = () => cubit.token;

    await cubit.login(identifier: 'a@b.c', password: 'password123');
    await cubit.logout();

    expect(cubit.token, isNull);
    expect(cubit.isAuthenticated, isFalse);
  });
}
