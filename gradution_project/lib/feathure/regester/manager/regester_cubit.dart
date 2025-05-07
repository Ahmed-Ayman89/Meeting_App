import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/network/api_helper.dart';
import 'package:gradution_project/feathure/regester/manager/regester_state.dart';

import '../data/model.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoading());

    final apiHelper = APIHelper();
    apiHelper
        .postData(
      url: 'register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
      token: '',
    )
        .then((value) {
      final model = RegisterModel.fromJson(value.data);
      emit(RegisterSuccess(model));
    }).catchError((error) {
      emit(RegisterError(error.toString()));
    });
  }
}
