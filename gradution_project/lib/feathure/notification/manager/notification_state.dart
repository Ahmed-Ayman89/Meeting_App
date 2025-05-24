import 'package:flutter/material.dart';

import '../data/model/notification_model.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationActionInProgress extends NotificationState {}

class NotificationActionSuccess extends NotificationState {
  final String message;
  final int accepted;
  final int rejected;

  NotificationActionSuccess(this.message, this.accepted, this.rejected);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationLoadedWithCount extends NotificationState {
  final List<AppNotification> notifications;
  final int? unreadCount;

  NotificationLoadedWithCount(this.notifications, [this.unreadCount]);
}

class NotificationDeletedSuccessfully extends NotificationState {
  @override
  List<Object> get props => [];
}
