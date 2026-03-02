import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';

class ProfileCreatedScreen extends StatelessWidget {
  const ProfileCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.white,
                  size: 52,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.profileCreated,
                style: AppTextStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.profileCreatedDesc,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Profile card preview
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lightGrey),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Icon(Icons.person,
                              size: 28, color: AppColors.darkGrey),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your Profile',
                                  style: AppTextStyles.titleLarge),
                              const SizedBox(height: 4),
                              Text('Active · Ready to hire',
                                  style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _StatItem(label: 'Applications', value: '0'),
                        _StatItem(label: 'Profile Views', value: '0'),
                        _StatItem(label: 'Saved Jobs', value: '0'),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.mainTab),
                child: const Text(AppStrings.exploreJobs),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
