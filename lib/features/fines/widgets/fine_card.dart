import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/fine_model.dart';

class FineCard extends StatelessWidget {
  final FineModel fine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FineCard({
    super.key,
    required this.fine,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    final tglPinjam = fine.tglPinjam.split('T').first;
    final tglKembali = fine.tglKembali.split('T').first;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
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
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN 1: TOTAL DENDA (Dibuat menonjol di atas) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.money_off_csred_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      'Total Denda',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  currencyFormat.format(fine.jumlahDenda),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            Divider(
              color: isDark
                  ? AppColors.dividerDark
                  : AppColors.dividerLight.withValues(alpha: 0.3),
              height: 1,
            ),
            const SizedBox(height: AppDimensions.md),

            // --- BAGIAN 2: INFO ID (Full Width agar aman dari teks panjang) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.receipt_long,
                  size: 18,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID Nota Peminjaman',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      // Teks panjang akan otomatis turun baris (wrap) berkat Expanded
                      Text(
                        fine.idPeminjaman,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, size: 18, color: AppColors.primary),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID Anggota',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        fine.idAnggota,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            Divider(
              color: isDark
                  ? AppColors.dividerDark
                  : AppColors.dividerLight.withValues(alpha: 0.3),
              height: 1,
            ),
            const SizedBox(height: AppDimensions.sm),

            // --- BAGIAN 3: PERIODE & TOMBOL AKSI ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pinjam: $tglPinjam',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kembali: $tglKembali',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: onEdit,
                      tooltip: 'Edit Denda',
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: onDelete,
                      tooltip: 'Hapus Denda',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
