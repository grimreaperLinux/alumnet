import 'package:alumnet/models/community.dart';
import 'package:alumnet/models/user.dart';
import 'package:alumnet/screens/community/batchList_screen.dart';
import 'package:alumnet/screens/community/discussion_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                ),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BatchList(
                              branch: index == 2
                                  ? "ECE"
                                  : index == 1
                                      ? "CSE"
                                      : index == 0
                                          ? "DSAI"
                                          : ""),
                        ),
                      );
                    },
                    child: DepartmentBlock(
                        text: index == 3
                            ? "PhD Students"
                            : index == 4
                                ? "Faculty"
                                : index == 2
                                    ? "ECE"
                                    : index == 1
                                        ? "CSE"
                                        : index == 0
                                            ? "DSAI"
                                            : ""),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                "Discover Communities",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('discussions')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("Be the first one to comment"));
                    }
                    final communityData = snapshot.data!.docs;
                    final communities = communityData
                        .map((doc) => Community.fromMap(
                            doc.data() as Map<String, dynamic>))
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: communityData.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DiscussionScreen(community: community),
                              ),
                            );
                          },
                          child: CommunityBlock(communityData: community),
                        );
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class DepartmentBlock extends StatelessWidget {
  final String text;

  DepartmentBlock({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            blurRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class CommunityBlock extends StatefulWidget {
  final Community communityData;

  CommunityBlock({required this.communityData});

  @override
  _CommunityBlockState createState() => _CommunityBlockState();
}

class _CommunityBlockState extends State<CommunityBlock> {
  bool isMember = false;

  @override
  void initState() {
    super.initState();
    checkIfMember();
  }

  void checkIfMember() async {
    final currentUser =
        Provider.of<CurrentUser>(context, listen: false).currentUser;
    final communityName = widget.communityData.name;

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
    final communityName = widget.communityData.name;

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
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.communityData.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.communityData.activeMembers} Active Members',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: manipulateMemberList,
                  child: Text(
                    isMember ? "Joined" : "Join",
                    style: TextStyle(
                      color: isMember ? Colors.black : Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 30),
                    backgroundColor: isMember ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
            Text(widget.communityData.bio),
          ],
        ),
      ),
    );
  }
}
