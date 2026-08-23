import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../cubit/attachment_gallery_cubit.dart';
import '../cubit/attachment_gallery_state.dart';
import '../widgets/attachment_gallery.dart';

class AttachmentGalleryTestScreen
    extends StatefulWidget {
  final int complaintId;

  const AttachmentGalleryTestScreen({
    super.key,
    required this.complaintId,
  });

  @override
  State<AttachmentGalleryTestScreen>
  createState() =>
      _AttachmentGalleryTestScreenState();
}

class _AttachmentGalleryTestScreenState
    extends State<AttachmentGalleryTestScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _loadAttachments();
    });
  }

  void _loadAttachments() {
    final authState =
        context.read<AuthCubit>().state;

    if (authState is LoginSuccessState) {
      context
          .read<AttachmentGalleryCubit>()
          .loadAttachments(
        complaintId:
        widget.complaintId,
        token:
        authState.user.token,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'معرض المرفقات',
        ),
      ),
      body: BlocBuilder<
          AttachmentGalleryCubit,
          AttachmentGalleryState>(
        builder: (context, state) {
          if (state.status ==
              AttachmentGalleryStatus
                  .loading) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (state.status ==
              AttachmentGalleryStatus
                  .error) {
            return Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ??
                        'حدث خطأ',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed:
                    _loadAttachments,
                    child: const Text(
                      'إعادة المحاولة',
                    ),
                  ),
                ],
              ),
            );
          }

          return AttachmentGallery(
            attachments:
            state.attachments,
          );
        },
      ),
    );
  }
}