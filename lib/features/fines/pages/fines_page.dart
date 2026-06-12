import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_dialog.dart';
import '../cubit/fine_cubit.dart';
import '../cubit/fine_state.dart';
import '../widgets/fine_card.dart';

class FinesPage extends StatelessWidget {
  const FinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<FineCubit>()..fetchFines(),
      child: BlocListener<FineCubit, FineState>(
        listener: (context, state) {
          if (state is FineDeleteError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is FineDeleteSuccess) {
            context.read<FineCubit>().fetchFines();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Kelola Denda')),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton.extended(
                heroTag: 'fines',
                onPressed: () async {
                  final result = await context.push('/admin/fines/add');
                  if (result == true && context.mounted) {
                    context.read<FineCubit>().fetchFines();
                  }
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Catat Denda',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          body: BlocBuilder<FineCubit, FineState>(
            builder: (context, state) {
              if (state is FineLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is FineError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              } else if (state is FineLoaded) {
                final list = state.fines;
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.money_off_csred_rounded,
                          size: 80,
                          color: isDark
                              ? Colors.white24
                              : AppColors.dividerLight,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          'Belum ada catatan denda',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => context.read<FineCubit>().fetchFines(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.md,
                      AppDimensions.md,
                      AppDimensions.md,
                      AppDimensions.safeBottom,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final fine = list[index];
                      return FineCard(
                        fine: fine,
                        onEdit: () async {
                          final result = await context.push(
                            '/admin/fines/edit',
                            extra: fine,
                          );
                          if (result == true && context.mounted) {
                            context.read<FineCubit>().fetchFines();
                          }
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (_) => AppDialog.confirm(
                              title: 'Hapus Denda',
                              message:
                                  'Apakah Anda yakin ingin menghapus denda untuk nota ${fine.idPeminjaman}?',
                              confirmText: 'Hapus',
                              onConfirm: () => context
                                  .read<FineCubit>()
                                  .deleteFine(fine.idDenda),
                            ),
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
      ),
    );
  }
}
