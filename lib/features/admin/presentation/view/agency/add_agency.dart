import 'package:final_flutter/core/widget/app_button.dart';
import 'package:final_flutter/core/widget/app_text_field.dart';
import 'package:final_flutter/features/admin/presentation/bloc/agency/agency_cubit/admin_agency_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAgency extends StatefulWidget {
  AddAgency({super.key});

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
    super.dispose();
    addressController.dispose();
    categoryController.dispose();
    cityController.dispose();
    phoneController.dispose();
    nameController.dispose();
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
                AppTextField(label: "Agency Name", controller: nameController),
                SizedBox(height: 10),
                AppTextField(
                  label: "Agency Category",
                  controller: nameController,
                ),
                SizedBox(height: 10),
                AppTextField(label: "Agency City", controller: nameController),
                SizedBox(height: 10),
                AppTextField(
                  label: "Agency address",
                  controller: nameController,
                ),
                SizedBox(height: 10),
                AppTextField(
                  label: "Agency phone",
                  controller: nameController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
          AppButton(
            label: "Add",
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
