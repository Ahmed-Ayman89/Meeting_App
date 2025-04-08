import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gradution_project/core/utils/App_assets.dart';
import 'package:gradution_project/core/utils/App_color.dart';
import 'package:gradution_project/feathure/on_boarding/Start_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: Center(
          child: Image.asset(
        AppAssets.mainlogo,
        width: 200,
        height: 200,
      )),
    );
  }
}
