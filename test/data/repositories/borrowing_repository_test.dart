//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/repositories/borrowing_repository_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:perpusku_app/data/models/borrowing_model.dart';
import 'package:perpusku_app/data/services/borrowing_api_service.dart';
import 'package:perpusku_app/data/repositories/borrowing_repository.dart';

// 1. Buat API Service palsu (Mock)
class MockBorrowingApiService extends Mock implements BorrowingApiService {}

void main() {
  late MockBorrowingApiService mockApiService;
  late BorrowingRepository repository;

  setUp(() {
    mockApiService = MockBorrowingApiService();
    repository = BorrowingRepository(borrowingApiService: mockApiService);
  });

  group('BorrowingRepository', () {
    test(
      'getAllBorrowing() harus mengembalikan List<BorrowingModel> saat API membalas array data',
      () async {
        // Arrange: Siapkan respons palsu dari API
        final mockResponse = Response(
          requestOptions: RequestOptions(path: '/peminjaman'),
          statusCode: 200,
          data: {
            "error": false,
            "data": [
              {
                "id": "1",
                "id_anggota": "AGT-1",
                "tgl_pinjam": "2023",
                "tgl_hrs_kembali": "2023",
                "jaminan": "KTP",
              },
            ],
          },
        );

        when(
          () => mockApiService.getAllBorrowing(),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getAllBorrowing();

        // Assert
        expect(result, isA<List<BorrowingModel>>());
        expect(result.length, 1);
        expect(result.first.idAnggota, 'AGT-1');
        verify(() => mockApiService.getAllBorrowing()).called(1);
      },
    );

    test(
      'createBorrowing() harus memanggil fungsi post di ApiService dengan payload yang tepat',
      () async {
        // Arrange
        final payload = {"id_anggota": "AGT-99"};
        final mockResponse = Response(
          requestOptions: RequestOptions(path: '/create'),
          statusCode: 201, // Created
        );

        when(
          () => mockApiService.createBorrowing(payload),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await repository.createBorrowing(payload);

        // Assert: Pastikan ApiService menerima payload yang persis sama
        verify(() => mockApiService.createBorrowing(payload)).called(1);
      },
    );

    test(
      'deleteBorrowing() harus mengirim JSON berisi id_peminjaman ke ApiService',
      () async {
        // Arrange
        when(() => mockApiService.deleteBorrowing(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ),
        );

        // Act
        await repository.deleteBorrowing('ID-RAHASIA');

        // Assert: Buktikan bahwa Repository otomatis membungkus ID menjadi format JSON
        verify(
          () => mockApiService.deleteBorrowing({"id_peminjaman": "ID-RAHASIA"}),
        ).called(1);
      },
    );
  });
}
