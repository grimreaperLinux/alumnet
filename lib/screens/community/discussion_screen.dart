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

  DiscussionScreen({required this.community});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  List<Discussion> postsData = [];
  List membersData = [];
  bool isMember = false;
  @override
  void initState() {
    super.initState();
    checkIfMember();
    _fetchData();
  }

  void _fetchData() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('discussions')
        .doc(widget.community.name)
        .collection('posts')
        .get();
    setState(() {
      postsData = querySnapshot.docs
          .map((doc) => Discussion.fromMap(doc.data()))
          .toList();
    });

    // QuerySnapshot<Map<String, dynamic>> querySnapshot2 = await _firestore
    //     .collection('discussions')
    //     .doc(widget.community.name)
    //     .collection('members')
    //     .get();
    // setState(() {
    //   membersData = querySnapshot2.docs.map((doc) => doc.data()).toList();
    // });
  }

  void manipulateMemberList() async {
    final _firestore = FirebaseFirestore.instance;
    final String currentUserID =
        Provider.of<CurrentUser>(context, listen: false).currentUser.id;
    final communityName = widget.community.name;

    try {
      if (!isMember) {
        await _firestore
            .collection('discussions')
            .doc(communityName)
            .collection('members')
            .doc(currentUserID)
            .set({'userId': currentUserID});

        print('User added to the community');
        setState(() {
          isMember = true;
        });
      } else {
        await _firestore
            .collection('discussions')
            .doc(communityName)
            .collection('members')
            .doc(currentUserID)
            .delete();

        print('User removed from the community');
        setState(() {
          isMember = false;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error manipulating member list: $e');
    }
  }

  void checkIfMember() async {
    print(isMember);
    final _firestore = FirebaseFirestore.instance;
    final User user =
        Provider.of<CurrentUser>(context as BuildContext, listen: false)
            .currentUser;
    final String communityName = widget.community.name;
    try {
      final snapshot = await _firestore
          .collection('discussions')
          .doc(communityName)
          .collection('members')
          .where('userID', isEqualTo: user.id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        isMember = true;
      } else {
        isMember = false;
      }
    } catch (e) {
      print(e);
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
            // IconButton(
            //     icon: Icon(Icons.people),
            //     onPressed: () {
            //       Scaffold.of(context).openDrawer();
            //     }),
            // IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
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
                stream:
                    FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  membersData = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: membersData.length,
                    itemBuilder: (context, index) {
                      final data = membersData[index];
                      return ListTile(
                        title: Text(data['fullName']),
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
                          Text(
                            "${membersData.length} active members",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
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
                      "Add Posts",
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
                            ),
                          ),
                        );
                      },
                      child: DiscussionPost(discussion: postsData[index]),
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
