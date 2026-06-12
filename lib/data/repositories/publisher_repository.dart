import '../models/publisher_model.dart';
import '../services/publisher_api_service.dart';

class PublisherRepository {
  final PublisherApiService apiService;

  PublisherRepository({required this.apiService});

  Future<List<PublisherModel>> getAllPublishers() async {
    final response = await apiService.getAllPublishers();
    final List data = response.data['data'] ?? [];
    return data.map((json) => PublisherModel.fromJson(json)).toList();
  }

  Future<void> createPublisher(Map<String, dynamic> data) async {
    await apiService.createPublisher(data);
  }

  Future<void> updatePublisher(Map<String, dynamic> data) async {
    await apiService.updatePublisher(data);
  }

  Future<void> deletePublisher(String id) async {
    await apiService.deletePublisher({"id": id});
  }
}
