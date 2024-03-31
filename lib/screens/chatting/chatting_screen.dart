import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';

class Message {
  final String messageBody;
  final String sentBy;
  final DateTime sentAt;

  Message({
    required this.messageBody,
    required this.sentBy,
    required this.sentAt,
  });
}

class ChatScreen extends StatefulWidget {
  final User currentUser;
  final String chatId;
  final User chattingWithUser;
  ChatScreen(
      {super.key,
      required this.chattingWithUser,
      required this.currentUser,
      required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                widget.chattingWithUser.profilepic,
              ), // Replace with the avatar image URL
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.chattingWithUser
                      .name, // Replace with the name of the person you're chatting with
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          ],
        ),
        actions: [Image.asset('assets/Images/cgc.jpeg')],
      ),
      body: Column(
        children: [
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .where('chatId', isEqualTo: widget.chatId)
                .orderBy('sentAt', descending: false)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              print(snapshot.hasData);
              print(snapshot.data!.docs.isEmpty);

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('Start Typing and start the chat.'),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final listItem = snapshot.data!.docs[index];
                  final bool isCurrentUser =
                      listItem['sentBy'] == widget.currentUser.id;
                  final bool isLastMessage =
                      index == snapshot.data!.docs.length - 1 ||
                          snapshot.data!.docs[index + 1]['sentBy'] !=
                              listItem['sentBy'];
    
                  return ChatMessageBubble(
                    message: listItem['messageBody'],
                    sentByCurrentUser: isCurrentUser,
                    sentAt: listItem['sentAt'].toDate(),
                    isLastMessage: isLastMessage,
                    currentUserImage: widget.currentUser.profilepic,
                    chattingWithUserImage: widget.chattingWithUser.profilepic,
                  );
                },
              );
            },
          )),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          SendMessageField(
            chatId: widget.chatId,
            currentUserId: widget.currentUser.id,
          ),
        ],
      ),
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final bool sentByCurrentUser;
  final DateTime sentAt;
  final bool isLastMessage;
  final String currentUserImage;
  final String chattingWithUserImage;

  const ChatMessageBubble({
    required this.message,
    required this.sentByCurrentUser,
    required this.sentAt,
    required this.isLastMessage,
    required this.chattingWithUserImage,
    required this.currentUserImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          sentByCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!sentByCurrentUser && isLastMessage)
          ProfileImage(
            profileImage: chattingWithUserImage,
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: sentByCurrentUser ? Colors.blue[200] : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(sentByCurrentUser ? 12 : 0),
              topRight: Radius.circular(sentByCurrentUser ? 0 : 12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 4),
              Text(
                _getTimeAgo(sentAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        if (sentByCurrentUser && isLastMessage)
          ProfileImage(
            profileImage: currentUserImage,
          ),
      ],
    );
  }

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

class ProfileImage extends StatelessWidget {
  final String profileImage;
  ProfileImage({required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: CircleAvatar(
        radius: 16,
        backgroundImage:
            NetworkImage(profileImage), // Add your profile image URL here
      ),
    );
  }
}

class SendMessageField extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  SendMessageField({required this.chatId, required this.currentUserId});

  @override
  State<SendMessageField> createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  TextEditingController _controller = TextEditingController();
  var _isSending = false;
  Future<void> _sendMessageHelper() async {
    String message = _controller.text;
    setState(() {
      _isSending=true;
    });
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message Body Cannot be empty'),
        ),
      );
    } else {
      try {
        FirebaseFirestore.instance.collection('messages').add({
          'chatId': widget.chatId,
          'messageBody': message,
          'sentBy': widget.currentUserId,
          'sentAt': DateTime.now()
        });

        FirebaseFirestore.instance.collection('chat').doc(widget.chatId).update({'lastMessage':message, 'lastMessageTime': DateTime.now()});
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong, could not send'),
          ),
        );
      }
    }

    _controller.clear();
    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
          SizedBox(width: 10),
          !_isSending?IconButton(
            onPressed: () {
              _sendMessageHelper();
            },
            icon: Icon(Icons.send),
          ):CircularProgressIndicator(),
        ],
      ),
    );
  }
}
