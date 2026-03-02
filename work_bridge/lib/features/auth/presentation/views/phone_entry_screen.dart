import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class PhoneEntryScreen extends StatelessWidget {
  const PhoneEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _PhoneEntryView(),
    );
  }
}

class _PhoneEntryView extends StatefulWidget {
  const _PhoneEntryView();

  @override
  State<_PhoneEntryView> createState() => _PhoneEntryViewState();
}

class _PhoneEntryViewState extends State<_PhoneEntryView> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
          context.push(AppRoutes.otpVerification, extra: state.phoneNumber);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  // Logo row
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'W',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppStrings.appName,
                        style: AppTextStyles.headlineMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Text(
                    AppStrings.enterPhone,
                    style: AppTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ll send an OTP to verify your number.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Phone field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppTextStyles.bodyLarge,
                    decoration: InputDecoration(
                      hintText: AppStrings.phoneHint,
                      counterText: '',
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              '+91',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 1,
                              height: 20,
                              color: AppColors.lightGrey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length != 10) {
                        return 'Please enter a valid 10-digit number';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<AuthCubit>()
                                      .sendOtp(_phoneController.text.trim());
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(AppStrings.sendOtp),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
