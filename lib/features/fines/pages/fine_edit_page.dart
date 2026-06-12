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
import '../../../data/models/fine_model.dart';
import '../cubit/fine_cubit.dart';
import '../cubit/fine_state.dart';

class FineEditPage extends StatefulWidget {
  final FineModel fine;

  const FineEditPage({super.key, required this.fine});

  @override
  State<FineEditPage> createState() => _FineEditPageState();
}

class _FineEditPageState extends State<FineEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _peminjamanController;
  late TextEditingController _anggotaController;
  late TextEditingController _jumlahController;

  late DateTime _tglPinjam;
  late DateTime _tglHrsKembali;
  late DateTime _tglKembali;

  @override
  void initState() {
    super.initState();
    _peminjamanController = TextEditingController(
      text: widget.fine.idPeminjaman,
    );
    _anggotaController = TextEditingController(text: widget.fine.idAnggota);
    _jumlahController = TextEditingController(
      text: widget.fine.jumlahDenda.toString(),
    );

    _tglPinjam = DateTime.tryParse(widget.fine.tglPinjam) ?? DateTime.now();
    _tglHrsKembali =
        DateTime.tryParse(widget.fine.tglHrsKembali) ?? DateTime.now();
    _tglKembali = DateTime.tryParse(widget.fine.tglKembali) ?? DateTime.now();
  }

  @override
  void dispose() {
    _peminjamanController.dispose();
    _anggotaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime initialDate,
    Function(DateTime) onSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  void _onSimpanTapped(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final jumlah =
        int.tryParse(
          _jumlahController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;

    context.read<FineCubit>().updateFine(
      widget.fine.idDenda,
      jumlah,
      _tglPinjam.toUtc().toIso8601String(),
      _tglHrsKembali.toUtc().toIso8601String(),
      _tglKembali.toUtc().toIso8601String(),
      _peminjamanController.text,
      _anggotaController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<FineCubit>(),
      child: BlocListener<FineCubit, FineState>(
        listener: (context, state) {
          if (state is FineSubmitError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is FineSubmitSuccess) {
            context.pop(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Edit Catatan Denda')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    title: 'ID Peminjaman (Nota)',
                    controller: _peminjamanController,
                    prefixIcon: const Icon(Icons.receipt_long),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'ID Anggota',
                    controller: _anggotaController,
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Jumlah Denda (Rp)',
                    controller: _jumlahController,
                    prefixIcon: const Icon(Icons.attach_money),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: AppDimensions.xl),

                  // --- DATE PICKERS ---
                  Text(
                    'Periode Peminjaman',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  _buildDatePickerRow(
                    context,
                    'Tgl Pinjam',
                    _tglPinjam,
                    (date) => setState(() => _tglPinjam = date),
                    isDark,
                  ),
                  _buildDatePickerRow(
                    context,
                    'Batas Kembali',
                    _tglHrsKembali,
                    (date) => setState(() => _tglHrsKembali = date),
                    isDark,
                  ),
                  _buildDatePickerRow(
                    context,
                    'Tgl Dikembalikan',
                    _tglKembali,
                    (date) => setState(() => _tglKembali = date),
                    isDark,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
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
            ),
            child: SafeArea(
              child: BlocBuilder<FineCubit, FineState>(
                builder: (context, state) {
                  final isLoading = state is FineSubmitLoading;
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

  Widget _buildDatePickerRow(
    BuildContext context,
    String label,
    DateTime date,
    Function(DateTime) onSelected,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: InkWell(
        onTap: () => _selectDate(context, date, onSelected),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            border: BoxBorder.all(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Text(DateFormat('dd MMM yyyy').format(date)),
                  const SizedBox(width: AppDimensions.sm),
                  const Icon(
                    Icons.calendar_month,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
