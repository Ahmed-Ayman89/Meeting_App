import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/utils/App_assets.dart';
import 'package:gradution_project/feathure/home/manager/get_meetings_cubit/get_meetings_cubit.dart';
import 'package:gradution_project/feathure/home/manager/get_meetings_cubit/get_meetings_state.dart';

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
  @override
  void initState() {
    super.initState();

    context.read<NotificationCubit>().getNotifications();

    Timer.periodic(Duration(seconds: 30), (_) {
      context.read<NotificationCubit>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.watch<ThemeCubit>().state ? AppColor.black : AppColor.white,
      appBar: AppBar(
        backgroundColor:
            context.watch<ThemeCubit>().state ? AppColor.black : AppColor.white,
        leading: const SizedBox(),
        title: Text(
          'Meetings',
          style: TextStyle(
            color:
                context.watch<ThemeCubit>().state ? Colors.white : Colors.black,
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
                    badgeAnimation: badges.BadgeAnimation.scale(
                      animationDuration: const Duration(milliseconds: 300),
                      loopAnimation: false,
                    ),
                    showBadge: unreadCount > 0,
                    badgeContent: Text(
                      '+$unreadCount',
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
              const SizedBox(height: 30),

              // consumer for meetings cubit
              BlocBuilder<GetMeetingsCubit, GetMeetingsState>(
                builder: (context, state) {
                  if (state is GetMeetingsLoadingState) {
                    return CircularProgressIndicator();
                  } else if (state is GetMeetingsErrorState) {
                    return Text(state.error);
                  } else if (state is GetMeetingsSuccessState) {
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.meetings.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 300, // Fixed width for each meeting card
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: MeetingBuilder(
                                meetingModel: state.meetings[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
              Text(
                'Create Meeting',
                style: TextStyle(
                  color: context.watch<ThemeCubit>().state
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Concert One',
                ),
              ),
              const SizedBox(height: 10),

              // Image
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

              // Create Meeting Button
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
                    backgroundColor: context.watch<ThemeCubit>().state
                        ? Colors.black
                        : Colors.white,
                    side: const BorderSide(color: Color(0xFF30C3D4), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(250, 50),
                  ),
                  child: Text(
                    'CREATE A MEETING',
                    style: TextStyle(
                      color: context.watch<ThemeCubit>().state
                          ? Colors.white
                          : Colors.black,
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
