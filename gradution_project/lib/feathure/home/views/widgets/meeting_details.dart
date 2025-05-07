import 'package:flutter/material.dart';
import 'package:gradution_project/feathure/home/data/models/meeting_response_model.dart';

class MeetingDetailsPage extends StatelessWidget {
  final GetMeetingResponseModel meetingModel;

  const MeetingDetailsPage({super.key, required this.meetingModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meetingModel.meetingname ?? 'Meeting Details',
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Concert One')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meeting Name: ${meetingModel.meetingname ?? "N/A"}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One')),
            const SizedBox(height: 25),
            Text('Date: ${meetingModel.date ?? "N/A"}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One')),
            const SizedBox(height: 25),
            Text('Time: ${meetingModel.time ?? "N/A"}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One')),
            const SizedBox(height: 25),
            Text('Phone Numbers: ${meetingModel.phoneNumbers ?? "N/A"}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One')),
            const SizedBox(height: 25),
            Text(' createdAt: ${meetingModel.createdAt ?? "N/A"}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One')),
            const SizedBox(height: 25),
            Text(' updatedAt: ${meetingModel.updatedAt ?? "N/A"}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One')),
            const SizedBox(height: 25),
            Text(' isPublic: ${meetingModel.isPublic ?? "N/A"}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One')),
            const SizedBox(height: 25),
            Text(' sId: ${meetingModel.sId ?? "N/A"}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One')),
            const SizedBox(height: 25),
            Text(' iV: ${meetingModel.iV ?? "N/A"}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One')),
          ],
        ),
      ),
    );
  }
}
