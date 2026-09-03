import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/local_keys.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widget/empty_state.dart';
import '../../../../core/widget/error_view.dart';
import '../cubit/staff_complaints_cubit.dart';
import '../cubit/staff_complaints_state.dart';
import '../widgets/staff_complaint_card.dart';

import '../widgets/staff_complaint_table.dart';
import '../widgets/staff_filter_bar.dart';

class StaffComplaintsScreen extends StatefulWidget {
  const StaffComplaintsScreen({super.key});

  @override
  State<StaffComplaintsScreen> createState() => _StaffComplaintsScreenState();
}

class _StaffComplaintsScreenState extends State<StaffComplaintsScreen> {
  final ScrollController _scrollController = ScrollController();

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffComplaintsCubit>().loadComplaints();
    });

    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        context.read<StaffComplaintsCubit>().refresh();
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<StaffComplaintsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.queue.tr())),
      body: BlocConsumer<StaffComplaintsCubit, StaffComplaintsState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.complaints.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.status == StaffComplaintsStatus.loading &&
              state.complaints.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == StaffComplaintsStatus.error &&
              state.complaints.isEmpty) {
            return ErrorView(
              message: state.errorMessage ?? LocaleKeys.loadComplaintsFailed.tr(),
              buttonText: LocaleKeys.retry.tr(),
              onRetry: () {
                context.read<StaffComplaintsCubit>().loadComplaints();
              },
            );
          }

          if (state.complaints.isEmpty && !state.hasFilters) {
            return EmptyState(
              message: LocaleKeys.noComplaintsFound.tr(),
              icon: Icons.inbox_outlined,
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;

              return RefreshIndicator(
                onRefresh: () => context.read<StaffComplaintsCubit>().refresh(),
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      sliver: SliverToBoxAdapter(
                        child: StaffFilterBar(
                          initialStatus: state.statusFilter,
                          initialPriority: state.priorityFilter,
                          initialDateFrom: state.dateFrom,
                          initialDateTo: state.dateTo,
                          onApply:
                              ({
                                required status,
                                required priority,
                                required dateFrom,
                                required dateTo,
                              }) {
                                context
                                    .read<StaffComplaintsCubit>()
                                    .applyFilters(
                                      status: status,
                                      priority: priority,
                                      dateFrom: dateFrom,
                                      dateTo: dateTo,
                                    );
                              },
                          onClear: () {
                            context.read<StaffComplaintsCubit>().clearFilters();
                          },
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Text(
                              LocaleKeys.complaints.tr(),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(LocaleKeys.totalCount.tr(args: ['${state.total}'])),
                          ],
                        ),
                      ),
                    ),

                    // إذا الفلاتر لم تُرجع أي شكوى
                    if (state.complaints.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Text(LocaleKeys.noMatchingResults.tr()),
                          ),
                        ),
                      ),

                    if (state.complaints.isNotEmpty && isDesktop)
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: StaffComplaintsTable(
                            complaints: state.complaints,
                            onComplaintTap: (complaint) async {
                              await context.push(
                                RoutePaths.sComplaintPath(complaint.id),
                              );

                              if (context.mounted) {
                                context.read<StaffComplaintsCubit>().refresh();
                              }
                            },
                          ),
                        ),
                      )
                    else if (state.complaints.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList.builder(
                          itemCount: state.complaints.length,
                          itemBuilder: (context, index) {
                            final complaint = state.complaints[index];

                            return StaffComplaintCard(
                              complaint: complaint,
                              onTap: () async {
                                await context.push(
                                  RoutePaths.sComplaintPath(complaint.id),
                                );

                                if (context.mounted) {
                                  context
                                      .read<StaffComplaintsCubit>()
                                      .refresh();
                                }
                              },
                            );
                          },
                        ),
                      ),

                    if (state.status == StaffComplaintsStatus.loadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 30)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();

    _scrollController.removeListener(_onScroll);

    _scrollController.dispose();

    super.dispose();
  }
}
