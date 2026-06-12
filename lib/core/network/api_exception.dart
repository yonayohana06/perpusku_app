import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic response;

  ApiException({required this.message, this.statusCode, this.response});

  /// Factory untuk memetakan DioException menjadi ApiException yang lebih rapi
  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Koneksi ke server timeout. Silakan coba lagi.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        String errorMessage = 'Terjadi kesalahan pada server.';

        // parsing field 'message' dari response JSON
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('msg')) {
          errorMessage = responseData['msg'];
        }

        return ApiException(
          message: errorMessage,
          statusCode: statusCode,
          response: responseData,
        );

      case DioExceptionType.connectionError:
        return ApiException(message: 'Tidak ada koneksi internet.');

      default:
        return ApiException(message: 'Terjadi kesalahan yang tidak terduga.');
    }
  }

  @override
  String toString() => message;
}
