import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/local_keys.dart';
import '../data/model/agency/agency_model/agency_model.dart';

Future<bool> confirmDeleteAgency(
  BuildContext context,
  AgencyModel agency,
) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(LocaleKeys.deleteAgency.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${LocaleKeys.sureToDelete.tr()} "${agency.name}"?'),
              const SizedBox(height: 8),
              Text(
                '⚠️ ${LocaleKeys.deleteAllAgencyComplaints.tr()}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(LocaleKeys.cancel.tr()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(LocaleKeys.delete.tr()),
            ),
          ],
        ),
      ) ??
      false;
}
