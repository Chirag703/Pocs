import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileOverviewScreen extends StatelessWidget {
  const ProfileOverviewScreen({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header card
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
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.lightGrey,
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : 'U',
                        style: AppTextStyles.headlineMedium,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: AppTextStyles.titleLarge),
                          const SizedBox(height: 2),
                          Text(
                            user.jobTitle ?? 'No title set',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.company ?? '',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Completion bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.profileCompletion,
                            style: AppTextStyles.bodySmall),
                        Text('${state.completionPercent}%',
                            style: AppTextStyles.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: state.completionPercent / 100,
                        backgroundColor: AppColors.lightGrey,
                        color: AppColors.black,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _OverviewStat(label: 'Applications', value: '4'),
                    _OverviewStat(label: 'Profile Views', value: '24'),
                    _OverviewStat(label: 'Saved', value: '7'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Settings menu
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Column(
              children: [
                _MenuItem(
                  icon: Icons.settings_outlined,
                  label: AppStrings.settings,
                  onTap: () {},
                ),
                const Divider(height: 1),
                _MenuItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () {},
                ),
                const Divider(height: 1),
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: AppStrings.signOut,
                  onTap: () => context.go(AppRoutes.phoneEntry),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? AppColors.error : AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label,
          style: AppTextStyles.bodyMedium.copyWith(color: color)),
      trailing: isDestructive
          ? null
          : const Icon(Icons.chevron_right_rounded,
              color: AppColors.mediumGrey),
      onTap: onTap,
      dense: true,
    );
  }
}
