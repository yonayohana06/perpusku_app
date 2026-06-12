import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/cubit/auth_state.dart';

class RouteGuard {
  /// Daftar rute yang bisa diakses oleh siapa saja tanpa perlu login
  static const List<String> publicRoutes = ['/', '/login'];

  /// Fungsi redirect utama yang dipanggil oleh GoRouter
  static String? redirect(
    BuildContext context,
    GoRouterState state,
    AuthState authState,
  ) {
    if (authState is AuthInitial) return null;

    final isUnauthenticated =
        authState is AuthUnauthenticated || authState is AuthError;
    final isAuthenticated = authState is AuthAuthenticated;

    final currentPath = state.uri.path;
    final isGoingToLogin = currentPath == '/login';
    final isPublicRoute =
        publicRoutes.contains(currentPath) ||
        currentPath.startsWith('/book-detail');
    if (kDebugMode) {
      print(('route saat ini= ') + currentPath);
      print(('state saat ini= ') + authState.toString());
    }

    // Skenario 1: User belum login, mencoba akses halaman khusus Admin (Protected Route)
    if (isUnauthenticated && !isPublicRoute) {
      return '/login'; // Lempar ke login
    }

    // Skenario 2: Admin sudah login, tapi mencoba kembali ke halaman Login
    if (isAuthenticated && (isGoingToLogin || currentPath == '/')) {
      return '/dashboard';
    }

    // Tidak butuh redirect (Aman)
    return null;
  }
}
