import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/theme_cubit.dart';

class ProfileMenuItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                    color: context.watch<ThemeCubit>().state
                        ? Colors.white
                        : Colors.black,
                    fontSize: 25,
                    fontFamily: ' Concert One',
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
