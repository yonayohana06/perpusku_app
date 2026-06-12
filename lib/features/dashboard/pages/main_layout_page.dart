import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class MainLayoutPage extends StatelessWidget {
  /// Widget bawaan GoRouter untuk mengatur state tiap tab
  final StatefulNavigationShell navigationShell;

  const MainLayoutPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Body diisi dengan navigationShell yang otomatis berganti sesuai tab
      body: navigationShell,

      // Bottom Navigation Bar ala Material 3
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        elevation: 10,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        onDestinationSelected: (index) {
          // goBranch akan berpindah tab tanpa menghapus state (scroll position aman!)
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_online_outlined),
            selectedIcon: Icon(Icons.book_online, color: AppColors.primary),
            label: 'Peminjaman',
          ),
          NavigationDestination(
            icon: Icon(Icons.money_off_outlined),
            selectedIcon: Icon(Icons.money_off, color: AppColors.primary),
            label: 'Denda',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage, color: AppColors.primary),
            label: 'Master Data',
          ),
        ],
      ),
    );
  }
}
