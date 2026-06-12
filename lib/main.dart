import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_colors.dart';
import 'core/di/service_locator.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_state.dart';

void main() async {
  // Pastikan binding widget Flutter sudah siap sebelum memanggil async function (seperti inisialisasi GetIt)
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi dependensi (GetIt, SharedPrefs, Dio, Interceptors, Repositories, dll)
  await initLocator();

  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider di-root untuk menyediakan instance Cubit yang bersifat global (Theme dan Auth)
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()),

        // Langsung panggil checkAuthStatus saat Cubit dibuat untuk mengecek token lokal
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkAuthStatus(),
        ),
      ],
      // BlocBuilder mendengarkan ThemeCubit agar UI langsung berubah saat tema diganti
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              // Jika token expired (401) atau user klik tombol Logout,
              // AuthCubit akan memberikan AuthUnauthenticated.
              // listener ini akan menangkapnya dan langsung menarik paksa ke halaman Login!
              if (state is AuthUnauthenticated) {
                if (state.message != null && state.message!.isNotEmpty) {
                  AppRouter.router.go('/login');
                  rootScaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                      content: Text(
                        state.message!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                } else {
                  AppRouter.router.go('/');
                }
              }
            },
            child: MaterialApp.router(
              title: 'Perpusku App',
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              debugShowCheckedModeBanner: false,

              // Konfigurasi Tema Terang & Gelap
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,

              // Menyambungkan navigasi aplikasi dengan GoRouter
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}
