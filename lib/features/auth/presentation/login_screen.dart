import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widget/error_view.dart';
import '../../../core/widget/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        identifier: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            context.go('/home');
          }
        },
        builder: (context, state) {
          if (state is LoginLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email/Phone'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your email or phone' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your password' : null,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Login',
                    onPressed: _submit,
                    isLoading: state is LoginLoadingState,
                  ),
                  if (state is LoginFailState) ...[
                    const SizedBox(height: 16),
                    ErrorView(
                      message: state.message,
                      onRetry: _submit,
                      buttonText: 'Retry',
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
