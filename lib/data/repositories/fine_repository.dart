import '../models/fine_model.dart';
import '../services/fine_api_service.dart';

class FineRepository {
  final FineApiService apiService;

  FineRepository({required this.apiService});

  Future<List<FineModel>> getAllFines() async {
    final response = await apiService.getAllFines();
    final List data = response.data['data'] ?? [];
    return data.map((json) => FineModel.fromJson(json)).toList();
  }

  Future<void> createFine(Map<String, dynamic> data) async {
    await apiService.createFine(data);
  }

  Future<void> updateFine(Map<String, dynamic> data) async {
    await apiService.updateFine(data);
  }

  Future<void> deleteFine(String id) async {
    await apiService.deleteFine({"id_denda": id});
  }
}
