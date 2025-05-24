import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/feathure/home/manager/get_meetings_cubit/get_meetings_state.dart';

import '../../data/models/meeting_response_model.dart';
import '../../data/repo/meetings_repo.dart';

class GetMeetingsCubit extends Cubit<GetMeetingsState> {
  GetMeetingsCubit() : super(GetMeetingsInitialState());
  static GetMeetingsCubit get(context) => BlocProvider.of(context);

  final MeetingsRepo repo = MeetingsRepo();
  List<GetMeetingResponseModel> _allMeetings = [];

  void getMeetings() async {
    emit(GetMeetingsLoadingState());
    final result = await repo.getMeetings();
    result.fold(
      (error) => emit(GetMeetingsErrorState(error)),
      (meetings) {
        _allMeetings = meetings;
        emit(GetMeetingsSuccessState(
          _allMeetings,
          meetings,
        ));
      },
    );
  }

  void searchMeetings(String query) {
    final filtered = _allMeetings.where((meeting) {
      final title = meeting.meetingname?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    emit(GetMeetingsSuccessState(
      _allMeetings,
      filtered,
    ));
  }

  Future<void> deleteMeeting(String meetingId, BuildContext context) async {
    emit(GetMeetingsLoadingState());

    final result = await repo.deleteMeeting(meetingId);

    result.fold(
      (error) {
        emit(GetMeetingsErrorState(error));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
      (success) {
        if (success) {
          _removeMeeting(meetingId);
        }
      },
    );
  }

  void _removeMeeting(String meetingId) {
    _allMeetings.removeWhere((meeting) => meeting.sId == meetingId);
    emit(GetMeetingsSuccessState(
      _allMeetings,
      _allMeetings,
    ));
  }
}
