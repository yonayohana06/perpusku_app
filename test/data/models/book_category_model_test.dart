//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/models/book_category_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:perpusku_app/data/models/book_category_model.dart';

void main() {
  group('BookCategoryModel - fromJson', () {
    test('Harus berhasil memetakan JSON lengkap ke objek Dart', () {
      // Arrange
      final Map<String, dynamic> jsonBackend = {
        "id": "CAT-1",
        "jenis_buku": "Fiksi Ilmiah",
        "deskripsi": "Buku tentang sains dan masa depan",
        "updated_at": "2023-10-10",
      };

      // Act
      final model = BookCategoryModel.fromJson(jsonBackend);

      // Assert
      expect(model.id, 'CAT-1');
      expect(model.jenisBuku, 'Fiksi Ilmiah');
      expect(model.deskripsi, 'Buku tentang sains dan masa depan');
    });

    test(
      'Harus aman dan memberi nilai default jika ada field yang hilang/null',
      () {
        // Arrange
        final Map<String, dynamic> jsonCacat = {
          "id": "CAT-2",
          // jenis_buku dan deskripsi hilang
        };

        // Act
        final model = BookCategoryModel.fromJson(jsonCacat);

        // Assert: Pastikan tidak crash dan mengisi string kosong
        expect(model.id, 'CAT-2');
        expect(model.jenisBuku, '');
        expect(model.deskripsi, '');
      },
    );
  });
}
