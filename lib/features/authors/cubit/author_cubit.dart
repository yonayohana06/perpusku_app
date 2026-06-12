import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/repositories/author_repository.dart';
import 'author_state.dart';

class AuthorCubit extends Cubit<AuthorState> {
  final AuthorRepository repository;

  AuthorCubit({required this.repository}) : super(AuthorInitial());

  Future<void> fetchAuthors() async {
    emit(AuthorLoading());
    try {
      final list = await repository.getAllAuthors();
      emit(AuthorLoaded(list));
    } on ApiException catch (e) {
      emit(AuthorError(e.message));
    } catch (e) {
      emit(AuthorError('Terjadi kesalahan saat memuat data penulis.'));
    }
  }

  Future<void> createAuthor(
    String penulisBuku,
    String alamat,
    String emailPenulis,
    String deskripsi,
  ) async {
    if (penulisBuku.isEmpty) {
      emit(AuthorSubmitError('Nama Penulis wajib diisi.'));
      return;
    }

    emit(AuthorSubmitLoading());
    try {
      final payload = {
        "penulis_buku": penulisBuku.trim(),
        "alamat_penulis": alamat.trim(),
        "email_penulis": emailPenulis.trim(),
        "deskripsi": deskripsi.trim(),
      };
      await repository.createAuthor(payload);
      emit(AuthorSubmitSuccess());
    } on ApiException catch (e) {
      emit(AuthorSubmitError(e.message));
    } catch (e) {
      emit(AuthorSubmitError('Terjadi kesalahan saat menambah data.'));
    }
  }

  Future<void> updateAuthor(
    String id,
    String penulisBuku,
    String alamat,
    String emailPenulis,
    String deskripsi,
  ) async {
    if (penulisBuku.isEmpty) {
      emit(AuthorSubmitError('Nama Penulis wajib diisi.'));
      return;
    }

    emit(AuthorSubmitLoading());
    try {
      final payload = {
        "id": id,
        "penulis_buku": penulisBuku.trim(),
        "alamat_penulis": alamat.trim(),
        "email_penulis": emailPenulis.trim(),
        "deskripsi": deskripsi.trim(),
      };
      await repository.updateAuthor(payload);
      emit(AuthorSubmitSuccess());
    } on ApiException catch (e) {
      emit(AuthorSubmitError(e.message));
    } catch (e) {
      emit(AuthorSubmitError('Terjadi kesalahan saat memperbarui data.'));
    }
  }

  Future<void> deleteAuthor(String id) async {
    emit(AuthorDeleteLoading());
    try {
      await repository.deleteAuthor(id);
      emit(AuthorDeleteSuccess());
    } on ApiException catch (e) {
      emit(AuthorDeleteError(e.message));
    } catch (e) {
      emit(AuthorDeleteError('Terjadi kesalahan saat menghapus data.'));
    }
  }
}
