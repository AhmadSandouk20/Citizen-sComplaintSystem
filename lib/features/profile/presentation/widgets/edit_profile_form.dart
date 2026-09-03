import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/localization/local_keys.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.isLoading,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final bool isLoading;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: nameController,
            enabled: !isLoading,
            textInputAction: TextInputAction.next,
            maxLength: 150,
            decoration: InputDecoration(
              labelText: LocaleKeys.name.tr(),
              prefixIcon: const Icon(Icons.person_outline),
              border: const OutlineInputBorder(),
              counterText: '',
            ),
            validator: (value) {
              final name = value?.trim() ?? '';
              if (name.isEmpty) return LocaleKeys.nameRequired.tr();
              // Arabic or Latin letters — digits alone are not a name.
              if (!RegExp(r'[a-zA-Z؀-ۿ]').hasMatch(name)) {
                return LocaleKeys.nameLettersOnly.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: phoneController,
            enabled: !isLoading,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            maxLength: 15,
            inputFormatters: [
              // Allow a leading + so international numbers are not rejected.
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
              LengthLimitingTextInputFormatter(15),
            ],
            onFieldSubmitted: (_) => onSave(),
            decoration: InputDecoration(
              labelText: LocaleKeys.phone.tr(),
              prefixIcon: const Icon(Icons.phone_outlined),
              border: const OutlineInputBorder(),
              counterText: '',
            ),
            validator: (value) {
              final phone = value?.trim() ?? '';
              if (phone.isEmpty) return LocaleKeys.phoneRequired.tr();
              // Deliberately loose: the backend is the authority on format,
              // and a 10-digit rule rejects valid international numbers.
              if (!RegExp(r'^\+?\d{8,15}$').hasMatch(phone)) {
                return LocaleKeys.phoneInvalid.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: isLoading ? null : onSave,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(LocaleKeys.saveChanges.tr()),
          ),
        ],
      ),
    );
  }
}
