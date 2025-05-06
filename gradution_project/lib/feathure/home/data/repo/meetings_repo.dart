import 'package:dartz/dartz.dart';
import 'package:gradution_project/core/network/api_endpoint.dart';
import 'package:gradution_project/core/network/api_helper.dart';
import 'package:gradution_project/feathure/home/data/models/meeting_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeetingsRepo {
  Future<Either<String, List<GetMeetingResponseModel>>> getMeetings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return Left("يجب تسجيل الدخول أولاً");
      }
      // get request to the server sugin dio
      final response = await APIHelper().getData(
        url: EndPoints.getMeetings,
        data: {},
        token: token,
      );
      if (response.statusCode == 200) {
        List<GetMeetingResponseModel> meetings = (response.data as List)
            .map((meeting) => GetMeetingResponseModel.fromJson(meeting))
            .toList();
        return Right(meetings);
      } else {
        return Left("Error: ${response.statusCode}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
