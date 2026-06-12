import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/repositories/fine_repository.dart';
import 'fine_state.dart';

class FineCubit extends Cubit<FineState> {
  final FineRepository repository;

  FineCubit({required this.repository}) : super(FineInitial());

  Future<void> fetchFines() async {
    emit(FineLoading());
    try {
      final list = await repository.getAllFines();
      emit(FineLoaded(list));
    } on ApiException catch (e) {
      emit(FineError(e.message));
    } catch (e) {
      emit(FineError('Terjadi kesalahan saat memuat data denda.'));
    }
  }

  Future<void> createFine(
    int jumlahDenda,
    String tglPinjam,
    String tglHrsKembali,
    String tglKembali,
    String idPeminjaman,
    String idAnggota,
  ) async {
    if (idPeminjaman.isEmpty || idAnggota.isEmpty) {
      emit(FineSubmitError('ID Peminjaman dan ID Anggota wajib diisi.'));
      return;
    }

    emit(FineSubmitLoading());
    try {
      final payload = {
        "jumlah_denda": jumlahDenda,
        "tgl_pinjam": tglPinjam,
        "tgl_hrs_kembali": tglHrsKembali,
        "tgl_kembali": tglKembali,
        "id_peminjaman": idPeminjaman.trim(),
        "id_anggota": idAnggota.trim(),
      };
      await repository.createFine(payload);
      emit(FineSubmitSuccess());
    } on ApiException catch (e) {
      emit(FineSubmitError(e.message));
    } catch (e) {
      emit(FineSubmitError('Terjadi kesalahan saat menambah data denda.'));
    }
  }

  Future<void> updateFine(
    String idDenda,
    int jumlahDenda,
    String tglPinjam,
    String tglHrsKembali,
    String tglKembali,
    String idPeminjaman,
    String idAnggota,
  ) async {
    if (idPeminjaman.isEmpty || idAnggota.isEmpty) {
      emit(FineSubmitError('ID Peminjaman dan ID Anggota wajib diisi.'));
      return;
    }

    emit(FineSubmitLoading());
    try {
      final payload = {
        "id_denda": idDenda,
        "jumlah_denda": jumlahDenda,
        "tgl_pinjam": tglPinjam,
        "tgl_hrs_kembali": tglHrsKembali,
        "tgl_kembali": tglKembali,
        "id_peminjaman": idPeminjaman.trim(),
        "id_anggota": idAnggota.trim(),
      };
      await repository.updateFine(payload);
      emit(FineSubmitSuccess());
    } on ApiException catch (e) {
      emit(FineSubmitError(e.message));
    } catch (e) {
      emit(FineSubmitError('Terjadi kesalahan saat memperbarui data denda.'));
    }
  }

  Future<void> deleteFine(String id) async {
    emit(FineDeleteLoading());
    try {
      await repository.deleteFine(id);
      emit(FineDeleteSuccess());
    } on ApiException catch (e) {
      emit(FineDeleteError(e.message));
    } catch (e) {
      emit(FineDeleteError('Terjadi kesalahan saat menghapus data denda.'));
    }
  }
}
