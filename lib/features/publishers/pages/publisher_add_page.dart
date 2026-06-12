import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:perpusku_app/core/utils/form_validator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../cubit/publisher_cubit.dart';
import '../cubit/publisher_state.dart';

class PublisherAddPage extends StatefulWidget {
  const PublisherAddPage({super.key});

  @override
  State<PublisherAddPage> createState() => _PublisherAddPageState();
}

class _PublisherAddPageState extends State<PublisherAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _telpController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _telpController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _onSimpanTapped(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<PublisherCubit>().createPublisher(
      _namaController.text,
      _alamatController.text,
      _telpController.text,
      _emailController.text,
      _deskripsiController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<PublisherCubit>(),
      child: BlocListener<PublisherCubit, PublisherState>(
        listener: (context, state) {
          if (state is PublisherSubmitError) {
            showDialog(
              context: context,
              builder: (_) => AppDialog.error(message: state.message),
            );
          } else if (state is PublisherSubmitSuccess) {
            context.pop(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Tambah Penerbit')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    title: 'Nama Penerbit',
                    hintText: 'Contoh: Gramedia, Erlangga...',
                    controller: _namaController,
                    prefixIcon: const Icon(Icons.business),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => FormValidator.required(
                      value,
                      'Nama Penerbit wajib diisi',
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Nomor Telepon',
                    hintText: 'Contoh: 021-1234567',
                    controller: _telpController,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormValidator.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Email',
                    hintText: 'Contoh: info@penerbit.com',
                    controller: _emailController,
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormValidator.email,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Alamat Lengkap',
                    hintText: 'Masukkan alamat penerbit...',
                    controller: _alamatController,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Deskripsi',
                    hintText: 'Informasi tambahan mengenai penerbit...',
                    controller: _deskripsiController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 50), // Spasi aman bawah
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
              child: BlocBuilder<PublisherCubit, PublisherState>(
                builder: (context, state) {
                  final isLoading = state is PublisherSubmitLoading;
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
