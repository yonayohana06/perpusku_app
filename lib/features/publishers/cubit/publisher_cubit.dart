import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/repositories/publisher_repository.dart';
import 'publisher_state.dart';

class PublisherCubit extends Cubit<PublisherState> {
  final PublisherRepository repository;

  PublisherCubit({required this.repository}) : super(PublisherInitial());

  Future<void> fetchPublishers() async {
    emit(PublisherLoading());
    try {
      final list = await repository.getAllPublishers();
      emit(PublisherLoaded(list));
    } on ApiException catch (e) {
      emit(PublisherError(e.message));
    } catch (e) {
      emit(PublisherError('Terjadi kesalahan saat memuat data penerbit.'));
    }
  }

  Future<void> createPublisher(
    String penerbitBuku,
    String alamat,
    String telp,
    String email,
    String deskripsi,
  ) async {
    if (penerbitBuku.isEmpty) {
      emit(PublisherSubmitError('Nama Penerbit wajib diisi.'));
      return;
    }

    emit(PublisherSubmitLoading());
    try {
      final payload = {
        "penerbit_buku": penerbitBuku.trim(),
        "alamat_penerbit": alamat.trim(),
        "telp_penerbit": telp.trim(),
        "email_penerbit": email.trim(),
        "deskripsi": deskripsi.trim(),
      };
      await repository.createPublisher(payload);
      emit(PublisherSubmitSuccess());
    } on ApiException catch (e) {
      emit(PublisherSubmitError(e.message));
    } catch (e) {
      emit(PublisherSubmitError('Terjadi kesalahan saat menambah data.'));
    }
  }

  Future<void> updatePublisher(
    String id,
    String penerbitBuku,
    String alamat,
    String telp,
    String email,
    String deskripsi,
  ) async {
    if (penerbitBuku.isEmpty) {
      emit(PublisherSubmitError('Nama Penerbit wajib diisi.'));
      return;
    }

    emit(PublisherSubmitLoading());
    try {
      final payload = {
        "id": id,
        "penerbit_buku": penerbitBuku.trim(),
        "alamat_penerbit": alamat.trim(),
        "telp_penerbit": telp.trim(),
        "email_penerbit": email.trim(),
        "deskripsi": deskripsi.trim(),
      };
      await repository.updatePublisher(payload);
      emit(PublisherSubmitSuccess());
    } on ApiException catch (e) {
      emit(PublisherSubmitError(e.message));
    } catch (e) {
      emit(PublisherSubmitError('Terjadi kesalahan saat memperbarui data.'));
    }
  }

  Future<void> deletePublisher(String id) async {
    emit(PublisherDeleteLoading());
    try {
      await repository.deletePublisher(id);
      emit(PublisherDeleteSuccess());
    } on ApiException catch (e) {
      emit(PublisherDeleteError(e.message));
    } catch (e) {
      emit(PublisherDeleteError('Terjadi kesalahan saat menghapus data.'));
    }
  }
}
