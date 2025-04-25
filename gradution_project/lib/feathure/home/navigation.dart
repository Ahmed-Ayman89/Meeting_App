import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:gradution_project/feathure/home/home_page.dart';

import 'package:gradution_project/screens/list_page.dart';
import 'package:gradution_project/screens/person.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int index = 0;

  final List<Widget> screens = [
    const Homepage(),
    const ListPage(),
    const PersonPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = const [
      Icon(Icons.home, size: 30),
      Icon(Icons.list, size: 30),
      Icon(Icons.person, size: 30),
    ];

    return Scaffold(
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          buttonBackgroundColor: const Color(0xFF30C3D4),
          color: const Color(0xFF30C3D4),
          backgroundColor: Colors.transparent,
          index: index,
          height: 60,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (i) => setState(() => index = i), // تغيير الصفحة عند الضغط
          items: items,
        ),
      ),
    );
  }
}
