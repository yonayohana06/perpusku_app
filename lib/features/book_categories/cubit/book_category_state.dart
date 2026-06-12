import '../../../data/models/book_category_model.dart';

abstract class BookCategoryState {}

class BookCategoryInitial extends BookCategoryState {}

// --- STATE DAFTAR ---
class BookCategoryLoading extends BookCategoryState {}

class BookCategoryLoaded extends BookCategoryState {
  final List<BookCategoryModel> categories;
  BookCategoryLoaded(this.categories);
}

class BookCategoryError extends BookCategoryState {
  final String message;
  BookCategoryError(this.message);
}

// --- STATE FORM (TAMBAH/EDIT) ---
class BookCategorySubmitLoading extends BookCategoryState {}

class BookCategorySubmitSuccess extends BookCategoryState {}

class BookCategorySubmitError extends BookCategoryState {
  final String message;
  BookCategorySubmitError(this.message);
}

// --- STATE HAPUS ---
class BookCategoryDeleteLoading extends BookCategoryState {}

class BookCategoryDeleteSuccess extends BookCategoryState {}

class BookCategoryDeleteError extends BookCategoryState {
  final String message;
  BookCategoryDeleteError(this.message);
}
