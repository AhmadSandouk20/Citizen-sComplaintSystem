import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/local_keys.dart';
import '../../domain/entities/profile_entity.dart';
import 'profile_actions.dart';
import 'profile_header.dart';
import 'profile_info_tile.dart';
import 'profile_role_label.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    required this.profile,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
  });

  final ProfileEntity profile;
  final Future<void> Function() onRefresh;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Center(
        child: ConstrainedBox(
          // Without this the info rows stretch edge to edge on the web shell.
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ProfileHeader(name: profile.name, role: profile.role),
              const SizedBox(height: 8),
              ProfileInfoTile(
                title: LocaleKeys.name.tr(),
                value: profile.name,
                icon: Icons.person_outline,
              ),
              ProfileInfoTile(
                title: LocaleKeys.email.tr(),
                value: profile.email ?? '—',
                icon: Icons.email_outlined,
              ),
              ProfileInfoTile(
                title: LocaleKeys.phone.tr(),
                value: profile.phone ?? '—',
                icon: Icons.phone_outlined,
              ),
              ProfileInfoTile(
                title: LocaleKeys.accountType.tr(),
                value: profile.role.label,
                icon: Icons.badge_outlined,
              ),
              ProfileInfoTile(
                title: LocaleKeys.accountStatus.tr(),
                value: profile.isActive
                    ? LocaleKeys.active.tr()
                    : LocaleKeys.inactive.tr(),
                icon: Icons.verified_user_outlined,
              ),
              const SizedBox(height: 24),
              ProfileActions(onEdit: onEdit, onDelete: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}

// The `UserRole.label` extension lives in `profile_role_label.dart` so both
// this widget and `ProfileHeader` share one definition.
