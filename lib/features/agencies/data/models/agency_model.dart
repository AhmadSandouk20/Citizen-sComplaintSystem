import '../../domain/entities/agency_entity.dart';

class AgencyModel extends AgencyEntity {
  const AgencyModel({
    required super.id,
    required super.name,
    super.category,
    super.city,
    super.address,
    super.phone,
  });

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      category: json['category'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
    );
  }
}
