import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class PublisherApiService {
  final ApiClient apiClient;

  PublisherApiService({required this.apiClient});

  Future<Response> getAllPublishers() async {
    return await apiClient.get(ApiEndpoints.publishers);
  }

  Future<Response> createPublisher(Map<String, dynamic> data) async {
    return await apiClient.post(
      '${ApiEndpoints.publishers}/create',
      data: data,
    );
  }

  Future<Response> updatePublisher(Map<String, dynamic> data) async {
    return await apiClient.put('${ApiEndpoints.publishers}/update', data: data);
  }

  Future<Response> deletePublisher(Map<String, dynamic> data) async {
    return await apiClient.delete(
      '${ApiEndpoints.publishers}/delete',
      data: data,
    );
  }
}
