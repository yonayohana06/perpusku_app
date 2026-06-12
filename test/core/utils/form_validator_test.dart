//
// CARA MENJALANKAN TEST INI:
// Buka terminal dan ketik:
// flutter test test/core/utils/form_validator_test.dart
//
import 'package:flutter_test/flutter_test.dart';
import 'package:perpusku_app/core/utils/form_validator.dart';

void main() {
  // group() digunakan untuk mengelompokkan tes yang sejenis agar log-nya rapi
  group('FormValidator - required()', () {
    test('Harus mengembalikan pesan error jika nilai null', () {
      // Act
      final result = FormValidator.required(null, 'Wajib diisi');
      // Assert
      expect(result, 'Wajib diisi');
    });

    test('Harus mengembalikan pesan error jika nilai hanya spasi kosong', () {
      final result = FormValidator.required('    ', 'Wajib diisi');
      expect(result, 'Wajib diisi');
    });

    test('Harus mengembalikan null (sukses) jika ada teks', () {
      final result = FormValidator.required('Buku Tere Liye');
      expect(result, isNull);
    });
  });

  group('FormValidator - email()', () {
    test(
      'Harus sukses (null) jika diisi null atau kosong karena email bersifat opsional di validator ini',
      () {
        final result = FormValidator.email(null);
        expect(result, isNull);
      },
    );

    test('Harus mengembalikan pesan error jika format salah', () {
      final result = FormValidator.email('bukan-email-yang-benar');
      expect(result, 'Format email tidak valid');
    });

    test('Harus mengembalikan null (sukses) jika format benar', () {
      final result = FormValidator.email('admin@perpus.com');
      expect(result, isNull);
    });
  });

  group('FormValidator - number()', () {
    test('Harus mengembalikan pesan error jika berisi selain angka', () {
      final result = FormValidator.number('abcde', 'Harus angka');
      expect(result, 'Harus angka');
    });

    test('Harus mengembalikan null (sukses) jika hanya berisi angka', () {
      final result = FormValidator.number('150000', 'Harus angka');
      expect(result, isNull);
    });

    test(
      'Harus tetap sukses jika berisi angka tapi ada karakter format seperti titik/koma',
      () {
        // Validator number kita membuang non-digit terlebih dahulu
        final result = FormValidator.number('Rp 150.000', 'Harus angka');
        expect(result, isNull);
      },
    );
  });

  group('FormValidator - compose()', () {
    // Kita membuat validator gabungan: Wajib diisi & Harus email
    final combinedValidator = FormValidator.compose([
      (value) => FormValidator.required(value, 'Email wajib diisi'),
      (value) => FormValidator.email(value, 'Format email salah'),
    ]);

    test('Harus memicu error pertama jika kosong', () {
      final result = combinedValidator('');
      expect(result, 'Email wajib diisi');
    });

    test('Harus memicu error kedua jika terisi tapi format salah', () {
      final result = combinedValidator('user.com');
      expect(result, 'Format email salah');
    });

    test('Harus lolos semua validasi jika benar', () {
      final result = combinedValidator('user@gmail.com');
      expect(result, isNull);
    });
  });
}
