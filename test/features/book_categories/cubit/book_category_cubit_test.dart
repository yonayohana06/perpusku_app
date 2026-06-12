//
// CARA MENJALANKAN TEST INI:
// flutter test test/features/book_categories/cubit/book_category_cubit_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:perpusku_app/core/network/api_exception.dart';
import 'package:perpusku_app/data/models/book_category_model.dart';
import 'package:perpusku_app/data/repositories/book_category_repository.dart';
import 'package:perpusku_app/features/book_categories/cubit/book_category_cubit.dart';
import 'package:perpusku_app/features/book_categories/cubit/book_category_state.dart';

class MockBookCategoryRepository extends Mock
    implements BookCategoryRepository {}

void main() {
  late MockBookCategoryRepository mockRepository;
  late BookCategoryCubit cubit;

  setUp(() {
    mockRepository = MockBookCategoryRepository();
    cubit = BookCategoryCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('BookCategoryCubit - fetchCategories()', () {
    final mockList = [
      BookCategoryModel(
        id: '1',
        jenisBuku: 'Sains',
        deskripsi: '-',
        updatedAt: '',
      ),
    ];

    blocTest<BookCategoryCubit, BookCategoryState>(
      'Memancarkan [Loading, Loaded] jika sukses mengambil data',
      build: () {
        when(
          () => mockRepository.getAllCategories(),
        ).thenAnswer((_) async => mockList);
        return cubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        isA<BookCategoryLoading>(),
        isA<BookCategoryLoaded>().having(
          (state) => state.categories.length,
          'jumlah data',
          1,
        ),
      ],
    );
  });

  group('BookCategoryCubit - createCategory()', () {
    blocTest<BookCategoryCubit, BookCategoryState>(
      'Langsung memancarkan SubmitError jika Nama Kategori kosong (tanpa panggil API)',
      build: () => cubit,
      act: (cubit) =>
          cubit.createCategory('', 'Deskripsi'), // Nama kategori kosong
      expect: () => [
        isA<BookCategorySubmitError>().having(
          (state) => state.message,
          'pesan',
          'Nama Jenis Buku wajib diisi.',
        ),
      ],
      verify: (_) => verifyNever(() => mockRepository.createCategory(any())),
    );

    blocTest<BookCategoryCubit, BookCategoryState>(
      'Memancarkan [SubmitLoading, SubmitSuccess] jika data valid dan API sukses',
      build: () {
        when(
          () => mockRepository.createCategory(any()),
        ).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.createCategory('Sains', 'Buku Sains'),
      expect: () => [
        isA<BookCategorySubmitLoading>(),
        isA<BookCategorySubmitSuccess>(),
      ],
    );
  });

  group('BookCategoryCubit - deleteCategory()', () {
    blocTest<BookCategoryCubit, BookCategoryState>(
      'Memancarkan [DeleteLoading, DeleteError] jika API menolak (misal: data sedang dipakai)',
      build: () {
        when(() => mockRepository.deleteCategory(any())).thenThrow(
          ApiException(message: 'Kategori ini masih digunakan oleh buku lain'),
        );
        return cubit;
      },
      act: (cubit) => cubit.deleteCategory('ID-1'),
      expect: () => [
        isA<BookCategoryDeleteLoading>(),
        isA<BookCategoryDeleteError>().having(
          (state) => state.message,
          'error',
          'Kategori ini masih digunakan oleh buku lain',
        ),
      ],
    );
  });
}
