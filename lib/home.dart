import 'package:alumnet/models/tab_item.dart';
import 'package:alumnet/models/user.dart';
import 'package:alumnet/navigation/custom_tab_bar.dart';
import 'package:alumnet/repository/auth_repo/auth_repo.dart';
import 'package:alumnet/profile/profile_screen.dart';
import 'package:alumnet/screens/community_screen.dart';
import 'package:alumnet/screens/home/home_screen.dart';
import 'package:alumnet/screens/messages_screen.dart';
import 'package:alumnet/screens/notifications_screen.dart';
import 'package:alumnet/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlumnetHome extends StatefulWidget {
  final Map<String, dynamic> userDoc;

  const AlumnetHome({super.key, required this.userDoc});

  @override
  State<AlumnetHome> createState() => _AlumnetHomeState();
}

class _AlumnetHomeState extends State<AlumnetHome> {
  User currentUser = User(
    id: '8BICx4WqZatmhFNsgmDZ',
    batch: '2024',
    username: "20bds016",
    name: "Chirag",
    about: "Hello User",
    profilepic:
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
    branch: 'DSAI',
    email: "chirag@gmail.com",
  );

  final List _pages = [HomePage(), SearchPage(), CommunityPage(), NotificationsPage(), MessagesPage(), Profile()];
  @override
  void initState() {
    super.initState();
    Provider.of<CurrentUser>(context, listen: false).setCurrentUser(widget.userDoc);
  }

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
                      backgroundImage: NetworkImage(currentUser.profilepic),
                    ),
                    onTap: () {
                      onTabPress(5);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout_outlined),
                  onPressed: () {
                    AuthRepo.instance.logout();
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
