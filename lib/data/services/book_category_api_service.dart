import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class BookCategoryApiService {
  final ApiClient apiClient;

  BookCategoryApiService({required this.apiClient});

  Future<Response> getAllCategories() async {
    return await apiClient.get(ApiEndpoints.bookCategories);
  }

  Future<Response> createCategory(Map<String, dynamic> data) async {
    return await apiClient.post(
      '${ApiEndpoints.bookCategories}/create',
      data: data,
    );
  }

  Future<Response> updateCategory(Map<String, dynamic> data) async {
    return await apiClient.put(
      '${ApiEndpoints.bookCategories}/update',
      data: data,
    );
  }

  Future<Response> deleteCategory(Map<String, dynamic> data) async {
    return await apiClient.delete(
      '${ApiEndpoints.bookCategories}/delete',
      data: data,
    );
  }
}
