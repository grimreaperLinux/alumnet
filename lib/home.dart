import 'package:alumnet/models/tab_item.dart';
import 'package:alumnet/navigation/custom_tab_bar.dart';
import 'package:alumnet/profile/profile_screen.dart';
import 'package:alumnet/screens/community/community_screen.dart';
import 'package:alumnet/screens/community/createCommunity_screen.dart';
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
      if (index <= 4) {
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                  Text(
                    'Aman Gupta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '@20bds024',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.person),
              onTap: () {
                onTabPress(5);
              },
            ),
            ListTile(
              title: Text("View Liked Posts"),
              leading: Icon(Icons.favorite),
              onTap: () {
                // Handle liked posts tap
              },
            ),
            ListTile(
              title: Text("Create a Community"),
              leading: Icon(Icons.add),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateCommunityScreen()));
              },
            ),
            ListTile(
              title: Text("Merchandise"),
              leading: Icon(Icons.shopping_bag),
              onTap: () {
                // Handle merchandise tap
              },
            ),
            ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
              onTap: () {
                // Handle settings tap
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   child: GestureDetector(
                // child: CircleAvatar(
                //   radius: 25,
                //   backgroundImage: NetworkImage(
                //       'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw='),
                // ),
                //     onTap: () {
                //       Scaffold.of(context).openDrawer();
                //     },
                //   ),
                // ),
                Container(
                  child: Builder(
                    builder: (context) => TextButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw='),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.verified_user),
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
