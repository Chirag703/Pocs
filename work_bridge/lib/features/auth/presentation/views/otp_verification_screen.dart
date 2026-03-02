import 'dart:async';
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

class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: _OtpVerificationView(phoneNumber: phoneNumber),
    );
  }
}

class _OtpVerificationView extends StatefulWidget {
  final String phoneNumber;

  const _OtpVerificationView({required this.phoneNumber});

  @override
  State<_OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<_OtpVerificationView> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        t.cancel();
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpVerified) {
          context.go(AppRoutes.mainTab);
        } else if (state is NewUserDetected) {
          context.go(AppRoutes.accountNotFound, extra: state.phoneNumber);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  AppStrings.otpVerification,
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: '${AppStrings.enterOtp} '),
                      TextSpan(
                        text: '+91 ${widget.phoneNumber}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // OTP boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      height: 56,
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: AppTextStyles.headlineMedium,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: AppColors.lightGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          if (_otp.length == 6) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Timer / resend
                Center(
                  child: _secondsRemaining > 0
                      ? Text(
                          '${AppStrings.resendIn} 0:${_secondsRemaining.toString().padLeft(2, '0')}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            _startTimer();
                            context
                                .read<AuthCubit>()
                                .sendOtp(widget.phoneNumber);
                          },
                          child: Text(
                            AppStrings.resendOtp,
                            style: AppTextStyles.titleMedium.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                ),
                const Spacer(),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return ElevatedButton(
                      onPressed: isLoading || _otp.length < 6
                          ? null
                          : () {
                              context
                                  .read<AuthCubit>()
                                  .verifyOtp(widget.phoneNumber, _otp);
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
                          : const Text(AppStrings.verify),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
