import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/network/api_helper.dart';
import 'package:gradution_project/feathure/LogIn/data/model/model.dart';
import 'package:gradution_project/feathure/LogIn/manager/logIn_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoading());

    final apiHelper = APIHelper();
    apiHelper
        .postData(
      url: 'login',
      data: {
        'email': email,
        'password': password,
      },
      token: '',
    )
        .then((value) {
      final model = LoginModel.fromJson(value.data);
      emit(LoginSuccess(model));
    }).catchError((error) {
      emit(LoginError(error.toString()));
    });
  }
}
