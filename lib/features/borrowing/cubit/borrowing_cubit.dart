import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/repositories/borrowing_repository.dart';
import 'borrowing_state.dart';

class BorrowingCubit extends Cubit<BorrowingState> {
  final BorrowingRepository borrowingRepository;

  BorrowingCubit({required this.borrowingRepository})
    : super(BorrowingInitial());

  Future<void> fetchBorrowing() async {
    emit(BorrowingLoading());
    try {
      final list = await borrowingRepository.getAllBorrowing();
      emit(BorrowingLoaded(list));
    } on ApiException catch (e) {
      emit(BorrowingError(e.message));
    } catch (e) {
      emit(BorrowingError('Terjadi kesalahan saat memuat data peminjaman.'));
    }
  }

  Future<void> submitNewBorrowing(
    String idAnggota,
    String jaminan,
    DateTime tglKembali,
  ) async {
    if (idAnggota.isEmpty || jaminan.isEmpty) {
      emit(BorrowingSubmitError('Semua field wajib diisi.'));
      return;
    }

    emit(BorrowingSubmitLoading());

    try {
      final payload = {
        "id_anggota": idAnggota.trim(),
        "tgl_pinjam": DateTime.now().toUtc().toIso8601String(),
        "tgl_hrs_kembali": tglKembali.toUtc().toIso8601String(),
        "jaminan": jaminan.trim(),
      };

      await borrowingRepository.createBorrowing(payload);

      emit(BorrowingSubmitSuccess());
    } on ApiException catch (e) {
      emit(BorrowingSubmitError(e.message));
    } catch (e) {
      emit(BorrowingSubmitError('Terjadi kesalahan saat menyimpan data.'));
    }
  }

  Future<void> updateBorrowing(
    String idPeminjaman,
    String idAnggota,
    String jaminan,
    DateTime tglKembali,
    String tglPinjamLama,
  ) async {
    if (idAnggota.isEmpty || jaminan.isEmpty) {
      emit(BorrowingSubmitError('Semua field wajib diisi.'));
      return;
    }

    emit(BorrowingSubmitLoading());
    try {
      final payload = {
        "id_peminjaman": idPeminjaman,
        "id_anggota": idAnggota.trim(),
        "tgl_pinjam": tglPinjamLama,
        "tgl_hrs_kembali": tglKembali.toUtc().toIso8601String(),
        "jaminan": jaminan.trim(),
      };

      await borrowingRepository.updateBorrowing(payload);
      emit(BorrowingSubmitSuccess());
    } on ApiException catch (e) {
      emit(BorrowingSubmitError(e.message));
    } catch (e) {
      emit(BorrowingSubmitError('Terjadi kesalahan saat memperbarui data.'));
    }
  }

  Future<void> deleteBorrowing(String id) async {
    emit(BorrowingDeleteLoading());
    try {
      await borrowingRepository.deleteBorrowing(id);
      emit(BorrowingDeleteSuccess());
    } on ApiException catch (e) {
      emit(BorrowingDeleteError(e.message));
    } catch (e) {
      emit(BorrowingDeleteError('Terjadi kesalahan saat menghapus data.'));
    }
  }
}
