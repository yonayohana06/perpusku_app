import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_dialog.dart';
import '../cubit/borrowing_cubit.dart';
import '../cubit/borrowing_detail_cubit.dart';
import '../cubit/borrowing_detail_state.dart';
import '../cubit/borrowing_state.dart';

class BorrowingDetailPage extends StatelessWidget {
  final String borrowingId;

  const BorrowingDetailPage({super.key, required this.borrowingId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<BorrowingDetailCubit>()..fetchBorrowingDetail(borrowingId),
        ),
        BlocProvider(create: (context) => sl<BorrowingCubit>()),
      ],
      child: BlocListener<BorrowingCubit, BorrowingState>(
        listener: (context, state) {
          if (state is BorrowingDeleteLoading) {
            // Tampilkan loading overlay jika perlu, atau diam saja
          } else if (state is BorrowingDeleteError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is BorrowingDeleteSuccess) {
            context.pop(
              true,
            ); // Kembali ke halaman utama dengan status "refresh true"
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Detail Peminjaman'),
            actions: [
              BlocBuilder<BorrowingDetailCubit, BorrowingDetailState>(
                builder: (context, state) {
                  if (state is BorrowingDetailLoaded) {
                    return Row(
                      children: [
                        // TOMBOL EDIT
                        IconButton(
                          icon: const Icon(Icons.edit_note_rounded),
                          tooltip: 'Edit Nota',
                          onPressed: () async {
                            final result = await context.push(
                              '/admin/borrowing/edit',
                              extra: state.detail,
                            );
                            if (result == true && context.mounted) {
                              // Jika edit berhasil, muat ulang detail nota ini
                              context
                                  .read<BorrowingDetailCubit>()
                                  .fetchBorrowingDetail(borrowingId);
                            }
                          },
                        ),
                        // TOMBOL HAPUS
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.error,
                          ),
                          tooltip: 'Hapus Nota',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AppDialog.confirm(
                                title: 'Hapus Nota',
                                message:
                                    'Apakah Anda yakin ingin menghapus nota peminjaman ini? '
                                    'Tindakan ini tidak dapat dibatalkan.',
                                confirmText: 'Ya, Hapus',
                                onConfirm: () {
                                  context
                                      .read<BorrowingCubit>()
                                      .deleteBorrowing(borrowingId);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink(); // Sembunyikan jika data belum termuat
                },
              ),
            ],
          ),
          body: BlocBuilder<BorrowingDetailCubit, BorrowingDetailState>(
            builder: (context, state) {
              if (state is BorrowingDetailLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is BorrowingDetailError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(state.message, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              } else if (state is BorrowingDetailLoaded) {
                final detail = state.detail;
                final tglPinjam = detail.tglPinjam.split('T').first;
                final tglKembali = detail.tglHrsKembali.split('T').first;

                final dateKembali =
                    DateTime.tryParse(detail.tglHrsKembali) ?? DateTime.now();
                final isOverdue = dateKembali.isBefore(DateTime.now());

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- KARTU INFORMASI ANGGOTA & NOTA ---
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.md),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusLg,
                          ),
                          border: BoxBorder.all(
                            color: isDark
                                ? AppColors.dividerDark
                                : AppColors.dividerLight.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Nota: //${detail.id}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppColors.secondary),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isOverdue
                                        ? AppColors.error.withValues(alpha: 0.1)
                                        : Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isOverdue ? 'Terlambat' : 'Aktif',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isOverdue
                                          ? AppColors.error
                                          : (isDark
                                                ? Colors.green[400]
                                                : Colors.green[700]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.md),

                            _buildInfoRow(
                              context,
                              'Nama Anggota',
                              detail.anggota.nama,
                              Icons.person,
                              isDark,
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            _buildInfoRow(
                              context,
                              'ID Anggota',
                              detail.anggota.idAnggota,
                              Icons.badge,
                              isDark,
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            _buildInfoRow(
                              context,
                              'Jaminan',
                              detail.jaminan,
                              Icons.security,
                              isDark,
                            ),

                            const SizedBox(height: AppDimensions.md),
                            Divider(
                              color: isDark
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight,
                            ),
                            const SizedBox(height: AppDimensions.md),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDateColumn(
                                  context,
                                  'Tanggal Pinjam',
                                  tglPinjam,
                                  isDark,
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.primary,
                                ),
                                _buildDateColumn(
                                  context,
                                  'Batas Kembali',
                                  tglKembali,
                                  isDark,
                                  isError: isOverdue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.xl),

                      // --- DAFTAR BUKU YANG DIPINJAM ---
                      Text(
                        'Buku yang Dipinjam (${detail.details.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppDimensions.md),

                      if (detail.details.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppDimensions.lg),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceDark
                                : AppColors.surfaceLight.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusLg,
                            ),
                            border: BoxBorder.all(
                              color: isDark
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.menu_book,
                                size: 48,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(height: AppDimensions.sm),
                              Text(
                                'Belum ada buku di dalam nota ini.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.secondary),
                              ),
                            ],
                          ),
                        )
                      else
                        ...detail.details.map((bookDetail) {
                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: AppDimensions.sm,
                            ),
                            padding: const EdgeInsets.all(AppDimensions.md),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.backgroundDark
                                  : AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd,
                              ),
                              border: BoxBorder.all(
                                color: isDark
                                    ? AppColors.dividerDark
                                    : AppColors.dividerLight,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.book,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppDimensions.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ID Buku: ${bookDetail.idBuku}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Kondisi Awal: ${bookDetail.kondisi}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.secondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                      const SizedBox(height: 100),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white54 : AppColors.secondary,
        ),
        const SizedBox(width: AppDimensions.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.white54 : AppColors.secondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateColumn(
    BuildContext context,
    String label,
    String value,
    bool isDark, {
    bool isError = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.white54 : AppColors.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isError ? AppColors.error : null,
          ),
        ),
      ],
    );
  }
}
