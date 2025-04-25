import 'package:flutter/material.dart';
import 'package:gradution_project/core/utils/App_assets.dart';

import '../../delete_me.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          'Meetings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Concert One',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            const Text(
              'Create Meeting',
              style: TextStyle(
                color: Colors.white,
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
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Color(0xFF30C3D4), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(250, 50),
                ),
                child: const Text(
                  'CREATE A MEETING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Concert One',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
