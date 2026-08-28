import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/app_button.dart';
import 'package:final_flutter/core/widget/app_text_field.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:final_flutter/features/admin/domain/staff_management_repository.dart';
import 'package:final_flutter/features/admin/domain/user_management_repository.dart';
import 'package:final_flutter/core/error/app_exception.dart';

class AdminStaffManagementFormScreen extends StatefulWidget {
  final int agencyId;
  final UserModel? staff;

  const AdminStaffManagementFormScreen({
    super.key,
    required this.agencyId,
    this.staff,
  });

  @override
  State<AdminStaffManagementFormScreen> createState() =>
      _AdminStaffManagementFormScreenState();
}

class _AdminStaffManagementFormScreenState
    extends State<AdminStaffManagementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staff?.name ?? '');
    _emailController = TextEditingController(text: widget.staff?.email ?? '');
    _phoneController = TextEditingController(text: widget.staff?.phone ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final data = <String, dynamic>{
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
    };

    try {
      if (widget.staff == null) {
        data['password'] = _passwordController.text;
        data['type'] = 'staff';
        data['is_active'] = true;
        await getIt<StaffManagementRepository>().createStaffForAgency(
          widget.agencyId,
          data,
        );
      } else {
        await getIt<UserManagementRepository>().updateUser(
          widget.staff!.id,
          data,
        );
      }
      if (mounted) context.pop(true);
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.somethingWWrong.tr())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.staff != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? LocaleKeys.editStaff.tr() : LocaleKeys.addStaff.tr(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      AppTextField(
                        label: LocaleKeys.name.tr(),
                        controller: _nameController,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? LocaleKeys.requiredField.tr()
                            : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: LocaleKeys.email.tr(),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? LocaleKeys.requiredField.tr()
                            : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: LocaleKeys.phone.tr(),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      if (!isEdit) ...[
                        const SizedBox(height: 12),
                        AppTextField(
                          label: LocaleKeys.password.tr(),
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) =>
                              value == null || value.length < 6
                              ? LocaleKeys.passwordMinLength.tr()
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: isEdit ? LocaleKeys.update.tr() : LocaleKeys.add.tr(),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
