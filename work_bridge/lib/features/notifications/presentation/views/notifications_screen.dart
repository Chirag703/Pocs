import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationsCubit>()..loadNotifications(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(AppStrings.notifications,
            style: AppTextStyles.headlineSmall),
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoaded) {
                return TextButton(
                  onPressed: () =>
                      context.read<NotificationsCubit>().markAllRead(),
                  child: Text(AppStrings.markAllRead,
                      style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.black));
            }
            if (state is NotificationsLoaded) {
              return _buildList(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'shortlist':
        return const Color(0xFF2E7D32);
      case 'interview':
        return const Color(0xFF1565C0);
      case 'offer':
        return const Color(0xFFF57F17);
      default:
        return AppColors.darkGrey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'shortlist':
        return Icons.star_rounded;
      case 'interview':
        return Icons.video_call_rounded;
      case 'offer':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Widget _buildList(BuildContext context, NotificationsLoaded state) {
    return Column(
      children: [
        // Job alert banner
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_active_rounded,
                  color: AppColors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.setJobAlert,
                        style: AppTextStyles.titleMedium
                            .copyWith(color: AppColors.white)),
                    const SizedBox(height: 2),
                    Text('Get notified for matching jobs',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.mediumGrey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: AppColors.white, size: 14),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notif = state.notifications[index];
              return GestureDetector(
                onTap: () =>
                    context.read<NotificationsCubit>().markRead(notif.id),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: notif.isRead
                        ? AppColors.white
                        : AppColors.offWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _typeColor(notif.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(_typeIcon(notif.type),
                            color: _typeColor(notif.type), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(notif.title,
                                      style: AppTextStyles.titleMedium
                                          .copyWith(
                                        fontWeight: notif.isRead
                                            ? FontWeight.w400
                                            : FontWeight.w600,
                                      )),
                                ),
                                if (!notif.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(notif.body,
                                style: AppTextStyles.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(notif.time, style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
