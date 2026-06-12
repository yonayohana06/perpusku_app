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
import '../../../data/models/borrowing_detail_model.dart';
import '../cubit/borrowing_cubit.dart';
import '../cubit/borrowing_state.dart';

class BorrowingEditPage extends StatefulWidget {
  final BorrowingDetailModel detail;

  const BorrowingEditPage({super.key, required this.detail});

  @override
  State<BorrowingEditPage> createState() => _BorrowingEditPageState();
}

class _BorrowingEditPageState extends State<BorrowingEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _anggotaController;
  late TextEditingController _jaminanController;
  late DateTime _tglKembali;

  @override
  void initState() {
    super.initState();
    // Isi form dengan data dari model saat halaman pertama kali dibuka
    _anggotaController = TextEditingController(
      text: widget.detail.anggota.idAnggota,
    );
    _jaminanController = TextEditingController(text: widget.detail.jaminan);
    _tglKembali =
        DateTime.tryParse(widget.detail.tglHrsKembali) ?? DateTime.now();
  }

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
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ), // Biarkan mundur jaga-jaga edit lama
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _tglKembali) {
      setState(() => _tglKembali = picked);
    }
  }

  void _onSimpanTapped(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<BorrowingCubit>().updateBorrowing(
      widget.detail.id,
      _anggotaController.text,
      _jaminanController.text,
      _tglKembali,
      widget.detail.tglPinjam,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<BorrowingCubit>(),
      child: BlocListener<BorrowingCubit, BorrowingState>(
        listener: (context, state) {
          if (state is BorrowingSubmitError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is BorrowingSubmitSuccess) {
            context.pop(
              true,
            ); // Kirim 'true' agar halaman detail tahu ada perubahan
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Edit Peminjaman')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    title: 'ID Anggota',
                    controller: _anggotaController,
                    prefixIcon: const Icon(Icons.person_search_outlined),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Jaminan (Identitas)',
                    controller: _jaminanController,
                    prefixIcon: const Icon(Icons.badge_outlined),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
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
                border: BoxBorder.all(
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: BlocBuilder<BorrowingCubit, BorrowingState>(
                builder: (context, state) {
                  final isLoading = state is BorrowingSubmitLoading;
                  return AppButton(
                    text: 'Simpan Perubahan',
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () => _onSimpanTapped(context),
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
