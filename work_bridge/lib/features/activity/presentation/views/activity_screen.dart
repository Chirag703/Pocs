import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/activity_cubit.dart';
import '../cubit/activity_state.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActivityCubit>()..loadActivity(),
      child: const _ActivityView(),
    );
  }
}

class _ActivityView extends StatelessWidget {
  const _ActivityView();

  static const List<String> _statuses = [
    'applied',
    'shortlisted',
    'interview',
    'offered',
    'rejected',
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'shortlisted':
        return const Color(0xFF1565C0);
      case 'interview':
        return const Color(0xFFF57F17);
      case 'offered':
        return const Color(0xFF2E7D32);
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.darkGrey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'shortlisted':
        return 'Shortlisted';
      case 'interview':
        return 'Interview';
      case 'offered':
        return 'Offered';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Applied';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        title:
            Text(AppStrings.myActivity, style: AppTextStyles.headlineSmall),
      ),
      body: SafeArea(
        child: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            if (state is ActivityLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.black));
            }
            if (state is ActivityLoaded) {
              return _buildList(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, ActivityLoaded state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.appliedJobs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final job = state.appliedJobs[index];
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
              // Header
              Row(
                children: [
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
                        Text(job.jobTitle, style: AppTextStyles.titleLarge),
                        Text(
                          '${job.company} · ${job.location}',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(job.currentStatus).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel(job.currentStatus),
                      style: AppTextStyles.caption.copyWith(
                        color: _statusColor(job.currentStatus),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Timeline
              Row(
                children: _buildTimeline(job),
              ),
              const SizedBox(height: 8),
              Text(
                'Applied on ${job.appliedDate}',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildTimeline(AppliedJob job) {
    final steps = ['applied', 'shortlisted', 'interview', 'offered'];
    final isRejected = job.currentStatus == 'rejected';

    if (isRejected) {
      return [
        _TimelineDot(isActive: true, color: _statusColor('applied')),
        _TimelineConnector(isActive: true),
        _TimelineDot(isActive: true, color: _statusColor('rejected')),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('Rejected',
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
        ),
      ];
    }

    return steps.asMap().entries.expand<Widget>((entry) {
      final i = entry.key;
      final step = entry.value;
      final isActive = job.timeline.contains(step);
      final widgets = <Widget>[
        _TimelineDot(isActive: isActive, color: _statusColor(step)),
      ];
      if (i < steps.length - 1) {
        widgets.add(_TimelineConnector(
          isActive: job.timeline.contains(steps[i + 1]),
        ));
      }
      return widgets;
    }).toList();
  }
}

class _TimelineDot extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _TimelineDot({required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : AppColors.lightGrey,
        border: Border.all(
          color: isActive ? color : AppColors.lightGrey,
          width: 2,
        ),
      ),
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  final bool isActive;

  const _TimelineConnector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? AppColors.black : AppColors.lightGrey,
      ),
    );
  }
}
