import 'package:flutter/material.dart';

import '../../domain/entities/profile_entity.dart';
import 'profile_header.dart';
import 'profile_info_tile.dart';
import 'profile_actions.dart';

class ProfileBody extends StatelessWidget {
  final ProfileEntity profile;
  final Future<void> Function() onRefresh;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileBody({
    super.key,
    required this.profile,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const ProfileHeader(),

          ProfileInfoTile(
            title: 'الاسم',
            value: profile.name,
            icon: Icons.person_outline,
          ),

          ProfileInfoTile(
            title: 'البريد الإلكتروني',
            value: profile.email ?? '-',
            icon: Icons.email_outlined,
          ),

          ProfileInfoTile(
            title: 'رقم الهاتف',
            value: profile.phone ?? '-',
            icon: Icons.phone_outlined,
          ),

          ProfileInfoTile(
            title: 'نوع الحساب',
            value: _getRoleName(profile.type),
            icon: Icons.badge_outlined,
          ),

          ProfileInfoTile(
            title: 'حالة الحساب',
            value: profile.isActive ? 'نشط' : 'غير نشط',
            icon: Icons.verified_user_outlined,
          ),
          const SizedBox(height: 20),

          ProfileActions(onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }

  String _getRoleName(String type) {
    switch (type.toLowerCase()) {
      case 'citizen':
        return 'مواطن';
      case 'admin':
        return 'مدير النظام';
      case 'agency':
        return 'جهة حكومية';
      default:
        return type;
    }
  }
}
