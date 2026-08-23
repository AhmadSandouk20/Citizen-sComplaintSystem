import 'package:final_flutter/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.isRead,
    required super.createdAt,
    super.readAt,
    super.complaintId,
    super.referenceCode,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final complaint = json['complaint'];
    return NotificationModel(
      id: _asInt(json['id']) ?? 0,
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? json['message'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      readAt: DateTime.tryParse(json['read_at']?.toString() ?? ''),
      complaintId:
          _asInt(json['complaint_id']) ??
          (complaint is Map ? _asInt(complaint['id']) : null),
      referenceCode:
          json['reference_code']?.toString() ??
          (complaint is Map ? complaint['reference_code']?.toString() : null),
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
