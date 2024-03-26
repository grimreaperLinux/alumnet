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

class ChatScreen extends StatelessWidget {
  final User currentUser;
  final User chattingWithUser;

  ChatScreen({super.key, required this.chattingWithUser, required this.currentUser});
  final List<Message> messages = [
    Message(
      messageBody: 'Hello!',
      sentBy: 'aniket',
      sentAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Message(
      messageBody: 'Hi, how are you?',
      sentBy: 'chirag',
      sentAt: DateTime.now(),
    )
  ];

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
                  chattingWithUser.profilepic), // Replace with the avatar image URL
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chattingWithUser.name, // Replace with the name of the person you're chatting with
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          ],
        ),
        actions: [
          Image.asset('assets/Images/cgc.jpeg')
        ],
      ),
      body: Column(
        children: [
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isCurrentUser = message.sentBy == currentUser.username;
                final bool isLastMessage = index == messages.length - 1 ||
                    messages[index + 1].sentBy != message.sentBy;
                return ChatMessageBubble(
                  message: message.messageBody,
                  sentByCurrentUser: isCurrentUser,
                  sentAt: message.sentAt,
                  isLastMessage: isLastMessage,
                  currentUserImage: currentUser.profilepic,
                  chattingWithUserImage: chattingWithUser.profilepic
                );
              },
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          SendMessageField(),
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
        if (!sentByCurrentUser && isLastMessage) ProfileImage(profileImage: chattingWithUserImage,),
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
        if (sentByCurrentUser && isLastMessage) ProfileImage(profileImage: currentUserImage,),
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
        backgroundImage: NetworkImage(profileImage), // Add your profile image URL here
      ),
    );
  }
}

class SendMessageField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
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
          IconButton(
            onPressed: () {
              // Handle sending message
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
