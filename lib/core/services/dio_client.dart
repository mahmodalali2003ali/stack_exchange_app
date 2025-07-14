import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio()
    ..options = BaseOptions(
      baseUrl: 'https://api.stackexchange.com/2.3/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*', 
      },
    );

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}