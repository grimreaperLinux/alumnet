import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User currentUser = User(id: '45', batch: '2024',username: "chirag",name:"chirag",about: "Somrthing",profilepic: 'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw=',branch: 'DSAI');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Divider(
                        thickness: 1,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(currentUser.profilepic) // Replace with your image
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${currentUser.name}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your onPressed logic here
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Capsule shape
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10)),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      '@${currentUser.username}',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      '${currentUser.about}',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      overflow: TextOverflow
                          .ellipsis, // Display ellipsis when overflowing
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Icon(Icons.calendar_month),
                        ),
                        Text(
                          'Batch ${currentUser.batch}',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(flex: 6, child: TabBarExample()),
        ],
      ),
    );
  }
}

class TabBarExample extends StatelessWidget {
  TabBarExample({super.key});
  List<Map<String, dynamic>> posts = [
    {
      'profileImageUrl':
          'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw=',
      'name': 'Chirag Mittal',
      'username': 'chiragmittal',
      'postedAt': DateTime.now().subtract(Duration(days: 2, hours: 1 * 2)),
      'postContent':
          'This is post number 1. Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      'likes': 10 + 1 * 2,
      'comments': 5 + 1,
      'views': 100 + 1 * 10,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: Column(
          children: [
            Container(
              constraints: BoxConstraints.expand(
                  height: 30), // Adjust the height as needed
              child: TabBar(
                tabs: [
                  Tab(text: 'Posts'),
                  Tab(text: 'Mentions'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostWidget(
                          profileImageUrl: posts[index]['profileImageUrl'],
                          name: posts[index]['name'],
                          username: posts[index]['username'],
                          postedAt: posts[index]['postedAt'],
                          postContent: posts[index]['postContent'],
                          likes: posts[index]['likes'],
                          comments: posts[index]['comments'],
                          views: posts[index]['views'],
                        );
                      },
                    ),
                  ),
                  Center(child: Text('Content for Tab 2')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String username;
  final DateTime postedAt;
  final String postContent;
  final int likes;
  final int comments;
  final int views;

  const PostWidget({
    required this.profileImageUrl,
    required this.name,
    required this.username,
    required this.postedAt,
    required this.postContent,
    required this.likes,
    required this.comments,
    required this.views,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.17,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
          ),
          SizedBox(width: 16.0),
          // Post Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name, Username, and Posted Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '$name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ' @$username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ' • ${_getTimeAgo(postedAt)} ago',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                // Post Content
                Text(
                  postContent,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.0),
                // Likes, Comments, Views
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite),
                        Text('$likes'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.comment),
                        Text('$comments'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.visibility),
                        Text('$views'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to calculate time ago
  String _getTimeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes';
    } else {
      return 'Just now';
    }
  }
}
