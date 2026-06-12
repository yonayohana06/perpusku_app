import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/repositories/book_category_repository.dart';
import 'book_category_state.dart';

class BookCategoryCubit extends Cubit<BookCategoryState> {
  final BookCategoryRepository repository;

  BookCategoryCubit({required this.repository}) : super(BookCategoryInitial());

  Future<void> fetchCategories() async {
    emit(BookCategoryLoading());
    try {
      final list = await repository.getAllCategories();
      emit(BookCategoryLoaded(list));
    } on ApiException catch (e) {
      emit(BookCategoryError(e.message));
    } catch (e) {
      emit(BookCategoryError('Terjadi kesalahan saat memuat jenis buku.'));
    }
  }

  Future<void> createCategory(String jenisBuku, String deskripsi) async {
    if (jenisBuku.isEmpty) {
      emit(BookCategorySubmitError('Nama Jenis Buku wajib diisi.'));
      return;
    }

    emit(BookCategorySubmitLoading());
    try {
      final payload = {
        "jenis_buku": jenisBuku.trim(),
        "deskripsi": deskripsi.trim(),
      };
      await repository.createCategory(payload);
      emit(BookCategorySubmitSuccess());
    } on ApiException catch (e) {
      emit(BookCategorySubmitError(e.message));
    } catch (e) {
      emit(BookCategorySubmitError('Terjadi kesalahan saat menambah data.'));
    }
  }

  Future<void> updateCategory(
    String id,
    String jenisBuku,
    String deskripsi,
  ) async {
    if (jenisBuku.isEmpty) {
      emit(BookCategorySubmitError('Nama Jenis Buku wajib diisi.'));
      return;
    }

    emit(BookCategorySubmitLoading());
    try {
      final payload = {
        "id": id,
        "jenis_buku": jenisBuku.trim(),
        "deskripsi": deskripsi.trim(),
      };
      await repository.updateCategory(payload);
      emit(BookCategorySubmitSuccess());
    } on ApiException catch (e) {
      emit(BookCategorySubmitError(e.message));
    } catch (e) {
      emit(BookCategorySubmitError('Terjadi kesalahan saat memperbarui data.'));
    }
  }

  Future<void> deleteCategory(String id) async {
    emit(BookCategoryDeleteLoading());
    try {
      await repository.deleteCategory(id);
      emit(BookCategoryDeleteSuccess());
    } on ApiException catch (e) {
      emit(BookCategoryDeleteError(e.message));
    } catch (e) {
      emit(BookCategoryDeleteError('Terjadi kesalahan saat menghapus data.'));
    }
  }
}
