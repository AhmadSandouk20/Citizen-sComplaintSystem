import 'package:flutter/material.dart';

class ComplaintDetailsStep extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final String priority;
  final ValueChanged<String> onPriorityChanged;
  final VoidCallback onPickLocation;
  const ComplaintDetailsStep({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.locationController,
    required this.priority,
    required this.onPriorityChanged,
    required this.onPickLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'بيانات الشكوى',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('أدخل تفاصيل الشكوى بشكل واضح'),
        const SizedBox(height: 24),

        TextFormField(
          controller: titleController,
          maxLength: 200,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'عنوان الشكوى',
            hintText: 'أدخل عنوانًا مختصرًا للشكوى',
            prefixIcon: Icon(Icons.title),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            final text = value?.trim() ?? '';

            if (text.isEmpty) {
              return 'عنوان الشكوى مطلوب';
            }

            if (text.length > 200) {
              return 'العنوان يجب ألا يتجاوز 200 حرف';
            }

            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: descriptionController,
          minLines: 4,
          maxLines: 7,
          decoration: const InputDecoration(
            labelText: 'وصف الشكوى',
            hintText: 'اشرح المشكلة بالتفصيل',
            alignLabelWithHint: true,
            prefixIcon: Icon(Icons.description_outlined),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'وصف الشكوى مطلوب';
            }

            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: locationController,
          decoration: InputDecoration(
            labelText: 'الموقع',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              tooltip: 'تحديد الموقع على الخريطة',
              onPressed: onPickLocation,
              icon: const Icon(Icons.map_outlined),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال الموقع';
            }

            return null;
          },
        ),
        const SizedBox(height: 16),

        const Text(
          'الأولوية',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),

        DropdownButtonFormField<String>(
          initialValue: priority,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.flag_outlined),
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'low', child: Text('منخفضة')),
            DropdownMenuItem(value: 'medium', child: Text('متوسطة')),
            DropdownMenuItem(value: 'high', child: Text('مرتفعة')),
          ],
          onChanged: (value) {
            if (value != null) {
              onPriorityChanged(value);
            }
          },
        ),
      ],
    );
  }
}
