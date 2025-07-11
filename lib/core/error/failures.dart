import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailuer extends Failure {
  ServerFailuer(super.message);

  factory ServerFailuer.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailuer('Connection timeout with server');
      case DioExceptionType.sendTimeout:
        return ServerFailuer('Send timeout with server');
      case DioExceptionType.receiveTimeout:
        return ServerFailuer('Receive timeout in connection with server');
      case DioExceptionType.badResponse:
        return ServerFailuer.fromResponse(
            error.response!.statusCode!, error.response!.data);
      case DioExceptionType.cancel:
        return ServerFailuer('Request to ApiService was cancelled');
      case DioExceptionType.unknown:
        if (error.message!.contains('SocketException')) {
          return ServerFailuer('No Internet Connection');
        }
        return ServerFailuer('Unexpected Error, Please try again!');
      default:
        return ServerFailuer('Opps There Was an Error, Please try again');
    }
  }
  factory ServerFailuer.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailuer(response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailuer('You Requset Not found, Please try later');
    } else if (statusCode == 500) {
      return ServerFailuer('Internal server error Please try later');
    } else {
      return ServerFailuer('Opps There Was an Error, Please try again');
    }
  }
}

