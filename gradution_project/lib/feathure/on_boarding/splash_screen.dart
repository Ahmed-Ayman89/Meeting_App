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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // أنيميشن التحكم
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // تبدأ من تحت
      end: Offset.zero, // وتنتهي في النص
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // نبدأ الأنيميشن
    _controller.forward();

    // بعد 3 ثواني نروح على StartPage
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // لازم نعمل ديسبوز
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.mainlogo,
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'WeyNak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Concert One'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
