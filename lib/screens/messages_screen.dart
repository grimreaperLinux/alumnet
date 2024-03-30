import 'package:alumnet/screens/chatting/chatting_screen.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class MessagesPage extends StatelessWidget {
  User currentUser = User(batch: '2024',username: "chirag",name:"chirag",about: "Somrthing",profilepic: 'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw=',);
  final List<Map<String,dynamic>> users = [
    {
      "user": User(about: 'Something',batch: '2024',name: "aniket", username: 'aniket', profilepic: 'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw=',),
      "lastChatDate": DateTime.now().subtract(Duration(days: 1)),
      "lastMessage": 'Hello there!',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Chat',
                prefixIcon: Icon(Icons.search), // Using Icons.chat constant
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Curved corners
                ),
                contentPadding: EdgeInsets.all(0)
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return FrequentChatItem(
                  chatId: '$index',
                  chattingWithUser: users[index]['user'],
                  lastMessageTime: users[index]['lastChatDate'],
                  lastChatMessage: users[index]['lastMessage'],
                  currentUser: currentUser,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FrequentChatItem extends StatelessWidget {
  final User chattingWithUser;
  final User currentUser;
  final String chatId;
  final String lastChatMessage;
  final DateTime lastMessageTime;

  const FrequentChatItem({
    required this.chattingWithUser,
    required this.currentUser,
    required this.chatId,
    required this.lastChatMessage,
    required this.lastMessageTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(currentUser: currentUser,chattingWithUser: chattingWithUser,)));
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.17,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(chattingWithUser.profilepic),
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
                          '${chattingWithUser.name}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          ' @${chattingWithUser.username}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          ' • ${_getTimeAgo(lastMessageTime)} ago',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  // Post Content
                  Text(
                    lastChatMessage,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
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
