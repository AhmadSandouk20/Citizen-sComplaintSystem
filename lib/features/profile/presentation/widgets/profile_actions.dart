import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/local_keys.dart';
import '../../../../core/router/route_paths.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
          label: Text(LocaleKeys.editProfile.tr()),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            await context.read<AuthCubit>().logout();
            if (context.mounted) context.go(RoutePaths.login);
          },
          icon: const Icon(Icons.logout),
          label: Text(LocaleKeys.logout.tr()),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onDelete,
          style: TextButton.styleFrom(foregroundColor: scheme.error),
          icon: const Icon(Icons.delete_forever_outlined),
          label: Text(LocaleKeys.deleteAccount.tr()),
        ),
      ],
    );
  }
}
