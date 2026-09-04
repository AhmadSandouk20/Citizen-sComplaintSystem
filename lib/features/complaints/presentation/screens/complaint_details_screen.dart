import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../attachments/presentation/widgets/attachment_gallery.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../cubit/complaint_details_cubit.dart';
import '../cubit/complaint_details_state.dart';
import '../cubit/status_history_cubit.dart';
import '../cubit/status_history_state.dart';
import '../widgets/status_timeline.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final int complaintId;

  const ComplaintDetailsScreen({super.key, required this.complaintId});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetails();
    });
  }

  void _loadDetails() {
    final authState = context.read<AuthCubit>().state;

    if (authState is LoginSuccessState) {
      context.read<ComplaintDetailsCubit>().getComplaintDetails(
        token: authState.user.token,
        complaintId: widget.complaintId,
      );

      context.read<StatusHistoryCubit>().getStatusHistory(
        token: authState.user.token,
        complaintId: widget.complaintId,
      );
    }
  }

  /// Leaves the screen, reporting whether anything changed. A tap on a push
  /// notification replaces the whole stack, so this screen can be the only page
  /// left; popping then would trip go_router's empty-stack assert. Fall back to
  /// the list, which is where a pop would have landed anyway.
  void _leave(bool changed) {
    if (context.canPop()) {
      context.pop(changed);
    } else {
      context.go(RoutePaths.cComplaints);
    }
  }

  void _goBack() {
    _leave(_hasChanges);
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('حذف الشكوى'),
          content: const Text(
            'هل أنت متأكد من حذف هذه الشكوى؟ لا يمكن التراجع عن هذه العملية.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    final authState = context.read<AuthCubit>().state;

    if (authState is LoginSuccessState) {
      context.read<ComplaintDetailsCubit>().deleteComplaint(
        token: authState.user.token,
        complaintId: widget.complaintId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _goBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الشكوى'),
          leading: IconButton(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: BlocConsumer<ComplaintDetailsCubit, ComplaintDetailsState>(
          listener: (context, state) {
            if (state.status == ComplaintDetailsStatus.deleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف الشكوى بنجاح')),
              );

              _leave(true);
            }
          },
          builder: (context, state) {
            if (state.status == ComplaintDetailsStatus.loading &&
                state.complaint == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ComplaintDetailsStatus.error &&
                state.complaint == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage ?? 'تعذر تحميل الشكوى',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDetails,
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

            final isDeleting = state.status == ComplaintDetailsStatus.deleting;

            return RefreshIndicator(
              onRefresh: () async {
                _loadDetails();
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
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

                  _DetailsCard(
                    title: 'العنوان',
                    value: complaint.title,
                    icon: Icons.title,
                  ),

                  _DetailsCard(
                    title: 'الوصف',
                    value: complaint.description,
                    icon: Icons.description_outlined,
                  ),

                  _DetailsCard(
                    title: 'الجهة',
                    value: complaint.agencyName,
                    icon: Icons.account_balance_outlined,
                  ),

                  _DetailsCard(
                    title: 'الموقع',
                    value: complaint.locationText ?? '-',
                    icon: Icons.location_on_outlined,
                  ),

                  _DetailsCard(
                    title: 'الحالة',
                    value: _statusLabel(complaint.status),
                    icon: Icons.info_outline,
                  ),

                  _DetailsCard(
                    title: 'الأولوية',
                    value: _priorityLabel(complaint.priority),
                    icon: Icons.flag_outlined,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'المرفقات',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  if (complaint.attachments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text('لا توجد مرفقات')),
                    )
                  else
                    SizedBox(
                      height: 400,
                      child: AttachmentGallery(
                        attachments: complaint.attachments,
                      ),
                    ),
                  const SizedBox(height: 28),

                  const Text(
                    'سجل حالة الشكوى',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  BlocBuilder<StatusHistoryCubit, StatusHistoryState>(
                    builder: (context, historyState) {
                      if (historyState.status == StatusHistoryStatus.loading) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (historyState.status == StatusHistoryStatus.error) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  historyState.errorMessage ??
                                      'تعذر تحميل سجل الحالة',
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton(
                                  onPressed: () {
                                    _loadDetails();
                                  },
                                  child: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return StatusTimeline(history: historyState.history);
                    },
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isDeleting || complaint.status != 'new'
                              ? null
                              : () async {
                                  final updated = await context.push<bool>(
                                    RoutePaths.cUpdatePath(
                                      complaint.id,
                                    ),
                                    extra: complaint,
                                  );

                                  if (updated == true && context.mounted) {
                                    _hasChanges = true;

                                    _loadDetails();
                                  }
                                },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('تعديل'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isDeleting || complaint.status != 'new'
                              ? null
                              : _confirmDelete,
                          icon: isDeleting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.delete_outline),
                          label: Text(isDeleting ? 'جارٍ الحذف...' : 'حذف'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _statusLabel(String value) {
    switch (value) {
      case 'in_progress':
        return 'قيد المعالجة';

      case 'resolved':
        return 'تم الحل';

      case 'rejected':
        return 'مرفوضة';

      case 'new':
      default:
        return 'جديدة';
    }
  }

  String _priorityLabel(String value) {
    switch (value) {
      case 'low':
        return 'منخفضة';

      case 'high':
        return 'مرتفعة';

      case 'medium':
      default:
        return 'متوسطة';
    }
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DetailsCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
