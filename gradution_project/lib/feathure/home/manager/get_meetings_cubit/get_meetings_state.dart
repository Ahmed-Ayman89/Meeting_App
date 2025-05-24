import 'package:gradution_project/feathure/home/data/models/meeting_response_model.dart';

abstract class GetMeetingsState {}

class GetMeetingsInitialState extends GetMeetingsState {}

class GetMeetingsLoadingState extends GetMeetingsState {}

class GetMeetingsSuccessState extends GetMeetingsState {
  final List<GetMeetingResponseModel> meetings;
  final List<GetMeetingResponseModel> filteredMeetings;
  GetMeetingsSuccessState(this.meetings, this.filteredMeetings);
}

class GetMeetingsErrorState extends GetMeetingsState {
  final String error;
  GetMeetingsErrorState(this.error);
}

class MeetingDeletedState extends GetMeetingsState {
  final String message;

  MeetingDeletedState(this.message);

  @override
  List<Object> get props => [message];
}
