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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              user.email ?? 'No email',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user.phone ?? 'No phone',
                    style: TextStyle(color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.badge, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  user.type.name,
                  style: TextStyle(color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.lock_clock, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user.lastLoginAt != null
                        ? 'Last login: ${user.lastLoginAt!.toLocal()}'
                        : 'Never logged in',
                    style: TextStyle(color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isAdmin)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: onDelete,
                  ),

                if (isAdmin)
                  Icon(
                    user.isActive ? Icons.check_circle : Icons.cancel,
                    color: user.isActive ? Colors.green : Colors.grey,
                    size: 24,
                  )
                else
                  IconButton(
                    icon: Icon(
                      user.isActive ? Icons.check_circle : Icons.cancel,
                      color: user.isActive ? Colors.green : Colors.grey,
                    ),
                    tooltip: user.isActive ? 'Deactivate' : 'Activate',
                    onPressed: onToggleActive,
                  ),

                if (!isAdmin)
                  PopupMenuButton<UserType>(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.swap_horiz, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          user.type.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    tooltip: 'Change Role',
                    onSelected: (newRole) => onChangeRole(newRole),
                    itemBuilder: (context) => [
                      if (user.type != UserType.citizen)
                        const PopupMenuItem(
                          value: UserType.citizen,
                          child: Text('Make Citizen'),
                        ),
                      if (user.type != UserType.staff)
                        const PopupMenuItem(
                          value: UserType.staff,
                          child: Text('Make Staff'),
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
