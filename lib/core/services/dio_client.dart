import 'dart:developer';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../error/failures.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      );

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      log(response.toString());
      return response;
    } on DioException catch (e) {
      throw ServerFailuer.fromDioError(e);
    } catch (e) {
      throw ServerFailuer('Unexpected Error: $e');
    }
  }
}
