import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';

class AccountNotFoundScreen extends StatelessWidget {
  final String phoneNumber;

  const AccountNotFoundScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go(AppRoutes.phoneEntry),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Illustration placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.person_search_rounded,
                  size: 56,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.accountNotFound,
                style: AppTextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.accountNotFoundDesc,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '+91 $phoneNumber',
                style: AppTextStyles.titleMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () =>
                    context.go(AppRoutes.registerStep1, extra: phoneNumber),
                child: const Text(AppStrings.createAccount),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.phoneEntry),
                child: const Text(
                  AppStrings.tryDifferentNumber,
                  style: TextStyle(color: AppColors.black),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
