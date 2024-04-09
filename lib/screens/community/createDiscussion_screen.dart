import 'package:alumnet/models/community.dart';
import 'package:alumnet/models/discussion.dart';
import 'package:alumnet/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateDiscussionScreen extends StatefulWidget {
  final Community community;

  CreateDiscussionScreen({required this.community});

  @override
  _CreateDiscussionScreenState createState() => _CreateDiscussionScreenState();
}

class _CreateDiscussionScreenState extends State<CreateDiscussionScreen> {
  String headline = '';
  String content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Discussion'),
        actions: [
          TextButton(
            onPressed: headline.isEmpty ? null : addDiscussion,
            child: Text(
              'Post',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: headline.isEmpty
                  ? Colors.grey.withOpacity(0.4)
                  : Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.people),
                  radius: 25,
                ),
                SizedBox(width: 10),
                Text(
                  widget.community.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text('Rules'),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  headline = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Content (Optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  content = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void addDiscussion() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User user = User.fromDummyData();
    List<DiscussionElement> elements = [
      DiscussionElement(type: ContentType.text, value: content)
    ];
    final DiscussionContent discussionContent =
        DiscussionContent(elements: elements);

    final discussionData = Discussion(
      id: headline,
      postedBy: user,
      postedAt: DateTime.now(),
      headline: headline,
      content: discussionContent,
    );

    try {
      await _firestore
          .collection('discussions')
          .doc(widget.community.name)
          .collection('posts')
          .doc(headline)
          .set(discussionData.toMap());
      print('Discussion added successfully.');
      Navigator.pop(context);
    } catch (e) {
      print('Error adding discussion: $e');
    }
  }
}
