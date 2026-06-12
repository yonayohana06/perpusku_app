//
// CARA MENJALANKAN TEST INI:
// Buka terminal dan ketik:
// flutter test test/features/borrowing/cubit/borrowing_cubit_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:perpusku_app/core/network/api_exception.dart';
import 'package:perpusku_app/data/models/borrowing_model.dart';
import 'package:perpusku_app/data/repositories/borrowing_repository.dart';
import 'package:perpusku_app/features/borrowing/cubit/borrowing_cubit.dart';
import 'package:perpusku_app/features/borrowing/cubit/borrowing_state.dart';

// 1. Buat Mock Repository
class MockBorrowingRepository extends Mock implements BorrowingRepository {}

void main() {
  late MockBorrowingRepository mockRepository;
  late BorrowingCubit borrowingCubit;

  setUp(() {
    mockRepository = MockBorrowingRepository();
    borrowingCubit = BorrowingCubit(borrowingRepository: mockRepository);
  });

  tearDown(() {
    borrowingCubit.close();
  });

  // --- TES SKENARIO BACA DATA (READ) ---
  group('BorrowingCubit - fetchBorrowing()', () {
    test('State awal harus BorrowingInitial', () {
      expect(borrowingCubit.state, isA<BorrowingInitial>());
    });

    final mockList = [
      BorrowingModel(
        id: '123',
        idAnggota: 'AGT-001',
        tglPinjam: '2023-10-01T10:00:00Z',
        tglHrsKembali: '2023-10-08T10:00:00Z',
        jaminan: 'KTP',
      ),
    ];

    blocTest<BorrowingCubit, BorrowingState>(
      'Harus memancarkan [Loading, Loaded] dan data list jika API sukses',
      build: () {
        when(
          () => mockRepository.getAllBorrowing(),
        ).thenAnswer((_) async => mockList);
        return borrowingCubit;
      },
      act: (cubit) => cubit.fetchBorrowing(),
      expect: () => [
        isA<BorrowingLoading>(),
        isA<BorrowingLoaded>().having(
          (state) => state.borrowingList.length,
          'jumlah data',
          1,
        ),
      ],
    );

    blocTest<BorrowingCubit, BorrowingState>(
      'Harus memancarkan [Loading, Error] jika API gagal',
      build: () {
        when(
          () => mockRepository.getAllBorrowing(),
        ).thenThrow(ApiException(message: 'Server sedang down'));
        return borrowingCubit;
      },
      act: (cubit) => cubit.fetchBorrowing(),
      expect: () => [
        isA<BorrowingLoading>(),
        isA<BorrowingError>().having(
          (state) => state.message,
          'pesan error',
          'Server sedang down',
        ),
      ],
    );
  });

  // --- TES SKENARIO TAMBAH DATA (CREATE) ---
  group('BorrowingCubit - submitNewBorrowing()', () {
    final tglKembaliDummy = DateTime.now().add(const Duration(days: 7));

    blocTest<BorrowingCubit, BorrowingState>(
      'Harus langsung memancarkan [SubmitError] jika ada input teks yang kosong, tanpa memanggil API',
      build: () => borrowingCubit,
      act: (cubit) => cubit.submitNewBorrowing(
        '',
        'KTP',
        tglKembaliDummy,
      ), // ID Anggota kosong
      expect: () => [
        isA<BorrowingSubmitError>().having(
          (state) => state.message,
          'pesan error',
          'Semua field wajib diisi.',
        ),
      ],
      verify: (_) {
        // Buktikan bahwa Repository TIDAK PERNAH dipanggil (menghemat kuota / beban server)
        verifyNever(() => mockRepository.createBorrowing(any()));
      },
    );

    blocTest<BorrowingCubit, BorrowingState>(
      'Harus memancarkan [SubmitLoading, SubmitSuccess] jika data valid dan API sukses',
      build: () {
        // Karena parameter di repository adalah Map<String, dynamic>, any() langsung bisa dipakai
        when(
          () => mockRepository.createBorrowing(any()),
        ).thenAnswer((_) async {});
        return borrowingCubit;
      },
      act: (cubit) =>
          cubit.submitNewBorrowing('AGT-001', 'KTP', tglKembaliDummy),
      expect: () => [
        isA<BorrowingSubmitLoading>(),
        isA<BorrowingSubmitSuccess>(),
      ],
      verify: (_) {
        verify(() => mockRepository.createBorrowing(any())).called(1);
      },
    );
  });

  // --- TES SKENARIO HAPUS DATA (DELETE) ---
  group('BorrowingCubit - deleteBorrowing()', () {
    blocTest<BorrowingCubit, BorrowingState>(
      'Harus memancarkan [DeleteLoading, DeleteSuccess] jika sukses hapus',
      build: () {
        when(
          () => mockRepository.deleteBorrowing(any()),
        ).thenAnswer((_) async {});
        return borrowingCubit;
      },
      act: (cubit) => cubit.deleteBorrowing('ID-123'),
      expect: () => [
        isA<BorrowingDeleteLoading>(),
        isA<BorrowingDeleteSuccess>(),
      ],
    );
  });
}
