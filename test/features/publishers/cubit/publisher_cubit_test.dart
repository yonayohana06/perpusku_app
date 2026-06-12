//
// CARA MENJALANKAN TEST INI:
// flutter test test/features/publishers/cubit/publisher_cubit_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:perpusku_app/data/models/publisher_model.dart';
import 'package:perpusku_app/data/repositories/publisher_repository.dart';
import 'package:perpusku_app/features/publishers/cubit/publisher_cubit.dart';
import 'package:perpusku_app/features/publishers/cubit/publisher_state.dart';

class MockPublisherRepository extends Mock implements PublisherRepository {}

void main() {
  late MockPublisherRepository mockRepository;
  late PublisherCubit cubit;

  setUp(() {
    mockRepository = MockPublisherRepository();
    cubit = PublisherCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('PublisherCubit - fetchPublishers()', () {
    final mockList = [
      PublisherModel(
        id: '1',
        penerbitBuku: 'Gramedia',
        alamatPenerbit: '',
        telpPenerbit: '',
        emailPenerbit: '',
        deskripsi: '',
        updatedAt: '',
      ),
    ];

    blocTest<PublisherCubit, PublisherState>(
      'Memancarkan [Loading, Loaded] jika sukses mengambil data',
      build: () {
        when(
          () => mockRepository.getAllPublishers(),
        ).thenAnswer((_) async => mockList);
        return cubit;
      },
      act: (cubit) => cubit.fetchPublishers(),
      expect: () => [
        isA<PublisherLoading>(),
        isA<PublisherLoaded>().having(
          (state) => state.publishers.length,
          'jumlah data',
          1,
        ),
      ],
    );
  });

  group('PublisherCubit - createPublisher()', () {
    blocTest<PublisherCubit, PublisherState>(
      'Langsung memancarkan SubmitError jika Nama Penerbit kosong',
      build: () => cubit,
      act: (cubit) => cubit.createPublisher(
        '',
        'Alamat',
        '08123',
        'email@test.com',
        'Deskripsi',
      ),
      expect: () => [
        isA<PublisherSubmitError>().having(
          (state) => state.message,
          'pesan',
          'Nama Penerbit wajib diisi.',
        ),
      ],
      verify: (_) => verifyNever(() => mockRepository.createPublisher(any())),
    );

    blocTest<PublisherCubit, PublisherState>(
      'Memancarkan [SubmitLoading, SubmitSuccess] jika sukses',
      build: () {
        when(
          () => mockRepository.createPublisher(any()),
        ).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.createPublisher(
        'Gramedia',
        'Alamat',
        '08123',
        'email@test.com',
        'Deskripsi',
      ),
      expect: () => [
        isA<PublisherSubmitLoading>(),
        isA<PublisherSubmitSuccess>(),
      ],
    );
  });
}
