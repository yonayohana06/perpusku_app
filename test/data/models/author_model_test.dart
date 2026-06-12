//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/models/author_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:perpusku_app/data/models/author_model.dart';

void main() {
  group('AuthorModel - fromJson', () {
    test('Harus berhasil memetakan JSON lengkap', () {
      final json = {
        "id": "AUTH-1",
        "penulis_buku": "Tere Liye",
        "alamat": "Jakarta",
        "email_penulis": "tere@mail.com",
        "deskripsi": "Penulis Fiksi",
        "updated_at": "2023-10-10",
      };

      final model = AuthorModel.fromJson(json);

      expect(model.id, 'AUTH-1');
      expect(model.penulisBuku, 'Tere Liye');
      expect(model.emailPenulis, 'tere@mail.com');
    });

    test('Harus aman jika JSON tidak lengkap', () {
      final jsonCacat = {"id": "AUTH-2"}; // Field lain hilang

      final model = AuthorModel.fromJson(jsonCacat);

      expect(model.id, 'AUTH-2');
      expect(model.penulisBuku, '');
      expect(model.emailPenulis, '');
    });
  });
}
