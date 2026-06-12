import '../../../data/models/publisher_model.dart';

abstract class PublisherState {}

class PublisherInitial extends PublisherState {}

// --- STATE DAFTAR ---
class PublisherLoading extends PublisherState {}

class PublisherLoaded extends PublisherState {
  final List<PublisherModel> publishers;
  PublisherLoaded(this.publishers);
}

class PublisherError extends PublisherState {
  final String message;
  PublisherError(this.message);
}

// --- STATE FORM (TAMBAH/EDIT) ---
class PublisherSubmitLoading extends PublisherState {}

class PublisherSubmitSuccess extends PublisherState {}

class PublisherSubmitError extends PublisherState {
  final String message;
  PublisherSubmitError(this.message);
}

// --- STATE HAPUS ---
class PublisherDeleteLoading extends PublisherState {}

class PublisherDeleteSuccess extends PublisherState {}

class PublisherDeleteError extends PublisherState {
  final String message;
  PublisherDeleteError(this.message);
}
