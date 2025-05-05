import 'package:dio/dio.dart';

import '../model/meeting_model.dart';

class MeetingRepository {
  Future<void> sendMeetingToServer(MeetingModel meeting) async {
    final response = await Dio().post(
      'https://omar-server-weynakk-234.vercel.app/meetings',
      data: meeting.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send meeting');
    }
  }
}
