import 'package:alumnet/screens/chatting/chatting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'dart:async';

class MessagesPage extends StatefulWidget {
  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final loggedInUserId = '8BICx4WqZatmhFNsgmDZ';
  TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  FocusNode _focusNode = FocusNode();
  var isFocus = false;
  var searchQueryText = "";

  User currentUser = User(
      id: '8BICx4WqZatmhFNsgmDZ',
      batch: '2024',
      username: "chirag",
      name: "chirag",
      about: "Somrthing",
      profilepic:
          'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw=',
      branch: 'DSAI');

  final List<Map<String, dynamic>> users = [
    {
      "user": User(
          id: "45",
          about: 'Something',
          batch: '2024',
          name: "aniket",
          username: 'aniket',
          profilepic:
              'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw=',
          branch: 'DSAI'),
      "lastChatDate": DateTime.now().subtract(Duration(days: 1)),
      "lastMessage": 'Hello there!',
    }
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    // Dispose the TextEditingController and the FocusNode to avoid memory leaks
    _controller.dispose();
    _debounce?.cancel(); // Cancel the debounce timer
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(Duration(seconds: 1), () {
      String searchText = _controller.text;
      setState(() {
        searchQueryText = searchText;
      });
    });
  }

  void _handleFocusChange() {
    if (isFocus != _focusNode.hasFocus) {
      setState(() {
        isFocus = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Chat',
                prefixIcon: Icon(Icons.search), // Using Icons.chat constant
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Curved corners
                ),
                contentPadding: EdgeInsets.all(0),
              ),
            ),
          ),
          !isFocus
              ? Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chat')
                        .where('users', arrayContains: currentUser.id)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text('No Active Chats, Search and Find People');
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final listItem = snapshot.data!.docs[index];
                          List<dynamic> users =
                              snapshot.data!.docs[index]['users'];

                          users.removeWhere(
                            (element) => element == currentUser.id,
                          );
                          final otherUserId = users[0];
                          print(otherUserId);

                          return FrequentChatItem(
                            chatId: listItem.id,
                            chattingWithUser: User(
                              id: listItem.id,
                              username: listItem[otherUserId]['username'],
                              batch: listItem[otherUserId]['batch'],
                              branch: listItem[otherUserId]['branch'],
                              about: listItem[otherUserId]['about'],
                              name: listItem[otherUserId]['name'],
                              profilepic: listItem[otherUserId]['profilepic'],
                            ),
                            lastMessageTime:
                                listItem['lastMessageTime'].toDate(),
                            lastChatMessage: listItem['lastMessage'],
                            currentUser: currentUser,
                          );
                        },
                      );
                    },
                  ),
                )
              : searchQueryText.isNotEmpty
                  ? Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('name',
                                isGreaterThanOrEqualTo: searchQueryText)
                            .where('name', isLessThan: searchQueryText + 'z')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Text('No matching documents found.');
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final listItem = snapshot.data!.docs[index];
                              return FrequentChatItem(
                                chatId: '',
                                chattingWithUser: User(
                                  id: listItem.id,
                                  username: listItem['username'],
                                  batch: listItem['batch'],
                                  branch: listItem['branch'],
                                  about: listItem['about'],
                                  name: listItem['name'],
                                  profilepic: listItem['profilepic'],
                                ),
                                lastMessageTime: DateTime.now(),
                                lastChatMessage: '',
                                currentUser: currentUser,
                              );
                            },
                          );
                        },
                      ),
                    )
                  : Text("Type to find people"),
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

  Future<String> _createOrRetrieveChat() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat')
        .where('users', isEqualTo: [currentUser.id, chattingWithUser.id]).get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    if (documents.isEmpty) {
      final createdObject =
          await FirebaseFirestore.instance.collection('chat').add({
        "users": [currentUser.id, chattingWithUser.id],
        "${chattingWithUser.id}": {
          "name": chattingWithUser.name,
          "username": chattingWithUser.username,
          "profilepic": chattingWithUser.profilepic,
          "batch": chattingWithUser.batch,
          "branch": chattingWithUser.branch,
          "about": chattingWithUser.about
        },
        "${currentUser.id}": {
          "name": currentUser.name,
          "username": currentUser.username,
          "profilepic": currentUser.profilepic,
          "batch": currentUser.batch,
          "branch": currentUser.branch,
          "about": currentUser.about
        },
        "created_at": DateTime.now(),
        "lastMessage": "",
        "lastMessageTime": DateTime.now()
      });

      return createdObject.id;
    } else {
      return documents[0].id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var chatIdToPass = chatId;
        if (chatIdToPass == '') {
          chatIdToPass = await _createOrRetrieveChat();
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatScreen(
                currentUser: currentUser,
                chattingWithUser: chattingWithUser,
                chatId: chatIdToPass)));
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
