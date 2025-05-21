import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/feathure/notification/manager/notification_state.dart';
import 'package:vibration/vibration.dart';
import '../data/model/notification_model.dart';

import '../data/repo/notification_repo.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo repo;
  List<AppNotification> _notifications = [];
  int _previousCount = 0;

  NotificationCubit(this.repo) : super(NotificationInitial());

  Future<void> getNotifications() async {
    emit(NotificationLoading());
    final result = await repo.getNotifications();
    result.fold(
      (error) => emit(NotificationError(error)),
      (list) {
        _notifications = list;
        final newCount = list.where((n) => n.status == "pending").length;
        void vibrateOrAnimateBell() async {
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 300);
          }
        }

        if (newCount > _previousCount) {
          vibrateOrAnimateBell();
        }
        _previousCount = newCount;
        emit(NotificationLoadedWithCount(list, newCount));
      },
    );
  }

  void markAllAsRead() {
    _previousCount = 0;
    emit(NotificationLoadedWithCount(_notifications, 0));
  }

  Future<void> accept(String id) async {
    final result = await repo.acceptNotification(id);
    result.fold(
      (error) => emit(NotificationError(error)),
      (response) {
        _updateNotificationStatus(id, "accepted");

        emit(NotificationActionSuccess(
          response.message,
          response.accepted,
          response.rejected,
        ));
        emit(NotificationLoadedWithCount(List.from(_notifications)));
      },
    );
  }

  Future<void> reject(String id) async {
    final result = await repo.rejectNotification(id);
    result.fold(
      (error) => emit(NotificationError(error)),
      (response) {
        _updateNotificationStatus(id, "rejected");

        emit(NotificationActionSuccess(
          response.message,
          response.accepted,
          response.rejected,
        ));
        emit(NotificationLoadedWithCount(List.from(_notifications)));
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
