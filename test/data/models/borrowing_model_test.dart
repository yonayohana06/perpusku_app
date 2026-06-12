//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/models/borrowing_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:perpusku_app/data/models/borrowing_model.dart';

void main() {
  group('BorrowingModel - fromJson', () {
    test('Harus berhasil memetakan JSON lengkap ke dalam objek Dart', () {
      // Arrange: Simulasi balasan JSON sempurna dari Backend Golang
      final Map<String, dynamic> jsonBackend = {
        "id": "BRW-001",
        "id_anggota": "AGT-999",
        "tgl_pinjam": "2023-10-01T10:00:00Z",
        "tgl_hrs_kembali": "2023-10-08T10:00:00Z",
        "jaminan": "KTP",
      };

      // Act: Eksekusi konversi
      final model = BorrowingModel.fromJson(jsonBackend);

      // Assert: Pastikan nilainya tepat
      expect(model.id, 'BRW-001');
      expect(model.idAnggota, 'AGT-999');
      expect(model.tglPinjam, '2023-10-01T10:00:00Z');
      expect(model.jaminan, 'KTP');
    });

    test(
      'Harus aman (memberikan nilai default) jika JSON dari backend kehilangan beberapa key',
      () {
        // Arrange: Simulasi backend error (hanya mengirim ID saja)
        final Map<String, dynamic> jsonCacat = {
          "id": "BRW-002",
          // id_anggota, tgl_pinjam, dll hilang!
        };

        // Act: Eksekusi konversi
        final model = BorrowingModel.fromJson(jsonCacat);

        // Assert: Pastikan TIDAK CRASH (Null Pointer Exception) dan menggunakan nilai fallback/default
        expect(model.id, 'BRW-002');
        expect(
          model.idAnggota,
          'Anonim',
        ); // Sesuai default di model: json['id_anggota'] ?? 'Anonim'
        expect(model.tglPinjam, '');
        expect(model.jaminan, '-');
      },
    );
  });
}
