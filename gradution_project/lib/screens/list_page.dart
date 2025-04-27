import 'package:flutter/material.dart';
import 'package:gradution_project/screens/person.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/widgets/profile_screen.dart';
import '../feathure/on_boarding/Start_page.dart'; // أتأكد المسار صح

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, // خلفية أسود مثلاً لو ماشي بنفس ستايل الأبلكيشن
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Concert One',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            ProfileMenuItem(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
              text: 'profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            ProfileMenuItem(
              icon: const Icon(
                Icons.dark_mode,
                color: Colors.white,
                size: 40,
              ),
              text: 'theme',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            ProfileMenuItem(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 40,
              ),
              text: 'Log Out',
              onTap: () async {
                bool? shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text(
                      'Confirm Logout',
                      style: TextStyle(color: Colors.black),
                    ),
                    content: const Text(
                      'Are you sure you want to log out?',
                      style: TextStyle(color: Colors.black87),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true) {
                  // امسح الداتا من SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  await prefs.remove('isLoggedIn');

                  // ارجع المستخدم لأول صفحة (مثلا StartPage)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const StartPage()),
                    (route) => false,
                  );

                  // بعدها بلحظة صغيرة نطلع SnackBar
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Logged out successfully!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
