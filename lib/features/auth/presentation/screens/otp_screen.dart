import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';
import '../../../../core/router/route_paths.dart';

class OtpScreen extends StatefulWidget {
  final String contact;
  const OtpScreen({super.key, required this.contact});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();
  int _secondsRemaining = 60;
  bool _canResend = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحقق من الرمز')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoginFailState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
            }
            if (state is AuthActionSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ تم إعادة إرسال الرمز بنجاح!'), backgroundColor: Colors.green),
              );
            }
            if (state is OtpVerifiedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ تم تفعيل الحساب بنجاح! يرجى تسجيل الدخول.'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go(RoutePaths.login);
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('أدخل الرمز المكون من 6 أرقام', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('تم إرساله إلى ${widget.contact}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),

                Pinput(
                  controller: _pinController,
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onCompleted: (pin) => _verifyOtp(pin),
                ),

                const SizedBox(height: 32),

                state is AuthLoadingState
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          final code = _pinController.text.trim();
                          if (code.length == 6) {
                            _verifyOtp(code);
                          } else {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(const SnackBar(content: Text('الرجاء إدخال 6 أرقام')));
                          }
                        },
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                        child: const Text('تحقق'),
                      ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _canResend
                          ? () {
                              context.read<AuthCubit>().resendOtp(widget.contact);
                              _startTimer();
                            }
                          : null,
                      child: Text(_canResend ? 'إعادة إرسال الرمز' : 'انتظر $_secondsRemaining ثانية'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _verifyOtp(String code) {
    context.read<AuthCubit>().verifyOtp(contact: widget.contact, code: code);
  }
}
