/// Kelas *Helper* (Utilitas) terpusat untuk memvalidasi input form.
///
/// Menyediakan berbagai fungsi validasi statis yang dapat dipanggil langsung.
///
/// **Contoh Penggunaan Kombinasi (Compose):**
/// ```dart
/// AppTextField(
///   title: 'Email Anggota',
///   validator: FormValidator.compose([
///     (value) => FormValidator.required(value, 'Email tidak boleh kosong'),
///     (value) => FormValidator.email(value, 'Gunakan format email yang benar'),
///   ]),
/// )
/// ```
class FormValidator {
  FormValidator._(); // Mencegah instansiasi class

  /// Validasi input yang wajib diisi (tidak boleh kosong atau hanya spasi).
  ///
  /// **Contoh Penggunaan:**
  /// ```dart
  /// validator: (value) => FormValidator.required(value, 'Nama harus diisi')
  /// ```
  static String? required(
    String? value, [
    String message = 'Field ini wajib diisi',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Validasi format email menggunakan Regex standar.
  ///
  /// **Catatan:** Fungsi ini membolehkan nilai kosong (null). Jika email ini
  /// sifatnya wajib, gabungkan dengan [FormValidator.required] menggunakan [compose].
  ///
  /// **Contoh Penggunaan:**
  /// ```dart
  /// validator: (value) => FormValidator.email(value)
  /// ```
  static String? email(
    String? value, [
    String message = 'Format email tidak valid',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return null; // Boleh kosong (jika wajib, gunakan berantai dengan required)
    }
    // Regex standar untuk email
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value)) {
      return message;
    }
    return null;
  }

  /// Validasi format nomor telepon.
  ///
  /// Mengecek apakah input hanya berisi angka, spasi, plus (+), atau strip (-),
  /// dan memastikan panjang minimalnya adalah 9 karakter numerik.
  ///
  /// **Contoh Penggunaan:**
  /// ```dart
  /// validator: (value) => FormValidator.phone(value, 'No. HP tidak valid')
  /// ```
  static String? phone(
    String? value, [
    String message = 'Nomor telepon tidak valid',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return null; // Boleh kosong
    }
    // Regex untuk mengecek apakah hanya berisi angka, spasi, plus, atau strip
    final phoneRegex = RegExp(r'^[\+0-9\-\s]+$');
    if (!phoneRegex.hasMatch(value) || value.trim().length < 9) {
      return message;
    }
    return null;
  }

  /// Validasi khusus angka (Numeric).
  ///
  /// Sangat berguna untuk form nominal uang atau stok, karena akan mengabaikan
  /// pemisah ribuan (titik/koma) saat mengecek apakah input tersebut memiliki angka.
  ///
  /// **Contoh Penggunaan:**
  /// ```dart
  /// validator: (value) => FormValidator.number(value, 'Hanya menerima angka')
  /// ```
  static String? number(
    String? value, [
    String message = 'Hanya boleh berisi angka',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    // Menghapus karakter non-digit (berguna jika ada format mata uang saat diketik)
    final numericString = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericString.isEmpty) {
      return message;
    }
    return null;
  }

  /// Validasi panjang minimal karakter dari sebuah input teks.
  ///
  /// **Contoh Penggunaan:**
  /// ```dart
  /// validator: (value) => FormValidator.minLength(value, 6, 'Password min 6 karakter')
  /// ```
  static String? minLength(String? value, int min, [String? message]) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length < min) {
      return message ?? 'Minimal $min karakter';
    }
    return null;
  }

  /// Menggabungkan (merantai) beberapa validator sekaligus untuk satu field.
  ///
  /// Validator akan dieksekusi secara berurutan (dari atas ke bawah).
  /// Pesan error yang pertama kali tertangkap akan langsung dikembalikan ke layar.
  ///
  /// **Contoh Penggunaan:**
  /// ```dart
  /// validator: FormValidator.compose([
  ///   (value) => FormValidator.required(value, 'Denda wajib diisi'),
  ///   (value) => FormValidator.number(value, 'Harus berupa angka'),
  /// ])
  /// ```
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        // Kembalikan error pertama yang ditemukan
        if (result != null) return result;
      }
      return null;
    };
  }
}
