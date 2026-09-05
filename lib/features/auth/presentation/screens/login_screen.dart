import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/localization/local_keys.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widget/app_button.dart';
import '../../../notifications/data/services/fcm_service.dart';
import '../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../data/models/user_role_enum.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().login(
      identifier: _identifierController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _onLoggedIn(BuildContext context, UserRole role) async {
    await getIt<FcmService>().syncToken();
    await getIt<NotificationsCubit>().refreshUnreadCount();
    if (!context.mounted) return;
    context.go(RoutePaths.homeForRole(role));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            _onLoggedIn(context, state.user.role);
          }
          if (state is LoginFailState) {
            if (state.message.toLowerCase().contains('locked')) {
              context.go(RoutePaths.aLocked);
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: scheme.error));
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 72, 24, 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                      colors: [scheme.primary, Color.lerp(scheme.primary, scheme.secondary, 0.35)!],
                    ),
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(32),
                      bottomEnd: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: scheme.onPrimary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.account_balance_outlined, size: 30, color: scheme.onPrimary),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        LocaleKeys.ccs.tr(),
                        style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onPrimary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        LocaleKeys.signInSubtitle.tr(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _identifierController,
                              enabled: !isLoading,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.username],
                              decoration: InputDecoration(
                                labelText: LocaleKeys.identifier.tr(),
                                prefixIcon: const Icon(Icons.person_outline, size: 20),
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? LocaleKeys.identifierRequired.tr() : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              enabled: !isLoading,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: LocaleKeys.password.tr(),
                                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                                suffixIcon: IconButton(
                                  tooltip: _obscurePassword
                                      ? LocaleKeys.showPassword.tr()
                                      : LocaleKeys.hidePassword.tr(),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return LocaleKeys.passwordRequired.tr();
                                }
                                if (v.length < 8) {
                                  return LocaleKeys.passwordTooShort.tr();
                                }
                                return null;
                              },
                            ),

                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton(
                                onPressed: isLoading ? null : () => context.push(RoutePaths.forgotPassword),
                                child: Text(LocaleKeys.forgotPassword.tr()),
                              ),
                            ),
                            const SizedBox(height: 8),

                            AppButton(
                              label: LocaleKeys.signIn.tr(),
                              onPressed: _submit,
                              isLoading: isLoading,
                              isFullWidth: true,
                              size: AppButtonSize.large,
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(LocaleKeys.noAccount.tr(), style: theme.textTheme.bodyMedium),
                                TextButton(
                                  onPressed: isLoading ? null : () => context.push(RoutePaths.signup),
                                  child: Text(LocaleKeys.createAccount.tr()),
                                ),
                              ],
                            ),

                            const Spacer(),

                            Center(
                              child: TextButton.icon(
                                onPressed: isLoading ? null : () => context.push(RoutePaths.cTrackEntry),
                                icon: const Icon(Icons.search, size: 18),
                                label: Text(LocaleKeys.trackWithoutLogin.tr()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
