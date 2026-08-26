import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/delete_account_dialog.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final firstConfirmation = await DeleteAccountDialog.showFirstConfirmation(
      context,
    );

    if (!firstConfirmation || !context.mounted) {
      return;
    }

    final finalConfirmation = await DeleteAccountDialog.showFinalConfirmation(
      context,
    );

    if (!finalConfirmation || !context.mounted) {
      return;
    }

    final authState = context.read<AuthCubit>().state;

    if (authState is LoginSuccessState) {
      context.read<ProfileCubit>().deleteProfile(token: authState.user.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حذف الحساب')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.deleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حذف الحساب بنجاح')),
            );

            Navigator.of(context).popUntil((route) => route.isFirst);
          }

          if (state.status == ProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'حدث خطأ أثناء حذف الحساب'),
              ),
            );
          }
        },
        builder: (context, state) {
          final isDeleting = state.status == ProfileStatus.deleting;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 80),
                const SizedBox(height: 24),
                const Text(
                  'حذف الحساب',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'عند حذف حسابك سيتم حذف بيانات الحساب نهائيًا. '
                  'يرجى التأكد قبل المتابعة.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isDeleting
                        ? null
                        : () => _deleteAccount(context),
                    icon: isDeleting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.delete_outline),
                    label: Text(
                      isDeleting ? 'جاري حذف الحساب...' : 'حذف الحساب',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
