import 'package:alumnet/models/tab_item.dart';
import 'package:alumnet/navigation/custom_tab_bar.dart';
import 'package:alumnet/profile/profile_screen.dart';
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
    MessagesPage(),
    Profile()
  ];

  int _index = 0;

  void changeScreen(int i) {
    setState(() {
      _index = i;
    });
  }

  int _selectedTab = 0;
  final List<TabItem> _icons = TabItem.tabItemList;

  void onTabPress(index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      changeScreen(index);
      if(index<=4){
        _icons[index].status!.change(true);
        Future.delayed(const Duration(seconds: 1), () {
          _icons[index].status!.change(false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: GestureDetector(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw='),
                    ),
                    onTap: (){
                      onTabPress(5);
                    },
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
          ),
          Flexible(
            // Wrap with Flexible
            child: _pages[_index],
          ),
        ],
      ),
      bottomNavigationBar: CustomTabBar(
        changeScreen: changeScreen,
        onTabPress: onTabPress,
        selectedTab: _selectedTab,
      ),
    );
  }
}
