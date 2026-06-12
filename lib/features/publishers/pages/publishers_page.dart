import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_dialog.dart';
import '../cubit/publisher_cubit.dart';
import '../cubit/publisher_state.dart';

class PublishersPage extends StatelessWidget {
  const PublishersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<PublisherCubit>()..fetchPublishers(),
      child: BlocListener<PublisherCubit, PublisherState>(
        listener: (context, state) {
          if (state is PublisherDeleteError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is PublisherDeleteSuccess) {
            context.read<PublisherCubit>().fetchPublishers();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Data Penerbit')),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton.extended(
                onPressed: () async {
                  final result = await context.push('/admin/publishers/add');
                  if (result == true && context.mounted) {
                    context.read<PublisherCubit>().fetchPublishers();
                  }
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Tambah Penerbit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          body: BlocBuilder<PublisherCubit, PublisherState>(
            builder: (context, state) {
              if (state is PublisherLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is PublisherError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              } else if (state is PublisherLoaded) {
                final list = state.publishers;
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.domain_disabled_rounded,
                          size: 80,
                          color: isDark
                              ? Colors.white24
                              : AppColors.dividerLight,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          'Belum ada data penerbit',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () =>
                      context.read<PublisherCubit>().fetchPublishers(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.md,
                      AppDimensions.md,
                      AppDimensions.md,
                      AppDimensions.safeBottom,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final publisher = list[index];

                      // Menggabungkan kontak menjadi satu baris info jika tersedia
                      final List<String> kontak = [];
                      if (publisher.telpPenerbit.isNotEmpty) {
                        kontak.add(publisher.telpPenerbit);
                      }
                      if (publisher.emailPenerbit.isNotEmpty) {
                        kontak.add(publisher.emailPenerbit);
                      }
                      final infoKontak = kontak.isEmpty
                          ? 'Tidak ada info kontak'
                          : kontak.join(' • ');

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
                              Icons.business,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            publisher.penerbitBuku,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                infoKontak,
                                // maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.secondary),
                              ),
                              if (publisher.alamatPenerbit.isNotEmpty)
                                Text(
                                  publisher.alamatPenerbit,
                                  // maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.grey[600],
                                      ),
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
                                    '/admin/publishers/edit',
                                    extra: publisher,
                                  );
                                  if (result == true && context.mounted) {
                                    context
                                        .read<PublisherCubit>()
                                        .fetchPublishers();
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
                                      title: 'Hapus Penerbit',
                                      message:
                                          'Apakah Anda yakin ingin menghapus "${publisher.penerbitBuku}"?',
                                      confirmText: 'Hapus',
                                      onConfirm: () => context
                                          .read<PublisherCubit>()
                                          .deletePublisher(publisher.id),
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
