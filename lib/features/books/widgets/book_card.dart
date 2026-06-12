import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = book.stokBuku > 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 115,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: BoxBorder.all(
                      color: isDark
                          ? AppColors.dividerDark
                          : AppColors.dividerLight.withValues(alpha: 0.2),
                    ),
                  ),
                  child: book.gambarBuku != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                          child: Image.network(
                            book.gambarBuku!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.primaryDark,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.auto_stories,
                          color: isDark
                              ? AppColors.surfaceLight
                              : AppColors.primary,
                          size: 36,
                        ),
                ),
                const SizedBox(width: AppDimensions.md),

                // --- DETAIL BUKU ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul & Badge Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              book.judulBuku,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          // Badge Ketersediaan
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? Colors.green.withValues(
                                      alpha: isDark ? 0.2 : 0.1,
                                    )
                                  : AppColors.error.withValues(
                                      alpha: isDark ? 0.2 : 0.1,
                                    ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isAvailable ? 'Tersedia' : 'Habis',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isAvailable
                                    ? (isDark
                                          ? Colors.green[400]
                                          : Colors.green[700])
                                    : (isDark
                                          ? Colors.red[300]
                                          : AppColors.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sm),

                      // Info Letak Rak
                      Row(
                        children: [
                          Icon(
                            Icons.shelves,
                            size: 16,
                            color: isDark
                                ? Colors.white70
                                : AppColors.secondary,
                          ),
                          const SizedBox(width: AppDimensions.xs),
                          Text(
                            'Rak: ${book.rakBuku}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Divider(
                        color: isDark
                            ? AppColors.dividerDark
                            : AppColors.dividerLight.withValues(alpha: 0.3),
                        height: 16,
                      ),

                      // Info Stok & Tahun
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sisa Stok: ${book.stokBuku}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.primaryDark,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            book.tahunTerbit,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ],
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
