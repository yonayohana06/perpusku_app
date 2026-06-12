//
// CARA MENJALANKAN TEST INI:
// flutter test test/features/authors/cubit/author_cubit_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:perpusku_app/data/models/author_model.dart';
import 'package:perpusku_app/data/repositories/author_repository.dart';
import 'package:perpusku_app/features/authors/cubit/author_cubit.dart';
import 'package:perpusku_app/features/authors/cubit/author_state.dart';

class MockAuthorRepository extends Mock implements AuthorRepository {}

void main() {
  late MockAuthorRepository mockRepository;
  late AuthorCubit cubit;

  setUp(() {
    mockRepository = MockAuthorRepository();
    cubit = AuthorCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthorCubit - fetchAuthors()', () {
    final mockList = [
      AuthorModel(
        id: '1',
        penulisBuku: 'Tere Liye',
        alamat: '',
        emailPenulis: '',
        deskripsi: '',
        updatedAt: '',
      ),
    ];

    blocTest<AuthorCubit, AuthorState>(
      'Memancarkan [Loading, Loaded] jika sukses mengambil data',
      build: () {
        when(
          () => mockRepository.getAllAuthors(),
        ).thenAnswer((_) async => mockList);
        return cubit;
      },
      act: (cubit) => cubit.fetchAuthors(),
      expect: () => [
        isA<AuthorLoading>(),
        isA<AuthorLoaded>().having(
          (state) => state.authors.length,
          'jumlah data',
          1,
        ),
      ],
    );
  });

  group('AuthorCubit - createAuthor()', () {
    blocTest<AuthorCubit, AuthorState>(
      'Langsung memancarkan SubmitError jika Nama Penulis kosong',
      build: () => cubit,
      act: (cubit) =>
          cubit.createAuthor('', 'Alamat', 'email@test.com', 'Deskripsi'),
      expect: () => [
        isA<AuthorSubmitError>().having(
          (state) => state.message,
          'pesan',
          'Nama Penulis wajib diisi.',
        ),
      ],
      verify: (_) => verifyNever(() => mockRepository.createAuthor(any())),
    );

    blocTest<AuthorCubit, AuthorState>(
      'Memancarkan [SubmitLoading, SubmitSuccess] jika sukses',
      build: () {
        when(() => mockRepository.createAuthor(any())).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.createAuthor(
        'Tere Liye',
        'Alamat',
        'email@test.com',
        'Deskripsi',
      ),
      expect: () => [isA<AuthorSubmitLoading>(), isA<AuthorSubmitSuccess>()],
    );
  });

  group('AuthorCubit - deleteAuthor()', () {
    blocTest<AuthorCubit, AuthorState>(
      'Memancarkan [DeleteLoading, DeleteSuccess] jika sukses hapus',
      build: () {
        when(() => mockRepository.deleteAuthor(any())).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.deleteAuthor('ID-1'),
      expect: () => [isA<AuthorDeleteLoading>(), isA<AuthorDeleteSuccess>()],
    );
  });
}
