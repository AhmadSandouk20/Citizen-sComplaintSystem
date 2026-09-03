import 'package:dio/dio.dart';

import '../models/agency_model.dart';

class AgencyRemoteDataSource {
  final Dio dio;

  AgencyRemoteDataSource({required this.dio});

  Future<List<AgencyModel>> getAgencies() async {
    final response = await dio.get(
      '/agencies',
      options: Options(headers: {'Accept': 'application/json'}),
    );

    final data = response.data as Map<String, dynamic>;

    final agenciesJson = data['data'] as List? ?? [];

    return agenciesJson
        .map((item) => AgencyModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
