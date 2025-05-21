import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/feathure/home/manager/get_meetings_cubit/get_meetings_cubit.dart';
import 'package:gradution_project/feathure/notification/data/repo/notification_repo.dart';
import 'package:gradution_project/feathure/on_boarding/splash_screen.dart';
import 'package:gradution_project/core/theme/theme_cubit.dart';
import 'feathure/create_meeting/data/repo/meeting_repo.dart';
import 'feathure/create_meeting/manager/meeting_cubit.dart';
import 'feathure/notification/manager/notification_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit()..loadTheme(),
        ),
        BlocProvider<MeetingCubit>(
          create: (context) => MeetingCubit(
            MeetingRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => GetMeetingsCubit()..getMeetings(),
        ),
        BlocProvider(
            create: (context) =>
                NotificationCubit(NotificationRepo())..getNotifications()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
