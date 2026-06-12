import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../data/repositories/borrowing_repository.dart';
import 'borrowing_detail_state.dart';

class BorrowingDetailCubit extends Cubit<BorrowingDetailState> {
  final BorrowingRepository borrowingRepository;

  BorrowingDetailCubit({required this.borrowingRepository})
    : super(BorrowingDetailInitial());

  Future<void> fetchBorrowingDetail(String id) async {
    emit(BorrowingDetailLoading());
    try {
      final detail = await borrowingRepository.getBorrowingDetail(id);
      emit(BorrowingDetailLoaded(detail));
    } on ApiException catch (e) {
      emit(BorrowingDetailError(e.message));
    } catch (e) {
      emit(
        BorrowingDetailError(
          'Terjadi kesalahan saat memuat detail peminjaman.',
        ),
      );
    }
  }
}
