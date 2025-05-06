import 'package:flutter/material.dart';
import 'package:gradution_project/feathure/home/data/models/meeting_response_model.dart';

class MeetingBuilder extends StatelessWidget {
  const MeetingBuilder({super.key, required this.meetingModel});

  final GetMeetingResponseModel meetingModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        width: 350,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meeting name/number
              Text(
                meetingModel.meetingname ?? 'Meeting',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Meeting details row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top X text
                      if (meetingModel.phoneNumbers != null)
                        Text(
                          'Top ${meetingModel.time}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.lightBlue,
                          ),
                        ),

                      // X person approve text
                      if (meetingModel.date != null)
                        Text(
                          '${meetingModel.location} person approve',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),

                  // Time text
                  if (meetingModel.time != null)
                    Text(
                      meetingModel.time!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.lightBlue,
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
