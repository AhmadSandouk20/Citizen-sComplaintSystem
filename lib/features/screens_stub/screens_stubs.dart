import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_paths.dart';

// ======================================================
// AUTH
// ======================================================

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Login')));
  }
}

// ======================================================
// PROFILE STUB
// يستخدمه Admin و Staff فقط
// ======================================================

class ProfileStubScreen extends StatelessWidget {
  const ProfileStubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profile')));
  }
}

// ======================================================
// CITIZEN
// ======================================================

class CitizenHomeScreen extends StatelessWidget {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citizen Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome!', style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 24),

            const Text(
              'إجراءات سريعة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _CitizenActionButton(
              title: 'تقديم شكوى',
              icon: Icons.add_circle_outline,
              onTap: () {
                context.push(RoutePaths.submit);
              },
            ),

            const SizedBox(height: 12),

            _CitizenActionButton(
              title: 'شكاواي',
              icon: Icons.list_alt_outlined,
              onTap: () {
                context.push(RoutePaths.cComplaints);
              },
            ),

            const SizedBox(height: 12),

            _CitizenActionButton(
              title: 'تتبع شكوى',
              icon: Icons.search,
              onTap: () {
                context.push(RoutePaths.cTrackEntry);
              },
            ),

            const SizedBox(height: 12),

            _CitizenActionButton(
              title: 'الملف الشخصي',
              icon: Icons.person_outline,
              onTap: () {
                context.push(RoutePaths.cProfile);
              },
            ),

            const SizedBox(height: 24),

            // يمكن إضافة ملخص الشكاوى هنا لاحقًا:
            // - إجمالي الشكاوى
            // - الشكاوى الجديدة
            // - قيد المعالجة
            // - المحلولة
          ],
        ),
      ),
    );
  }
}

class _CitizenActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CitizenActionButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 32),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// STAFF
// ======================================================

class StaffComplainsQueueScreen extends StatelessWidget {
  const StaffComplainsQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Staff Queue')));
  }
}

// ======================================================
// ADMIN
// ======================================================

class AdminStatisticsScreen extends StatelessWidget {
  const AdminStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Statistics')));
  }
}

class AdminUsersListScreen extends StatelessWidget {
  const AdminUsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Users List')));
  }
}

class AdminAgenciesListScreen extends StatelessWidget {
  const AdminAgenciesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Agencies List')));
  }
}

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Reports')));
  }
}
