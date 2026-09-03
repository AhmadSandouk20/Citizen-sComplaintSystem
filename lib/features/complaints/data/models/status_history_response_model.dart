import 'status_history_model.dart';

class StatusHistoryResponseModel {
  final int complaintId;
  final String referenceCode;
  final List<StatusHistoryModel> history;

  const StatusHistoryResponseModel({
    required this.complaintId,
    required this.referenceCode,
    required this.history,
  });

  factory StatusHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final historyJson = json['status_history'] as List? ?? [];

    return StatusHistoryResponseModel(
      complaintId: json['complaint_id'] as int,
      referenceCode: json['reference_code'] as String? ?? '',
      history: historyJson
          .map(
            (item) => StatusHistoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
