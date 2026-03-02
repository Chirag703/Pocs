import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(const NotificationsLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(NotificationsLoaded(
      notifications: [
        AppNotification(
          id: 'n1',
          title: 'Application Viewed',
          body: 'TechCorp viewed your application for Flutter Developer.',
          type: 'alert',
          time: '2 hours ago',
        ),
        AppNotification(
          id: 'n2',
          title: 'Shortlisted! 🎉',
          body: 'You have been shortlisted for Product Designer at DesignHub.',
          type: 'shortlist',
          time: '1 day ago',
        ),
        AppNotification(
          id: 'n3',
          title: 'Interview Scheduled',
          body:
              'Your interview with CloudBase is scheduled for tomorrow at 11 AM.',
          type: 'interview',
          time: '2 days ago',
        ),
        AppNotification(
          id: 'n4',
          title: 'New Job Alert',
          body:
              '5 new Flutter Developer jobs match your profile in Bengaluru.',
          type: 'alert',
          time: '3 days ago',
          isRead: true,
        ),
        AppNotification(
          id: 'n5',
          title: 'Offer Letter Received',
          body: 'Congratulations! ScaleUp has sent you an offer letter.',
          type: 'offer',
          time: '5 days ago',
          isRead: true,
        ),
      ],
    ));
  }

  void markAllRead() {
    final current = state;
    if (current is NotificationsLoaded) {
      final updated =
          current.notifications.map((n) => n.copyWith(isRead: true)).toList();
      emit(NotificationsLoaded(notifications: updated));
    }
  }

  void markRead(String id) {
    final current = state;
    if (current is NotificationsLoaded) {
      final updated = current.notifications.map((n) {
        return n.id == id ? n.copyWith(isRead: true) : n;
      }).toList();
      emit(NotificationsLoaded(notifications: updated));
    }
  }
}
