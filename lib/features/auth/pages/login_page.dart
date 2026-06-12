import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../cubit/login_cubit.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,

        child: Scaffold(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Konten Utama
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimensions.lg),

                        // --- IKON & SAPAAN ---
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.lg),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.local_library_rounded,
                              size: 64,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xl),

                        Text(
                          'Selamat Datang,\nPustakawan.',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontSize: 32,
                                height: 1.2,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.primaryDark,
                              ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          'Silakan masuk untuk mengelola katalog dan data peminjaman perpustakaan.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.secondary,
                              ),
                        ),
                        const SizedBox(height: AppDimensions.xl),

                        const LoginForm(),

                        const SizedBox(height: AppDimensions.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
