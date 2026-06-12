import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class FineApiService {
  final ApiClient apiClient;

  FineApiService({required this.apiClient});

  Future<Response> getAllFines() async {
    return await apiClient.get(ApiEndpoints.fines);
  }

  Future<Response> createFine(Map<String, dynamic> data) async {
    return await apiClient.post('${ApiEndpoints.fines}/create', data: data);
  }

  Future<Response> updateFine(Map<String, dynamic> data) async {
    return await apiClient.put('${ApiEndpoints.fines}/update', data: data);
  }

  Future<Response> deleteFine(Map<String, dynamic> data) async {
    return await apiClient.delete('${ApiEndpoints.fines}/delete', data: data);
  }
}
