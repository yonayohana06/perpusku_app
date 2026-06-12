import '../../../data/models/borrowing_detail_model.dart';

abstract class BorrowingDetailState {}

class BorrowingDetailInitial extends BorrowingDetailState {}

class BorrowingDetailLoading extends BorrowingDetailState {}

class BorrowingDetailLoaded extends BorrowingDetailState {
  final BorrowingDetailModel detail;

  BorrowingDetailLoaded(this.detail);
}

class BorrowingDetailError extends BorrowingDetailState {
  final String message;

  BorrowingDetailError(this.message);
}
