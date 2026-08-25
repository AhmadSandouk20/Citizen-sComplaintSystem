import 'package:freezed_annotation/freezed_annotation.dart';

part 'agency_model.freezed.dart';
part 'agency_model.g.dart';

@freezed
abstract class AgencyModel with _$AgencyModel {
  const factory AgencyModel({
    required int id,
    required String name,
    required String category,
    required String city,
    required String address,
    required String phone,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AgencyModel;

  factory AgencyModel.fromJson(Map<String, dynamic> json) =>
      _$AgencyModelFromJson(json);
}
