//
// CARA MENJALANKAN TEST INI:
// Buka terminal dan ketik:
// flutter test test/core/network/auth_interceptor_test.dart
//
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:perpusku_app/core/constants/api_endpoints.dart';
import 'package:perpusku_app/core/network/auth_interceptor.dart';
import 'package:perpusku_app/core/services/storage_service.dart';
import 'package:perpusku_app/features/auth/cubit/auth_cubit.dart';

// 1. Buat Mocks
class MockStorageService extends Mock implements StorageService {}

class MockAuthCubit extends Mock implements AuthCubit {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

void main() {
  late MockStorageService mockStorageService;
  late MockAuthCubit mockAuthCubit;
  late AuthInterceptor authInterceptor;
  late MockRequestInterceptorHandler mockRequestHandler;
  late MockErrorInterceptorHandler mockErrorHandler;

  // Mendapatkan instance GetIt (Service Locator) global
  final sl = GetIt.instance;

  setUpAll(() {
    // Mendaftarkan fallback values agar mocktail bisa menggunakan fungsi any() pada handler Dio
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(
      DioException(requestOptions: RequestOptions(path: '')),
    );
  });

  setUp(() async {
    // Bersihkan GetIt setiap kali test baru dimulai agar tidak bentrok
    await sl.reset();

    mockStorageService = MockStorageService();
    mockAuthCubit = MockAuthCubit();
    mockRequestHandler = MockRequestInterceptorHandler();
    mockErrorHandler = MockErrorInterceptorHandler();

    // INJEKSI PENTING: AuthInterceptor kita menggunakan sl<AuthCubit>() di dalamnya.
    // Jadi kita harus mendaftarkan MockAuthCubit ke dalam GetIt selama testing!
    sl.registerSingleton<AuthCubit>(mockAuthCubit);

    authInterceptor = AuthInterceptor(mockStorageService);
  });

  group('AuthInterceptor - onRequest()', () {
    test('Harus menyisipkan token Bearer jika token tersedia di Storage', () {
      // Arrange
      final options = RequestOptions(path: '/buku');
      when(() => mockStorageService.getToken()).thenReturn('token_rahasia_123');

      // Act
      authInterceptor.onRequest(options, mockRequestHandler);

      // Assert
      expect(options.headers['Authorization'], 'Bearer token_rahasia_123');
      expect(options.headers['Content-Type'], 'application/json');
      verify(
        () => mockRequestHandler.next(options),
      ).called(1); // Pastikan request dilanjutkan
    });

    test('TIDAK Boleh menyisipkan token Bearer jika token kosong/null', () {
      // Arrange
      final options = RequestOptions(path: '/buku');
      when(() => mockStorageService.getToken()).thenReturn(null);

      // Act
      authInterceptor.onRequest(options, mockRequestHandler);

      // Assert
      expect(
        options.headers.containsKey('Authorization'),
        false,
      ); // Harusnya kunci Authorization tidak dibuat
      expect(options.headers['Content-Type'], 'application/json');
      verify(() => mockRequestHandler.next(options)).called(1);
    });
  });

  group('AuthInterceptor - onError()', () {
    test(
      'Harus memanggil forceLogout() pada AuthCubit jika mendapat Error 401 di Endpoint Non-Login',
      () {
        // Arrange
        final options = RequestOptions(path: '/buku'); // Path BUKAN login
        final exception = DioException(
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: 401),
        );

        // Mock agar tidak terjadi error saat fungsi forceLogout dipanggil
        when(() => mockAuthCubit.forceLogout()).thenAnswer((_) async {});

        // Act
        authInterceptor.onError(exception, mockErrorHandler);

        // Assert
        verify(
          () => mockAuthCubit.forceLogout(),
        ).called(1); // Terbukti! Aplikasi akan menendang pengguna
        verify(() => mockErrorHandler.next(exception)).called(
          1,
        ); // Error harus tetap diteruskan agar bisa ditangkap oleh blok catch di try-catch
      },
    );

    test(
      'TIDAK memanggil forceLogout() jika Error 401 terjadi di Endpoint Login (karena salah password)',
      () {
        // Arrange
        final options = RequestOptions(
          path: ApiEndpoints.login,
        ); // Path ADALAH login
        final exception = DioException(
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: 401),
        );

        // Act
        authInterceptor.onError(exception, mockErrorHandler);

        // Assert
        verifyNever(
          () => mockAuthCubit.forceLogout(),
        ); // Terbukti! Jika salah password saat login, aplikasi tidak force logout.
        verify(() => mockErrorHandler.next(exception)).called(1);
      },
    );

    test(
      'TIDAK memanggil forceLogout() jika Error BUKAN 401 (misal: 500 Internal Server Error)',
      () {
        // Arrange
        final options = RequestOptions(path: '/buku');
        final exception = DioException(
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: 500),
        );

        // Act
        authInterceptor.onError(exception, mockErrorHandler);

        // Assert
        verifyNever(() => mockAuthCubit.forceLogout());
        verify(() => mockErrorHandler.next(exception)).called(1);
      },
    );
  });
}
