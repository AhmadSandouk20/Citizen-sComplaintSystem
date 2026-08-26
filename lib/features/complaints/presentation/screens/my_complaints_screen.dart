import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../cubit/my_complaints_cubit.dart';
import '../cubit/my_complaints_state.dart';
import '../widgets/complaint_card.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadComplaints();
    });
  }

  String? _getToken() {
    final authState = context.read<AuthCubit>().state;

    if (authState is LoginSuccessState) {
      return authState.user.token;
    }

    return null;
  }

  void _loadComplaints() {
    final token = _getToken();

    if (token == null) {
      return;
    }

    context.read<MyComplaintsCubit>().getComplaints(token: token);
  }

  Future<void> _refresh() async {
    final token = _getToken();

    if (token == null) {
      return;
    }

    await context.read<MyComplaintsCubit>().refresh(token: token);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      final token = _getToken();

      if (token == null) {
        return;
      }

      context.read<MyComplaintsCubit>().loadMore(token: token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شكاواي')),
      body: BlocConsumer<MyComplaintsCubit, MyComplaintsState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.complaints.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          final complaints = state.filteredComplaints;

          if (state.status == MyComplaintsStatus.loading &&
              state.complaints.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MyComplaintsStatus.error &&
              state.complaints.isEmpty) {
            return _ErrorView(
              message: state.errorMessage ?? 'تعذر تحميل الشكاوى',
              onRetry: _loadComplaints,
            );
          }

          if (state.complaints.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: const [SizedBox(height: 160), _EmptyView()],
              ),
            );
          }

          if (complaints.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _ComplaintFilters(
                    selectedFilter: state.selectedFilter,
                    onSelected: (filter) {
                      context.read<MyComplaintsCubit>().setFilter(filter);
                    },
                  ),

                  const SizedBox(height: 120),

                  const _FilteredEmptyView(),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount:
                  complaints.length +
                  1 +
                  (state.status == MyComplaintsStatus.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ComplaintFilters(
                      selectedFilter: state.selectedFilter,
                      onSelected: (filter) {
                        context.read<MyComplaintsCubit>().setFilter(filter);
                      },
                    ),
                  );
                }

                final complaintIndex = index - 1;

                if (complaintIndex == complaints.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final complaint = complaints[complaintIndex];

                return ComplaintCard(
                  complaint: complaint,
                  onTap: () async {
                    final changed = await context.push<bool>(
                      RoutePaths.citizenComplaintDetails(complaint.id),
                    );

                    if (changed == true && context.mounted) {
                      await _refresh();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);

    _scrollController.dispose();

    super.dispose();
  }
}

class _ComplaintFilters extends StatelessWidget {
  final ComplaintFilter selectedFilter;

  final ValueChanged<ComplaintFilter> onSelected;

  const _ComplaintFilters({
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'الكل',
            filter: ComplaintFilter.all,
            selectedFilter: selectedFilter,
            onSelected: onSelected,
          ),

          _FilterChip(
            label: 'جديدة',
            filter: ComplaintFilter.newComplaint,
            selectedFilter: selectedFilter,
            onSelected: onSelected,
          ),

          _FilterChip(
            label: 'قيد المعالجة',
            filter: ComplaintFilter.inProgress,
            selectedFilter: selectedFilter,
            onSelected: onSelected,
          ),

          _FilterChip(
            label: 'تم الحل',
            filter: ComplaintFilter.resolved,
            selectedFilter: selectedFilter,
            onSelected: onSelected,
          ),

          _FilterChip(
            label: 'مرفوضة',
            filter: ComplaintFilter.rejected,
            selectedFilter: selectedFilter,
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;

  final ComplaintFilter filter;

  final ComplaintFilter selectedFilter;

  final ValueChanged<ComplaintFilter> onSelected;

  const _FilterChip({
    required this.label,
    required this.filter,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          onSelected(filter);
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 64),
          SizedBox(height: 16),
          Text('لا توجد شكاوى حتى الآن'),
        ],
      ),
    );
  }
}

class _FilteredEmptyView extends StatelessWidget {
  const _FilteredEmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.filter_alt_off_outlined, size: 64),
          SizedBox(height: 16),
          Text('لا توجد شكاوى ضمن هذا التصنيف'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

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
