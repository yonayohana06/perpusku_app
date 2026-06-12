import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/publisher_model.dart';
import '../cubit/publisher_cubit.dart';
import '../cubit/publisher_state.dart';

class PublisherEditPage extends StatefulWidget {
  final PublisherModel publisher;

  const PublisherEditPage({super.key, required this.publisher});

  @override
  State<PublisherEditPage> createState() => _PublisherEditPageState();
}

class _PublisherEditPageState extends State<PublisherEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _telpController;
  late TextEditingController _emailController;
  late TextEditingController _alamatController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.publisher.penerbitBuku,
    );
    _telpController = TextEditingController(
      text: widget.publisher.telpPenerbit,
    );
    _emailController = TextEditingController(
      text: widget.publisher.emailPenerbit,
    );
    _alamatController = TextEditingController(
      text: widget.publisher.alamatPenerbit,
    );
    _deskripsiController = TextEditingController(
      text: widget.publisher.deskripsi,
    );
  }

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
    context.read<PublisherCubit>().updatePublisher(
      widget.publisher.id,
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
          appBar: AppBar(title: const Text('Edit Penerbit')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    title: 'Nama Penerbit',
                    controller: _namaController,
                    prefixIcon: const Icon(Icons.business),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama Penerbit wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Nomor Telepon',
                    controller: _telpController,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Email',
                    controller: _emailController,
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Alamat Lengkap',
                    controller: _alamatController,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  AppTextField(
                    title: 'Deskripsi',
                    controller: _deskripsiController,
                    maxLines: 3,
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
