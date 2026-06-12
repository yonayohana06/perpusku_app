//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/repositories/publisher_repository_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:perpusku_app/data/services/publisher_api_service.dart';
import 'package:perpusku_app/data/repositories/publisher_repository.dart';

class MockPublisherApi extends Mock implements PublisherApiService {}

void main() {
  late MockPublisherApi mockApi;
  late PublisherRepository repo;

  setUp(() {
    mockApi = MockPublisherApi();
    repo = PublisherRepository(apiService: mockApi);
  });

  group('PublisherRepository', () {
    test('getAllPublishers() mengambil list data', () async {
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          "data": [
            {"id": "1", "penerbit_buku": "Erlangga"},
          ],
        },
      );
      when(() => mockApi.getAllPublishers()).thenAnswer((_) async => response);

      final result = await repo.getAllPublishers();
      expect(result.first.penerbitBuku, 'Erlangga');
    });

    test(
      'deletePublisher() otomatis membungkus parameter ke {"id": id}',
      () async {
        when(() => mockApi.deletePublisher(any())).thenAnswer(
          (_) async => Response(requestOptions: RequestOptions(path: '')),
        );

        await repo.deletePublisher('123');
        verify(() => mockApi.deletePublisher({"id": "123"})).called(1);
      },
    );
  });
}
