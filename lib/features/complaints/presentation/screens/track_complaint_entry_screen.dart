import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widget/adaptive_back_button.dart';

class TrackComplaintEntryScreen extends StatefulWidget {
  const TrackComplaintEntryScreen({super.key});

  @override
  State<TrackComplaintEntryScreen> createState() =>
      _TrackComplaintEntryScreenState();
}

class _TrackComplaintEntryScreenState extends State<TrackComplaintEntryScreen> {
  final TextEditingController _codeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _trackComplaint() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final code = _codeController.text.trim();

    context.push(RoutePaths.cTrackCodePath(code));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AdaptiveBackButton(),
        title: const Text('تتبع شكوى'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),

                  const Icon(Icons.search_outlined, size: 72),

                  const SizedBox(height: 24),

                  const Text(
                    'أدخل رمز الشكوى',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'استخدم الرمز المرجعي الذي حصلت عليه عند تقديم الشكوى',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  TextFormField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'رمز الشكوى',
                      hintText: 'CMP-2026-00004',
                      prefixIcon: Icon(Icons.confirmation_number_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final code = value?.trim() ?? '';

                      if (code.isEmpty) {
                        return 'يرجى إدخال رمز الشكوى';
                      }

                      return null;
                    },
                    onFieldSubmitted: (_) {
                      _trackComplaint();
                    },
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _trackComplaint,
                    icon: const Icon(Icons.search),
                    label: const Text('تتبع الشكوى'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
