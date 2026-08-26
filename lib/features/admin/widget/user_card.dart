import 'package:flutter/material.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
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
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
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
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        user.email ?? 'No email',
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
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
                            color: colorScheme.primaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Phone:',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(user.phone ?? 'N/A', style: textTheme.bodyLarge),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.lock_clock,
                            size: 20,
                            color: colorScheme.primaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Last Login:',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              user.lastLoginAt != null
                                  ? user.lastLoginAt!.toLocal().toString()
                                  : 'Never',
                              style: textTheme.bodyLarge,
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
                          color: colorScheme.primaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Role:',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(user.type.name, style: textTheme.bodyLarge),
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
                      tooltip: 'Change Role',
                      onSelected: onChangeRole,
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) => [
                        if (user.type != UserType.citizen)
                          const PopupMenuItem(
                            value: UserType.citizen,
                            child: Text(' Citizen'),
                          ),
                        if (user.type != UserType.staff)
                          const PopupMenuItem(
                            value: UserType.staff,
                            child: Text(' Staff'),
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
                              color: user.isActive ? Colors.green : Colors.grey,
                              size: 32,
                            ),
                            onPressed: onToggleActive,
                            tooltip: user.isActive ? 'Deactivate' : 'Activate',
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user.isActive ? 'Active' : 'Inactive',
                            style: textTheme.bodyLarge,
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
                    icon: const Icon(Icons.delete, color: Colors.red),
                    iconSize: 60,
                    tooltip: 'Delete',
                    onPressed: onDelete,
                  ),
                ],
              ),
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Chip(
                  label: const Text('Admin (protected)'),
                  backgroundColor: colorScheme.primaryContainer,
                  labelStyle: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
