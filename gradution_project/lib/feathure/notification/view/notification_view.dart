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
          NotificationCubit(NotificationRepo())..getNotifications(),
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 30, fontFamily: 'concert one'),
        )),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoadedWithCount) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return Dismissible(
                    key: Key(notification.message.toString()),
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          title: Text(
                            notification.title ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                notification.message ?? "",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _getStatusColor(notification.status),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      notification.status ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        BlocProvider(
                                  create: (_) =>
                                      NotificationCubit(NotificationRepo())
                                        ..getNotifications(),
                                  child: NotificationDetailsScreen(
                                    notificationId: notification.sId!,
                                  ),
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          }),
                    ),
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("No notifications found."));
            }
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'read':
        return Colors.green;
      case 'unread':
        return Colors.orange;
      case 'important':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
