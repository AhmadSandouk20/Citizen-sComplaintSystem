// import 'package:easy_localization/easy_localization.dart';
// import 'package:final_flutter/core/localization/local_keys.dart';
// import 'package:final_flutter/core/router/route_paths.dart';
// import 'package:final_flutter/core/theme/colors.dart';
// import 'package:final_flutter/core/widget/empty_state.dart';
// import 'package:final_flutter/core/widget/error_view.dart';
// import 'package:final_flutter/features/admin_analytics/domain/entities/statistics_entities.dart';
// import 'package:final_flutter/features/admin_analytics/presentation/bloc/statistics_cubit.dart';
// import 'package:final_flutter/features/admin_analytics/presentation/bloc/statistics_state.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class AdminStatisticsScreen extends StatefulWidget {
//   const AdminStatisticsScreen({super.key});

//   @override
//   State<AdminStatisticsScreen> createState() => _AdminStatisticsScreenState();
// }

// class _AdminStatisticsScreenState extends State<AdminStatisticsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<StatisticsCubit>().load(refresh: true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(LocaleKeys.statistics.tr()),
//         actions: [
//           IconButton(
//             tooltip: LocaleKeys.performance.tr(),
//             onPressed: () => context.go(RoutePaths.performance),
//             icon: const Icon(Icons.speed_outlined),
//           ),
//         ],
//       ),
//       body: BlocBuilder<StatisticsCubit, StatisticsState>(
//         builder: (context, state) {
//           if (state is StatisticsLoading || state is StatisticsInitial) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state is StatisticsError) {
//             return ErrorView(
//               message: state.message,
//               buttonText: LocaleKeys.retry.tr(),
//               onRetry: () =>
//                   context.read<StatisticsCubit>().load(refresh: true),
//             );
//           }
//           if (state is StatisticsEmpty) {
//             return EmptyState(
//               icon: Icons.bar_chart_outlined,
//               message: LocaleKeys.insufficientData.tr(),
//             );
//           }
//           if (state is StatisticsLoaded) {
//             return RefreshIndicator(
//               onRefresh: () =>
//                   context.read<StatisticsCubit>().load(refresh: true),
//               child: ListView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   _MetricGrid(overall: state.data.overall),
//                   if (state.data.overall.hasInsufficientResolutionData) ...[
//                     const SizedBox(height: 12),
//                     Card(
//                       child: ListTile(
//                         leading: const Icon(Icons.info_outline),
//                         title: Text(LocaleKeys.insufficientData.tr()),
//                         subtitle: Text(LocaleKeys.insufficientDataHint.tr()),
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 16),
//                   _SectionTitle(LocaleKeys.byStatus.tr()),
//                   _DistributionChart(
//                     values: state.data.overall.byStatus,
//                     colors: const {
//                       'new': AppColors.statusNew,
//                       'in_progress': AppColors.statusInProgress,
//                       'resolved': AppColors.statusResolved,
//                       'rejected': AppColors.statusRejected,
//                     },
//                     labels: {
//                       'new': LocaleKeys.statusNew.tr(),
//                       'in_progress': LocaleKeys.statusInProgress.tr(),
//                       'resolved': LocaleKeys.statusResolved.tr(),
//                       'rejected': LocaleKeys.statusRejected.tr(),
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   _SectionTitle(LocaleKeys.byPriority.tr()),
//                   _DistributionChart(
//                     values: state.data.overall.byPriority,
//                     colors: const {
//                       'low': AppColors.priorityLow,
//                       'medium': AppColors.priorityMedium,
//                       'high': AppColors.priorityHigh,
//                     },
//                     labels: {
//                       'low': LocaleKeys.priorityLow.tr(),
//                       'medium': LocaleKeys.priorityMedium.tr(),
//                       'high': LocaleKeys.priorityHigh.tr(),
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   _SectionTitle(LocaleKeys.agencyPerformance.tr()),
//                   _AgencyChart(agencies: state.data.agencies),
//                   const SizedBox(height: 16),
//                   _SectionTitle(LocaleKeys.timeSeries.tr()),
//                   _TimeSeriesChart(points: state.data.byDate),
//                 ],
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   const _SectionTitle(this.text);
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(text, style: Theme.of(context).textTheme.titleMedium),
//     );
//   }
// }

// class _MetricGrid extends StatelessWidget {
//   const _MetricGrid({required this.overall});
//   final OverallStatistics overall;

//   @override
//   Widget build(BuildContext context) {
//     final avgText = overall.avgResolutionHours == null
//         ? LocaleKeys.insufficientData.tr()
//         : '${overall.avgResolutionHours}h';
//     return Wrap(
//       spacing: 12,
//       runSpacing: 12,
//       children: [
//         _MetricCard(
//           label: LocaleKeys.totalComplaints.tr(),
//           value: '${overall.totalComplaints}',
//         ),
//         _MetricCard(
//           label: LocaleKeys.resolvedCount.tr(),
//           value: '${overall.resolvedCount}',
//         ),
//         _MetricCard(
//           label: LocaleKeys.resolutionRate.tr(),
//           value: '${overall.resolutionRate}%',
//         ),
//         _MetricCard(
//           label: LocaleKeys.avgResolution.tr(),
//           value: avgText,
//         ),
//       ],
//     );
//   }
// }

// class _MetricCard extends StatelessWidget {
//   const _MetricCard({required this.label, required this.value});
//   final String label;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 160,
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label, style: Theme.of(context).textTheme.bodySmall),
//               const SizedBox(height: 8),
//               Text(value, style: Theme.of(context).textTheme.headlineSmall),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _DistributionChart extends StatelessWidget {
//   const _DistributionChart({
//     required this.values,
//     required this.colors,
//     required this.labels,
//   });

//   final Map<String, int> values;
//   final Map<String, Color> colors;
//   final Map<String, String> labels;

//   @override
//   Widget build(BuildContext context) {
//     final sections = values.entries
//         .where((entry) => entry.value > 0)
//         .map(
//           (entry) => PieChartSectionData(
//             value: entry.value.toDouble(),
//             color: colors[entry.key] ?? AppColors.primary,
//             title: '${entry.value}',
//             radius: 48,
//             titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
//           ),
//         )
//         .toList();
//     if (sections.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 24),
//         child: Text(LocaleKeys.insufficientData.tr()),
//       );
//     }
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 180,
//               child: PieChart(
//                 PieChartData(
//                   sections: sections,
//                   centerSpaceRadius: 28,
//                   sectionsSpace: 2,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Wrap(
//               spacing: 12,
//               runSpacing: 8,
//               children: values.keys.map((key) {
//                 return Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 10,
//                       height: 10,
//                       color: colors[key] ?? AppColors.primary,
//                     ),
//                     const SizedBox(width: 6),
//                     Text('${labels[key] ?? key}: ${values[key] ?? 0}'),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AgencyChart extends StatelessWidget {
//   const _AgencyChart({required this.agencies});
//   final List<AgencyStatistics> agencies;

//   @override
//   Widget build(BuildContext context) {
//     if (agencies.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 24),
//         child: Text(LocaleKeys.insufficientData.tr()),
//       );
//     }
//     final top = agencies.take(8).toList();
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 220,
//               child: BarChart(
//                 BarChartData(
//                   maxY: 100,
//                   alignment: BarChartAlignment.spaceAround,
//                   titlesData: FlTitlesData(
//                     leftTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: true, reservedSize: 32),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           final index = value.toInt();
//                           if (index < 0 || index >= top.length) {
//                             return const SizedBox.shrink();
//                           }
//                           final name = top[index].agencyName;
//                           final short = name.length > 8
//                               ? '${name.substring(0, 8)}…'
//                               : name;
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 4),
//                             child: Text(short, style: const TextStyle(fontSize: 10)),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   barGroups: [
//                     for (var i = 0; i < top.length; i++)
//                       BarChartGroupData(
//                         x: i,
//                         barRods: [
//                           BarChartRodData(
//                             toY: top[i].resolutionRate,
//                             color: AppColors.primary,
//                             width: 14,
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...top.map(
//               (agency) => ListTile(
//                 dense: true,
//                 title: Text(agency.agencyName),
//                 subtitle: Text(
//                   '${agency.resolved}/${agency.total}',
//                 ),
//                 trailing: Text('${agency.resolutionRate}%'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _TimeSeriesChart extends StatelessWidget {
//   const _TimeSeriesChart({required this.points});
//   final List<DateStatistics> points;

//   @override
//   Widget build(BuildContext context) {
//     if (points.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 24),
//         child: Text(LocaleKeys.insufficientData.tr()),
//       );
//     }
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SizedBox(
//           height: 220,
//           child: LineChart(
//             LineChartData(
//               titlesData: FlTitlesData(
//                 rightTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 topTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: false),
//                 ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     interval: (points.length / 4).clamp(1, 8).toDouble(),
//                     getTitlesWidget: (value, meta) {
//                       final index = value.toInt();
//                       if (index < 0 || index >= points.length) {
//                         return const SizedBox.shrink();
//                       }
//                       final date = points[index].date;
//                       final short = date.length >= 10 ? date.substring(5) : date;
//                       return Text(short, style: const TextStyle(fontSize: 10));
//                     },
//                   ),
//                 ),
//               ),
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: [
//                     for (var i = 0; i < points.length; i++)
//                       FlSpot(i.toDouble(), points[i].total.toDouble()),
//                   ],
//                   color: AppColors.primary,
//                   isCurved: true,
//                   dotData: const FlDotData(show: false),
//                 ),
//                 LineChartBarData(
//                   spots: [
//                     for (var i = 0; i < points.length; i++)
//                       FlSpot(i.toDouble(), points[i].resolved.toDouble()),
//                   ],
//                   color: AppColors.success,
//                   isCurved: true,
//                   dotData: const FlDotData(show: false),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
