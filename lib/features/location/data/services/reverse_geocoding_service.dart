import 'package:dio/dio.dart';

class ReverseGeocodingService {
  final Dio dio;

  ReverseGeocodingService({required this.dio});

  Future<String?> getAddress({
    required double latitude,
    required double longitude,
  }) async {
    final response = await dio.get(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {
        'format': 'jsonv2',
        'lat': latitude,
        'lon': longitude,
        'accept-language': 'ar',
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'CitizenComplaintSystem/1.0',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;

    final displayName = data['display_name'] as String?;

    if (displayName == null || displayName.trim().isEmpty) {
      return null;
    }

    return displayName.trim();
  }
}
