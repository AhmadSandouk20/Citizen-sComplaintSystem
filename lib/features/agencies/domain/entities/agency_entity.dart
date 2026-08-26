import 'package:equatable/equatable.dart';

class AgencyEntity extends Equatable {
  final int id;
  final String name;
  final String? category;
  final String? city;
  final String? address;
  final String? phone;

  const AgencyEntity({
    required this.id,
    required this.name,
    this.category,
    this.city,
    this.address,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, category, city, address, phone];
}
