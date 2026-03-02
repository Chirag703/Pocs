import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/job.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..loadJobs(),
      child: _JobDetailView(job: job),
    );
  }
}

class _JobDetailView extends StatelessWidget {
  final Job job;

  const _JobDetailView({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final currentJob = state is HomeLoaded
                  ? state.jobs.firstWhere(
                      (j) => j.id == job.id,
                      orElse: () => job,
                    )
                  : job;
              return IconButton(
                icon: Icon(
                  currentJob.isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: currentJob.isSaved
                      ? AppColors.black
                      : AppColors.mediumGrey,
                ),
                onPressed: () =>
                    context.read<HomeCubit>().toggleSave(job.id),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job header
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.business, size: 32,
                      color: AppColors.darkGrey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title, style: AppTextStyles.headlineSmall),
                      const SizedBox(height: 4),
                      Text(job.company,
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Info chips row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(Icons.location_on_outlined, job.location),
                _InfoChip(Icons.work_outline_rounded, job.type),
                _InfoChip(Icons.currency_rupee_rounded, job.salary),
                _InfoChip(Icons.people_outline_rounded, job.openings),
                _InfoChip(Icons.schedule_rounded, job.experience),
                _InfoChip(Icons.access_time_rounded, job.postedAt),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 20),
            // Description
            Text(
              AppStrings.jobDescription,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(job.description, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            // Required skills
            Text(
              AppStrings.requiredSkills,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.requiredSkills
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.lightGrey),
                      ),
                      child: Text(skill, style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      )),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final currentJob = state is HomeLoaded
              ? state.jobs.firstWhere(
                  (j) => j.id == job.id,
                  orElse: () => job,
                )
              : job;
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: currentJob.isApplied
                ? Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Applied ✓',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.darkGrey),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () =>
                        context.read<HomeCubit>().applyJob(job.id),
                    child: const Text(AppStrings.applyNow),
                  ),
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
