import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import '../cubit/books_cubit.dart';
import '../cubit/books_state.dart';
import '../widgets/book_card.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<BooksCubit>()..fetchBooks(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SafeArea(
            // Membungkus dengan Builder agar kita punya akses ke context dari BlocProvider di bawahnya
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          final isLoggedIn = authState is AuthAuthenticated;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isLoggedIn
                                        ? 'Halo, Pustakawan!'
                                        : 'Halo, Pengunjung!',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(color: AppColors.secondary),
                                  ),
                                  Text(
                                    'Katalog Buku',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(fontSize: 28),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceLight,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        isLoggedIn
                                            ? Icons.logout_rounded
                                            : Icons.login_rounded,
                                        color: AppColors.primaryDark,
                                      ),
                                      onPressed: () {
                                        if (isLoggedIn) {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AppDialog.confirm(
                                              title: 'Konfirmasi Keluar',
                                              message:
                                                  'Apakah Anda yakin ingin keluar?',
                                              confirmText: 'Ya, Keluar',
                                              onConfirm: () {
                                                context
                                                    .read<AuthCubit>()
                                                    .logout();
                                              },
                                            ),
                                          );
                                        } else {
                                          context.push('/login');
                                        }
                                      },
                                      tooltip: isLoggedIn ? 'Keluar' : 'Login',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // --- SEARCH BAR ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md,
                      ),
                      child: AppTextField(
                        controller: _searchController,
                        hintText: 'Cari judul, ISBN, atau rak...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primary,
                        ),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _searchController,
                          builder: (context, value, child) {
                            if (value.text.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: AppColors.secondary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                context.read<BooksCubit>().searchBooks('');
                                FocusScope.of(context).unfocus();
                              },
                            );
                          },
                        ),
                        onChanged: (value) {
                          context.read<BooksCubit>().searchBooks(value);
                        },
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),

                    // --- LIST BUKU ---
                    Expanded(
                      child: BlocBuilder<BooksCubit, BooksState>(
                        builder: (context, state) {
                          if (state is BooksLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          } else if (state is BooksError) {
                            return _buildErrorState(context, state.message);
                          } else if (state is BooksLoaded) {
                            final books = state.books;
                            if (books.isEmpty) {
                              return _buildEmptyState(
                                context,
                                _searchController.text.isNotEmpty,
                              );
                            }
                            return RefreshIndicator(
                              color: AppColors.primary,
                              onRefresh: () async {
                                _searchController.clear();
                                await context.read<BooksCubit>().fetchBooks();
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.md,
                                ),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: books.length,
                                itemBuilder: (context, index) {
                                  return BookCard(
                                    book: books[index],
                                    onTap: () {
                                      context.push(
                                        '/book-detail',
                                        extra: books[index],
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppDimensions.lg),
            ElevatedButton.icon(
              onPressed: () => context.read<BooksCubit>().fetchBooks(),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menyesuaikan Empty State (Jika kosong karena pencarian vs kosong karena tidak ada data)
  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.inventory_2_outlined,
            size: 80,
            color: AppColors.dividerLight,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            isSearching
                ? 'Buku tidak ditemukan'
                : 'Belum ada buku di perpustakaan',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
