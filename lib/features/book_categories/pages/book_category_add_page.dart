import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../cubit/book_category_cubit.dart';
import '../cubit/book_category_state.dart';

class BookCategoryAddPage extends StatefulWidget {
  const BookCategoryAddPage({super.key});

  @override
  State<BookCategoryAddPage> createState() => _BookCategoryAddPageState();
}

class _BookCategoryAddPageState extends State<BookCategoryAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _onSimpanTapped(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<BookCategoryCubit>().createCategory(
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
            context.pop(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Tambah Jenis Buku')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    title: 'Nama Jenis Buku',
                    hintText: 'Contoh: Fiksi Ilmiah, Sejarah...',
                    controller: _namaController,
                    prefixIcon: const Icon(Icons.category_outlined),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama Jenis Buku wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Deskripsi',
                    hintText:
                        'Masukkan penjelasan singkat mengenai jenis buku ini...',
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
                    text: 'Simpan Data',
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
