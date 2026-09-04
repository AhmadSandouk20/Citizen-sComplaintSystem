import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/local_keys.dart';
import 'package:final_flutter/features/agency_workspace/presentation/widgets/request_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_text_field.dart';
import '../../../../core/widget/error_view.dart';
import '../../../../core/widget/status_chip.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/staff_complaint_entity.dart';
import '../cubit/staff_complaints_details_cubit.dart';
import '../cubit/staff_complaints_details_state.dart';
import '../widgets/revisions_section.dart';
import '../widgets/status_history_section.dart';

class StaffComplaintDetailsScreen extends StatefulWidget {
  final int complaintId;

  const StaffComplaintDetailsScreen({super.key, required this.complaintId});

  @override
  State<StaffComplaintDetailsScreen> createState() =>
      _StaffComplaintDetailsScreenState();
}

class _StaffComplaintDetailsScreenState
    extends State<StaffComplaintDetailsScreen> {
  final TextEditingController _internalNoteController = TextEditingController();
  final TextEditingController _requestInfoController = TextEditingController();

  String? _selectedStatus;
  String? _selectedPriority;

  @override
  void dispose() {
    _internalNoteController.dispose();
    _requestInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StaffComplaintDetailsCubit, StaffComplaintDetailsState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
        }

        if (state.errorMessage != null && state.complaint != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        if (state.status == StaffComplaintDetailsStatus.loading &&
            state.complaint == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == StaffComplaintDetailsStatus.error &&
            state.complaint == null) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorView(
              message: state.errorMessage ?? LocaleKeys.loadDetailsFailed.tr(),
              buttonText: LocaleKeys.retry.tr(),
              onRetry: () {
                context.read<StaffComplaintDetailsCubit>().loadComplaint(
                  widget.complaintId,
                );
              },
            ),
          );
        }

        final complaint = state.complaint;

        if (complaint == null) {
          return const Scaffold(body: SizedBox.shrink());
        }

        _selectedStatus ??= complaint.status;
        _selectedPriority ??= complaint.priority;

        final currentUserId = getIt<AuthCubit>().user?.id;

        final lockedByMe =
            currentUserId != null && complaint.isLockedByMe(currentUserId);

        final lockedByAnother =
            currentUserId != null && complaint.isLockedByAnother(currentUserId);

        final canEdit = lockedByMe && !lockedByAnother;

        return Scaffold(
          appBar: AppBar(title: Text(complaint.referenceCode)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ComplaintHeader(complaint: complaint),

                    const SizedBox(height: 24),

                    _sectionTitle(context, LocaleKeys.complaintDetails.tr()),

                    const SizedBox(height: 12),

                    _InfoCard(
                      children: [
                        _InfoRow(label: LocaleKeys.complaintTitle.tr(), value: complaint.title),
                        _InfoRow(label: LocaleKeys.description.tr(), value: complaint.description),
                        _InfoRow(
                          label: LocaleKeys.location.tr(),
                          value: complaint.locationText ?? '-',
                        ),
                        _InfoRow(label: LocaleKeys.agency.tr(), value: complaint.agency.name),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle(context, LocaleKeys.citizenInfo.tr()),

                    const SizedBox(height: 12),

                    _InfoCard(
                      children: [
                        _InfoRow(label: LocaleKeys.name.tr(), value: complaint.user.name),
                        _InfoRow(
                          label: LocaleKeys.email.tr(),
                          value: complaint.user.email ?? '-',
                        ),
                        _InfoRow(
                          label: LocaleKeys.phone.tr(),
                          value: complaint.user.phone ?? '-',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    if (lockedByAnother)
                      _LockedWarning(staffName: complaint.lockedByName),

                    if (lockedByAnother) const SizedBox(height: 20),

                    _buildLockSection(
                      context,
                      complaint,
                      lockedByMe,
                      lockedByAnother,
                      state.isActionLoading,
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle(context, LocaleKeys.updateComplaintAction.tr()),

                    const SizedBox(height: 12),

                    _buildUpdateSection(
                      context,
                      complaint,
                      canEdit,
                      state.isActionLoading,
                    ),
                    const SizedBox(height: 16),

                    RequestInfoSection(
                      controller: _requestInfoController,
                      isLoading: state.isActionLoading,
                      enabled: !complaint.isLockedByAnother(currentUserId!),
                      onSend: () async {
                        final success = await context
                            .read<StaffComplaintDetailsCubit>()
                            .requestMoreInfo(
                              complaintId: complaint.id,
                              message: _requestInfoController.text,
                            );

                        if (success) {
                          _requestInfoController.clear();
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    StatusHistorySection(history: state.statusHistory),

                    const SizedBox(height: 16),

                    RevisionsSection(revisions: state.revisions),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLockSection(
    BuildContext context,
    StaffComplaintEntity complaint,
    bool lockedByMe,
    bool lockedByAnother,
    bool loading,
  ) {
    if (!complaint.isLocked) {
      return AppButton(
        label: LocaleKeys.lockComplaint.tr(),
        icon: Icons.lock_outline,
        isLoading: loading,
        onPressed: loading
            ? null
            : () {
                context.read<StaffComplaintDetailsCubit>().lockComplaint(
                  complaint.id,
                );
              },
      );
    }

    if (lockedByMe) {
      return AppButton(
        label: LocaleKeys.unlockComplaint.tr(),
        icon: Icons.lock_open_outlined,
        variant: AppButtonVariant.outlined,
        isLoading: loading,
        onPressed: loading
            ? null
            : () {
                context.read<StaffComplaintDetailsCubit>().unlockComplaint(
                  complaint.id,
                );
              },
      );
    }

    return Text(
      LocaleKeys.lockedBy.tr(
        args: [complaint.lockedByName ?? LocaleKeys.anotherStaff.tr()],
      ),
    );
  }

  Widget _buildUpdateSection(
    BuildContext context,
    StaffComplaintEntity complaint,
    bool canEdit,
    bool loading,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: InputDecoration(labelText: LocaleKeys.status.tr()),
              items: [
                DropdownMenuItem(value: 'new', child: Text(LocaleKeys.statusNew.tr())),
                DropdownMenuItem(
                  value: 'in_progress',
                  child: Text(LocaleKeys.statusInProgress.tr()),
                ),
                DropdownMenuItem(value: 'resolved', child: Text(LocaleKeys.statusResolved.tr())),
                DropdownMenuItem(value: 'rejected', child: Text(LocaleKeys.statusRejected.tr())),
              ],
              onChanged: canEdit
                  ? (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  : null,
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _selectedPriority,
              decoration: InputDecoration(labelText: LocaleKeys.priority.tr()),
              items: [
                DropdownMenuItem(value: 'low', child: Text(LocaleKeys.priorityLow.tr())),
                DropdownMenuItem(value: 'medium', child: Text(LocaleKeys.priorityMedium.tr())),
                DropdownMenuItem(value: 'high', child: Text(LocaleKeys.priorityHigh.tr())),
              ],
              onChanged: canEdit
                  ? (value) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    }
                  : null,
            ),

            const SizedBox(height: 16),

            IgnorePointer(
              ignoring: !canEdit,
              child: Opacity(
                opacity: canEdit ? 1 : 0.55,
                child: AppTextField(
                  controller: _internalNoteController,
                  label: LocaleKeys.internalNote.tr(),
                  hint: LocaleKeys.internalNotePlaceholder.tr(),
                  maxLines: 4,
                ),
              ),
            ),

            const SizedBox(height: 20),

            AppButton(
              label: LocaleKeys.saveChanges.tr(),
              icon: Icons.save_outlined,
              isLoading: loading,
              onPressed: !canEdit || loading
                  ? null
                  : () {
                      context
                          .read<StaffComplaintDetailsCubit>()
                          .updateComplaint(
                            complaintId: complaint.id,
                            status: _selectedStatus ?? complaint.status,
                            priority: _selectedPriority ?? complaint.priority,
                            internalNote: _internalNoteController.text,
                          );
                    },
            ),

            if (!canEdit) ...[
              const SizedBox(height: 12),
              Text(
                complaint.isLocked
                    ? LocaleKeys.mustHoldLock.tr()
                    : LocaleKeys.lockBeforeEditing.tr(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _ComplaintHeader extends StatelessWidget {
  final StaffComplaintEntity complaint;

  const _ComplaintHeader({required this.complaint});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(complaint.referenceCode, style: theme.textTheme.labelLarge),

            const SizedBox(height: 8),

            Text(
              complaint.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                StatusChip(status: complaint.status),
                PriorityChip(priority: complaint.priority),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _LockedWarning extends StatelessWidget {
  final String? staffName;

  const _LockedWarning({this.staffName});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: scheme.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              LocaleKeys.lockedByCannotEdit.tr(
                args: [staffName ?? LocaleKeys.anotherStaff.tr()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
