import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../../domain/entities/job.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..loadJobs(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  static const List<String> _filters = [
    'All',
    'Full Time',
    'Part Time',
    'Remote',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.black));
            }
            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<HomeCubit>().loadJobs(),
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }
            if (state is HomeLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context, state)),
        SliverToBoxAdapter(child: _buildStats(context, state)),
        SliverToBoxAdapter(child: _buildFilterBar(context, state)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final job = state.jobs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _JobCard(
                    job: job,
                    onSave: () =>
                        context.read<HomeCubit>().toggleSave(job.id),
                    onApply: () =>
                        context.read<HomeCubit>().applyJob(job.id),
                    onTap: () =>
                        context.push(AppRoutes.jobDetail, extra: job),
                  ),
                );
              },
              childCount: state.jobs.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, HomeLoaded state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.goodMorning},',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text('Rahul! 👋', style: AppTextStyles.headlineMedium),
              ],
            ),
          ),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.lightGrey,
            child: const Icon(Icons.person, color: AppColors.darkGrey, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, HomeLoaded state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatChip(
              label: AppStrings.applications,
              value: '${state.applicationsCount}'),
          _divider(),
          _StatChip(
              label: AppStrings.profileViews, value: '${state.profileViews}'),
          _divider(),
          _StatChip(label: AppStrings.saved, value: '${state.savedCount}'),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 32,
        color: AppColors.darkGrey,
      );

  Widget _buildFilterBar(BuildContext context, HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            AppStrings.recommendedJobs,
            style: AppTextStyles.headlineSmall,
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final active = state.activeFilter == filter;
              return GestureDetector(
                onTap: () =>
                    context.read<HomeCubit>().loadJobs(filter: filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: active ? AppColors.black : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? AppColors.black : AppColors.lightGrey,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    filter,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: active ? AppColors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onSave;
  final VoidCallback onApply;
  final VoidCallback onTap;

  const _JobCard({
    required this.job,
    required this.onSave,
    required this.onApply,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              children: [
                // Company logo placeholder
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.business, size: 22,
                      color: AppColors.darkGrey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title, style: AppTextStyles.titleLarge),
                      const SizedBox(height: 2),
                      Text(job.company,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onSave,
                  icon: Icon(
                    job.isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: job.isSaved ? AppColors.black : AppColors.mediumGrey,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Tags
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _Tag(icon: Icons.location_on_outlined, label: job.location),
                _Tag(icon: Icons.work_outline_rounded, label: job.type),
                _Tag(icon: Icons.currency_rupee_rounded, label: job.salary),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(job.postedAt,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textHint)),
                const Spacer(),
                if (job.isApplied)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Applied',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.darkGrey),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: onApply,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppStrings.apply,
                        style: AppTextStyles.labelMedium
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Tag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.headlineSmall
                .copyWith(color: AppColors.white)),
        const SizedBox(height: 2),
        Text(label,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.mediumGrey)),
      ],
    );
  }
}
