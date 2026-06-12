//
// CARA MENJALANKAN TEST INI:
// Buka terminal dan ketik:
// flutter test test/data/repositories/auth_repository_test.dart
//
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:perpusku_app/core/services/storage_service.dart';
import 'package:perpusku_app/data/models/login_request_model.dart';
import 'package:perpusku_app/data/repositories/auth_repository.dart';
import 'package:perpusku_app/data/services/auth_api_service.dart';

// 1. Buat Mock untuk setiap dependensi yang dibutuhkan
class MockAuthApiService extends Mock implements AuthApiService {}

class MockStorageService extends Mock implements StorageService {}

// 2. Buat Fake class untuk LoginRequestModel agar mocktail bisa pakai any()
class FakeLoginRequestModel extends Fake implements LoginRequestModel {}

void main() {
  late MockAuthApiService mockApiService;
  late MockStorageService mockStorageService;
  late AuthRepository authRepository;

  // setUpAll dijalankan sekali saja sebelum semua test dimulai
  setUpAll(() {
    // Daftarkan Fake class agar mocktail mengenali parameter custom
    registerFallbackValue(FakeLoginRequestModel());
  });

  // setUp dijalankan berulang kali sebelum masing-masing fungsi test()
  setUp(() {
    mockApiService = MockAuthApiService();
    mockStorageService = MockStorageService();

    // Injeksi mock ke dalam repository asli
    authRepository = AuthRepository(
      authApiService: mockApiService,
      storageService: mockStorageService,
    );
  });

  group('AuthRepository - login()', () {
    test(
      'Harus sukses, menyimpan token ke StorageService, dan mengembalikan LoginResponseModel',
      () async {
        // --- 1. ARRANGE (SIAPKAN SKENARIO PALSU) ---

        // Siapkan balasan Response palsu dari ApiService
        final mockResponse = Response(
          requestOptions: RequestOptions(path: '/login'),
          statusCode: 200,
          data: {
            "data": {"token": "token123", "refresh_token": "refresh123"},
          },
        );

        // Jika apiService.login() dipanggil, berikan balasan mockResponse
        when(
          () => mockApiService.login(any()),
        ).thenAnswer((_) async => mockResponse);

        // Jika storageService disuruh menyimpan token, biarkan berlalu (karena Future<void>)
        when(
          () => mockStorageService.saveToken(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockStorageService.saveRefreshToken(any()),
        ).thenAnswer((_) async => {});

        // --- 2. ACT (JALANKAN FUNGSI) ---
        final result = await authRepository.login('admin', 'passwordrahasia');

        // --- 3. ASSERT (PASTIKAN HASILNYA BENAR) ---

        // Pastikan model yang dikembalikan berisi data yang sesuai
        expect(result.token, 'token123');
        expect(result.refreshToken, 'refresh123');

        // Pastikan ApiService benar-benar dipanggil 1 kali
        verify(() => mockApiService.login(any())).called(1);

        // Pastikan StorageService benar-benar dieksekusi dengan parameter yang benar!
        verify(() => mockStorageService.saveToken('token123')).called(1);
        verify(
          () => mockStorageService.saveRefreshToken('refresh123'),
        ).called(1);
      },
    );

    test('Harus melempar Exception jika token dari API kosong', () async {
      // --- 1. ARRANGE ---
      final mockResponseKosong = Response(
        requestOptions: RequestOptions(path: '/login'),
        statusCode: 200,
        data: {
          "data": {
            "token": "", // Simulasi token kosong
            "refresh_token": "",
          },
        },
      );
      when(
        () => mockApiService.login(any()),
      ).thenAnswer((_) async => mockResponseKosong);

      // --- 2 & 3. ACT & ASSERT ---
      // Pastikan fungsi ini "meledak" (melempar Exception) seperti yang ditulis di repository
      expect(
        () async => await authRepository.login('admin', 'password'),
        throwsA(isA<Exception>()),
      );

      // Pastikan StorageService TIDAK PERNAH dipanggil karena token kosong
      verifyNever(() => mockStorageService.saveToken(any()));
    });
  });
}
