import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../cubit/borrowing_cubit.dart';
import '../cubit/borrowing_state.dart';

class BorrowingAddPage extends StatefulWidget {
  const BorrowingAddPage({super.key});

  @override
  State<BorrowingAddPage> createState() => _BorrowingAddPageState();
}

class _BorrowingAddPageState extends State<BorrowingAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _anggotaController = TextEditingController();
  final _jaminanController = TextEditingController();

  // Ephemeral State (Hanya untuk UI Lokal)
  DateTime _tglKembali = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _anggotaController.dispose();
    _jaminanController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tglKembali,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _tglKembali) {
      setState(() {
        _tglKembali = picked;
      });
    }
  }

  void _onSimpanTapped(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<BorrowingCubit>().submitNewBorrowing(
      _anggotaController.text,
      _jaminanController.text,
      _tglKembali,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<BorrowingCubit>(),
      // BLOC LISTENER: Hanya bertugas mendengarkan event sukses/gagal dari Cubit
      child: BlocListener<BorrowingCubit, BorrowingState>(
        listener: (context, state) {
          if (state is BorrowingSubmitError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is BorrowingSubmitSuccess) {
            context.pop(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Peminjaman Baru')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Peminjaman',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    'Masukkan informasi anggota dan jaminan untuk membuat nota peminjaman baru.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white70 : AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xl),

                  AppTextField(
                    title: 'ID Anggota',
                    hintText: 'Contoh: AGT-001',
                    controller: _anggotaController,
                    prefixIcon: const Icon(Icons.person_search_outlined),
                    validator: (value) => value == null || value.isEmpty
                        ? 'ID Anggota wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  AppTextField(
                    title: 'Jaminan (Identitas)',
                    hintText: 'Contoh: KTP, KTM, SIM',
                    controller: _jaminanController,
                    prefixIcon: const Icon(Icons.badge_outlined),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Jaminan wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  Text(
                    'Batas Waktu Kembali',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark
                            : AppColors.surfaceLight,
                        border: BoxBorder.all(
                          color: isDark
                              ? AppColors.dividerDark
                              : AppColors.dividerLight,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd MMMM yyyy').format(_tglKembali),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Icon(
                            Icons.calendar_month,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.lg),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
                border: BoxBorder.fromLTRB(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.dividerDark
                        : AppColors.dividerLight.withValues(alpha: 0.5),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Builder(
                builder: (context) {
                  // BLOC BUILDER: Hanya bereaksi pada tombol ini saja,
                  // mengontrol kapan animasi loading muncul.
                  return BlocBuilder<BorrowingCubit, BorrowingState>(
                    builder: (context, state) {
                      final isLoading = state is BorrowingSubmitLoading;
                      return AppButton(
                        text: 'Simpan',
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () => _onSimpanTapped(context),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
