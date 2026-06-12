import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_dialog.dart';
import '../cubit/book_category_cubit.dart';
import '../cubit/book_category_state.dart';

class BookCategoriesPage extends StatelessWidget {
  const BookCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<BookCategoryCubit>()..fetchCategories(),
      child: BlocListener<BookCategoryCubit, BookCategoryState>(
        listener: (context, state) {
          if (state is BookCategoryDeleteError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is BookCategoryDeleteSuccess) {
            // Jika sukses hapus, otomatis refresh daftar
            context.read<BookCategoryCubit>().fetchCategories();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Jenis Buku (Kategori)')),

          // --- FLOATING ACTION BUTTON ---
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton.extended(
                onPressed: () async {
                  final result = await context.push('/admin/categories/add');
                  if (result == true && context.mounted) {
                    context.read<BookCategoryCubit>().fetchCategories();
                  }
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Tambah Data',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),

          // --- BODY UTAMA ---
          body: BlocBuilder<BookCategoryCubit, BookCategoryState>(
            builder: (context, state) {
              if (state is BookCategoryLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is BookCategoryError) {
                return _buildErrorState(context, state.message);
              } else if (state is BookCategoryLoaded) {
                final list = state.categories;
                if (list.isEmpty) {
                  return _buildEmptyState(context, isDark);
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () =>
                      context.read<BookCategoryCubit>().fetchCategories(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.md,
                      AppDimensions.md,
                      AppDimensions.md,
                      AppDimensions.safeBottom,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final category = list[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppDimensions.sm),
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.md,
                            vertical: AppDimensions.xs,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.category_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            category.jenisBuku,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            category.deskripsi.isNotEmpty
                                ? category.deskripsi
                                : 'Tidak ada deskripsi',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.secondary),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: AppColors.primary,
                                ),
                                onPressed: () async {
                                  final result = await context.push(
                                    '/admin/categories/edit',
                                    extra: category,
                                  );
                                  if (result == true && context.mounted) {
                                    context
                                        .read<BookCategoryCubit>()
                                        .fetchCategories();
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.error,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AppDialog.confirm(
                                      title: 'Hapus Kategori',
                                      message:
                                          'Apakah Anda yakin ingin menghapus "${category.jenisBuku}"?',
                                      confirmText: 'Hapus',
                                      onConfirm: () => context
                                          .read<BookCategoryCubit>()
                                          .deleteCategory(category.id),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.error),
            const SizedBox(height: AppDimensions.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.lg),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<BookCategoryCubit>().fetchCategories(),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: isDark ? Colors.white24 : AppColors.dividerLight,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Belum ada jenis buku',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
