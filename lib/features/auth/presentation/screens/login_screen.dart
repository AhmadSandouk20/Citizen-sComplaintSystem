import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:final_flutter/features/auth/data/models/user_role_enum.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:final_flutter/features/notifications/data/services/fcm_service.dart';
import 'package:final_flutter/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  String _homeFor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return RoutePaths.statistics;
      case UserRole.staff:
        return RoutePaths.sComplaints;
      case UserRole.citizen:
        return RoutePaths.cHome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is LoginSuccessState) {
          await getIt<FcmService>().syncToken();
          await getIt<NotificationsCubit>().refreshUnreadCount();
          if (!context.mounted) return;
          context.go(_homeFor(state.user.role));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final loading = state is LoginLoadingState;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            LocaleKeys.ccs.tr(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _identifier,
                            enabled: !loading,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: LocaleKeys.email.tr(),
                            ),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                ? LocaleKeys.email.tr()
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _password,
                            enabled: !loading,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: LocaleKeys.password.tr(),
                            ),
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? LocaleKeys.password.tr()
                                : null,
                          ),
                          if (state is LoginFailState) ...[
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: loading
                                ? null
                                : () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    context.read<AuthCubit>().login(
                                      identifier: _identifier.text,
                                      password: _password.text,
                                    );
                                  },
                            child: loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(LocaleKeys.login.tr()),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
