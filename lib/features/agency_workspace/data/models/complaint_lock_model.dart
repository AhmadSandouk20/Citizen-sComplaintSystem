class ComplaintLockModel {
  final String message;
  final int lockedBy;
  final DateTime lockedAt;

  const ComplaintLockModel({
    required this.message,
    required this.lockedBy,
    required this.lockedAt,
  });

  factory ComplaintLockModel.fromJson(Map<String, dynamic> json) {
    return ComplaintLockModel(
      message: json['message'] as String,
      lockedBy: json['locked_by'] as int,
      lockedAt: DateTime.parse(json['locked_at'] as String),
    );
  }
}
