import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('تعديل الملف الشخصي'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            label: const Text('حذف الحساب'),
          ),
        ),
      ],
    );
  }
}