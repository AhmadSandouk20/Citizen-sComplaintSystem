import 'package:flutter/material.dart';

class DeleteAccountDialog {
  static Future<bool> showFirstConfirmation(
      BuildContext context,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف الحساب'),
          content: const Text(
            'هل أنت متأكد أنك تريد حذف حسابك؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('متابعة'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  static Future<bool> showFinalConfirmation(
      BuildContext context,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد نهائي'),
          content: const Text(
            'سيتم حذف الحساب نهائيًا. هل تريد المتابعة؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('تراجع'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('حذف الحساب'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}