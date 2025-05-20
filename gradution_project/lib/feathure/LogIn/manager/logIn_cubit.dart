import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/network/api_helper.dart';
import 'package:gradution_project/feathure/LogIn/data/model/model.dart';
import 'package:gradution_project/feathure/LogIn/manager/logIn_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      final apiHelper = APIHelper();
      final response = await apiHelper.postData(
        url: 'login',
        data: {
          'email': email,
          'password': password,
        },
        token: '',
      );

      final model = LoginModel.fromJson(response.data);

      await _saveLoginData(model);

      emit(LoginSuccess(model));
    } catch (error) {
      emit(LoginError(error.toString()));
    }
  }

  Future<void> _saveLoginData(LoginModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', model.accessToken);
    await prefs.setString('refresh_token', model.refreshToken);
    await prefs.setString('user_id', model.user.id);
    await prefs.setString('user_name', model.user.name);
    await prefs.setString('user_email', model.user.email);
    await prefs.setString('user_phone', model.user.phone);
  }
}
