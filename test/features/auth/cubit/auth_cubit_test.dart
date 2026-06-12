//
// CARA MENJALANKAN TEST INI:
// Buka terminal dan ketik:
// flutter test test/features/auth/cubit/auth_cubit_test.dart
//
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:perpusku_app/core/network/api_exception.dart';
import 'package:perpusku_app/data/models/login_response_model.dart';
import 'package:perpusku_app/data/repositories/auth_repository.dart';
import 'package:perpusku_app/features/auth/cubit/auth_cubit.dart';
import 'package:perpusku_app/features/auth/cubit/auth_state.dart';

// 1. Buat Mock Repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthCubit authCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCubit = AuthCubit(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit - checkAuthStatus()', () {
    test('State awal harus AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });

    blocTest<AuthCubit, AuthState>(
      'Harus memancarkan [AuthAuthenticated] jika user sudah login (punya token)',
      build: () {
        // Mock repo: pura-puranya user sudah punya token di HP-nya
        when(() => mockAuthRepository.isLoggedIn()).thenReturn(true);
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'Harus memancarkan [AuthUnauthenticated] jika user belum login',
      build: () {
        when(() => mockAuthRepository.isLoggedIn()).thenReturn(false);
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [isA<AuthUnauthenticated>()],
    );
  });

  group('AuthCubit - login()', () {
    blocTest<AuthCubit, AuthState>(
      'Harus memancarkan [AuthError] jika username atau password kosong',
      build: () => authCubit,
      act: (cubit) => cubit.login('', ''),
      expect: () => [
        isA<AuthError>().having(
          (state) => state.message,
          'message',
          'Username dan password tidak boleh kosong',
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'Harus memancarkan [AuthLoading, AuthAuthenticated] jika login sukses',
      build: () {
        when(() => mockAuthRepository.login('admin', '123')).thenAnswer(
          (_) async =>
              LoginResponseModel(token: 'token', refreshToken: 'refresh'),
        );
        return authCubit;
      },
      act: (cubit) => cubit.login('admin', '123'),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'Harus memancarkan [AuthLoading, AuthError] jika API menolak login',
      build: () {
        when(
          () => mockAuthRepository.login('admin', 'salah'),
        ).thenThrow(ApiException(message: 'Password salah', statusCode: 401));
        return authCubit;
      },
      act: (cubit) => cubit.login('admin', 'salah'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (state) => state.message,
          'message',
          'Password salah',
        ),
      ],
    );
  });

  group('AuthCubit - Logout', () {
    blocTest<AuthCubit, AuthState>(
      'logout() manual harus memancarkan [AuthUnauthenticated] TANPA pesan error',
      build: () {
        when(() => mockAuthRepository.logout()).thenAnswer((_) async => {});
        return authCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<AuthUnauthenticated>().having(
          (state) => state.message,
          'message',
          isNull,
        ),
      ],
      verify: (_) => verify(() => mockAuthRepository.logout()).called(1),
    );

    blocTest<AuthCubit, AuthState>(
      'forceLogout() harus memancarkan [AuthUnauthenticated] DENGAN pesan peringatan sesi habis',
      build: () {
        when(() => mockAuthRepository.logout()).thenAnswer((_) async => {});
        return authCubit;
      },
      act: (cubit) => cubit.forceLogout(),
      expect: () => [
        isA<AuthUnauthenticated>().having(
          (state) => state.message,
          'message',
          'Sesi Anda telah berakhir. Silakan login kembali.',
        ),
      ],
      verify: (_) => verify(() => mockAuthRepository.logout()).called(1),
    );
  });
}
