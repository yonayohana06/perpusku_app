import '../../../data/models/borrowing_model.dart';

abstract class BorrowingState {}

class BorrowingInitial extends BorrowingState {}

class BorrowingLoading extends BorrowingState {}

class BorrowingLoaded extends BorrowingState {
  final List<BorrowingModel> borrowingList;

  BorrowingLoaded(this.borrowingList);
}

class BorrowingError extends BorrowingState {
  final String message;

  BorrowingError(this.message);
}

class BorrowingSubmitLoading extends BorrowingState {}

class BorrowingSubmitSuccess extends BorrowingState {}

class BorrowingSubmitError extends BorrowingState {
  final String message;
  BorrowingSubmitError(this.message);
}

class BorrowingDeleteLoading extends BorrowingState {}

class BorrowingDeleteSuccess extends BorrowingState {}

class BorrowingDeleteError extends BorrowingState {
  final String message;
  BorrowingDeleteError(this.message);
}
