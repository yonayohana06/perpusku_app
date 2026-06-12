//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/repositories/book_category_repository_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:perpusku_app/data/models/book_category_model.dart';
import 'package:perpusku_app/data/services/book_category_api_service.dart';
import 'package:perpusku_app/data/repositories/book_category_repository.dart';

class MockBookCategoryApiService extends Mock
    implements BookCategoryApiService {}

void main() {
  late MockBookCategoryApiService mockApiService;
  late BookCategoryRepository repository;

  setUp(() {
    mockApiService = MockBookCategoryApiService();
    repository = BookCategoryRepository(apiService: mockApiService);
  });

  group('BookCategoryRepository', () {
    test(
      'getAllCategories() harus mengekstrak List<BookCategoryModel> dari JSON "data"',
      () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: '/jenbuk'),
          statusCode: 200,
          data: {
            "error": false,
            "data": [
              {"id": "1", "jenis_buku": "Sains"},
            ],
          },
        );
        when(
          () => mockApiService.getAllCategories(),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.getAllCategories();

        // Assert
        expect(result, isA<List<BookCategoryModel>>());
        expect(result.length, 1);
        expect(result.first.jenisBuku, 'Sains');
        verify(() => mockApiService.getAllCategories()).called(1);
      },
    );

    test('createCategory() harus meneruskan data map ke ApiService', () async {
      // Arrange
      final payload = {"jenis_buku": "Sejarah", "deskripsi": "Buku sejarah"};
      when(() => mockApiService.createCategory(any())).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(path: ''), statusCode: 201),
      );

      // Act
      await repository.createCategory(payload);

      // Assert
      verify(() => mockApiService.createCategory(payload)).called(1);
    });
  });
}
