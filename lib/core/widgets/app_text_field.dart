import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class AppTextField extends StatefulWidget {
  /// Teks judul yang berada di luar (di atas) text field
  final String? title;

  /// Teks label yang berada di dalam text field (floating label)
  final String? labelText;

  /// Teks bayangan saat text field kosong
  final String? hintText;

  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Jika true, otomatis mengaktifkan fitur sembunyikan teks dan tombol lihat password
  final bool isPassword;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?)? validator;
  final int maxLines;
  final void Function(String)? onChanged;

  /// Widget `AppTextField` yang dapat digunakan ulang (reusable) untuk berbagai kebutuhan input form.
  ///
  /// **Contoh Penggunaan:**
  ///
  /// 1. **Mode Floating Label (Standar Material):**
  /// ```dart
  /// AppTextField(
  ///   labelText: 'Username',
  ///   prefixIcon: const Icon(Icons.person_outline),
  /// )
  /// ```
  ///
  /// 2. **Mode Judul di Luar (External Title):**
  /// ```dart
  /// AppTextField(
  ///   title: 'Nama Lengkap',
  ///   hintText: 'Masukkan nama sesuai KTP',
  /// )
  /// ```
  ///
  /// 3. **Mode Password (Fitur lihat/sembunyikan otomatis):**
  /// ```dart
  /// AppTextField(
  ///   labelText: 'Password',
  ///   prefixIcon: const Icon(Icons.lock_outline),
  ///   isPassword: true,
  /// )
  /// ```
  ///
  /// 4. **Mode Multi-baris (Text Area / Alamat):**
  /// ```dart
  /// AppTextField(
  ///   title: 'Alamat',
  ///   hintText: 'Tuliskan alamat lengkap...',
  ///   maxLines: 3, // Otomatis menjadi tinggi
  /// )
  /// ```
  ///
  /// 5. **Mode dengan Validasi dan Tipe Keyboard:**
  /// ```dart
  /// AppTextField(
  ///   labelText: 'Email',
  ///   keyboardType: TextInputType.emailAddress,
  ///   validator: (value) {
  ///     if (value == null || !value.contains('@')) return 'Email tidak valid';
  ///     return null;
  ///   },
  /// )
  /// ```
  ///
  /// 6. **Mode Lengkap (Prefix & Suffix Kustom):**
  /// ```dart
  /// AppTextField(
  ///   title: 'Cari Buku',
  ///   hintText: 'Ketik judul buku...',
  ///   prefixIcon: const Icon(Icons.search),
  ///   suffixIcon: IconButton(
  ///     icon: const Icon(Icons.clear),
  ///     onPressed: () => _controller.clear(),
  ///   ),
  /// )
  /// ```
  ///
  ///
  /// credit: yona299@gmail.com
  ///
  /// for: Assesment Test
  ///

  const AppTextField({
    super.key,
    this.title,
    this.labelText,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    // Jika tipe password, default disembunyikan
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    // Widget input form utama
    final textField = TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      maxLines: widget.isPassword
          ? 1
          : widget.maxLines, // Password harus 1 baris
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        // Otomatis tambahkan ikon mata jika ini adalah field password
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : widget.suffixIcon,
      ),
    );

    // Jika properti title diisi, bungkus dengan Column agar title berada di atas
    if (widget.title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          textField,
        ],
      );
    }

    // Jika tidak ada title, kembalikan textfield biasa (biasanya untuk mode floating label)
    return textField;
  }
}
