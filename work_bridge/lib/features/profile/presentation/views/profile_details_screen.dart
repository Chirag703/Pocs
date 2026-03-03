import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
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
    final user = state.user;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _InfoSection(
            title: 'Personal Information',
            items: [
              _InfoItem(label: AppStrings.fullName, value: user.name),
              _InfoItem(label: AppStrings.emailAddress, value: user.email),
              _InfoItem(
                  label: AppStrings.dateOfBirth,
                  value: user.dateOfBirth ?? '—'),
              _InfoItem(
                  label: AppStrings.gender, value: user.gender ?? '—'),
              _InfoItem(
                  label: 'Phone',
                  value: '+91 ${user.phone}'),
            ],
          ),
          const SizedBox(height: 16),
          _InfoSection(
            title: 'Professional Details',
            items: [
              _InfoItem(
                  label: AppStrings.jobTitle,
                  value: user.jobTitle ?? '—'),
              _InfoItem(
                  label: AppStrings.currentCompany,
                  value: user.company ?? '—'),
              _InfoItem(
                  label: AppStrings.experience,
                  value: user.experienceYears != null
                      ? '${user.experienceYears} years'
                      : '—'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.skills,
                        style: AppTextStyles.titleLarge),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: user.skills
                      .map(
                        (skill) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: AppColors.lightGrey),
                          ),
                          child: Text(skill,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Education section
          _EmptySection(
            title: AppStrings.addEducation,
            icon: Icons.school_rounded,
            onAdd: () => context.push(AppRoutes.addEducation),
          ),
          const SizedBox(height: 16),
          // Employment section
          _EmptySection(
            title: AppStrings.addEmployment,
            icon: Icons.business_center_rounded,
            onAdd: () => context.push(AppRoutes.addEmployment),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;

  const _InfoSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.titleLarge),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(item.label,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textSecondary)),
                    ),
                    Expanded(
                      child: Text(item.value,
                          style: AppTextStyles.bodyMedium),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});
}

class _EmptySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onAdd;

  const _EmptySection({
    required this.title,
    required this.icon,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Icon(icon, color: AppColors.darkGrey, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title, style: AppTextStyles.titleMedium),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: AppColors.black, size: 22),
            onPressed: onAdd,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
