import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/notification_model.dart';
import '../data/repo/notification_repo.dart';
import '../manager/notification_cubit.dart';
import '../manager/notification_state.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final AppNotification notification;

  const NotificationDetailsScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(NotificationRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notification Details"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<NotificationCubit, NotificationState>(
            listener: (context, state) {
              if (state is NotificationActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else if (state is NotificationActionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailItem(
                              icon: Icons.title,
                              label: "Title",
                              value: notification.title ?? "N/A",
                            ),
                            const Divider(height: 24),
                            _buildDetailItem(
                              icon: Icons.message,
                              label: "Message",
                              value: notification.message ?? "N/A",
                            ),
                            const Divider(height: 24),
                            _buildDetailItem(
                              icon: Icons.category,
                              label: "Type",
                              value: notification.type ?? "N/A",
                            ),
                            const Divider(height: 24),
                            _buildDetailItem(
                              icon: Icons.meeting_room,
                              label: "Meeting ID",
                              value: notification.meetingId ?? "N/A",
                            ),
                            const Divider(height: 24),
                            _buildDetailItem(
                              icon: Icons.circle,
                              label: "Status",
                              value: notification.status ?? "N/A",
                              valueColor: _getStatusColor(notification.status),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state is NotificationActionLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => context
                                .read<NotificationCubit>()
                                .acceptNotification(notification.sId!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Accept",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => context
                                .read<NotificationCubit>()
                                .rejectNotification(notification.sId!),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            child: const Text(
                              "Reject",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
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
