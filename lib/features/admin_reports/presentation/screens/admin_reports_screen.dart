import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/app_button.dart';
import 'package:final_flutter/features/admin_reports/presentation/bloc/reports_cubit.dart';
import 'package:final_flutter/features/admin_reports/presentation/bloc/reports_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.reports.tr())),
      body: BlocConsumer<ReportsCubit, ReportsState>(
        listener: (context, state) {
          if (state is ReportsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(LocaleKeys.downloadStarted.tr())),
            );
          }
          if (state is ReportsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final downloading = state is ReportsDownloading ? state.kind : null;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                LocaleKeys.reportsHint.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: LocaleKeys.downloadComplaintsCsv.tr(),
                icon: Icons.table_chart_outlined,
                isLoading: downloading == 'csv',
                onPressed: downloading != null
                    ? null
                    : () => context.read<ReportsCubit>().downloadComplaintsCsv(),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: LocaleKeys.downloadStatisticsCsv.tr(),
                icon: Icons.bar_chart_outlined,
                variant: AppButtonVariant.outlined,
                isLoading: downloading == 'stats',
                onPressed: downloading != null
                    ? null
                    : () =>
                          context.read<ReportsCubit>().downloadStatisticsCsv(),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: LocaleKeys.downloadComplaintsPdf.tr(),
                icon: Icons.picture_as_pdf_outlined,
                variant: AppButtonVariant.outlined,
                isLoading: downloading == 'pdf',
                onPressed: downloading != null
                    ? null
                    : () => context.read<ReportsCubit>().downloadComplaintsPdf(),
              ),
            ],
          );
        },
      ),
    );
  }
}
