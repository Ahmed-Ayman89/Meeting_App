import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_cubit.dart';

extension ThemeContext on BuildContext {
  bool get isDark => watch<ThemeCubit>().state;
  Color get textColor => isDark ? Colors.white : Colors.black;
  Color get backgroundColor => isDark ? Colors.black : Colors.white;
  Color get cardColor => isDark ? Color(0xFF1D1C1B) : Colors.black;
  Color get navbarColor => isDark ? Colors.grey[900]! : Colors.black;
  Color get btnColor => isDark ? Colors.white : Colors.black;
}
