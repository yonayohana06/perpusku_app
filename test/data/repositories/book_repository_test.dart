import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:perpusku_app/data/services/book_api_service.dart';
import 'package:perpusku_app/data/repositories/book_repository.dart';

class MockBookApi extends Mock implements BookApiService {}

void main() {
  late MockBookApi mockApi;
  late BookRepository repo;

  setUp(() {
    mockApi = MockBookApi();
    repo = BookRepository(bookApiService: mockApi);
  });

  group('BookRepository', () {
    test('getBooks() harus return List of Books', () async {
      final res = Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          "data": [
            {"id_buku": "1", "judul_buku": "Flutter Master"},
          ],
        },
      );
      when(() => mockApi.getBooks()).thenAnswer((_) async => res);

      final result = await repo.getBooks();
      expect(result.first.judulBuku, 'Flutter Master');
    });

    test('getBookById() harus return 1 objek BookModel', () async {
      final res = Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          "data": {"id_buku": "99", "judul_buku": "Clean Code"},
        },
      );
      when(() => mockApi.getBookById(any())).thenAnswer((_) async => res);

      final result = await repo.getBookById('99');
      expect(result.idBuku, '99');
      expect(result.judulBuku, 'Clean Code');
    });
  });
}
