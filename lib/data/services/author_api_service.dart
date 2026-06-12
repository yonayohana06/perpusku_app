import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class AuthorApiService {
  final ApiClient apiClient;

  AuthorApiService({required this.apiClient});

  Future<Response> getAllAuthors() async {
    return await apiClient.get(ApiEndpoints.authors);
  }

  Future<Response> createAuthor(Map<String, dynamic> data) async {
    return await apiClient.post('${ApiEndpoints.authors}/create', data: data);
  }

  Future<Response> updateAuthor(Map<String, dynamic> data) async {
    return await apiClient.put('${ApiEndpoints.authors}/update', data: data);
  }

  Future<Response> deleteAuthor(Map<String, dynamic> data) async {
    return await apiClient.delete('${ApiEndpoints.authors}/delete', data: data);
  }
}
