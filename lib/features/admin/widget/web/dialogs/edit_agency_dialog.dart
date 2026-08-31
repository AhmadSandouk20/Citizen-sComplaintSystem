import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/app_text_field.dart';
import 'package:final_flutter/core/widget/app_button.dart';
import 'package:final_flutter/features/admin/presentation/bloc/agency/agency_cubit/admin_agency_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/agency/agency_cubit/admin_agency_state.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injector.dart';

class EditAgencyDialog extends StatefulWidget {
  final int? agencyId;
  const EditAgencyDialog({super.key, this.agencyId});

  @override
  State<EditAgencyDialog> createState() => _EditAgencyDialogState();
}

class _EditAgencyDialogState extends State<EditAgencyDialog> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  late final AdminAgenciesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AdminAgenciesCubit>();
    if (widget.agencyId != null) {
      _cubit.getAgencyDetails(widget.agencyId!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    cityController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AdminAgenciesCubit, AdminAgenciesState>(
        listener: (context, state) {
          if (state is AgencyDetailsLoaded && widget.agencyId != null) {
            final agency = state.agencyModelDetails;
            nameController.text = agency.name;
            categoryController.text = agency.category;
            cityController.text = agency.city;
            phoneController.text = agency.phone;
            addressController.text = agency.address;
          }
          if (state is AgenciesError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: AlertDialog(
          title: Text(
            widget.agencyId == null
                ? LocaleKeys.addAgency.tr()
                : LocaleKeys.editAgency.tr(),
          ),
          content: SizedBox(
            width: 500,
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  AppTextField(
                    label: LocaleKeys.name.tr(),
                    controller: nameController,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: LocaleKeys.category.tr(),
                    controller: categoryController,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: LocaleKeys.city.tr(),
                    controller: cityController,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: LocaleKeys.address.tr(),
                    controller: addressController,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: LocaleKeys.phone.tr(),
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
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
              label: widget.agencyId == null
                  ? LocaleKeys.add.tr()
                  : LocaleKeys.update.tr(),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final name = nameController.text.trim();
                  final category = categoryController.text.trim();
                  final city = cityController.text.trim();
                  final address = addressController.text.trim();
                  final phone = phoneController.text.trim();
                  try {
                    if (widget.agencyId == null) {
                      await _cubit.addAgency(
                        name: name,
                        category: category,
                        city: city,
                        phone: phone,
                        address: address,
                      );
                    } else {
                      await _cubit.updateAgency(
                        id: widget.agencyId!,
                        name: name,
                        category: category,
                        city: city,
                        phone: phone,
                        address: address,
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
        ),
      ),
    );
  }
}
