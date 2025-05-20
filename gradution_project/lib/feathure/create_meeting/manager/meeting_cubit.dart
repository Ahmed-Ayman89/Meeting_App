import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradution_project/feathure/create_meeting/manager/metting_state.dart';
import '../data/model/meeting_model.dart';
import '../data/repo/meeting_repo.dart';

class MeetingCubit extends Cubit<CreateMeetLocationState> {
  final MeetingRepository repository;

  MeetingCubit(this.repository) : super(CreateMeetLocationInitial());

  Future<void> saveMeeting(MeetingModel meeting) async {
    emit(CreateMeetLocationLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        emit(CreateMeetLocationFailure('يجب تسجيل الدخول أولاً'));
        return;
      }

      await repository.sendMeetingToServer(meeting, token);
      emit(CreateMeetLocationSuccess('تم إنشاء الاجتماع بنجاح'));
    } catch (e) {
      emit(CreateMeetLocationFailure('حدث خطأ: ${e.toString()}'));
    }
  }
}
