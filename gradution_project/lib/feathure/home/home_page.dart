import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_ext.dart';
import 'package:gradution_project/core/utils/App_assets.dart';
import 'package:gradution_project/feathure/home/manager/get_meetings_cubit/get_meetings_cubit.dart';
import 'package:gradution_project/feathure/home/manager/get_meetings_cubit/get_meetings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/theme_cubit.dart';
import '../../core/utils/App_color.dart';
import 'package:badges/badges.dart' as badges;
import '../create_meeting/view/map_screen.dart';
import '../notification/manager/notification_cubit.dart';
import '../notification/manager/notification_state.dart';
import '../notification/view/notification_view.dart';
import 'views/widgets/meeting_builder.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Timer? _notificationTimer;
  String userName = '';

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'User';
    if (mounted) {
      setState(() {
        userName = name;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();

    context.read<NotificationCubit>().getNotifications();

    _notificationTimer = Timer.periodic(Duration(seconds: 30), (_) {
      if (!mounted) return;
      context.read<NotificationCubit>().getNotifications();
    });
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeCubit>().state;

    return Scaffold(
      backgroundColor: isDark ? AppColor.black : AppColor.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColor.black : AppColor.white,
        leading: const SizedBox(),
        title: Text(
          'Meetings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Concert One',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                int unreadCount = 0;
                if (state is NotificationLoadedWithCount &&
                    state.unreadCount != null) {
                  unreadCount = state.unreadCount!;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NotificationView()),
                    ).then((_) {
                      context.read<NotificationCubit>().markAllAsRead();
                    });
                  },
                  child: badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      elevation: 10,
                      badgeColor: context.textColor,
                    ),
                    badgeAnimation: badges.BadgeAnimation.scale(
                      animationDuration: const Duration(milliseconds: 300),
                      loopAnimation: false,
                    ),
                    showBadge: unreadCount > 0,
                    badgeContent: Text(
                      '$unreadCount',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    position: badges.BadgePosition.topEnd(top: -4, end: -4),
                    child: Icon(Icons.notifications),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// WELCOME TEXT
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Hi, $userName 👋',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Concert One',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// SEARCH BAR
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search meetings...',
                  hintStyle: TextStyle(color: context.textColor),
                  prefixIcon: Icon(Icons.search, color: context.textColor),
                  filled: true,
                  fillColor: isDark ? AppColor.lightblue : AppColor.lightblue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              /// MEETINGS TITLE
              Text(
                'Your Meetings',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Concert One',
                ),
              ),
              const SizedBox(height: 10),

              /// MEETINGS LIST
              BlocBuilder<GetMeetingsCubit, GetMeetingsState>(
                builder: (context, state) {
                  if (state is GetMeetingsLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is GetMeetingsErrorState) {
                    return Text(state.error);
                  } else if (state is GetMeetingsSuccessState) {
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.meetings.length,
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            animation: Listenable.merge([]),
                            builder: (context, _) {
                              return TweenAnimationBuilder(
                                tween: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ),
                                duration:
                                    Duration(milliseconds: 300 + (index * 100)),
                                curve: Curves.easeOut,
                                builder: (context, offset, child) {
                                  return Transform.translate(
                                    offset: offset * 50,
                                    child: Opacity(
                                      opacity: 1.0,
                                      child: SizedBox(
                                        width: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: MeetingBuilder(
                                            meetingModel: state.meetings[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),

              /// DIVIDER
              const SizedBox(height: 20),
              Divider(
                height: 30,
                thickness: 1,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
              const SizedBox(height: 10),

              /// CREATE MEETING SECTION
              Text(
                'Create Meeting',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Concert One',
                ),
              ),
              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: Image.asset(
                  AppAssets.maplogo,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 269,
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            MapScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.black : Colors.white,
                    side: const BorderSide(color: Color(0xFF30C3D4), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(250, 50),
                  ),
                  child: Text(
                    'CREATE A MEETING',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Concert One',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
