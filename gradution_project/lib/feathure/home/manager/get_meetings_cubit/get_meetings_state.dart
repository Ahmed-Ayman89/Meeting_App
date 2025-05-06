import 'package:gradution_project/feathure/home/data/models/meeting_response_model.dart';

abstract class GetMeetingsState {}

class GetMeetingsInitialState extends GetMeetingsState {}

class GetMeetingsLoadingState extends GetMeetingsState {}

class GetMeetingsSuccessState extends GetMeetingsState {
  final List<GetMeetingResponseModel> meetings;
  GetMeetingsSuccessState(this.meetings);
}

class GetMeetingsErrorState extends GetMeetingsState {
  final String error;
  GetMeetingsErrorState(this.error);
}
