// lib/feature/reset/manager/reset_password_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/network/api_helper.dart';
import '../data/model/model_reset.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  static ResetPasswordCubit get(context) => BlocProvider.of(context);

  void resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) {
    emit(ResetPasswordLoading());

    APIHelper().postData(
      url: 'reset-password',
      data: {
        'email': email,
        'otp': otp,
        'new_password': password,
        'confirm_password': confirmPassword,
      },
    ).then((value) {
      final model = ResetPasswordModel.fromJson(value.data);
      emit(ResetPasswordSuccess(model));
    }).catchError((error) {
      emit(ResetPasswordError(error.toString()));
    });
  }
}
