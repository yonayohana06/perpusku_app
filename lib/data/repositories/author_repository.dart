import '../models/author_model.dart';
import '../services/author_api_service.dart';

class AuthorRepository {
  final AuthorApiService apiService;

  AuthorRepository({required this.apiService});

  Future<List<AuthorModel>> getAllAuthors() async {
    final response = await apiService.getAllAuthors();
    final List data = response.data['data'] ?? [];
    return data.map((json) => AuthorModel.fromJson(json)).toList();
  }

  Future<void> createAuthor(Map<String, dynamic> data) async {
    await apiService.createAuthor(data);
  }

  Future<void> updateAuthor(Map<String, dynamic> data) async {
    await apiService.updateAuthor(data);
  }

  Future<void> deleteAuthor(String id) async {
    await apiService.deleteAuthor({"id": id});
  }
}
