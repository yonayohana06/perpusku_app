//
// CARA MENJALANKAN TEST INI:
// Buka terminal dan ketik:
// flutter test test/features/auth/cubit/login_cubit_test.dart
//
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:perpusku_app/core/network/api_exception.dart';
import 'package:perpusku_app/data/models/login_response_model.dart';
import 'package:perpusku_app/data/repositories/auth_repository.dart';
import 'package:perpusku_app/features/auth/cubit/login_cubit.dart';

// 1. BUAT KELAS MOCK (PALSU)
// Extends Mock dan implements kelas aslinya.
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  // Variabel yang akan digunakan di seluruh tes
  late MockAuthRepository mockAuthRepository;
  late LoginCubit loginCubit;

  // setUp() akan dijalankan SEBELUM setiap test() dimulai.
  // Ini memastikan setiap tes mendapat instance Cubit yang baru dan bersih (fresh).
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginCubit = LoginCubit(authRepository: mockAuthRepository);
  });

  // tearDown() dijalankan SETELAH test() selesai. Berguna untuk membersihkan memori.
  tearDown(() {
    loginCubit.close();
  });

  group('LoginCubit', () {
    // Tes 1: Pastikan state pertama kali adalah Initial
    test('State awal harus LoginInitial', () {
      expect(loginCubit.state, isA<LoginInitial>());
    });

    // Tes 2: Menguji fungsi login dengan input kosong (Tanpa blocTest karena tidak ada proses async API)
    blocTest<LoginCubit, LoginState>(
      'Harus memancarkan [LoginFailure] jika username atau password kosong',
      build: () => loginCubit,
      act: (cubit) => cubit.login('', ''), // Aksi yang dilakukan (Act)
      expect: () => [
        isA<LoginFailure>().having(
          (state) => state.message,
          'message',
          'Username dan password tidak boleh kosong',
        ),
      ],
    );

    // Tes 3: Skenario Login Berhasil (Happy Path)
    blocTest<LoginCubit, LoginState>(
      'Harus memancarkan [LoginLoading, LoginSuccess] ketika API merespons sukses',
      build: () {
        // MENGATUR RESPONS PALSU:
        // Jika fungsi login() dipanggil dengan 'admin' dan '123', maka kembalikan data sukses.
        when(() => mockAuthRepository.login('admin', '123')).thenAnswer(
          (_) async => LoginResponseModel(
            token: 'token_dummy',
            refreshToken: 'refresh_dummy',
          ),
        );
        return loginCubit;
      },
      act: (cubit) => cubit.login('admin', '123'),
      expect: () => [
        isA<LoginLoading>(), // Pertama, pasti loading dulu
        isA<LoginSuccess>(), // Kedua, berubah jadi sukses
      ],
      verify: (_) {
        // Memastikan fungsi login di repository dipanggil tepat 1 kali
        verify(() => mockAuthRepository.login('admin', '123')).called(1);
      },
    );

    // Tes 4: Skenario Login Gagal karena API (Sad Path)
    blocTest<LoginCubit, LoginState>(
      'Harus memancarkan [LoginLoading, LoginFailure] ketika API mengembalikan error',
      build: () {
        // MENGATUR RESPONS PALSU:
        // Jika fungsi login() dipanggil dengan password salah, lemparkan ApiException.
        when(() => mockAuthRepository.login('admin', 'salah')).thenThrow(
          ApiException(
            message: 'Username atau password salah',
            statusCode: 401,
          ),
        );
        return loginCubit;
      },
      act: (cubit) => cubit.login('admin', 'salah'),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (state) => state.message,
          'message',
          'Username atau password salah',
        ),
      ],
    );
  });
}
