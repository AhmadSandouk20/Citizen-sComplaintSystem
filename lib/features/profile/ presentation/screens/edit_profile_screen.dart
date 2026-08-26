import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/edit_profile_form.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.profile.name);

    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthCubit>().state;

    if (authState is LoginSuccessState) {
      context.read<ProfileCubit>().updateProfile(
        token: authState.user.token,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('.تعديل الملف الشخصي ')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.updated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('.تم تعديل الملف الشخصي بنجاح')),
            );

            Navigator.pop(context);
          }

          if (state.status == ProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'حدث خطأ، يرجى المحاولة مرة أخرى',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return EditProfileForm(
            formKey: _formKey,
            nameController: _nameController,
            phoneController: _phoneController,
            isLoading: state.status == ProfileStatus.updating,
            onSave: _save,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
