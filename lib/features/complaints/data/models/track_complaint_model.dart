import 'package:equatable/equatable.dart';

class TrackComplaintModel extends Equatable {
  final String referenceCode;
  final String status;
  final String title;
  final DateTime? lastUpdate;

  const TrackComplaintModel({
    required this.referenceCode,
    required this.status,
    required this.title,
    this.lastUpdate,
  });

  factory TrackComplaintModel.fromJson(Map<String, dynamic> json) {
    return TrackComplaintModel(
      referenceCode: json['reference_code'] as String? ?? '',
      status: json['status'] as String? ?? '',
      title: json['title'] as String? ?? '',
      lastUpdate: json['last_update'] != null
          ? DateTime.tryParse(json['last_update'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [referenceCode, status, title, lastUpdate];
}
