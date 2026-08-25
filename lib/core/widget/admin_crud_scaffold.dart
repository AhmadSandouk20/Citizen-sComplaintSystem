import 'package:flutter/material.dart';

class AdminCrudScaffold<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final bool isLoading;
  final String? errorMessage;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final VoidCallback? onAdd;
  final void Function(T item)? onEdit;
  final void Function(T item)? onDelete;
  final List<Widget> Function(BuildContext context, T item)? extraActions;
  final Widget? emptyState;
  final bool showPagination;
  final bool hasMore;
  final VoidCallback? onLoadMore;

  const AdminCrudScaffold({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.isLoading = false,
    this.errorMessage,
    this.onAdd,
    this.onEdit,
    this.onDelete,
    this.extraActions,
    this.emptyState,
    this.showPagination = false,
    this.hasMore = false,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (onAdd != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
              tooltip: 'Add',
            ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: onAdd != null
          ? FloatingActionButton(onPressed: onAdd, child: const Icon(Icons.add))
          : null,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return emptyState ?? const Center(child: Text('No data found.'));
    }

    final list = ListView.builder(
      itemCount: items.length + (showPagination && hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: onLoadMore != null
                  ? TextButton(
                      onPressed: onLoadMore,
                      child: const Text('Load more'),
                    )
                  : const CircularProgressIndicator(),
            ),
          );
        }
        return _buildItemCard(context, items[index]);
      },
    );

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (showPagination &&
            hasMore &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200 &&
            onLoadMore != null) {
          onLoadMore!();
        }
        return false;
      },
      child: list,
    );
  }

  Widget _buildItemCard(BuildContext context, T item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: itemBuilder(context, item),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (extraActions != null) ...extraActions!(context, item),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit!(item),
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete!(item),
              ),
          ],
        ),
      ),
    );
  }
}
