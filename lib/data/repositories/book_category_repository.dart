import '../models/book_category_model.dart';
import '../services/book_category_api_service.dart';

class BookCategoryRepository {
  final BookCategoryApiService apiService;

  BookCategoryRepository({required this.apiService});

  Future<List<BookCategoryModel>> getAllCategories() async {
    final response = await apiService.getAllCategories();
    final List data = response.data['data'] ?? [];
    return data.map((json) => BookCategoryModel.fromJson(json)).toList();
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    await apiService.createCategory(data);
  }

  Future<void> updateCategory(Map<String, dynamic> data) async {
    await apiService.updateCategory(data);
  }

  Future<void> deleteCategory(String id) async {
    await apiService.deleteCategory({"id": id});
  }
}
