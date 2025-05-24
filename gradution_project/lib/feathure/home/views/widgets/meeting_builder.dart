import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';
import 'package:gradution_project/feathure/home/manager/get_meetings_cubit/get_meetings_cubit.dart';

import '../../../../core/utils/App_color.dart';
import '../../data/models/meeting_response_model.dart';
import 'meeting_details.dart';

class MeetingBuilder extends StatelessWidget {
  const MeetingBuilder({super.key, required this.meetingModel});

  final GetMeetingResponseModel meetingModel;

  Future<void> _confirmDelete(BuildContext context) async {
    final parentContext = context;

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(" confirm delete",
            style: TextStyle(fontFamily: 'Concert One')),
        content: const Text(
          " Are you sure you want to delete this meeting?",
          style: TextStyle(fontFamily: 'Concert One'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("cancel",
                style: TextStyle(fontFamily: 'Concert One')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(Duration.zero, () {
                BlocProvider.of<GetMeetingsCubit>(parentContext)
                    .deleteMeeting(meetingModel.sId!, parentContext);
              });
            },
            child: const Text(
              "delete",
              style: TextStyle(color: Colors.red, fontFamily: 'Concert One'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MeetingDetailsPage(meetingModel: meetingModel),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.white,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      meetingModel.meetingname ?? 'No Meeting Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Concert One',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _confirmDelete(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      meetingModel.date ?? 'Today',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Concert One',
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        meetingModel.time ?? '00:00',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Concert One',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
