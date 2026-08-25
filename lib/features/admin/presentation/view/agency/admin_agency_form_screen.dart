import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/widget/app_button.dart';
import 'package:final_flutter/core/widget/app_text_field.dart';
import 'package:final_flutter/features/admin/presentation/bloc/agency/agency_cubit/admin_agency_cubit.dart';
import 'package:final_flutter/features/admin/presentation/bloc/agency/agency_cubit/admin_agency_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/app_exception.dart';

class AdminAgencyFormScreen extends StatefulWidget {
  final int? id;
  const AdminAgencyFormScreen({super.key, this.id});

  @override
  State<AdminAgencyFormScreen> createState() => _AdminAgencyFormScreenState();
}

class _AdminAgencyFormScreenState extends State<AdminAgencyFormScreen> {
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
    if (widget.id != null) {
      _cubit.getAgencyDetails(widget.id!);
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
    return BlocProvider<AdminAgenciesCubit>.value(
      value: _cubit,
      child: BlocListener<AdminAgenciesCubit, AdminAgenciesState>(
        listener: (context, state) {
          if (state is AgencyDetailsLoaded && widget.id != null) {
            final agency = state.agencyModelDetails;
            nameController.text = agency.name;
            categoryController.text = agency.category;
            cityController.text = agency.city;
            phoneController.text = agency.phone;
            addressController.text = agency.address;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.id == null ? 'Add Agency' : 'Edit Agency'),
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
                            label: "Agency Name",
                            controller: nameController,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: "Agency Category",
                            controller: categoryController,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: "Agency City",
                            controller: cityController,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: "Agency Address",
                            controller: addressController,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: "Agency Phone",
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: widget.id == null ? "Add" : "Update",
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (widget.id == null) {
                          try {
                            await _cubit.addAgency(
                              name: nameController.text.trim(),
                              category: categoryController.text.trim(),
                              city: cityController.text.trim(),
                              phone: phoneController.text.trim(),
                              address: addressController.text.trim(),
                            );
                          } on AppException catch (e) {
                            if (mounted && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message)),
                              );
                            }
                          } catch (e) {
                            if (mounted && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Something went wrong'),
                                ),
                              );
                            }
                          }
                        } else {
                          try {
                            await _cubit.updateAgency(
                              id: widget.id!,
                              name: nameController.text.trim(),
                              category: categoryController.text.trim(),
                              city: cityController.text.trim(),
                              phone: phoneController.text.trim(),
                              address: addressController.text.trim(),
                            );
                          } on AppException catch (e) {
                            if (mounted && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message)),
                              );
                            }
                          } catch (e) {
                            if (mounted && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Something went wrong'),
                                ),
                              );
                            }
                          }
                          if (mounted && context.mounted) {
                            context.pop();
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
