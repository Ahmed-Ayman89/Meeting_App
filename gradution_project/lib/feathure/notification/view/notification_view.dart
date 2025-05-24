import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';
import 'package:vibration/vibration.dart';

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
                final notifications = state.notifications;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: (value) {
                          context
                              .read<NotificationCubit>()
                              .searchNotifications(value);
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: context.textColor),
                          prefixIcon:
                              Icon(Icons.search, color: context.textColor),
                          hintText: 'Search notifications...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        style: TextStyle(
                            color: context.textColor,
                            fontSize: 16,
                            fontFamily: 'concert one'),
                      ),
                    ),
                    Expanded(
                      child: notifications.isEmpty
                          ? const Center(
                              child: Text("No notifications found.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'concert one',
                                  )))
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                final notification = notifications[index];
                                return Dismissible(
                                  key: Key(notification.sId!),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    color: Colors.red,
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  confirmDismiss: (direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(" confirm delete",
                                            style: TextStyle(
                                                fontFamily: 'concert one')),
                                        content: const Text(
                                          " Are you sure you want to delete this notification?",
                                          style: TextStyle(
                                              fontFamily: 'concert one'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text("delete",
                                                style: TextStyle(
                                                    fontFamily: 'concert one',
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  onDismissed: (direction) {
                                    context
                                        .read<NotificationCubit>()
                                        .deleteNotification(notification.sId!);

                                    Vibration.vibrate(duration: 100);
                                  },
                                  child: Card(
                                    elevation: 2,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(
                                                      notification.status),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                BlocProvider(
                                              create: (_) => NotificationCubit(
                                                  NotificationRepo())
                                                ..getNotifications(),
                                              child: NotificationDetailsScreen(
                                                notificationId:
                                                    notification.sId!,
                                              ),
                                            ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              } else if (state is NotificationError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text("No notifications found."));
              }
            },
          ),
        ));
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
