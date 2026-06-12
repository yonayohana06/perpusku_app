//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/repositories/fine_repository_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:perpusku_app/data/models/fine_model.dart';
import 'package:perpusku_app/data/services/fine_api_service.dart';
import 'package:perpusku_app/data/repositories/fine_repository.dart';

class MockFineApiService extends Mock implements FineApiService {}

void main() {
  late MockFineApiService mockApiService;
  late FineRepository repository;

  setUp(() {
    mockApiService = MockFineApiService();
    repository = FineRepository(apiService: mockApiService);
  });

  group('FineRepository', () {
    test(
      'getAllFines() harus mengekstrak List dari dalam properti "data"',
      () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: '/denda'),
          statusCode: 200,
          data: {
            "error": false,
            "data": [
              {"id_denda": "1", "jumlah_denda": 50000},
            ],
          },
        );
        when(
          () => mockApiService.getAllFines(),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getAllFines();

        // Assert
        expect(result, isA<List<FineModel>>());
        expect(result.length, 1);
        expect(result.first.jumlahDenda, 50000);
        verify(() => mockApiService.getAllFines()).called(1);
      },
    );

    test('createFine() harus memanggil post di ApiService', () async {
      // Arrange
      final payload = {"jumlah_denda": 10000, "id_peminjaman": "BRW-1"};
      when(() => mockApiService.createFine(any())).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(path: ''), statusCode: 201),
      );

      // Act
      await repository.createFine(payload);

      // Assert
      verify(() => mockApiService.createFine(payload)).called(1);
    });
  });
}
