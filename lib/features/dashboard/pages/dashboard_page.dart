import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../auth/cubit/auth_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            tooltip: 'Keluar',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AppDialog.confirm(
                  title: 'Konfirmasi Keluar',
                  message:
                      'Apakah Anda yakin ingin keluar dari sesi Admin Perpustakaan?',
                  confirmText: 'Ya, Keluar',
                  onConfirm: () => context.read<AuthCubit>().logout(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, Pustakawan! 👋',
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Berikut adalah ringkasan sistem perpustakaan hari ini.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark ? Colors.white70 : AppColors.secondary,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // --- GRID STATISTIK ---
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppDimensions.md,
              crossAxisSpacing: AppDimensions.md,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  context,
                  'Total Buku',
                  '124',
                  Icons.menu_book,
                  Colors.blue,
                ),
                _buildStatCard(
                  context,
                  'Sedang Dipinjam',
                  '18',
                  Icons.book_online,
                  Colors.orange,
                ),
                _buildStatCard(
                  context,
                  'Anggota Aktif',
                  '45',
                  Icons.people,
                  Colors.green,
                ),
                _buildStatCard(
                  context,
                  'Total Denda',
                  'Rp 0',
                  Icons.money_off,
                  AppColors.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: BoxBorder.all(
          color: isDark
              ? AppColors.dividerDark
              : AppColors.dividerLight.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
