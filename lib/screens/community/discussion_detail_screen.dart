import 'package:alumnet/models/comment.dart';
import 'package:alumnet/models/community.dart';
import 'package:alumnet/models/discussion.dart';
import 'package:alumnet/models/user.dart';
import 'package:alumnet/widgets/feed_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiscussionDetailScreen extends StatefulWidget {
  final Discussion discussion;
  final Community community;

  DiscussionDetailScreen({required this.discussion, required this.community});

  @override
  _DiscussionDetailViewState createState() => _DiscussionDetailViewState();
}

class _DiscussionDetailViewState extends State<DiscussionDetailScreen> {
  String commentContent = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Spacer(),
                        Icon(Icons.search),
                        SizedBox(width: 20),
                        Icon(Icons.share),
                        SizedBox(width: 20),
                        Icon(Icons.more_vert),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          'https://via.placeholder.com/150',
                          width: 35,
                          height: 35,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.community.name),
                            Row(
                              children: [
                                Text(
                                  widget.discussion.postedBy.name,
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '5h',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    Text(
                      widget.discussion.headline,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // getContent(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: <Widget>[
                    //     IconTextButton(
                    //       iconData: Icons.thumb_up,
                    //       text: "21",
                    //       onTap: () {},
                    //     ),
                    //     IconTextButton(
                    //       iconData: Icons.comment,
                    //       text: "20",
                    //       onTap: () {},
                    //     ),
                    //   ],
                    // ),

                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('discussions')
                            .doc(widget.community.name)
                            .collection('posts')
                            .doc(widget.discussion.headline)
                            .collection('comments')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                                child: Text("Be the first one to comment"));
                          }
                          final comments = snapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          comment['user']['profilepic']),
                                      radius: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment['user']['name'],
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              timeago.format(
                                                  DateTime.parse(
                                                      comment['time']),
                                                  locale: 'en_short'),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(comment['content']),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            IconTextButton(
                                              iconData: Icons.thumb_up,
                                              text: "",
                                              onTap: () {},
                                            ),
                                            IconTextButton(
                                              iconData: Icons.comment,
                                              text: "",
                                              onTap: () {},
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a Comment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        commentContent = value;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    addCommentToPost();

                    setState(() {
                      commentContent = '';
                    });
                  },
                  child: Text("Send"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.discussion.content.elements.map((element) {
        switch (element.type) {
          case ContentType.text:
            return Text(element.value);
          case ContentType.link:
            return InkWell(
              onTap: () {},
              child: Text(element.value),
            );
          case ContentType.image:
            return Image.network(element.value);
        }
      }).toList(),
    );
  }

  void addCommentToPost() async {
    final _firestore = FirebaseFirestore.instance;
    String collectionPath = 'discussions/';
    String communityId = widget.community.name;
    String discussionId = widget.discussion.headline;
    User user = Provider.of<CurrentUser>(context, listen: false).currentUser;
    String commentID = _firestore
        .collection(collectionPath)
        .doc(communityId)
        .collection('posts')
        .doc(discussionId)
        .collection('comments')
        .doc()
        .id;

    Comment comment = Comment(
      id: commentID,
      user: user,
      content: commentContent,
      time: DateTime.now(),
    );

    try {
      await _firestore
          .collection(collectionPath)
          .doc(communityId)
          .collection('posts')
          .doc(discussionId)
          .collection('comments')
          .doc(commentID)
          .set(comment.toMap());
      print('Comment added successfully.');
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
}
