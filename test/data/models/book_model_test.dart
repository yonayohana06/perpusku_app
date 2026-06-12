import 'package:flutter_test/flutter_test.dart';
import 'package:perpusku_app/data/models/book_model.dart';

void main() {
  group('BookModel - fromJson', () {
    test('Berhasil mapping JSON buku', () {
      final json = {
        "id_buku": "BK-1",
        "isbn": "978-602",
        "judul_buku": "Harry Potter",
        "stok_buku": 15,
        "rak_buku": "A1",
      };

      final model = BookModel.fromJson(json);
      expect(model.idBuku, 'BK-1');
      expect(model.judulBuku, 'Harry Potter');
      expect(model.stokBuku, 15);
    });

    test('Menangani nilai default jika kosong', () {
      final model = BookModel.fromJson({"id_buku": "BK-2"});
      expect(model.stokBuku, 0); // Default int
      expect(model.judulBuku, 'Tanpa Judul'); // Default string fallback
    });
  });
}
