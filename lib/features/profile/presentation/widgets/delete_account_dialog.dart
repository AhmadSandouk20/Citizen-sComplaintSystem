import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/local_keys.dart';

/// Two-step confirmation required before deleting an account.
class DeleteAccountDialog {
  DeleteAccountDialog._();

  static Future<bool> showFirstConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.deleteAccountConfirmTitle.tr()),
        content: Text(LocaleKeys.deleteAccountConfirmBody.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(LocaleKeys.continueAction.tr()),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<bool> showFinalConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      // No accidental dismissal on the irreversible step.
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(LocaleKeys.deleteAccountFinalTitle.tr()),
        content: Text(LocaleKeys.deleteAccountFinalBody.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(LocaleKeys.back.tr()),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(LocaleKeys.deleteAccount.tr()),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
