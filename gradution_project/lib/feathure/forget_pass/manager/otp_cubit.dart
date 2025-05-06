import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/network/api_helper.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  static OtpCubit get(context) => BlocProvider.of(context);

  void verifyOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    emit(OtpLoading());

    APIHelper()
        .postData(
            url: 'reset-password',
            data: {
              'email': email,
              'otp': otp,
              'newPassword': newPassword,
            },
            token: '')
        .then((value) {
      emit(OtpSuccess());
    }).catchError((error) {
      emit(OtpError(error.toString()));
    });
  }
}
