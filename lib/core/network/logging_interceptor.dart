import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '--> [${options.method.toUpperCase()}] ${options.baseUrl}${options.path}',
      name: 'API_REQUEST',
    );
    log('Headers: ${options.headers}', name: 'API_REQUEST');
    if (options.data != null) {
      log('Body: ${options.data}', name: 'API_REQUEST');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '<-- [${response.statusCode}] ${response.requestOptions.baseUrl}${response.requestOptions.path}',
      name: 'API_RESPONSE',
    );
    final body = jsonEncode(response.data);
    log('Data: $body', name: 'API_RESPONSE');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '<-- [ERROR ${err.response?.statusCode}] ${err.requestOptions.baseUrl}${err.requestOptions.path}',
      name: 'API_ERROR',
    );
    log('Message: ${err.message}', name: 'API_ERROR');
    if (err.response?.data != null) {
      log('Error Data: ${err.response?.data}', name: 'API_ERROR');
    }
    super.onError(err, handler);
  }
}
