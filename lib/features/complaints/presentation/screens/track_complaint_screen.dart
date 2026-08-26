import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/track_complaint_cubit.dart';
import '../cubit/track_complaint_state.dart';

class TrackComplaintScreen extends StatefulWidget {
  final String referenceCode;

  const TrackComplaintScreen({super.key, required this.referenceCode});

  @override
  State<TrackComplaintScreen> createState() => _TrackComplaintScreenState();
}

class _TrackComplaintScreenState extends State<TrackComplaintScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  void _load() {
    context.read<TrackComplaintCubit>().trackComplaint(
      referenceCode: widget.referenceCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نتيجة التتبع')),
      body: BlocBuilder<TrackComplaintCubit, TrackComplaintState>(
        builder: (context, state) {
          if (state.status == TrackComplaintStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TrackComplaintStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'تعذر تتبع الشكوى',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _load,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          final complaint = state.complaint;

          if (complaint == null) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              _load();
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 16),

                Icon(_statusIcon(complaint.status), size: 80),

                const SizedBox(height: 16),

                Text(
                  _statusLabel(complaint.status),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 28),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.confirmation_number_outlined),
                    title: const Text('رمز الشكوى'),
                    subtitle: SelectableText(complaint.referenceCode),
                    trailing: IconButton(
                      tooltip: 'نسخ الرمز',
                      icon: const Icon(Icons.copy_outlined),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: complaint.referenceCode),
                        );

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم نسخ رمز الشكوى')),
                        );
                      },
                    ),
                  ),
                ),

                _TrackItem(
                  title: 'العنوان',
                  value: complaint.title,
                  icon: Icons.title,
                ),

                _TrackItem(
                  title: 'الحالة',
                  value: _statusLabel(complaint.status),
                  icon: Icons.info_outline,
                ),

                _TrackItem(
                  title: 'آخر تحديث',
                  value: _formatDate(complaint.lastUpdate),
                  icon: Icons.schedule,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'in_progress':
        return 'قيد المعالجة';

      case 'resolved':
        return 'تم حل الشكوى';

      case 'rejected':
        return 'تم رفض الشكوى';

      case 'new':
      default:
        return 'شكوى جديدة';
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'in_progress':
        return Icons.hourglass_top;

      case 'resolved':
        return Icons.check_circle_outline;

      case 'rejected':
        return Icons.cancel_outlined;

      case 'new':
      default:
        return Icons.fiber_new;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    final day = date.day.toString().padLeft(2, '0');

    final month = date.month.toString().padLeft(2, '0');

    final hour = date.hour.toString().padLeft(2, '0');

    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/${date.year} $hour:$minute';
  }
}

class _TrackItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _TrackItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
