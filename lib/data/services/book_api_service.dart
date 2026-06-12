import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class BookApiService {
  final ApiClient apiClient;

  BookApiService({required this.apiClient});

  Future<Response> getBooks() async {
    return await apiClient.get(ApiEndpoints.books);
  }

  Future<Response> getBookById(String id) async {
    return await apiClient.get('${ApiEndpoints.books}/$id');
  }
}
