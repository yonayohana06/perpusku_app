import '../models/book_model.dart';
import '../services/book_api_service.dart';

class BookRepository {
  final BookApiService bookApiService;

  BookRepository({required this.bookApiService});

  Future<List<BookModel>> getBooks() async {
    final response = await bookApiService.getBooks();
    final List data = response.data['data'] ?? response.data;
    return data.map((json) => BookModel.fromJson(json)).toList();
  }

  Future<BookModel> getBookById(String id) async {
    final response = await bookApiService.getBookById(id);
    final data = response.data['data'] ?? response.data;
    return BookModel.fromJson(data);
  }
}
