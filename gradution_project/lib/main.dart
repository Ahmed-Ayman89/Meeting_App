import 'package:flutter/material.dart';
import 'package:gradution_project/core/utils/App_color.dart';
import 'package:gradution_project/feathure/on_boarding/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.black,
        appBarTheme: AppBarTheme(backgroundColor: AppColor.black),
      ),
      home: SplashScreen(),
    );
  }
}
