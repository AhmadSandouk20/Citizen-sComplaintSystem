import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_paths.dart';
import '../locale/presentation/bloc/locale_cubit.dart';
import '../theme/presentation/bloc/theme_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('SplashScreen')));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Login')));
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Signup')));
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Signup')));
}

class AccountLockedScreen extends StatelessWidget {
  const AccountLockedScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Account Locked')));
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Register')));
}

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Verify OTP')));
}

class ResendOtpScreen extends StatelessWidget {
  const ResendOtpScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Resend OTP')));
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Forgot Password')));
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Reset Password')));
}

// ------------------track entry------------
class TrackEntryScreen extends StatelessWidget {
  const TrackEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Track Complaint')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Enter Tracking Code',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final code = codeController.text.trim();
                if (code.isNotEmpty) {
                  // Navigate to the required /:code route
                  context.go('/citizen/track/$code');
                }
              },
              child: const Text('Track'),
            ),
          ],
        ),
      ),
    );
  }
}

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
                    Text(
                      '${LocaleKeys.theme.tr()}: ${currentTheme.themeMode == ThemeMode.dark ? LocaleKeys.dark.tr() : LocaleKeys.light.tr()}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                    Text(
                      '${LocaleKeys.language.tr()}: ${currentLocale.locale.languageCode == 'en' ? 'English' : 'العربية'}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () =>
                          localeCubit.toggleLanguage(context), // YOUR method
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
            // Quick action cards
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
            // Summary stats (unresolved, total, etc.) goes here later
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

class SubmissionSuccessScreen extends StatelessWidget {
  const SubmissionSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('My Complaints')));
}

class CitizenComplaintDetailScreen extends StatelessWidget {
  const CitizenComplaintDetailScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Complaint Detail')));
}

class SubmitComplaintScreen extends StatelessWidget {
  const SubmitComplaintScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Submit Complaint')));
}

class UpdateComplaintScreen extends StatelessWidget {
  const UpdateComplaintScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Update Complaint')));
}

class TrackComplaintScreen extends StatelessWidget {
  const TrackComplaintScreen({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Track Complaint')));
}

class UploadAttachmentsScreen extends StatelessWidget {
  const UploadAttachmentsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Upload Attachments')));
}

// ----- STAFF -----
class StaffQueueScreen extends StatelessWidget {
  const StaffQueueScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Staff Queue')));
}

class StaffComplaintDetailScreen extends StatelessWidget {
  const StaffComplaintDetailScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Staff Complaint Detail')));
}

class StaffUpdateComplaintScreen extends StatelessWidget {
  const StaffUpdateComplaintScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Staff Update')));
}

class StaffLockComplaintScreen extends StatelessWidget {
  const StaffLockComplaintScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Lock Complaint')));
}

class StaffUnlockComplaintScreen extends StatelessWidget {
  const StaffUnlockComplaintScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Unlock Complaint')));
}

class StaffRevisionsScreen extends StatelessWidget {
  const StaffRevisionsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Revisions')));
}

class StaffStatusHistoryScreen extends StatelessWidget {
  const StaffStatusHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Status History')));
}

// ----- ADMIN -----
class AdminStatisticsScreen extends StatelessWidget {
  const AdminStatisticsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Statistics')));
}

class SystemPerformanceScreen extends StatelessWidget {
  const SystemPerformanceScreen({super.key});
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

class AdminUserDetailScreen extends StatelessWidget {
  const AdminUserDetailScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('User Detail')));
}

class AdminAgenciesListScreen extends StatelessWidget {
  const AdminAgenciesListScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Agencies List')));
}

class AdminAgencyDetailScreen extends StatelessWidget {
  const AdminAgencyDetailScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Agency Detail')));
}

class AdminAgencyUsersListScreen extends StatelessWidget {
  const AdminAgencyUsersListScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Agency Users')));
}

class AdminAgencyUserDetailScreen extends StatelessWidget {
  const AdminAgencyUserDetailScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Agency User Detail')));
}

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Reports')));
}
