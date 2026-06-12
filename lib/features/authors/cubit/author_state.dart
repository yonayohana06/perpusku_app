import '../../../data/models/author_model.dart';

abstract class AuthorState {}

class AuthorInitial extends AuthorState {}

// --- STATE DAFTAR ---
class AuthorLoading extends AuthorState {}

class AuthorLoaded extends AuthorState {
  final List<AuthorModel> authors;
  AuthorLoaded(this.authors);
}

class AuthorError extends AuthorState {
  final String message;
  AuthorError(this.message);
}

// --- STATE FORM (TAMBAH/EDIT) ---
class AuthorSubmitLoading extends AuthorState {}

class AuthorSubmitSuccess extends AuthorState {}

class AuthorSubmitError extends AuthorState {
  final String message;
  AuthorSubmitError(this.message);
}

// --- STATE HAPUS ---
class AuthorDeleteLoading extends AuthorState {}

class AuthorDeleteSuccess extends AuthorState {}

class AuthorDeleteError extends AuthorState {
  final String message;
  AuthorDeleteError(this.message);
}
