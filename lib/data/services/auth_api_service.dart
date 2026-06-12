import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/login_request_model.dart';

class AuthApiService {
  final ApiClient apiClient;

  AuthApiService({required this.apiClient});

  Future<Response> login(LoginRequestModel request) async {
    return await apiClient.post(ApiEndpoints.login, data: request.toJson());
  }
}
