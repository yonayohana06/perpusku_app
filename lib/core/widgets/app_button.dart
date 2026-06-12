import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Menentukan jenis tampilan tombol
enum ButtonType {
  /// Tombol utama dengan latar belakang solid (ElevatedButton)
  primary,

  /// Tombol sekunder dengan garis pinggir (OutlinedButton)
  outlined,

  /// Tombol berupa teks saja (TextButton)
  text,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? customColor;
  final Color? customTextColor;

  /// Widget `AppButton` yang dapat digunakan ulang (reusable) untuk berbagai kebutuhan aksi.
  ///
  /// **Contoh Penggunaan:**
  ///
  /// 1. **Tombol Utama (Primary) - Default:**
  /// ```dart
  /// AppButton(
  ///   text: 'MASUK',
  ///   onPressed: () => login(),
  /// )
  /// ```
  ///
  /// 2. **Tombol dengan State Loading:**
  /// ```dart
  /// AppButton(
  ///   text: 'MENYIMPAN...',
  ///   isLoading: true, // Akan menampilkan indikator loading melingkar
  ///   onPressed: () {},
  /// )
  /// ```
  ///
  /// 3. **Tombol Outlined dengan Ikon:**
  /// ```dart
  /// AppButton(
  ///   text: 'Kembali',
  ///   type: ButtonType.outlined,
  ///   icon: Icons.arrow_back,
  ///   onPressed: () => context.pop(),
  /// )
  /// ```
  ///
  /// 4. **Tombol Teks Saja (Text Button):**
  /// ```dart
  /// AppButton(
  ///   text: 'Lupa Password?',
  ///   type: ButtonType.text,
  ///   isFullWidth: false, // Sesuaikan lebar dengan panjang teks saja
  ///   onPressed: () {},
  /// )
  /// ```
  ///
  /// 5. **Tombol dengan Warna Kustom (Menimpa Tema):**
  /// ```dart
  /// AppButton(
  ///   text: 'Hapus Data',
  ///   customColor: AppColors.error,
  ///   onPressed: () {},
  /// )
  /// ```
  ///
  ///
  /// credit: yona299@gmail.com
  ///
  /// for: Assesment Test
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true, // Default penuh agar mudah dipakai di form
    this.icon,
    this.customColor,
    this.customTextColor,
  });

  @override
  Widget build(BuildContext context) {
    // Menentukan aksi saat ditekan. Jika sedang loading, nonaktifkan tombol.
    final action = isLoading ? null : onPressed;

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              // Jika primary, indikator warna putih. Jika tidak, ikuti warna teks/utama.
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.primary
                    ? Colors.white
                    : (customColor ?? AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppDimensions.sm),
        ],
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );

    // Bungkus dengan SizedBox jika ingin full width
    Widget finalButton;

    switch (type) {
      case ButtonType.primary:
        finalButton = ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor ?? AppColors.primary,
            foregroundColor: customTextColor ?? Colors.white,
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            // Efek disabled
            disabledBackgroundColor: AppColors.dividerLight,
            disabledForegroundColor: Colors.grey,
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.outlined:
        finalButton = OutlinedButton(
          onPressed: action,
          style: OutlinedButton.styleFrom(
            foregroundColor: customColor ?? AppColors.primary,
            side: BorderSide(
              color: action == null
                  ? AppColors.dividerLight
                  : (customColor ?? AppColors.primary),
            ),
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.text:
        finalButton = TextButton(
          onPressed: action,
          style: TextButton.styleFrom(
            foregroundColor: customColor ?? AppColors.primary,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.md,
              horizontal: AppDimensions.sm,
            ),
          ),
          child: buttonChild,
        );
        break;
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: finalButton)
        : finalButton;
  }
}
