import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final IconData iconData;
  final Color iconColor;

  // Private constructor (hanya bisa dipanggil dari dalam class ini)
  const AppDialog._({
    required this.title,
    required this.message,
    required this.confirmText,
    this.cancelText,
    this.onConfirm,
    required this.iconData,
    required this.iconColor,
  });

  /// Factory constructor untuk Dialog Error / Peringatan (1 Tombol)
  ///
  /// **Contoh Penggunaan:**
  ///
  /// 1. **Dialog Error :**
  /// ```dart
  /// showDialog(
  ///   context: context,
  ///   builder: (_) => AppDialog.error(message: state.message ?? 'error'),
  /// );
  /// ```
  ///
  ///
  ///
  /// credit: yona299@gmail.com
  ///
  /// for: Assesment Test
  ///
  factory AppDialog.error({
    String title = 'Terjadi Kesalahan',
    required String message,
    String confirmText = 'Mengerti',
  }) {
    return AppDialog._(
      title: title,
      message: message,
      confirmText: confirmText,
      iconData: Icons.error_outline_rounded,
      iconColor: AppColors.error,
    );
  }

  /// Factory constructor untuk Dialog Konfirmasi (2 Tombol)
  ///
  /// **Contoh Penggunaan:**
  ///
  /// 2. **Dialog Confirm :**
  /// ```dart
  /// showDialog(
  ///   context: context,
  ///   builder: (_) => AppDialog.confirm(
  ///      title: 'Konfirmasi Keluar',
  ///      message: 'Apakah Anda yakin ingin keluar?',
  ///      confirmText: 'Ya, Keluar',
  ///      onConfirm: () {
  ///         context.read<AuthCubit>().logout();
  ///      },
  ///    ),
  /// );
  /// ```
  ///
  ///
  ///
  /// credit: yona299@gmail.com
  ///
  /// for: Assesment Test
  ///
  factory AppDialog.confirm({
    required String title,
    required String message,
    String confirmText = 'Ya, Lanjutkan',
    String cancelText = 'Batal',
    required VoidCallback onConfirm,
  }) {
    return AppDialog._(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      iconData: Icons.help_outline_rounded,
      iconColor: AppColors.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- IKON ---
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 48),
            ),
            const SizedBox(height: AppDimensions.md),

            // --- JUDUL ---
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.sm),

            // --- PESAN ---
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.xl),

            // --- TOMBOL AKSI ---
            if (cancelText != null) ...[
              // Mode 2 Tombol (Confirm)
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: cancelText!,
                      type: ButtonType.outlined,
                      onPressed: () =>
                          Navigator.of(context).pop(), // Tutup dialog
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: AppButton(
                      text: confirmText,
                      customColor: AppColors.error,
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup dialog dulu
                        if (onConfirm != null) {
                          onConfirm!(); // Baru jalankan aksi
                        }
                      },
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Mode 1 Tombol (Error/Info)
              AppButton(
                text: confirmText,
                isFullWidth: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onConfirm != null) onConfirm!();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
