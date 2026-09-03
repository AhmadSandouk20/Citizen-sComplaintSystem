import 'package:easy_localization/easy_localization.dart';

import '../../../../core/localization/local_keys.dart';
import '../../../auth/data/models/user_role_enum.dart';

/// Localized label for a role.
///
/// Kept in the presentation layer so [UserRole] stays free of translation
/// concerns. Covers all three roles — the earlier version handled a
/// non-existent `agency` role and left `staff` untranslated.
extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.citizen:
        return LocaleKeys.roleCitizen.tr();
      case UserRole.staff:
        return LocaleKeys.roleStaff.tr();
      case UserRole.admin:
        return LocaleKeys.roleAdmin.tr();
    }
  }
}
