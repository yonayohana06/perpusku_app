import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../cubit/borrowing_cubit.dart';
import '../cubit/borrowing_state.dart';
import '../widgets/borrowing_card.dart';

class BorrowingPage extends StatelessWidget {
  const BorrowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BorrowingCubit>()..fetchBorrowing(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Kelola Peminjaman')),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              heroTag: 'borrow',
              onPressed: () async {
                final result = await context.push('/admin/borrowing/add');

                if (result == true && context.mounted) {
                  context.read<BorrowingCubit>().fetchBorrowing();
                }
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            );
          },
        ),
        body: BlocBuilder<BorrowingCubit, BorrowingState>(
          builder: (context, state) {
            if (state is BorrowingLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is BorrowingError) {
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
                      const SizedBox(height: AppDimensions.lg),
                      ElevatedButton.icon(
                        onPressed: () =>
                            context.read<BorrowingCubit>().fetchBorrowing(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is BorrowingLoaded) {
              final list = state.borrowingList;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada data peminjaman aktif.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.secondary),
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () =>
                    context.read<BorrowingCubit>().fetchBorrowing(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.md,
                    AppDimensions.md,
                    AppDimensions.md,
                    AppDimensions.safeBottom,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return BorrowingCard(borrowing: list[index]);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
