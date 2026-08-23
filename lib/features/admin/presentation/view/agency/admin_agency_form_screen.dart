import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/local_keys.dart';

/// PLACEHOLDER — owned by the agencies/staff track (Ahmad).
///
/// `route.dart` on `main` imported this file at commit `ab02bc4` but the file
/// itself was never pushed, which left `main` with four analyzer errors and
/// unbuildable. This stub restores the contract (`AdminAgencyFormScreen({int? id})`)
/// so the router compiles and the two agency routes stay registered.
///
/// Replace the body with the real create/edit form:
///   POST /api/agencies          when [id] is null
///   PUT  /api/agencies/{id}     when [id] is set
class AdminAgencyFormScreen extends StatelessWidget {
  const AdminAgencyFormScreen({super.key, this.id});

  /// Agency being edited, or null when creating a new one.
  final int? id;

  bool get isEditing => id != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.agencies.tr())),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.notImplementedYet.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                isEditing ? 'PUT /api/agencies/$id' : 'POST /api/agencies',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
