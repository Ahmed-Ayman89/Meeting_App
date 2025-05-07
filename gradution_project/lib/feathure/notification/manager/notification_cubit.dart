import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/notification_repo.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo repo;

  NotificationCubit(this.repo) : super(NotificationInitial());

  void fetchNotifications() async {
    emit(NotificationLoading());
    final result = await repo.getNotifications();
    result.fold(
      (error) => emit(NotificationError(error)),
      (notifications) => emit(NotificationLoaded(notifications)),
    );
  }

  void acceptNotification(String id) async {
    emit(NotificationActionLoading());
    final result = await repo.acceptNotification(id);
    result.fold(
      (error) => emit(NotificationActionError(error)),
      (message) => emit(NotificationActionSuccess(message)),
    );
  }

  void rejectNotification(String id) async {
    emit(NotificationActionLoading());
    final result = await repo.rejectNotification(id);
    result.fold(
      (error) => emit(NotificationActionError(error)),
      (message) => emit(NotificationActionSuccess(message)),
    );
  }
}
