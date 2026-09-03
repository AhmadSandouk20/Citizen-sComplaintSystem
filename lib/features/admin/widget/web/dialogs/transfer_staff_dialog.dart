import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/features/auth/data/models/user_model.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/bloc/staff/staff_management_cubit.dart';
import '../../../presentation/bloc/staff/staff_management_state.dart';

class TransferStaffDialog extends StatefulWidget {
  final int agencyId;
  final UserModel staff;
  final StaffManagementCubit cubit;
  const TransferStaffDialog({
    super.key,
    required this.agencyId,
    required this.staff,
    required this.cubit,
  });

  @override
  State<TransferStaffDialog> createState() => _TransferStaffDialogState();
}

class _TransferStaffDialogState extends State<TransferStaffDialog> {
  int? selectedAgencyId;

  @override
  void initState() {
    super.initState();
    widget.cubit.loadAgencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${LocaleKeys.transfer.tr()} ${widget.staff.name}'),
      content: BlocBuilder<StaffManagementCubit, StaffManagementState>(
        bloc: widget.cubit,
        builder: (context, state) {
          if (state is StaffManagementLoading) {
            return SizedBox(
              height: 100,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (state is StaffManagementError) {
            return Text('${LocaleKeys.error.tr()}: ${state.message}');
          }
          if (state is StaffManagementLoaded) {
            final agencies = state.agencies
                .where((a) => a.id != widget.agencyId)
                .toList();
            if (agencies.isEmpty) {
              return Text(LocaleKeys.noOtherAgencies.tr());
            }
            return DropdownButtonFormField<int>(
              initialValue: selectedAgencyId,
              hint: Text(LocaleKeys.selectNewAgency.tr()),
              items: agencies.map((agency) {
                return DropdownMenuItem(
                  value: agency.id,
                  child: Text(agency.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedAgencyId = value),
              validator: (v) =>
                  v == null ? LocaleKeys.selectAgencyRequired.tr() : null,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(LocaleKeys.cancel.tr()),
        ),
        TextButton(
          onPressed: () async {
            if (selectedAgencyId == null) return;
            try {
              await widget.cubit.transferStaff(
                widget.staff.id,
                selectedAgencyId!,
              );
              if (!context.mounted) return;
              context.pop();
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: Text(LocaleKeys.transfer.tr()),
        ),
      ],
    );
  }
}
