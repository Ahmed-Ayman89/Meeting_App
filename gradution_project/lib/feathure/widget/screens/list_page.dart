import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/utils/App_color.dart';
import 'package:gradution_project/feathure/widget/screens/person.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/widgets/profile_screen.dart';
import '../../on_boarding/Start_page.dart'; // تأكد المسار

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.watch<ThemeCubit>().state ? AppColor.black : AppColor.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SizedBox(),
        title: Text(
          "Settings",
          style: TextStyle(
            color:
                context.watch<ThemeCubit>().state ? Colors.white : Colors.black,
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

            // Profile button
            ProfileMenuItem(
              icon: Icon(
                Icons.person,
                color: context.watch<ThemeCubit>().state
                    ? Colors.white
                    : Colors.black,
                size: 40,
              ),
              text: 'Profile',
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

            // Theme Switch
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDarkMode) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isDarkMode ? AppColor.black : AppColor.white,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.dark_mode,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 40,
                    ),
                    title: Text(
                      'Theme',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontFamily: 'Concert One',
                      ),
                    ),
                    trailing: Switch(
                      value: isDarkMode,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      onChanged: (_) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Logout button
            ProfileMenuItem(
              icon: Icon(
                Icons.logout,
                color: context.watch<ThemeCubit>().state
                    ? Colors.white
                    : Colors.black,
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

                  // ارجع المستخدم لأول صفحة
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const StartPage()),
                    (route) => false,
                  );

                  // بعد الخروج نظهر SnackBar
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
