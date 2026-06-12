import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_dialog.dart';
import '../cubit/author_cubit.dart';
import '../cubit/author_state.dart';

class AuthorsPage extends StatelessWidget {
  const AuthorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<AuthorCubit>()..fetchAuthors(),
      child: BlocListener<AuthorCubit, AuthorState>(
        listener: (context, state) {
          if (state is AuthorDeleteError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is AuthorDeleteSuccess) {
            context.read<AuthorCubit>().fetchAuthors();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Data Penulis')),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton.extended(
                onPressed: () async {
                  final result = await context.push('/admin/authors/add');
                  if (result == true && context.mounted) {
                    context.read<AuthorCubit>().fetchAuthors();
                  }
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Tambah Penulis',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          body: BlocBuilder<AuthorCubit, AuthorState>(
            builder: (context, state) {
              if (state is AuthorLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is AuthorError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              } else if (state is AuthorLoaded) {
                final list = state.authors;
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 80,
                          color: isDark
                              ? Colors.white24
                              : AppColors.dividerLight,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          'Belum ada data penulis',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => context.read<AuthorCubit>().fetchAuthors(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.md,
                      AppDimensions.md,
                      AppDimensions.md,
                      AppDimensions.safeBottom,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final author = list[index];
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
                              Icons.draw,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            author.penulisBuku,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                author.emailPenulis.isNotEmpty
                                    ? '${author.emailPenulis}\n${author.deskripsi}'
                                    : author.deskripsi,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.secondary),
                              ),
                              Text(
                                author.alamat,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.secondary),
                              ),
                            ],
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
                                    '/admin/authors/edit',
                                    extra: author,
                                  );
                                  if (result == true && context.mounted) {
                                    context.read<AuthorCubit>().fetchAuthors();
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
                                      title: 'Hapus Penulis',
                                      message:
                                          'Apakah Anda yakin ingin menghapus "${author.penulisBuku}"?',
                                      confirmText: 'Hapus',
                                      onConfirm: () => context
                                          .read<AuthorCubit>()
                                          .deleteAuthor(author.id),
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
}
