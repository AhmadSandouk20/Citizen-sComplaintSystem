import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final bool isLoading;
  final VoidCallback onSave;

  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.isLoading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'الاسم',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              final name = value?.trim() ?? '';

              if (name.isEmpty) {
                return 'الاسم مطلوب';
              }

              if (!RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(name)) {
                return 'يجب أن يحتوي الاسم على أحرف فقط';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: const InputDecoration(
              labelText: 'رقم الهاتف',
              hintText: '09XXXXXXXX',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
              counterText: '',
            ),
            validator: (value) {
              final phone = value?.trim() ?? '';

              if (phone.isEmpty) {
                return 'رقم الهاتف مطلوب';
              }

              if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
                return 'يجب أن يتكون رقم الهاتف من 10 أرقام';
              }

              return null;
            },
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: isLoading ? null : onSave,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }
}
