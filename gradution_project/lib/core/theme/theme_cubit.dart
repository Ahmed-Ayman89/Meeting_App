import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  // تحميل الثيم المحفوظ
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getBool('isDarkMode') ?? false;
    emit(savedTheme);
  }

  // قلب الثيم وحفظه
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme = !state;
    await prefs.setBool('isDarkMode', newTheme);
    emit(newTheme);
  }
}
