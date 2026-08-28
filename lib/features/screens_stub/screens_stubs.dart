import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_paths.dart';
import '../locale/presentation/bloc/locale_cubit.dart';
import '../theme/presentation/bloc/theme_cubit.dart';

// ----------------Profile-------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final localeCubit = context.read<LocaleCubit>();

    final currentTheme = context.watch<ThemeCubit>().state;
    final currentLocale = context.watch<LocaleCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile (Test Center)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   '${LocaleKeys.theme.tr()}: ${currentTheme.themeMode == ThemeMode.dark ? LocaleKeys.dark.tr() : LocaleKeys.light.tr()}',
                    //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => themeCubit.toggleThemeMode(),
                      icon: Icon(
                        currentTheme.themeMode == ThemeMode.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      label: Text(
                        currentTheme.themeMode == ThemeMode.dark
                            ? 'Switch to Light'
                            : 'Switch to Dark',
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    // '${LocaleKeys.language.tr()}: ${currentLocale.locale.languageCode == 'en' ? 'English' : 'العربية'}',
                    // style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    // fontWeight: FontWeight.bold,
                    // ),
                    // ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => localeCubit.toggleLanguage(context),
                      icon: Icon(
                        currentLocale.locale.languageCode == 'en'
                            ? Icons.translate
                            : Icons.translate,
                      ),
                      label: Text(
                        currentLocale.locale.languageCode == 'en'
                            ? 'Switch to العربية'
                            : 'Switch to English',
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class CitizenHomeScreen extends StatelessWidget {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citizen Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),

            Wrap(
              spacing: 16,
              children: [
                _QuickActionCard(
                  title: 'Submit Complaint',
                  icon: Icons.add_circle,
                  onTap: () => context.go(RoutePaths.submit),
                ),
                _QuickActionCard(
                  title: 'Track a Complaint',
                  icon: Icons.search,
                  onTap: () => context.go(RoutePaths.cTrackEntry),
                ),
                _QuickActionCard(
                  title: 'My Complaints',
                  icon: Icons.list,
                  onTap: () => context.go(RoutePaths.cComplaints),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

// ----- CITIZEN -----
class CitizenComplaintListScreen extends StatelessWidget {
  const CitizenComplaintListScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('My Complaints')));
}

class SubmitComplaintScreen extends StatelessWidget {
  const SubmitComplaintScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Submit Complaint')));
}

// ----- STAFF -----
class StaffComplainsQueueScreen extends StatelessWidget {
  const StaffComplainsQueueScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Staff Queue')));
}

// ----- ADMIN -----
class AdminStatisticsScreen extends StatelessWidget {
  const AdminStatisticsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Statistics')));
}

class AdminUsersListScreen extends StatelessWidget {
  const AdminUsersListScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Users List')));
}

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Reports')));
}
