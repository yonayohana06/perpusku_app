import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';

class BorrowingApiService {
  final ApiClient apiClient;

  BorrowingApiService({required this.apiClient});

  Future<Response> getAllBorrowing() async {
    return await apiClient.get(ApiEndpoints.borrowing);
  }

  Future<Response> createBorrowing(Map<String, dynamic> data) async {
    return await apiClient.post('${ApiEndpoints.borrowing}/create', data: data);
  }

  Future<Response> getBorrowingDetail(String id) async {
    return await apiClient.get('${ApiEndpoints.borrowing}/detail/$id');
  }

  Future<Response> updateBorrowing(Map<String, dynamic> data) async {
    return await apiClient.put('${ApiEndpoints.borrowing}/update', data: data);
  }

  Future<Response> deleteBorrowing(Map<String, dynamic> data) async {
    return await apiClient.delete(
      '${ApiEndpoints.borrowing}/delete',
      data: data,
    );
  }
}
