import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/app_button.dart';
import 'package:final_flutter/core/widget/app_text_field.dart';
import 'package:final_flutter/features/admin/presentation/bloc/mobile/agency/agency_cubit/admin_agency_cubit.dart';

class AddAgency extends StatefulWidget {
  const AddAgency({super.key});

  @override
  State<AddAgency> createState() => _AddAgencyState();
}

class _AddAgencyState extends State<AddAgency> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    phoneController.dispose();
    addressController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: LocaleKeys.name.tr(),
                  controller: nameController,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: LocaleKeys.category.tr(),
                  controller: categoryController,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: LocaleKeys.city.tr(),
                  controller: cityController,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: LocaleKeys.address.tr(),
                  controller: addressController,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: LocaleKeys.phone.tr(),
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          Expanded(child: const SizedBox()),
          AppButton(
            label: LocaleKeys.add.tr(),
            onPressed: () {
              final isValid = _formKey.currentState?.validate() ?? false;
              if (isValid) {
                _formKey.currentState!.save();
                context.read<AdminAgenciesCubit>().addAgency(
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  address: addressController.text.trim(),
                  city: cityController.text.trim(),
                  category: categoryController.text.trim(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
