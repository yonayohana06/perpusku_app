import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/borrowing_model.dart';
import '../cubit/borrowing_cubit.dart';

class BorrowingCard extends StatelessWidget {
  final BorrowingModel borrowing;

  const BorrowingCard({super.key, required this.borrowing});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dateKembali =
        DateTime.tryParse(borrowing.tglHrsKembali) ?? DateTime.now();
    final isOverdue = dateKembali.isBefore(DateTime.now());

    final formattedPinjam = borrowing.tglPinjam.isNotEmpty
        ? borrowing.tglPinjam.split('T').first
        : '-';
    final formattedKembali = borrowing.tglHrsKembali.isNotEmpty
        ? borrowing.tglHrsKembali.split('T').first
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: () async {
            final result = await context.push(
              '/admin/borrowing/detail/${borrowing.id}',
            );

            // JIKA BALASANNYA TRUE (ADA DATA DIHAPUS / DIEDIT), REFRESH LIST UTAMA!
            if (result == true && context.mounted) {
              context.read<BorrowingCubit>().fetchBorrowing();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${borrowing.id.length > 8 ? borrowing.id.substring(0, 8) : borrowing.id}...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? AppColors.error.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isOverdue ? 'Terlambat' : 'Berjalan',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isOverdue
                              ? AppColors.error
                              : Colors.orange[800],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppDimensions.xs),
                    Expanded(
                      child: Text(
                        'Anggota: ${borrowing.idAnggota}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                Divider(
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight.withValues(alpha: 0.3),
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tgl Pinjam',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          formattedPinjam,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Batas Kembali',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          formattedKembali,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isOverdue ? AppColors.error : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
