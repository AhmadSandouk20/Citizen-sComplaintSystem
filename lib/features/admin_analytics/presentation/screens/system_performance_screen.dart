import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/localization/local_keys.dart';
import 'package:final_flutter/core/widget/empty_state.dart';
import 'package:final_flutter/core/widget/error_view.dart';
import 'package:final_flutter/features/admin_analytics/presentation/bloc/performance_cubit.dart';
import 'package:final_flutter/features/admin_analytics/presentation/bloc/performance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SystemPerformanceScreen extends StatelessWidget {
  const SystemPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.performance.tr())),
      body: BlocBuilder<PerformanceCubit, PerformanceState>(
        builder: (context, state) {
          if (state is PerformanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PerformanceError) {
            return ErrorView(
              message: state.message,
              buttonText: LocaleKeys.retry.tr(),
              onRetry: () => context.read<PerformanceCubit>().load(),
            );
          }
          if (state is PerformanceEmpty) {
            return EmptyState(
              icon: Icons.speed_outlined,
              message: LocaleKeys.insufficientData.tr(),
            );
          }
          if (state is PerformanceLoaded) {
            final data = state.data;
            return RefreshIndicator(
              onRefresh: () => context.read<PerformanceCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  ListTile(
                    title: Text(LocaleKeys.totalOperations.tr()),
                    trailing: Text('${data.totalOperations}'),
                  ),
                  ListTile(
                    title: Text(LocaleKeys.avgDuration.tr()),
                    trailing: Text('${data.avgDurationMs} ms'),
                  ),
                  ListTile(
                    title: Text(LocaleKeys.errorRate.tr()),
                    trailing: Text(
                      '${data.errorRatePercent}% (${data.errorCount})',
                    ),
                  ),
                  const Divider(),
                  Text(
                    LocaleKeys.byLayer.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...data.byLayer.map(
                    (layer) => ListTile(
                      title: Text(layer.layer),
                      subtitle: Text('${layer.count}'),
                      trailing: Text('${layer.avgDurationMs} ms'),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
