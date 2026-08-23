import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../cubit/attachment_cubit.dart';
import '../cubit/attachment_state.dart';
import '../widgets/attachment_file_list.dart';
import '../widgets/attachment_picker_buttons.dart';
import '../widgets/upload_progress_view.dart';

class AttachmentsScreen extends StatelessWidget {
  final int complaintId;

  const AttachmentsScreen({
    super.key,
    required this.complaintId,
  });

  void _upload(BuildContext context) {
  final authState = context.read<AuthCubit>().state;

    if (authState is LoginSuccessState) {
      context.read<AttachmentCubit>().uploadAttachments(
        complaintId: complaintId,
        token: authState.user.token,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المرفقات'),
      ),
      body: BlocConsumer<AttachmentCubit, AttachmentState>(
        listener: (context, state) {
          if (state.status == AttachmentStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message ?? 'تم رفع المرفقات بنجاح',
                ),
              ),
            );
          }

          if (state.status == AttachmentStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'حدث خطأ أثناء رفع المرفقات',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AttachmentCubit>();

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AttachmentPickerButtons(
                onFiles: cubit.pickFiles,
                onGallery: cubit.pickImagesFromGallery,
                onCamera: cubit.takePhoto,
              ),
              const SizedBox(height: 20),

              AttachmentFileList(
                files: state.files,
                onRemove: cubit.removeFile,
              ),
              const SizedBox(height: 20),

              if (state.status == AttachmentStatus.uploading)
                UploadProgressView(
                  progress: state.progress,
                  onCancel: cubit.cancelUpload,
                )
              else
                ElevatedButton.icon(
                  onPressed: state.files.isEmpty
                      ? null
                      : () => _upload(context),
                  icon: const Icon(
                    Icons.cloud_upload_outlined,
                  ),
                  label: const Text('رفع المرفقات'),
                ),

              if (state.status == AttachmentStatus.error &&
                  state.files.isNotEmpty) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    final authState =
                        context.read<AuthCubit>().state;

                    if (authState is LoginSuccessState) {
                      cubit.retryUpload(
                        complaintId: complaintId,
                        token: authState.user.token,
                      );
                    }
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}