//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/repositories/author_repository_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:perpusku_app/data/models/author_model.dart';
import 'package:perpusku_app/data/services/author_api_service.dart';
import 'package:perpusku_app/data/repositories/author_repository.dart';

class MockAuthorApiService extends Mock implements AuthorApiService {}

void main() {
  late MockAuthorApiService mockApi;
  late AuthorRepository repo;

  setUp(() {
    mockApi = MockAuthorApiService();
    repo = AuthorRepository(apiService: mockApi);
  });

  group('AuthorRepository', () {
    test('getAllAuthors() harus mengembalikan List<AuthorModel>', () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/'),
        data: {
          "data": [
            {"id": "1", "penulis_buku": "Raditya"},
          ],
        },
        statusCode: 200,
      );
      when(() => mockApi.getAllAuthors()).thenAnswer((_) async => mockResponse);

      final result = await repo.getAllAuthors();
      expect(result, isA<List<AuthorModel>>());
      expect(result.first.penulisBuku, 'Raditya');
    });

    test('createAuthor() meneruskan data map ke API', () async {
      final payload = {"penulis_buku": "Baru"};
      when(() => mockApi.createAuthor(any())).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: '')),
      );

      await repo.createAuthor(payload);
      verify(() => mockApi.createAuthor(payload)).called(1);
    });
  });
}
