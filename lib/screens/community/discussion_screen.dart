import 'package:alumnet/models/community.dart';
import 'package:alumnet/models/discussion.dart';
import 'package:alumnet/models/user.dart';
import 'package:alumnet/screens/community/components/discussion_post.dart';
import 'package:alumnet/screens/community/createDiscussion_screen.dart';
import 'package:alumnet/screens/community/discussion_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DiscussionScreen extends StatefulWidget {
  final Community community;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List membersData = [];
  DiscussionScreen({required this.community});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  List<Discussion> postsData = [];

  bool isMember = false;
  @override
  void initState() {
    super.initState();
    checkIfMember();
  }

  void checkIfMember() async {
    final currentUser =
        Provider.of<CurrentUser>(context, listen: false).currentUser;
    final communityName = widget.community.name;

    final snapshot = await FirebaseFirestore.instance
        .collection('discussions')
        .doc(communityName)
        .collection('members')
        .doc(currentUser.id)
        .get();

    setState(() {
      isMember = snapshot.exists;
    });
  }

  void manipulateMemberList() async {
    final _firestore = FirebaseFirestore.instance;
    final currentUser =
        Provider.of<CurrentUser>(context, listen: false).currentUser;
    final communityName = widget.community.name;

    try {
      if (!isMember) {
        await _firestore
            .collection('discussions')
            .doc(communityName)
            .collection('members')
            .doc(currentUser.id)
            .set(currentUser.toMap());
        print('User added to the community');
      } else {
        await _firestore
            .collection('discussions')
            .doc(communityName)
            .collection('members')
            .doc(currentUser.id)
            .delete();
        print('User removed from the community');
      }
      setState(() {
        isMember = !isMember;
      });
    } catch (e) {
      // Handle errors
      print('Error manipulating member list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Spacer(),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.people),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Community Members',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w600),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('discussions')
                    .doc(widget.community.name)
                    .collection('members')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  widget.membersData = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.membersData.length,
                    itemBuilder: (context, index) {
                      final data = widget.membersData[index];
                      return ListTile(
                        title: Text(data['name']),
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                          radius: 25,
                        ),
                        onTap: () {},
                      );
                    },
                  );
                })
            // ListTile(
            //   title: Text("View Liked Posts"),
            //   leading: Icon(Icons.favorite),
            //   onTap: () {
            //     // Handle liked posts tap
            //   },
            // ),
            // ListTile(
            //   title: Text("Merchandise"),
            //   leading: Icon(Icons.shopping_bag),
            //   onTap: () {
            //     // Handle merchandise tap
            //   },
            // ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.people),
                        radius: 25,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.community.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   "${widget.membersData.length} active members",
                          //   style: TextStyle(fontSize: 12, color: Colors.grey),
                          // ),
                        ],
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          manipulateMemberList();
                        },
                        child: Text(
                          isMember ? "Joined" : "Join",
                          style: TextStyle(
                              color: isMember ? Colors.black : Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(80, 50),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor:
                              isMember ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: isMember
                                ? BorderSide(color: Colors.black)
                                : BorderSide.none,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(widget.community.bio)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateDiscussionScreen(
                                  community: widget.community)));
                    },
                    child: Text(
                      "Add Post",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Recent",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Top Discussions",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('discussions')
                  .doc(widget.community.name)
                  .collection('posts')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Discussion> postsData = snapshot.data!.docs
                    .map((doc) =>
                        Discussion.fromMap(doc.data() as Map<String, dynamic>?))
                    .toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: postsData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscussionDetailScreen(
                              discussion: postsData[index],
                              community: widget.community,
                              currentLevel: 0,
                            ),
                          ),
                        );
                      },
                      child: DiscussionPost(
                          community: widget.community,
                          discussion: postsData[index]),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
