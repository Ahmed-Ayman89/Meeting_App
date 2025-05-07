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
        appBar: AppBar(title: Text("NotificationDetails")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<NotificationCubit, NotificationState>(
            listener: (context, state) {
              if (state is NotificationActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                Navigator.pop(context);
              } else if (state is NotificationActionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Address: ${notification.title}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'concert one')),
                  const SizedBox(height: 10),
                  Text("Message: ${notification.message}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'concert one')),
                  Text("Type: ${notification.type}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'concert one')),
                  const SizedBox(height: 10),
                  Text("meetingId: ${notification.meetingId}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'concert one')),
                  Text("staus: ${notification.status}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'concert one')),
                  const SizedBox(height: 20),
                  if (state is NotificationActionLoading)
                    Center(child: CircularProgressIndicator())
                  else
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => context
                              .read<NotificationCubit>()
                              .acceptNotification(notification.sId!),
                          child: Text("Accept"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<NotificationCubit>()
                              .rejectNotification(notification.sId!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text("Reject"),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
