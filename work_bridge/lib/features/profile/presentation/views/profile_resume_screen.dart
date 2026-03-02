import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileResumeScreen extends StatelessWidget {
  const ProfileResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileUpdating) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.black));
        }
        if (state is ProfileLoaded) {
          return _buildContent(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildContent(BuildContext context, ProfileLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload zone
          GestureDetector(
            onTap: () {
              // In production: use file_picker to pick PDF
              context.read<ProfileCubit>().uploadResume('/mock/resume.pdf');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.lightGrey,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(Icons.upload_file_rounded,
                        size: 32, color: AppColors.darkGrey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.resumeFileName != null
                        ? state.resumeFileName!
                        : AppStrings.uploadResume,
                    style: AppTextStyles.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.resumeFileName != null
                        ? 'Tap to replace'
                        : 'PDF, DOC or DOCX · Max 5 MB',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Resume visibility toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Row(
              children: [
                const Icon(Icons.visibility_outlined,
                    size: 22, color: AppColors.darkGrey),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.resumeVisibility,
                          style: AppTextStyles.titleMedium),
                      Text(
                        state.resumeVisible
                            ? 'Visible to recruiters'
                            : 'Hidden from recruiters',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: state.resumeVisible,
                  activeColor: AppColors.black,
                  onChanged: (val) {
                    context
                        .read<ProfileCubit>()
                        .toggleResumeVisibility(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Tips card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded,
                        size: 20, color: AppColors.darkGrey),
                    const SizedBox(width: 8),
                    Text('Resume Tips',
                        style: AppTextStyles.titleMedium),
                  ],
                ),
                const SizedBox(height: 12),
                ...const [
                  'Keep your resume to 1–2 pages.',
                  'Use action verbs (Built, Designed, Led...).',
                  'Include measurable achievements.',
                  'Tailor it to each job application.',
                ].map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('•  ',
                            style: TextStyle(
                                color: AppColors.textSecondary)),
                        Expanded(
                          child: Text(tip, style: AppTextStyles.bodySmall),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Sign out button
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.phoneEntry),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text(
              AppStrings.signOut,
              style: TextStyle(color: AppColors.black),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.black,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
