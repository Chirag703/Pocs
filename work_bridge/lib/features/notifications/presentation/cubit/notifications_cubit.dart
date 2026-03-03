import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/dummy_data.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(const NotificationsLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const NotificationsLoaded(notifications: DummyData.notifications));
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
