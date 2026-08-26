import 'complaint_model.dart';

class ComplaintsPageModel {
  final List<ComplaintModel> complaints;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const ComplaintsPageModel({
    required this.complaints,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  factory ComplaintsPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return ComplaintsPageModel(
      complaints: data
          .map((item) => ComplaintModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
    );
  }
}
