import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../cubit/author_cubit.dart';
import '../cubit/author_state.dart';

class AuthorAddPage extends StatefulWidget {
  const AuthorAddPage({super.key});

  @override
  State<AuthorAddPage> createState() => _AuthorAddPageState();
}

class _AuthorAddPageState extends State<AuthorAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _emailController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _emailController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _onSimpanTapped(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthorCubit>().createAuthor(
      _namaController.text,
      _alamatController.text,
      _emailController.text,
      _deskripsiController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<AuthorCubit>(),
      child: BlocListener<AuthorCubit, AuthorState>(
        listener: (context, state) {
          if (state is AuthorSubmitError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is AuthorSubmitSuccess) {
            context.pop(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Tambah Penulis')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    title: 'Nama Penulis',
                    hintText: 'Contoh: Tere Liye, Andrea Hirata...',
                    controller: _namaController,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama Penulis wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Email Penulis',
                    hintText: 'Contoh: penulis@email.com',
                    controller: _emailController,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Alamat',
                    hintText: 'Masukkan alamat penulis...',
                    controller: _alamatController,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Deskripsi / Biografi',
                    hintText: 'Masukkan biografi singkat penulis...',
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
              child: BlocBuilder<AuthorCubit, AuthorState>(
                builder: (context, state) {
                  final isLoading = state is AuthorSubmitLoading;
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
