import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/local_keys.dart';
import '../../../../core/router/route_paths.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/delete_account_dialog.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  Future<void> _confirmAndDelete(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();

    if (!await DeleteAccountDialog.showFirstConfirmation(context)) return;
    if (!context.mounted) return;

    if (!await DeleteAccountDialog.showFinalConfirmation(context)) return;

    await cubit.deleteProfile();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.deleteAccount.tr())),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ProfileStatus.deleted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(LocaleKeys.deleteAccountDone.tr())),
              );
            // The Cubit already cleared the session; send the user to login
            // instead of popping back into a shell with no account behind it.
            context.go(RoutePaths.login);
          }

          if (state.status == ProfileStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? LocaleKeys.genericError.tr(),
                  ),
                  backgroundColor: scheme.error,
                ),
              );
            context.read<ProfileCubit>().clearError();
          }
        },
        builder: (context, state) {
          final isDeleting = state.status == ProfileStatus.deleting;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 56,
                      color: scheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.deleteAccountWarning.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: isDeleting
                          ? null
                          : () => _confirmAndDelete(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.error,
                        foregroundColor: scheme.onError,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: isDeleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.delete_forever_outlined),
                      label: Text(LocaleKeys.deleteAccount.tr()),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: isDeleting ? null : () => context.pop(),
                      child: Text(LocaleKeys.cancel.tr()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
