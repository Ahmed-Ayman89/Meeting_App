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
}
