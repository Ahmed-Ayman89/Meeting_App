import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/network/api_helper.dart';

import '../data/model/model_password.dart';
import 'forget_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  static ForgotPasswordCubit get(context) => BlocProvider.of(context);

  void sendResetLink({required String email}) {
    emit(ForgotPasswordLoading());

    APIHelper()
        .postData(
      url: 'forgot-password',
      data: {'email': email},
      token: '',
    )
        .then((value) {
      final model = ForgotPasswordModel.fromJson(value.data);
      emit(ForgotPasswordSuccess(model));
    }).catchError((error) {
      emit(ForgotPasswordError(error.toString()));
    });
  }
}
