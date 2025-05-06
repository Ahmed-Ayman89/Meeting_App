import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/feathure/home/data/repo/meetings_repo.dart';
import 'package:gradution_project/feathure/home/manager/get_meetings_cubit/get_meetings_state.dart';

class GetMeetingsCubit extends Cubit<GetMeetingsState> {
  GetMeetingsCubit() : super(GetMeetingsInitialState());
  static GetMeetingsCubit get(context) => BlocProvider.of(context);
  MeetingsRepo repo = MeetingsRepo();
  void getMeetings() async {
    emit(GetMeetingsLoadingState());
    final result = await repo.getMeetings();
    result.fold(
      (error) => emit(GetMeetingsErrorState(error)),
      (meetings) => emit(GetMeetingsSuccessState(meetings)),
    );
  }
}
