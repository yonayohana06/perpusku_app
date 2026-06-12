import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/book_model.dart';
import '../../../data/repositories/book_repository.dart';
import '../../../core/network/api_exception.dart';
import 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final BookRepository bookRepository;

  List<BookModel> _allBooks = [];

  BooksCubit({required this.bookRepository}) : super(BooksInitial());

  Future<void> fetchBooks() async {
    emit(BooksLoading());
    try {
      _allBooks = await bookRepository.getBooks();
      emit(BooksLoaded(_allBooks));
    } on ApiException catch (e) {
      emit(BooksError(e.message));
    } catch (e) {
      emit(BooksError('Terjadi kesalahan saat memuat data buku.'));
    }
  }

  /// Fungsi untuk menyaring daftar buku secara real-time
  void searchBooks(String query) {
    if (_allBooks.isEmpty) return;

    if (query.isEmpty) {
      emit(BooksLoaded(_allBooks));
    } else {
      final lowerQuery = query.toLowerCase();

      final filteredBooks = _allBooks.where((book) {
        return book.judulBuku.toLowerCase().contains(lowerQuery) ||
            book.isbn.toLowerCase().contains(lowerQuery) ||
            book.rakBuku.toLowerCase().contains(lowerQuery);
      }).toList();

      emit(BooksLoaded(filteredBooks));
    }
  }
}
