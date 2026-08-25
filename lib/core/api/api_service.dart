import 'package:dio/dio.dart';

class APIService {
  final Dio _dio;

  APIService(this._dio);

  static const String _post = "POST";
  static const String _patch = "PATCH";
  static const String _put = "PUT";

  Future<Response> _sendWithBody({
    required String method,
    required String path,
    required dynamic bodyData,
    Map<String, dynamic>? queryParameters,
    required bool isFormData,
    Map<String, dynamic>? headers,
  }) async {
    final Options reqOptions;
    if (headers != null && headers.isNotEmpty) {
      reqOptions = Options(headers: headers);
    } else if (isFormData) {
      reqOptions = Options();
    } else {
      reqOptions = Options(headers: {'Content-Type': 'application/json'});
    }

    final data = !isFormData ? bodyData : FormData.fromMap(bodyData);

    final Future<Response> Function(
      String path, {
      Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options,
    })
    dioMethod;
    switch (method) {
      case (_post):
        dioMethod = _dio.post;
        break;
      case (_put):
        dioMethod = _dio.put;
        break;
      case (_patch):
        dioMethod = _dio.patch;
        break;
      default:
        throw ArgumentError('Unsupported method: $method');
    }

    return await dioMethod(
      path,
      data: data,
      options: reqOptions,
      queryParameters: queryParameters,
    );
  }

  Future<Response> postData(
    String path, {
    required dynamic bodyData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) => _sendWithBody(
    method: _post,
    path: path,
    bodyData: bodyData,
    isFormData: isFormData,
    queryParameters: queryParameters,
    headers: headers,
  );
  Future<Response> putData(
    String path, {
    required dynamic bodyData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) => _sendWithBody(
    method: _put,
    path: path,
    bodyData: bodyData,
    isFormData: isFormData,
    queryParameters: queryParameters,
    headers: headers,
  );
  Future<Response> patchData(
    String path, {
    required dynamic bodyData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) => _sendWithBody(
    method: _patch,
    path: path,
    bodyData: bodyData,
    isFormData: isFormData,
    queryParameters: queryParameters,
    headers: headers,
  );

  Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.delete(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }
}
