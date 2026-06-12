//
// CARA MENJALANKAN TEST INI:
// flutter test test/features/fines/cubit/fine_cubit_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:perpusku_app/core/network/api_exception.dart';
import 'package:perpusku_app/data/models/fine_model.dart';
import 'package:perpusku_app/data/repositories/fine_repository.dart';
import 'package:perpusku_app/features/fines/cubit/fine_cubit.dart';
import 'package:perpusku_app/features/fines/cubit/fine_state.dart';

class MockFineRepository extends Mock implements FineRepository {}

void main() {
  late MockFineRepository mockRepository;
  late FineCubit fineCubit;

  setUp(() {
    mockRepository = MockFineRepository();
    fineCubit = FineCubit(repository: mockRepository);
  });

  tearDown(() {
    fineCubit.close();
  });

  group('FineCubit - fetchFines()', () {
    test('State awal harus FineInitial', () {
      expect(fineCubit.state, isA<FineInitial>());
    });

    final mockList = [
      FineModel(
        idDenda: 'DND-1',
        jumlahDenda: 10000,
        tglPinjam: '2023-01-01',
        tglHrsKembali: '2023-01-08',
        tglKembali: '2023-01-10',
        idPeminjaman: 'BRW-1',
        idAnggota: 'AGT-1',
        createdAt: '',
        updatedAt: '',
      ),
    ];

    blocTest<FineCubit, FineState>(
      'Memancarkan [Loading, Loaded] jika sukses',
      build: () {
        when(
          () => mockRepository.getAllFines(),
        ).thenAnswer((_) async => mockList);
        return fineCubit;
      },
      act: (cubit) => cubit.fetchFines(),
      expect: () => [
        isA<FineLoading>(),
        isA<FineLoaded>().having(
          (state) => state.fines.length,
          'jumlah data',
          1,
        ),
      ],
    );
  });

  group('FineCubit - createFine()', () {
    blocTest<FineCubit, FineState>(
      'Langsung Error jika ID Peminjaman atau Anggota kosong (Tanpa panggil API)',
      build: () => fineCubit,
      act: (cubit) => cubit.createFine(
        50000,
        'tgl',
        'tgl',
        'tgl',
        '',
        'AGT-1',
      ), // ID Pinjam kosong
      expect: () => [
        isA<FineSubmitError>().having(
          (state) => state.message,
          'error',
          'ID Peminjaman dan ID Anggota wajib diisi.',
        ),
      ],
      verify: (_) => verifyNever(() => mockRepository.createFine(any())),
    );

    blocTest<FineCubit, FineState>(
      'Memancarkan [SubmitLoading, SubmitSuccess] jika data valid dan API sukses',
      build: () {
        when(() => mockRepository.createFine(any())).thenAnswer((_) async {});
        return fineCubit;
      },
      act: (cubit) =>
          cubit.createFine(50000, 'tgl', 'tgl', 'tgl', 'BRW-1', 'AGT-1'),
      expect: () => [isA<FineSubmitLoading>(), isA<FineSubmitSuccess>()],
    );

    blocTest<FineCubit, FineState>(
      'Memancarkan [SubmitLoading, SubmitError] jika API menolak',
      build: () {
        when(
          () => mockRepository.createFine(any()),
        ).thenThrow(ApiException(message: 'Nota sudah memiliki denda'));
        return fineCubit;
      },
      act: (cubit) =>
          cubit.createFine(50000, 'tgl', 'tgl', 'tgl', 'BRW-1', 'AGT-1'),
      expect: () => [
        isA<FineSubmitLoading>(),
        isA<FineSubmitError>().having(
          (state) => state.message,
          'error',
          'Nota sudah memiliki denda',
        ),
      ],
    );
  });
}
