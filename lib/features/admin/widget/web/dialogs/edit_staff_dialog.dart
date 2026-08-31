import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/app_text_field.dart';
import 'package:final_flutter/core/widget/app_button.dart';
import 'package:final_flutter/features/admin/domain/staff_management_repository.dart';
import 'package:final_flutter/features/admin/domain/user_management_repository.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:go_router/go_router.dart';

class EditStaffDialog extends StatefulWidget {
  final int agencyId;
  final UserModel? staff;
  const EditStaffDialog({super.key, required this.agencyId, this.staff});

  @override
  State<EditStaffDialog> createState() => _EditStaffDialogState();
}

class _EditStaffDialogState extends State<EditStaffDialog> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      nameController.text = widget.staff!.name;
      emailController.text = widget.staff!.email ?? '';
      phoneController.text = widget.staff!.phone ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.staff != null;
    return AlertDialog(
      title: Text(
        isEdit ? LocaleKeys.editStaff.tr() : LocaleKeys.addStaff.tr(),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              AppTextField(
                label: LocaleKeys.name.tr(),
                controller: nameController,
                validator: (v) => v == null || v.trim().isEmpty
                    ? LocaleKeys.requiredField.tr()
                    : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: LocaleKeys.email.tr(),
                controller: emailController,
                validator: (v) => v == null || v.trim().isEmpty
                    ? LocaleKeys.requiredField.tr()
                    : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: LocaleKeys.phone.tr(),
                controller: phoneController,
              ),
              if (!isEdit) ...[
                const SizedBox(height: 12),
                AppTextField(
                  label: LocaleKeys.password.tr(),
                  controller: passwordController,
                  obscureText: true,
                  validator: (v) => v == null || v.length < 6
                      ? LocaleKeys.passwordMinLength.tr()
                      : null,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(LocaleKeys.cancel.tr()),
        ),
        AppButton(
          label: isEdit ? LocaleKeys.update.tr() : LocaleKeys.add.tr(),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                final data = <String, dynamic>{
                  'name': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'phone': phoneController.text.trim(),
                };
                if (isEdit) {
                  await getIt<UserManagementRepository>().updateUser(
                    widget.staff!.id,
                    data,
                  );
                } else {
                  data['password'] = passwordController.text;
                  data['type'] = 'staff';
                  data['is_active'] = true;
                  await getIt<StaffManagementRepository>().createStaffForAgency(
                    widget.agencyId,
                    data,
                  );
                }
                if (!context.mounted) return;
                context.pop();
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }
          },
        ),
      ],
    );
  }
}
