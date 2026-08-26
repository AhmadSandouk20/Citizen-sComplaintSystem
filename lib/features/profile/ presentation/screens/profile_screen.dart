import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_body.dart';
import '../widgets/profile_error_view.dart';
import 'delete_account_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  void _loadProfile() {
    final authState = context.read<AuthCubit>().state;

    if (authState is LoginSuccessState) {
      context.read<ProfileCubit>().getProfile(token: authState.user.token);
    }
  }

  Future<void> _refreshProfile() async {
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProfileStatus.error) {
            return ProfileErrorView(
              message: state.errorMessage ?? 'حدث خطأ، يرجى المحاولة مرة أخرى',
              onRetry: _loadProfile,
            );
          }

          final profile = state.profile;

          if (profile == null) {
            return const Center(child: Text('لا توجد بيانات للملف الشخصي'));
          }

          return ProfileBody(
            profile: profile,
            onRefresh: _refreshProfile,
            onEdit: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: EditProfileScreen(profile: profile),
                  ),
                ),
              );

              _loadProfile();
            },
            onDelete: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProfileCubit>(),
                    child: const DeleteAccountScreen(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
