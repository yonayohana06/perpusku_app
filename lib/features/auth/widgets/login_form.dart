import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/login_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return AppDialog.error(
                title: 'Login Gagal',
                message: state.message,
              );
            },
          );
        } else if (state is LoginSuccess) {
          // Setelah API sukses dan token tersimpan, beri tahu AuthCubit global
          context.read<AuthCubit>().checkAuthStatus();

          // Arahkan kembali ke Dashboard/Katalog sebagai Pustakawan
          context.go('/');
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Menggunakan AppTextField Reusable
            AppTextField(
              controller: _usernameController,
              labelText: 'Username',
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: AppDimensions.md),

            // AppTextField otomatis menangani fungsi lihat/sembunyikan password
            AppTextField(
              controller: _passwordController,
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              isPassword: true,
            ),
            const SizedBox(height: AppDimensions.xl),

            AppButton(
              text: 'MASUK ',
              isLoading: state is LoginLoading,
              icon: Icons.login_rounded,
              onPressed: () {
                FocusScope.of(context).unfocus();
                context.read<LoginCubit>().login(
                  _usernameController.text,
                  _passwordController.text,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
