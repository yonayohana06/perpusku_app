//
// CARA MENJALANKAN TEST INI:
// Buka terminal dan ketik:
// flutter test test/data/models/login_response_model_test.dart
//
import 'package:flutter_test/flutter_test.dart';
import 'package:perpusku_app/data/models/login_response_model.dart';

void main() {
  test('Harus berhasil memetakan JSON ke Model dengan benar', () {
    // 1. Arrange: Siapkan JSON mentah (simulasi dari backend Golang)
    final Map<String, dynamic> jsonBackend = {
      "token": "ey123456",
      "refresh_token": "refresh789",
    };

    // 2. Act: Masukkan ke fungsi fromJson
    final model = LoginResponseModel.fromJson(jsonBackend);

    // 3. Assert: Pastikan nilainya masuk ke variabel yang tepat
    expect(model.token, 'ey123456');
    expect(model.refreshToken, 'refresh789');
  });

  test(
    'Harus aman (tidak crash) jika JSON dari backend kehilangan key tertentu (null safety)',
    () {
      // Simulasi backend error dan tidak mengirim refresh_token
      final Map<String, dynamic> jsonBackendCacat = {"token": "ey123456"};

      final model = LoginResponseModel.fromJson(jsonBackendCacat);

      // Pastikan aplikasi tidak crash dan memberikan nilai default string kosong ('')
      expect(model.token, 'ey123456');
      expect(model.refreshToken, '');
    },
  );
}
