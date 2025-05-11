import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/feathure/notification/manager/notification_state.dart';

import '../data/model/notification_model.dart';
import '../data/repo/notification_repo.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo repo;
  List<AppNotification> _notifications = [];

  NotificationCubit(this.repo) : super(NotificationInitial());

  Future<void> getNotifications() async {
    emit(NotificationLoading());
    final result = await repo.getNotifications();
    result.fold(
      (error) => emit(NotificationError(error)),
      (list) {
        _notifications = list;
        emit(NotificationLoaded(list));
      },
    );
  }

  Future<void> accept(String id) async {
    final result = await repo.acceptNotification(id);
    result.fold(
      (error) => emit(NotificationError(error)),
      (message) {
        _updateNotificationStatus(id, "accepted");
        emit(NotificationActionSuccess(message));
        emit(NotificationLoaded(List.from(_notifications)));
      },
    );
  }

  Future<void> reject(String id) async {
    final result = await repo.rejectNotification(id);
    result.fold(
      (error) => emit(NotificationError(error)),
      (message) {
        _updateNotificationStatus(id, "rejected");
        emit(NotificationActionSuccess(message));
        emit(NotificationLoaded(List.from(_notifications)));
      },
    );
  }

  void _updateNotificationStatus(String id, String status) {
    final index = _notifications.indexWhere((n) => n.sId == id);
    if (index != -1) {
      final updated = _notifications[index];
      _notifications[index] = AppNotification(
        sId: updated.sId,
        userId: updated.userId,
        title: updated.title,
        message: updated.message,
        meetingId: updated.meetingId,
        type: updated.type,
        status: status,
        iV: updated.iV,
      );
    }
  }
}
