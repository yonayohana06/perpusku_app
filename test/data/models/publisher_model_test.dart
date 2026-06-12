//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/models/publisher_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:perpusku_app/data/models/publisher_model.dart';

void main() {
  group('PublisherModel - fromJson', () {
    test('Harus berhasil memetakan JSON lengkap', () {
      final json = {
        "id": "PUB-1",
        "penerbit_buku": "Gramedia",
        "alamat_penerbit": "Jakarta",
        "telp_penerbit": "021-123",
        "email_penerbit": "gramedia@mail.com",
        "deskripsi": "-",
        "updated_at": "2023-10-10",
      };

      final model = PublisherModel.fromJson(json);
      expect(model.id, 'PUB-1');
      expect(model.penerbitBuku, 'Gramedia');
      expect(model.telpPenerbit, '021-123');
    });

    test('Harus aman jika JSON cacat (fallback ke default)', () {
      final jsonCacat = {"id": "PUB-2"};
      final model = PublisherModel.fromJson(jsonCacat);

      expect(model.id, 'PUB-2');
      expect(model.penerbitBuku, '');
      expect(model.telpPenerbit, ''); // Null safety terjamin
    });
  });
}
