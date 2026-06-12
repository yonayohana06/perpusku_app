import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/book_repository.dart';
import '../../../core/network/api_exception.dart';
import 'book_detail_state.dart';

class BookDetailCubit extends Cubit<BookDetailState> {
  final BookRepository bookRepository;

  BookDetailCubit({required this.bookRepository}) : super(BookDetailInitial());

  Future<void> fetchBookDetail(String idBuku) async {
    emit(BookDetailLoading());
    try {
      final book = await bookRepository.getBookById(idBuku);
      emit(BookDetailLoaded(book));
    } on ApiException catch (e) {
      emit(BookDetailError(e.message));
    } catch (e) {
      emit(BookDetailError('Terjadi kesalahan saat memuat detail buku.'));
    }
  }
}
