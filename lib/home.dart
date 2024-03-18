import 'package:alumnet/navigation/custom_tab_bar.dart';
import 'package:alumnet/screens/community_screen.dart';
import 'package:alumnet/screens/home/home_screen.dart';
import 'package:alumnet/screens/messages_screen.dart';
import 'package:alumnet/screens/notifications_screen.dart';
import 'package:alumnet/screens/search_screen.dart';
import 'package:flutter/material.dart';

class AlumnetHome extends StatefulWidget {
  const AlumnetHome({super.key});

  @override
  State<AlumnetHome> createState() => _AlumnetHomeState();
}

class _AlumnetHomeState extends State<AlumnetHome> {
  final List _pages = [
    HomePage(),
    SearchPage(),
    CommunityPage(),
    NotificationsPage(),
    MessagesPage()
  ];

  int _index = 0;

  void changeScreen(int i) {
    setState(() {
      _index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw='),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Handle settings icon action
                  },
                ),
              ],
            ),
            Flexible(
              // Wrap with Flexible
              child: _pages[_index],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomTabBar(
        changeScreen: changeScreen,
      ),
    );
  }
}
