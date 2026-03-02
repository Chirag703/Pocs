import 'package:equatable/equatable.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // 'alert', 'shortlist', 'interview', 'offer'
  final String time;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      time: time,
      isRead: isRead ?? this.isRead,
    );
  }
}

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> notifications;

  const NotificationsLoaded({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}
