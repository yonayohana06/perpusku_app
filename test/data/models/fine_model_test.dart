//
// CARA MENJALANKAN TEST INI:
// flutter test test/data/models/fine_model_test.dart
//

import 'package:flutter_test/flutter_test.dart';
import 'package:perpusku_app/data/models/fine_model.dart';

void main() {
  group('FineModel - fromJson', () {
    test(
      'Harus berhasil memetakan JSON lengkap dari Backend ke objek Dart',
      () {
        // Arrange: Simulasi JSON sukses dari Golang
        final Map<String, dynamic> jsonBackend = {
          "id_denda": "DND-001",
          "jumlah_denda": 15000,
          "tgl_pinjam": "2023-10-01T10:00:00Z",
          "tgl_hrs_kembali": "2023-10-08T10:00:00Z",
          "tgl_kembali": "2023-10-10T10:00:00Z",
          "id_peminjaman": "BRW-999",
          "id_anggota": "AGT-123",
          "created_at": "2023-10-10",
          "updated_at": "2023-10-10",
        };

        // Act
        final model = FineModel.fromJson(jsonBackend);

        // Assert
        expect(model.idDenda, 'DND-001');
        // Pastikan angka masuk sebagai integer
        expect(model.jumlahDenda, 15000);
        expect(model.idAnggota, 'AGT-123');
      },
    );

    test(
      'Harus aman dan memberi nilai default jika ada field yang hilang/null dari API',
      () {
        // Arrange: Simulasi backend bermasalah (JSON tidak lengkap)
        final Map<String, dynamic> jsonCacat = {
          "id_denda": "DND-002",
          // jumlah_denda, tgl_kembali, dll hilang!
        };

        // Act
        final model = FineModel.fromJson(jsonCacat);

        // Assert: Pastikan aplikasi tidak crash dan memakai nilai default (0 atau string kosong)
        expect(model.idDenda, 'DND-002');
        expect(model.jumlahDenda, 0); // Default ke 0, bukan null
        expect(model.tglKembali, '');
        expect(model.idPeminjaman, '');
      },
    );
  });
}
