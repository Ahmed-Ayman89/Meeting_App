import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';

import '../manager/notification_cubit.dart';
import '../manager/notification_state.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final String notificationId;

  const NotificationDetailsScreen({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' notification details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final notification = state.notifications.firstWhere(
              (n) => n.sId == notificationId,
            );

            final status = parseStatus(notification.status);
            final isPending = status == NotificationStatus.pending;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Notification Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with status badge
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title ?? ' no title',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildStatusBadge(status),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Message
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              notification.message ?? 'no message',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Details Section
                          _buildDetailCard(
                            icon: Icons.meeting_room,
                            title: 'meeting details',
                            items: [
                              _buildDetailRow(
                                Icons.numbers,
                                ' meeting id',
                                notification.meetingId ?? ' no id',
                              ),
                              _buildDetailRow(
                                Icons.person,
                                'user id',
                                notification.userId ?? ' no id',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons or Status Message
                  if (isPending) ...[
                    _buildActionButtons(context, notification.sId!)
                  ] else
                    _buildStatusMessage(status),
                ],
              ),
            );
          } else if (state is NotificationError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text(' no data available'));
          }
        },
      ),
    );
  }

  Widget _buildStatusBadge(NotificationStatus status) {
    final colors = {
      NotificationStatus.pending: Colors.orange,
      NotificationStatus.accepted: Colors.green,
      NotificationStatus.rejected: Colors.red,
    };

    final labels = {
      NotificationStatus.pending: ' pending',
      NotificationStatus.accepted: 'accepted',
      NotificationStatus.rejected: 'refused',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors[status]!.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors[status]!),
      ),
      child: Text(
        labels[status]!,
        style: TextStyle(
          color: colors[status],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String notificationId) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () =>
                context.read<NotificationCubit>().accept(notificationId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'accept',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () =>
                context.read<NotificationCubit>().reject(notificationId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.red),
              ),
            ),
            child: const Text(
              'refuse',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusMessage(NotificationStatus status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: status == NotificationStatus.accepted
            ? Colors.green[50]
            : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              status == NotificationStatus.accepted ? Colors.green : Colors.red,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            status == NotificationStatus.accepted
                ? Icons.check_circle
                : Icons.cancel,
            color: status == NotificationStatus.accepted
                ? Colors.green
                : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            status == NotificationStatus.accepted
                ? 'you have accepted this notification'
                : 'you have refused this notification',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: status == NotificationStatus.accepted
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

enum NotificationStatus { pending, accepted, rejected }

NotificationStatus parseStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'accepted':
      return NotificationStatus.accepted;
    case 'rejected':
      return NotificationStatus.rejected;
    default:
      return NotificationStatus.pending;
  }
}
