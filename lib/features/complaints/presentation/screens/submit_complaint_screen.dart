import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/files/models/selected_attachment.dart';
import 'package:final_flutter/core/files/services/attachment_picker_service.dart';

import 'package:final_flutter/features/agencies/domain/entities/agency_entity.dart';
import 'package:final_flutter/features/agencies/presentation/cubit/agency_cubit.dart';
import 'package:final_flutter/features/agencies/presentation/cubit/agency_state.dart';

import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_state.dart';

import '../cubit/create_complaint_cubit.dart';
import '../cubit/create_complaint_state.dart';
import '../widgets/submit_complaint/agency_step.dart';
import '../widgets/submit_complaint/complaint_attachments_step.dart';
import '../widgets/submit_complaint/complaint_details_step.dart';
import '../widgets/submit_complaint/complaint_review_step.dart';
import '../widgets/submit_complaint/complaint_step_indicator.dart';
import 'package:final_flutter/features/location/presentation/screens/location_picker_screen.dart';

class SubmitComplaintScreen extends StatefulWidget {
  const SubmitComplaintScreen({super.key});

  @override
  State<SubmitComplaintScreen> createState() => _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends State<SubmitComplaintScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  final AttachmentPickerService _pickerService =
      getIt<AttachmentPickerService>();

  int _currentStep = 0;

  AgencyEntity? _selectedAgency;

  String _priority = 'medium';

  List<SelectedAttachment> _attachments = [];

  static const int _totalSteps = 4;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgencyCubit>().getAgencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateComplaintCubit, CreateComplaintState>(
      listener: (context, state) {
        if (state.status == CreateComplaintStatus.success) {
          final result = state.result;

          if (result == null) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إرسال الشكوى بنجاح')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => _ComplaintSuccessScreen(
                complaintId: result.complaintId,
                referenceCode: result.referenceCode,
              ),
            ),
          );
        }

        if (state.status == CreateComplaintStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'حدث خطأ أثناء إرسال الشكوى'),
            ),
          );
        }

        if (state.status == CreateComplaintStatus.cancelled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إلغاء إرسال الشكوى')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('تقديم شكوى')),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ComplaintStepIndicator(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                ),
              ),
              Expanded(child: _buildStep()),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _buildAgencyStep();

      case 1:
        return _buildDetailsStep();

      case 2:
        return _buildAttachmentsStep();

      case 3:
        return _buildReviewStep();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAgencyStep() {
    return BlocBuilder<AgencyCubit, AgencyState>(
      builder: (context, state) {
        if (state.status == AgencyStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == AgencyStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'تعذر تحميل الجهات',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AgencyCubit>().getAgencies();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.status == AgencyStatus.success && state.agencies.isEmpty) {
          return const Center(child: Text('لا توجد جهات متاحة'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: AgencyStep(
            agencies: state.agencies,
            selectedAgency: _selectedAgency,
            onSelected: (agency) {
              setState(() {
                _selectedAgency = agency;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailsStep() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ComplaintDetailsStep(
          titleController: _titleController,
          descriptionController: _descriptionController,
          locationController: _locationController,
          priority: _priority,
          onPriorityChanged: (value) {
            setState(() {
              _priority = value;
            });
          },
          onPickLocation: _pickLocationFromMap,
        ),
      ),
    );
  }

  Widget _buildAttachmentsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ComplaintAttachmentsStep(
        attachments: _attachments,
        onPickFiles: _pickFiles,
        onPickGallery: _pickGallery,
        onTakePhoto: _takePhoto,
        onRemove: _removeAttachment,
      ),
    );
  }

  Widget _buildReviewStep() {
    final agency = _selectedAgency;

    if (agency == null) {
      return const Center(child: Text('لم يتم اختيار جهة'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ComplaintReviewStep(
        agency: agency,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        priority: _priority,
        attachments: _attachments,
      ),
    );
  }

  Widget _buildBottomActions() {
    return BlocBuilder<CreateComplaintCubit, CreateComplaintState>(
      builder: (context, state) {
        final isSubmitting = state.status == CreateComplaintStatus.submitting;

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                if (isSubmitting) ...[
                  LinearProgressIndicator(value: state.progress),
                  const SizedBox(height: 8),
                  Text('${(state.progress * 100).round()}%'),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isSubmitting ? null : _previousStep,
                          child: const Text('السابق'),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : _currentStep == _totalSteps - 1
                            ? _submitComplaint
                            : _nextStep,
                        child: Text(
                          _currentStep == _totalSteps - 1
                              ? 'إرسال الشكوى'
                              : 'التالي',
                        ),
                      ),
                    ),
                  ],
                ),
                if (isSubmitting) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.read<CreateComplaintCubit>().cancelSubmission();
                    },
                    child: const Text('إلغاء الإرسال'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedAgency == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار جهة حكومية')));
      return;
    }

    if (_currentStep == 1) {
      final isValid = _formKey.currentState?.validate() ?? false;

      if (!isValid) {
        return;
      }
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep <= 0) {
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  Future<void> _pickLocationFromMap() async {
    final result = await Navigator.of(context).push<LocationPickerResult>(
      MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _locationController.text = result.address;
    });
  }

  Future<void> _pickFiles() async {
    try {
      final files = await _pickerService.pickFiles();

      if (!mounted || files.isEmpty) {
        return;
      }

      setState(() {
        _attachments = [..._attachments, ...files];
      });
    } catch (e) {
      _showAttachmentError(e);
    }
  }

  Future<void> _pickGallery() async {
    try {
      final files = await _pickerService.pickImagesFromGallery();

      if (!mounted || files.isEmpty) {
        return;
      }

      setState(() {
        _attachments = [..._attachments, ...files];
      });
    } catch (e) {
      _showAttachmentError(e);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final file = await _pickerService.takePhoto();

      if (!mounted || file == null) {
        return;
      }

      setState(() {
        _attachments = [..._attachments, file];
      });
    } catch (e) {
      _showAttachmentError(e);
    }
  }

  void _removeAttachment(SelectedAttachment attachment) {
    setState(() {
      _attachments = List<SelectedAttachment>.from(_attachments)
        ..remove(attachment);
    });
  }

  void _showAttachmentError(Object error) {
    if (!mounted) {
      return;
    }

    final message = error.toString().replaceFirst('Exception: ', '');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitComplaint() {
    final agency = _selectedAgency;

    if (agency == null) {
      return;
    }

    final authState = context.read<AuthCubit>().state;

    if (authState is! LoginSuccessState) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى تسجيل الدخول أولًا')));
      return;
    }

    context.read<CreateComplaintCubit>().createComplaint(
      token: authState.user.token,
      agencyId: agency.id,
      title: _titleController.text,
      description: _descriptionController.text,
      locationText: _locationController.text,
      priority: _priority,
      attachments: _attachments,
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

class _ComplaintSuccessScreen extends StatelessWidget {
  final int complaintId;
  final String referenceCode;

  const _ComplaintSuccessScreen({
    required this.complaintId,
    required this.referenceCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تم إرسال الشكوى'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 80),
              const SizedBox(height: 24),
              const Text(
                'تم إرسال شكواك بنجاح',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('رمز التتبع'),
              const SizedBox(height: 8),
              SelectableText(
                referenceCode,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('رقم الشكوى: $complaintId'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('تم'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
