import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../data/models/book_model.dart';
import '../cubit/book_detail_cubit.dart';
import '../cubit/book_detail_state.dart';

class BookDetailPage extends StatelessWidget {
  final BookModel book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // Inject Cubit dan langsung jalankan fetchBookDetail berdasarkan ID buku
    return BlocProvider(
      create: (context) => sl<BookDetailCubit>()..fetchBookDetail(book.idBuku),
      child: BlocBuilder<BookDetailCubit, BookDetailState>(
        builder: (context, state) {
          // OPTIMISTIC UI:
          // Jika API sudah merespons, gunakan data terbaru (state.book).
          // Jika masih loading atau gagal, gunakan data bawaan dari halaman katalog (book).
          final currentBook = state is BookDetailLoaded ? state.book : book;

          final isDark = Theme.of(context).brightness == Brightness.dark;
          final bool isAvailable = currentBook.stokBuku > 0;

          return Scaffold(
            backgroundColor: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 300.0,
                      pinned: true,
                      backgroundColor: isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                      iconTheme: IconThemeData(
                        color: isDark ? Colors.white : AppColors.primaryDark,
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: currentBook.gambarBuku != null
                            ? Image.network(
                                currentBook.gambarBuku!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, obj, err) =>
                                    _buildPlaceholderCover(isDark),
                              )
                            : _buildPlaceholderCover(isDark),
                      ),
                    ),

                    // --- KONTEN DETAIL BUKU ---
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.lg),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.backgroundDark
                              : AppColors.backgroundLight,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppDimensions.radiusXl),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    currentBook.judulBuku,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(fontSize: 24, height: 1.3),
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.md),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
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
                                      fontSize: 12,
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
                            const SizedBox(height: AppDimensions.lg),

                            // Kotak Info Singkat (Rak, ISBN, Tahun)
                            Container(
                              padding: const EdgeInsets.all(AppDimensions.md),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceDark
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusLg,
                                ),
                                border: BoxBorder.all(
                                  color: isDark
                                      ? AppColors.dividerDark
                                      : AppColors.dividerLight.withValues(
                                          alpha: 0.3,
                                        ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildInfoColumn(
                                    context,
                                    'Tahun',
                                    currentBook.tahunTerbit,
                                    isDark,
                                  ),
                                  _buildDivider(isDark),
                                  _buildInfoColumn(
                                    context,
                                    'Rak',
                                    currentBook.rakBuku,
                                    isDark,
                                  ),
                                  _buildDivider(isDark),
                                  _buildInfoColumn(
                                    context,
                                    'Stok',
                                    '${currentBook.stokBuku}',
                                    isDark,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppDimensions.lg),

                            // Metadata Tambahan
                            Text(
                              'Informasi Tambahan',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            _buildMetaRow(
                              context,
                              'ISBN',
                              currentBook.isbn,
                              isDark,
                            ),
                            _buildMetaRow(
                              context,
                              'ID Kategori',
                              currentBook.idKategoriBuku,
                              isDark,
                            ),
                            _buildMetaRow(
                              context,
                              'ID Penulis',
                              currentBook.idPenulisBuku,
                              isDark,
                            ),
                            _buildMetaRow(
                              context,
                              'ID Penerbit',
                              currentBook.idPenerbitBuku,
                              isDark,
                            ),
                            const SizedBox(height: AppDimensions.lg),

                            // Deskripsi Buku
                            Text(
                              'Sinopsis / Deskripsi',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            Text(
                              currentBook.deskripsiBuku.isNotEmpty
                                  ? currentBook.deskripsiBuku
                                  : 'Belum ada deskripsi untuk buku ini.',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: isDark
                                        ? Colors.white70
                                        : AppColors.primaryDark.withValues(
                                            alpha: 0.8,
                                          ),
                                    height: 1.6,
                                  ),
                            ),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                if (state is BookDetailLoading)
                  const Positioned(
                    top: kToolbarHeight + 16,
                    right: 16,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget Helper untuk Kotak Info
  Widget _buildInfoColumn(
    BuildContext context,
    String title,
    String value,
    bool isDark,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.white54 : AppColors.secondary,
          ),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Widget Helper untuk Garis Pemisah Vertikal
  Widget _buildDivider(bool isDark) {
    return Container(
      height: 30,
      width: 1,
      color: isDark
          ? AppColors.dividerDark
          : AppColors.dividerLight.withValues(alpha: 0.5),
    );
  }

  // Widget Helper untuk Baris Metadata
  Widget _buildMetaRow(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white54 : AppColors.secondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Placeholder Sampul Buku
  Widget _buildPlaceholderCover(bool isDark) {
    return Container(
      color: isDark
          ? AppColors.surfaceVariantLight.withValues(alpha: 0.1)
          : AppColors.surfaceVariantLight,
      child: Center(
        child: Icon(
          Icons.auto_stories,
          size: 80,
          color: isDark
              ? Colors.white24
              : AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
