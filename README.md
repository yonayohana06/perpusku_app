# 📚 Perpusku - Library Management App

![Flutter Version](https://img.shields.io/badge/Flutter-3.41.6-blue.svg)
![Architecture](https://img.shields.io/badge/Architecture-Feature--First-success.svg)
![State Management](https://img.shields.io/badge/State-Cubit_(BLoC)-orange.svg)
![Test Coverage](https://img.shields.io/badge/Coverage-100%25_Cubit-brightgreen.svg)

**Perpusku** adalah aplikasi mobile manajemen perpustakaan skala *enterprise* yang dirancang dengan antarmuka modern dan arsitektur yang sangat tangguh (*Clean, Feature-First Architecture*). Aplikasi ini terintegrasi langsung dengan Backend RESTful API berbasis Golang.

---

## ✨ Fitur Utama

* **🔒 Sistem Keamanan (Auth):** Login aman berbasis JWT dengan proteksi rute (`RouteGuard`) dan penanganan *Session Expired* otomatis via *Interceptor*.
* **📖 Katalog Publik & Pencarian:** Fitur pencarian buku *real-time* dengan dukungan filter ISBN, Judul, dan Rak secara lokal (in-memory) demi performa kilat.
* **🗄️ Master Data (Admin):** Manajemen komprehensif untuk data Kategori Buku, Penulis, dan Penerbit (CRUD).
* **🔄 Transaksi Terpadu:** Sistem pencatatan Peminjaman Buku dan perhitungan Denda Keterlambatan dengan konversi standar zona waktu *UTC/ISO-8601* agar sinkron dengan database server.
* **🌗 Dukungan Tema:** Mode Terang (*Light Mode*) bernuansa kertas klasik dan Mode Gelap (*Dark Mode*) elegan yang disimpan secara persisten di penyimpanan lokal.

---

## 🛠️ Tech Stack & Arsitektur

Proyek ini dibangun tanpa kompromi pada kualitas kode, menggunakan standar industri terbaru:

* **State Management:** `flutter_bloc` (Pendekatan Cubit untuk efisiensi dan mengurangi *boilerplate*).
* **Routing:** `go_router` (Navigasi deklaratif berbasis URL dan proteksi halaman melalui riwayat rute).
* **Network:** `dio` (Ditenagai dengan `AuthInterceptor` untuk injeksi token otomatis dan `LoggingInterceptor`).
* **Dependency Injection:** `get_it` (Pemisahan instance secara *lazy* untuk menjaga efisiensi penggunaan memori).
* **Testing:** `mocktail` (Pengujian cepat tanpa proses *code generation* yang lambat) & `bloc_test`.

---

## 🔄 Alur Data (Data Flow)

Aplikasi ini menggunakan pola komunikasi **Unidirectional Data Flow** (Alur Data Satu Arah) yang berlapis ganda. Lapisan antarmuka (UI) dilarang keras menyentuh API Service atau memproses data mentah secara langsung.

```text
+----------+      +---------+      +--------------+      +-------------+      +-------------+
| UI Layer | ---> |  Cubit  | ---> |  Repository  | ---> | API Service | ---> | Backend API |
| (Widget) |      | (Logic) |      | (Data Trans) |      |    (Dio)    |      |  (Golang)   |
+----------+      +---------+      +--------------+      +-------------+      +-------------+
```

### Skenario Alur Kerja (Contoh: Menambah Peminjaman Baru)

1.  **UI Layer (Widget):** Pengguna menekan tombol "Simpan Data". Widget memanggil fungsi logika pada block terdekat: `context.read<BorrowingCubit>().submitNewBorrowing(...)`.
2.  **Cubit Layer (Logic):** Cubit langsung mengubah *state* menjadi `BorrowingSubmitLoading` agar UI menampilkan indikator pemrosesan. Cubit merakit data input dari UI, melakukan konversi objek `DateTime` menjadi string standar global (`toUtc().toIso8601String()`), menyusunnya ke dalam struktur *Map/JSON*, lalu meneruskannya ke Repository.
3.  **Repository Layer (Data Transformer):** Bertindak sebagai jembatan data. Menerima objek *Map* dari Cubit, memastikan strukturnya sesuai dengan kontrak API backend, lalu memanggil fungsi POST murni pada *API Service*.
4.  **API Service Layer (Network):** `Dio` mempersiapkan *HTTP Request*. Sebelum terkirim, `AuthInterceptor` mencegat request secara otomatis untuk menyisipkan header token keamanan: `Authorization: Bearer <token_jwt>`. Request kemudian ditembakkan ke Backend Golang.
5.  **Backend API (Golang):** Menerima request, melakukan validasi token dan data, menyimpan transaksi ke database, dan mengembalikan respons berformat JSON.
6.  **Resolusi Data & Emit State:**
    * **Jika Sukses (HTTP 200/201):** API Service mengembalikan objek *Response* -> Repository mengonversinya menjadi model objek Dart -> Cubit menerima konfirmasi dan melempar (*emit*) `BorrowingSubmitSuccess` -> UI menangkap status sukses, menutup modal/form, dan memicu penarikan ulang daftar data terbaru.
    * **Jika Gagal (HTTP 400/401/500):** Dio menangkap *error* jaringan -> Interceptor mendeteksi jenis kesalahan (jika *401 Unauthorized*, Cubit Auth otomatis dipicu untuk *Force Logout*) -> Jaringan mengubahnya menjadi objek `ApiException` dengan pesan bahasa Indonesia -> Cubit melempar (*emit*) `BorrowingSubmitError(message)` -> UI menangkap *state error* lalu menampilkan `SnackBar` atau dialog peringatan berwarna merah.

---

## 📂 Struktur Folder (*Feature-First*)

Proyek dikelompokkan berdasarkan **Fitur**, bukan berdasarkan tipe file (seperti arsitektur MVC tradisional), sehingga memudahkan tim untuk fokus dan mengisolasi pengerjaan per modul fitur tanpa mengganggu modul lainnya:

```text
lib/
├── core/                  # Utilitas global (Jantung utama aplikasi)
│   ├── constants/         # Konfigurasi statis seperti Warna, Dimensi, Endpoints API
│   ├── di/                # service_locator.dart (Setup registrasi instance GetIt)
│   ├── network/           # DioClient, AuthInterceptor, API Exceptions
│   ├── routes/            # go_router setup, nama-nama rute, & RouteGuard
│   ├── theme/             # Konfigurasi visual Light Mode & Dark Mode
│   └── widgets/           # Reusable UI global (AppButton, AppTextField, AppDialog)
├── data/                  # Data Layer (Komunikasi Eksternal)
│   ├── models/            # DTOs (Data Transfer Objects) untuk pemetaan data JSON
│   ├── repositories/      # Kelas abstraksi penentu sumber data bagi Cubit
│   └── services/          # Kelas eksekutor HTTP Request (Dio murni) ke API
└── features/              # Feature Layer (Modul Aplikasi Terisolasi)
    ├── auth/              # Fitur Login, Logout, dan Manajemen Sesi
    ├── authors/           # Modul Manajemen Penulis
    ├── books/             # Modul Katalog & Pencarian Buku
    ├── borrowing/         # Modul Transaksi Peminjaman Buku
    ├── dashboard/         # Shell Route navigasi & Ringkasan Beranda Admin
    ├── fines/             # Modul Transaksi Perhitungan Denda
    └── publishers/        # Modul Manajemen Penerbit
```

---

## 🚀 Cara Menjalankan Aplikasi (Getting Started)

Ikuti langkah-langkah di bawah ini secara berurutan untuk memasang dan menjalankan aplikasi di lingkungan lokal Anda.

### 1. Persiapan Prerequisites
* Pastikan **Flutter SDK versi 3.41.6** atau yang terbaru sudah terinstal dengan benar di perangkat Anda (`flutter doctor`).
* Pastikan *Backend RESTful API (Golang)* perpustakaan sudah aktif berjalan di jaringan lokal atau server *staging* Anda.

### 2. Mengunduh Repositori
Buka terminal/command prompt, jalankan perintah clone untuk mengunduh kode sumber aplikasi:
```bash
git clone [https://github.com/username/perpusku_app.git](https://github.com/username/perpusku_app.git)
cd perpusku_app
```

### 3. Konfigurasi Endpoint API (PENTING!)
Sebelum menjalankan aplikasi, Anda **wajib** menyesuaikan alamat IP server agar aplikasi Flutter dapat berkomunikasi dengan backend Golang. Buka file `lib/core/constants/api_endpoints.dart` dan sesuaikan variabel `baseUrl`:

* **Android Emulator:** Gunakan IP loopback khusus Android untuk mendeteksi localhost komputer Anda.
  ```dart
  static const String baseUrl = '[http://10.0.2.2:8001/api/v1](http://10.0.2.2:8001/api/v1)';
  ```
* **iOS Simulator / Mac / Web:** Anda bisa langsung mengarahkannya ke localhost murni.
  ```dart
  static const String baseUrl = '[http://127.0.0.1:8001/api/v1](http://127.0.0.1:8001/api/v1)';
  ```
* **Perangkat Fisik (HP Asli via Kabel):** Pastikan HP dan Laptop Anda berada dalam satu jaringan Wi-Fi yang sama. Cari tahu IP lokal laptop Anda (via `ipconfig` di Windows atau `ifconfig` di Mac/Linux), kemudian masukkan ke konfigurasi:
  ```dart
  static const String baseUrl = '[http://119.168.1.5:8001/api/v1](http://119.168.1.5:8001/api/v1)'; // Contoh IP lokal
  ```

### 4. Instalasi Dependency & Menjalankan Aplikasi
Eksekusi rangkaian perintah berikut di terminal root proyek Anda untuk mengunduh library dan memasangnya ke perangkat target:

```bash
# Mengunduh dan menyinkronkan seluruh paket library yang terdaftar di pubspec.yaml
flutter pub get

# Memeriksa daftar perangkat/emulator yang terhubung dan siap digunakan
flutter devices

# Menjalankan aplikasi ke perangkat target (Debug Mode)
flutter run
```

---

## 🧪 Pengujian Terotomatisasi (Unit Testing)

Proyek ini telah dilindungi secara ketat oleh "Satpam Otomatis" berupa rangkaian pengujian unit (*Unit Testing*) komprehensif yang mencakup lapisan **Model (JSON parsing)**, **Repository (API payload contracts)**, dan **Cubit (Business Logic)**.

Kami menggunakan pustaka `mocktail` untuk melakukan simulasi objek palsu (*mocking*) secara dinamis. Keunggulannya adalah proses pengujian berjalan sangat cepat karena **tidak bergantung** pada generator kode (`build_runner`) yang lambat.

Untuk mengeksekusi seluruh pengujian secara massal dan memastikan tidak ada kode baru yang merusak fitur lama (*anti-regression defense*), jalankan perintah berikut:

```bash
flutter test
```

### Contoh Output Pengujian Sukses:
```text
00:02 +12: test/core/utils/form_validator_test.dart: FormValidator - required() Harus sukses jika nilai terisi
00:03 +24: test/features/auth/cubit/auth_cubit_test.dart: AuthCubit - login() Harus sukses jika API membalas token
00:05 +48: test/core/network/auth_interceptor_test.dart: AuthInterceptor - onError() Harus memanggil forceLogout() jika mendapat Error 401
00:06 +64: All tests passed!
```