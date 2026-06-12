import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/book_category_model.dart';
import '../cubit/book_category_cubit.dart';
import '../cubit/book_category_state.dart';

class BookCategoryEditPage extends StatefulWidget {
  final BookCategoryModel category;

  const BookCategoryEditPage({super.key, required this.category});

  @override
  State<BookCategoryEditPage> createState() => _BookCategoryEditPageState();
}

class _BookCategoryEditPageState extends State<BookCategoryEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    // Mengisi form dengan data kategori yang di-passing
    _namaController = TextEditingController(text: widget.category.jenisBuku);
    _deskripsiController = TextEditingController(
      text: widget.category.deskripsi,
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _onSimpanTapped(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<BookCategoryCubit>().updateCategory(
      widget.category.id,
      _namaController.text,
      _deskripsiController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<BookCategoryCubit>(),
      child: BlocListener<BookCategoryCubit, BookCategoryState>(
        listener: (context, state) {
          if (state is BookCategorySubmitError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is BookCategorySubmitSuccess) {
            context.pop(true); // Kirim 'true' agar List mereload datanya
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Edit Jenis Buku')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    title: 'Nama Jenis Buku',
                    controller: _namaController,
                    prefixIcon: const Icon(Icons.category_outlined),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama Jenis Buku wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Deskripsi',
                    controller: _deskripsiController,
                    maxLines: 4,
                  ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: BlocBuilder<BookCategoryCubit, BookCategoryState>(
                builder: (context, state) {
                  final isLoading = state is BookCategorySubmitLoading;
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
