import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_cubit.dart';

extension ThemeContext on BuildContext {
  bool get isDark => watch<ThemeCubit>().state;
  Color get textColor => isDark ? Colors.white : Colors.black;
  Color get backgroundColor => isDark ? Colors.black : Colors.white;
}
