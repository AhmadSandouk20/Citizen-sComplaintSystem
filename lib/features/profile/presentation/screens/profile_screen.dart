import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/local_keys.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widget/empty_state.dart';
import '../../../../core/widget/error_view.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_body.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.profile.tr())),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          // Loading — only when there is nothing to show yet; a refresh over
          // existing data keeps the content on screen.
          if (state.status == ProfileStatus.loading && state.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (state.status == ProfileStatus.error && state.profile == null) {
            return ErrorView(
              message: state.errorMessage ?? LocaleKeys.genericError.tr(),
              buttonText: LocaleKeys.retry.tr(),
              onRetry: () => context.read<ProfileCubit>().getProfile(),
            );
          }

          final profile = state.profile;

          // Empty
          if (profile == null) {
            return EmptyState(
              icon: Icons.person_off_outlined,
              message: LocaleKeys.profileEmpty.tr(),
            );
          }

          // Success
          return ProfileBody(
            profile: profile,
            onRefresh: () => context.read<ProfileCubit>().getProfile(),
            onEdit: () => context.push(RoutePaths.editProfile),
            onDelete: () => context.push(RoutePaths.deleteAccount),
          );
        },
      ),
    );
  }
}
