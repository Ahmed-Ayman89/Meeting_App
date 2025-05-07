import 'package:flutter/material.dart';
import 'package:gradution_project/core/utils/App_color.dart';
import 'package:gradution_project/feathure/home/data/models/meeting_response_model.dart';

import 'meeting_details.dart';

class MeetingBuilder extends StatelessWidget {
  const MeetingBuilder({super.key, required this.meetingModel});

  final GetMeetingResponseModel meetingModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MeetingDetailsPage(meetingModel: meetingModel),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: AppColor.lightblue,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان + Today
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meetingModel.meetingname ?? 'Meeting 1',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Concert One',
                    ),
                  ),
                  const SizedBox(width: 100),
                  Text(
                    meetingModel.date ?? 'Today',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Concert One',
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${meetingModel.phoneNumbers ?? "0"} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Concert One',
                    ),
                  ),
                  const SizedBox(width: 50),
                  Text(
                    meetingModel.time ?? '00:00:00',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Concert One',
                    ),
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
