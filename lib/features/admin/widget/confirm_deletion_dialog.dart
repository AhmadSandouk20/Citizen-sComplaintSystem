import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/model/agency/agency_model/agency_model.dart';

Future<bool> confirmDeleteAgency(
  BuildContext context,
  AgencyModel agency,
) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Agency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete "${agency.name}"?'),
              const SizedBox(height: 8),
              const Text(
                '⚠️ This will also delete all complaints associated with this agency.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => context.pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;
}
