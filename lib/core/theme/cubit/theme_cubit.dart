import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final StorageService storageService;

  ThemeCubit(this.storageService) : super(_getInitialTheme(storageService));

  static ThemeMode _getInitialTheme(StorageService storageService) {
    final savedTheme = storageService.getThemeMode();
    if (savedTheme == 'dark') return ThemeMode.dark;
    if (savedTheme == 'light') return ThemeMode.light;

    // Jika belum ada preferensi tersimpan, ikuti tema perangkat (System)
    return ThemeMode.system;
  }

  // Fungsi agar bisa menerima mode spesifik (termasuk mengembalikan ke system)
  void changeTheme(ThemeMode mode) {
    storageService.saveThemeMode(mode.name); // 'system', 'light', atau 'dark'
    emit(mode);
  }
}
