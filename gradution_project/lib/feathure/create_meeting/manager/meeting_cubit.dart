import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/feathure/create_meeting/manager/metting_state.dart';

import '../data/model/meeting_model.dart';
import '../data/repo/meeting_repo.dart';

class MeetingCubit extends Cubit<CreateMeetLocationState> {
  final MeetingRepository repository;

  MeetingCubit(this.repository) : super(CreateMeetLocationInitial());

  void saveMeeting(MeetingModel meeting) async {
    emit(CreateMeetLocationLoading());
    try {
      await repository.sendMeetingToServer(meeting);
      emit(CreateMeetLocationSuccess('Meeting created successfully'));
    } catch (e) {
      emit(CreateMeetLocationFailure(e.toString()));
    }
  }
}
