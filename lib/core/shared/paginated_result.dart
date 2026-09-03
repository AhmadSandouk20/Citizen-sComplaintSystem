class PaginatedResult<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  bool get hasMore => currentPage < lastPage;

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) itemParser,
  ) {
    final rawItems = json['data'] as List<dynamic>? ?? const [];
    return PaginatedResult<T>(
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(itemParser)
          .toList(),
      currentPage: _asInt(json['current_page']) ?? 1,
      lastPage: _asInt(json['last_page']) ?? 1,
      total: _asInt(json['total']) ?? rawItems.length,
      perPage: _asInt(json['per_page']) ?? 15,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
