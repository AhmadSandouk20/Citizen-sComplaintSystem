import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../agencies/domain/entities/agency_entity.dart';
import '../../../agencies/presentation/cubit/agency_cubit.dart';
import '../../../agencies/presentation/cubit/agency_state.dart';
import '../../../agencies/presentation/widgets/agency_selector.dart';

import '../../../attachments/presentation/cubit/attachment_cubit.dart';
import '../../../attachments/presentation/cubit/attachment_state.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

import '../../domain/entities/complaint_entity.dart';

import '../cubit/update_complaint_cubit.dart';
import '../cubit/update_complaint_state.dart';

import '../widgets/submit_complaint/complaint_attachments_step.dart';
import '../../../location/presentation/screens/location_picker_screen.dart';

class UpdateComplaintScreen extends StatefulWidget {
  final ComplaintEntity complaint;

  const UpdateComplaintScreen({super.key, required this.complaint});

  @override
  State<UpdateComplaintScreen> createState() => _UpdateComplaintScreenState();
}

class _UpdateComplaintScreenState extends State<UpdateComplaintScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;

  AgencyEntity? _selectedAgency;

  String _priority = 'medium';

  bool _isFinishingUpdate = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.complaint.title);

    _descriptionController = TextEditingController(
      text: widget.complaint.description,
    );

    _locationController = TextEditingController(
      text: widget.complaint.locationText ?? '',
    );

    _priority = widget.complaint.priority;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgencyCubit>().getAgencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateComplaintCubit, UpdateComplaintState>(
          listener: _updateComplaintListener,
        ),
        BlocListener<AttachmentCubit, AttachmentState>(
          listener: _attachmentListener,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('تعديل الشكوى')),
        body: BlocBuilder<AgencyCubit, AgencyState>(
          builder: (context, agencyState) {
            if (agencyState.status == AgencyStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (agencyState.status == AgencyStatus.error) {
              return _AgencyErrorView(
                message: agencyState.errorMessage ?? 'تعذر تحميل الجهات',
                onRetry: () {
                  context.read<AgencyCubit>().getAgencies();
                },
              );
            }

            _selectedAgency ??= _findInitialAgency(agencyState.agencies);

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'الجهة الحكومية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  AgencySelector(
                    agencies: agencyState.agencies,
                    selectedAgency: _selectedAgency,
                    onSelected: (agency) {
                      setState(() {
                        _selectedAgency = agency;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _titleController,
                    maxLength: 200,
                    decoration: const InputDecoration(
                      labelText: 'عنوان الشكوى',
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
                    controller: _descriptionController,
                    minLines: 4,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      labelText: 'وصف الشكوى',
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
                    controller: _locationController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: 'الموقع',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      suffixIcon: IconButton(
                        tooltip: 'تحديد الموقع على الخريطة',
                        onPressed: _pickLocationFromMap,
                        icon: const Icon(Icons.map_outlined),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';

                      if (text.length > 255) {
                        return 'الموقع يجب ألا يتجاوز 255 حرفًا';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue: _priority,
                    decoration: const InputDecoration(
                      labelText: 'الأولوية',
                      prefixIcon: Icon(Icons.flag_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'low', child: Text('منخفضة')),
                      DropdownMenuItem(value: 'medium', child: Text('متوسطة')),
                      DropdownMenuItem(value: 'high', child: Text('مرتفعة')),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _priority = value;
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  const Divider(),

                  const SizedBox(height: 20),

                  BlocBuilder<AttachmentCubit, AttachmentState>(
                    builder: (context, attachmentState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ComplaintAttachmentsStep(
                            attachments: attachmentState.files,
                            onPickFiles: () {
                              context.read<AttachmentCubit>().pickFiles();
                            },
                            onPickGallery: () {
                              context
                                  .read<AttachmentCubit>()
                                  .pickImagesFromGallery();
                            },
                            onTakePhoto: () {
                              context.read<AttachmentCubit>().takePhoto();
                            },
                            onRemove: (attachment) {
                              context.read<AttachmentCubit>().removeFile(
                                attachment,
                              );
                            },
                          ),

                          if (attachmentState.status ==
                              AttachmentStatus.uploading) ...[
                            const SizedBox(height: 16),

                            LinearProgressIndicator(
                              value: attachmentState.progress,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'رفع المرفقات ${(attachmentState.progress * 100).round()}%',
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 8),

                            TextButton.icon(
                              onPressed: () {
                                context.read<AttachmentCubit>().cancelUpload();
                              },
                              icon: const Icon(Icons.close),
                              label: const Text('إلغاء رفع المرفقات'),
                            ),
                          ],

                          if (attachmentState.status ==
                              AttachmentStatus.error) ...[
                            const SizedBox(height: 12),

                            Text(
                              attachmentState.errorMessage ??
                                  'حدث خطأ أثناء رفع المرفقات',
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 8),

                            OutlinedButton.icon(
                              onPressed: _retryAttachments,
                              icon: const Icon(Icons.refresh),
                              label: const Text('إعادة محاولة رفع المرفقات'),
                            ),
                          ],
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  BlocBuilder<UpdateComplaintCubit, UpdateComplaintState>(
                    builder: (context, updateState) {
                      return BlocBuilder<AttachmentCubit, AttachmentState>(
                        builder: (context, attachmentState) {
                          final isUpdating =
                              updateState.status ==
                              UpdateComplaintStatus.loading;

                          final isUploading =
                              attachmentState.status ==
                              AttachmentStatus.uploading;

                          final isBusy =
                              isUpdating || isUploading || _isFinishingUpdate;

                          return ElevatedButton(
                            onPressed: isBusy ? null : _saveChanges,
                            child: isBusy
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('حفظ التعديلات'),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _updateComplaintListener(
    BuildContext context,
    UpdateComplaintState state,
  ) {
    if (state.status == UpdateComplaintStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'تعذر تعديل الشكوى')),
      );

      return;
    }

    if (state.status != UpdateComplaintStatus.success) {
      return;
    }

    final attachmentCubit = context.read<AttachmentCubit>();

    if (attachmentCubit.state.files.isEmpty) {
      _finishSuccessfully();
      return;
    }

    final authState = context.read<AuthCubit>().state;

    if (authState is! LoginSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم تعديل بيانات الشكوى، لكن تعذر رفع المرفقات بسبب انتهاء جلسة الدخول',
          ),
        ),
      );

      return;
    }

    attachmentCubit.uploadAttachments(
      complaintId: widget.complaint.id,
      token: authState.user.token,
    );
  }

  Future<void> _pickLocationFromMap() async {
    final result = await Navigator.of(context).push<LocationPickerResult>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialAddress: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _locationController.text = result.address;
    });
  }

  void _attachmentListener(BuildContext context, AttachmentState state) {
    if (state.status == AttachmentStatus.success) {
      _finishSuccessfully();
      return;
    }

    if (state.status == AttachmentStatus.cancelled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تعديل بيانات الشكوى، وتم إلغاء رفع المرفقات'),
        ),
      );
    }
  }

  Future<void> _finishSuccessfully() async {
    if (_isFinishingUpdate || !mounted) {
      return;
    }

    setState(() {
      _isFinishingUpdate = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تعديل الشكوى بنجاح')));

    Navigator.of(context).pop(true);
  }

  void _retryAttachments() {
    final authState = context.read<AuthCubit>().state;

    if (authState is! LoginSuccessState) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى تسجيل الدخول أولًا')));

      return;
    }

    context.read<AttachmentCubit>().retryUpload(
      complaintId: widget.complaint.id,
      token: authState.user.token,
    );
  }

  AgencyEntity? _findInitialAgency(List<AgencyEntity> agencies) {
    for (final agency in agencies) {
      if (agency.id == widget.complaint.agencyId) {
        return agency;
      }
    }

    return null;
  }

  void _saveChanges() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final agency = _selectedAgency;

    if (agency == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار جهة حكومية')));

      return;
    }

    final authState = context.read<AuthCubit>().state;

    if (authState is! LoginSuccessState) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى تسجيل الدخول أولًا')));

      return;
    }

    context.read<UpdateComplaintCubit>().updateComplaint(
      token: authState.user.token,
      complaintId: widget.complaint.id,
      agencyId: agency.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      locationText: _locationController.text.trim(),
      priority: _priority,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();

    super.dispose();
  }
}

class _AgencyErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AgencyErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56),

            const SizedBox(height: 16),

            Text(message, textAlign: TextAlign.center),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
