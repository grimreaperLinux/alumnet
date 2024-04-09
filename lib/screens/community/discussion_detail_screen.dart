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
  final currentLevel;
  DiscussionDetailScreen(
      {required this.discussion,
      required this.community,
      required this.currentLevel});

  @override
  _DiscussionDetailViewState createState() => _DiscussionDetailViewState();
}

class _DiscussionDetailViewState extends State<DiscussionDetailScreen> {
  String commentContent = '';

  @override
  Widget build(BuildContext context) {
    print(widget.currentLevel);
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
                    getContent(),
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
                              final commentData =
                                  comment.data() as Map<String, dynamic>;

                              final postedBy = commentData['postedBy'];
                              final postedAt = commentData['postedAt'];
                              final headline = commentData['headline'];
                              final user = User(
                                  name: postedBy['name'],
                                  id: postedBy['id'],
                                  email: postedBy['email']);
                              return Container(
                                padding: EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DiscussionDetailScreen(
                                                    discussion: Discussion(
                                                        id: comment['id'],
                                                        postedBy: user,
                                                        postedAt:
                                                            DateTime.parse(
                                                                postedAt),
                                                        headline: headline),
                                                    community: widget.community,
                                                    currentLevel:
                                                        widget.currentLevel +
                                                            1)));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            postedBy['profilepic']),
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
                                                postedBy['name'],
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                timeago.format(
                                                    DateTime.parse(postedAt),
                                                    locale: 'en_short'),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(comment['headline']),
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
                                          Divider(),
                                        ],
                                      ),
                                    ],
                                  ),
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
              child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: ((context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              height: 700,
                              child: Column(children: [
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel")),
                                    Text(
                                      "Reply",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                                Divider(),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Add a Comment',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              commentContent = value;
                                            });
                                          },
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(5),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              addCommentToPost(widget
                                                  .currentLevel
                                                  .toString());
                                              Navigator.pop(context);
                                              setState(() {
                                                commentContent = '';
                                              });
                                            },
                                            child: Text("Send"),
                                          ))
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          );
                        }));
                  },
                  child: Container(
                      width: 400,
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child:
                          Text("Reply to ${widget.discussion.postedBy.name}"))))
        ],
      ),
    );
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.discussion.content?.elements.map((element) {
            Widget widget;
            switch (element.type) {
              case ContentType.text:
                widget = Text(element.value ?? '');
                break;
              case ContentType.link:
                widget = InkWell(
                  onTap: () {},
                  child: Text(element.value ?? ''),
                );
                break;
              case ContentType.image:
                widget = Image.network(element.value ?? '');
                break;
              default:
                widget = SizedBox(); // Default case, return an empty widget
            }
            return widget;
          }).toList() ??
          [], // Use null-aware operator to handle null content
    );
  }

  void addCommentToPost(String parentId) async {
    final _firestore = FirebaseFirestore.instance;

    String communityId = widget.community.name;
    String discussionId = widget.discussion.id;
    String collectionPath = 'discussions/';

    User user = Provider.of<CurrentUser>(context, listen: false).currentUser;
    String commentID = _firestore
        .collection(collectionPath)
        .doc(communityId)
        .collection('posts')
        .doc(discussionId)
        .collection('comments')
        .doc()
        .id;

    if (parentId == '0' || parentId.isEmpty) {
      parentId = '';
    } else {
      DocumentSnapshot parentSnapshot = await _firestore
          .collection(collectionPath)
          .doc(communityId)
          .collection('posts')
          .doc(discussionId)
          .collection('comments')
          .doc(parentId)
          .get();

      if (parentSnapshot.exists) {
        parentId = parentSnapshot.id;
      } else {
        print('Parent comment not found.');
        return;
      }
    }

    Discussion comment = Discussion(
      id: commentID,
      parentId: parentId,
      postedBy: user,
      headline: commentContent,
      postedAt: DateTime.now(),
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
