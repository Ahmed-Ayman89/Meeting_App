import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/notification_repo.dart';
import '../manager/notification_cubit.dart';
import '../manager/notification_state.dart';
import 'notification_details.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationCubit(NotificationRepo())..fetchNotifications(),
      child: Scaffold(
        appBar: AppBar(title: Text("Notifications")),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return ListTile(
                    title: Text(notification.title ?? ""),
                    subtitle: Text(notification.message ?? ""),
                    trailing: Text(notification.status ?? ""),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  NotificationDetailsScreen(
                            notification: notification,
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text("No notifications found."));
            }
          },
        ),
      ),
    );
  }
}
