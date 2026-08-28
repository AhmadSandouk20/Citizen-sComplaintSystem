import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/auth/data/models/user_type_enum.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;
  final ValueChanged<UserType> onChangeRole;

  const UserCard({
    Key? key,
    required this.user,
    required this.onDelete,
    required this.onToggleActive,
    required this.onChangeRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAdmin = user.type == UserType.admin;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: scheme.primaryContainer,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: textTheme.headlineSmall?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        user.email ?? LocaleKeys.noEmail.tr(),
                        style: textTheme.titleSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 20,
                            color: scheme.primaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${LocaleKeys.phone.tr()}:',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user.phone ?? LocaleKeys.none.tr(),
                            style: textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.lock_clock,
                            size: 20,
                            color: scheme.primaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${LocaleKeys.lastLogin.tr()}:',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              user.lastLoginAt != null
                                  ? user.lastLoginAt!.toLocal().toString()
                                  : LocaleKeys.never.tr(),
                              style: textTheme.bodyLarge?.copyWith(
                                color: scheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.badge,
                          size: 20,
                          color: scheme.primaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${LocaleKeys.role.tr()}:',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.type.name,
                          style: textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    PopupMenuButton<UserType>(
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(user.type.name, style: textTheme.titleSmall),
                          Icon(Icons.arrow_drop_down, size: 28),
                        ],
                      ),
                      tooltip: LocaleKeys.changeRole.tr(),
                      onSelected: onChangeRole,
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) => [
                        if (user.type != UserType.citizen)
                          PopupMenuItem(
                            value: UserType.citizen,
                            child: Text(LocaleKeys.citizen.tr()),
                          ),
                        if (user.type != UserType.staff)
                          PopupMenuItem(
                            value: UserType.staff,
                            child: Text(LocaleKeys.staff.tr()),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              user.isActive ? Icons.check_circle : Icons.cancel,
                              color: user.isActive
                                  ? scheme.primary
                                  : scheme.outline,
                              size: 32,
                            ),
                            onPressed: onToggleActive,
                            tooltip: user.isActive
                                ? LocaleKeys.deactivate.tr()
                                : LocaleKeys.activate.tr(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user.isActive
                                ? LocaleKeys.active.tr()
                                : LocaleKeys.inactive.tr(),
                            style: textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    iconSize: 60,
                    tooltip: LocaleKeys.delete.tr(),
                    onPressed: onDelete,
                  ),
                ],
              ),
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Chip(
                  label: Text(LocaleKeys.adminProtected.tr()),
                  backgroundColor: scheme.primaryContainer,
                  labelStyle: textTheme.labelLarge?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
