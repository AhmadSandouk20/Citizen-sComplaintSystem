class CreateComplaintResultModel {
  final int complaintId;
  final String referenceCode;

  const CreateComplaintResultModel({
    required this.complaintId,
    required this.referenceCode,
  });

  factory CreateComplaintResultModel.fromJson(Map<String, dynamic> json) {
    return CreateComplaintResultModel(
      complaintId: json['complaint_id'] as int,
      referenceCode: json['reference_code'] as String,
    );
  }
}
