import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/network/api_exception.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  /// Memeriksa status login saat aplikasi pertama kali dibuka
  void checkAuthStatus() {
    if (authRepository.isLoggedIn()) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Proses login
  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      emit(AuthError('Username dan password tidak boleh kosong'));
      return;
    }

    emit(AuthLoading());
    try {
      await authRepository.login(username, password);
      emit(AuthAuthenticated());
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan yang tidak terduga.'));
    }
  }

  /// Proses logout
  Future<void> logout() async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> forceLogout() async {
    await authRepository.logout();
    emit(
      AuthUnauthenticated(
        message: 'Sesi Anda telah berakhir. Silakan login kembali.',
      ),
    );
  }
}
