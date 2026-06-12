import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/author_repository.dart';
import '../../data/repositories/book_category_repository.dart';
import '../../data/repositories/borrowing_repository.dart';
import '../../data/repositories/fine_repository.dart';
import '../../data/repositories/publisher_repository.dart';
import '../../data/services/auth_api_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/author_api_service.dart';
import '../../data/services/book_category_api_service.dart';
import '../../data/services/borrowing_api_service.dart';
import '../../data/services/fine_api_service.dart';
import '../../data/services/publisher_api_service.dart';
import '../../features/auth/cubit/auth_cubit.dart';

import '../../data/services/book_api_service.dart';
import '../../data/repositories/book_repository.dart';
import '../../features/auth/cubit/login_cubit.dart';
import '../../features/authors/cubit/author_cubit.dart';
import '../../features/book_categories/cubit/book_category_cubit.dart';
import '../../features/books/cubit/book_detail_cubit.dart';
import '../../features/books/cubit/books_cubit.dart';
import '../../features/borrowing/cubit/borrowing_cubit.dart';
import '../../features/borrowing/cubit/borrowing_detail_cubit.dart';
import '../../features/fines/cubit/fine_cubit.dart';
import '../../features/publishers/cubit/publisher_cubit.dart';
import '../network/api_client.dart';
import '../network/auth_interceptor.dart';
import '../network/logging_interceptor.dart';
import '../services/storage_service.dart';
import '../theme/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initLocator() async {
  // 1. External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // 2. Services
  sl.registerLazySingleton<StorageService>(() => StorageService(sl()));

  // 3. Network & Interceptors
  sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(sl()));
  sl.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(authInterceptor: sl(), loggingInterceptor: sl()),
  );

  // 4. API & Repositories (Data Layer) & Cubit

  // --- MAIN LAYER ---
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl()));

  // --- AUTH LAYER ---
  sl.registerLazySingleton<AuthApiService>(
    () => AuthApiService(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(authApiService: sl(), storageService: sl()),
  );
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(authRepository: sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(authRepository: sl()));

  // --- BOOK LAYER (BUKU)
  sl.registerLazySingleton<BookApiService>(
    () => BookApiService(apiClient: sl()),
  );
  sl.registerLazySingleton<BookRepository>(
    () => BookRepository(bookApiService: sl()),
  );
  sl.registerFactory<BooksCubit>(() => BooksCubit(bookRepository: sl()));
  sl.registerFactory<BookDetailCubit>(
    () => BookDetailCubit(bookRepository: sl()),
  );

  // --- BORROWING LAYER (PEMINJAMAN) ---
  sl.registerLazySingleton<BorrowingApiService>(
    () => BorrowingApiService(apiClient: sl()),
  );
  sl.registerLazySingleton<BorrowingRepository>(
    () => BorrowingRepository(borrowingApiService: sl()),
  );
  sl.registerFactory<BorrowingCubit>(
    () => BorrowingCubit(borrowingRepository: sl()),
  );
  sl.registerFactory<BorrowingDetailCubit>(
    () => BorrowingDetailCubit(borrowingRepository: sl()),
  );

  // --- BOOK CATEGORY LAYER (JENIS BUKU) ---
  sl.registerLazySingleton<BookCategoryApiService>(
    () => BookCategoryApiService(apiClient: sl()),
  );
  sl.registerLazySingleton<BookCategoryRepository>(
    () => BookCategoryRepository(apiService: sl()),
  );
  sl.registerFactory<BookCategoryCubit>(
    () => BookCategoryCubit(repository: sl()),
  );

  // --- AUTHOR LAYER (PENULIS BUKU) ---
  sl.registerLazySingleton<AuthorApiService>(
    () => AuthorApiService(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthorRepository>(
    () => AuthorRepository(apiService: sl()),
  );
  sl.registerFactory<AuthorCubit>(() => AuthorCubit(repository: sl()));

  // --- PUBLISHER LAYER (PENERBIT BUKU) ---
  sl.registerLazySingleton<PublisherApiService>(
    () => PublisherApiService(apiClient: sl()),
  );
  sl.registerLazySingleton<PublisherRepository>(
    () => PublisherRepository(apiService: sl()),
  );
  sl.registerFactory<PublisherCubit>(() => PublisherCubit(repository: sl()));

  // --- FINES LAYER (DENDA) ---
  sl.registerLazySingleton<FineApiService>(
    () => FineApiService(apiClient: sl()),
  );
  sl.registerLazySingleton<FineRepository>(
    () => FineRepository(apiService: sl()),
  );
  sl.registerFactory<FineCubit>(() => FineCubit(repository: sl()));
}
