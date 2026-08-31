import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/local_keys.dart';
import 'package:flutter/material.dart';

import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_text_field.dart';

class RequestInfoSection extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final bool enabled;
  final Future<void> Function() onSend;

  const RequestInfoSection({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.enabled,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_support_outlined),
                SizedBox(width: 8),
                Text(
                  LocaleKeys.requestInfo.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.requestInfoHint.tr(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            IgnorePointer(
              ignoring: !enabled || isLoading,
              child: Opacity(
                opacity: enabled ? 1 : 0.6,
                child: AppTextField(
                  controller: controller,
                  label: LocaleKeys.message.tr(),
                  hint: LocaleKeys.requestInfoPlaceholder.tr(),
                  maxLines: 4,
                ),
              ),
            ),

            const SizedBox(height: 16),

            AppButton(
              label: LocaleKeys.sendRequest.tr(),
              icon: Icons.send_outlined,
              isLoading: isLoading,
              onPressed: enabled && !isLoading ? onSend : null,
            ),
          ],
        ),
      ),
    );
  }
}
