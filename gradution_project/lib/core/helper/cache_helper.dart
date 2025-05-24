import 'package:shared_preferences/shared_preferences.dart';

import '../../feathure/LogIn/data/model/model.dart';

void saveUserName(LoginModel model) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_name', model.user.name);
}

void saveUserEmail(LoginModel model) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userEmail', model.user.email);
}

void saveUserPhone(LoginModel model) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userPhone', model.user.phone);
}
