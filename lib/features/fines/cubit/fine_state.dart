import '../../../data/models/fine_model.dart';

abstract class FineState {}

class FineInitial extends FineState {}

// --- STATE DAFTAR ---
class FineLoading extends FineState {}

class FineLoaded extends FineState {
  final List<FineModel> fines;
  FineLoaded(this.fines);
}

class FineError extends FineState {
  final String message;
  FineError(this.message);
}

// --- STATE FORM ---
class FineSubmitLoading extends FineState {}

class FineSubmitSuccess extends FineState {}

class FineSubmitError extends FineState {
  final String message;
  FineSubmitError(this.message);
}

// --- STATE HAPUS ---
class FineDeleteLoading extends FineState {}

class FineDeleteSuccess extends FineState {}

class FineDeleteError extends FineState {
  final String message;
  FineDeleteError(this.message);
}
