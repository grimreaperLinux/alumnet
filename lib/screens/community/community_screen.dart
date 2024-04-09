import 'package:alumnet/models/community.dart';
import 'package:alumnet/screens/community/batchList_screen.dart';
import 'package:alumnet/screens/community/discussion_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Community> communityData = [];

  @override
  initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('discussions').get();

    setState(() {
      communityData = querySnapshot.docs
          .map((doc) => Community.fromMap(doc.data()))
          .toList();
    });
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
              TextButton(
                onPressed: () {
                  addCommunitiesToFirebase();
                },
                child: Text('Add Communities to Firebase'),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 5, // Assuming there are 5 departments
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BatchList(
                              branch: index == 3
                                  ? "PhD"
                                  : index == 4
                                      ? "Faculty"
                                      : index == 2
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: communityData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DiscussionScreen(community: communityData[index]),
                        ),
                      );
                    },
                    child: CommunityBlock(communityData: communityData[index]),
                  );
                },
              ),
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
        child: Text(text),
      ),
    );
  }
}

class CommunityBlock extends StatelessWidget {
  final Community communityData;

  CommunityBlock({required this.communityData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
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
                      communityData.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${communityData.activeMembers} Active Members',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Join",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(60, 30),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ],
            ),
            Text(communityData.bio),
          ],
        ),
      ),
    );
  }
}

void addUsersToFirebase() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    List<Map<String, dynamic>> userData = [
      {
        "name": 'Aniket Raj',
        "profilepic":
            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
        "username": '20bds007',
        "batch": '2024',
        "about": 'FatAss, Genius, Billionaire, Playboy, Philanthropist',
      },
      {
        "name": 'Aman Gupta',
        "profilepic":
            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
        "username": '20bds024',
        "batch": '2024',
        "about": 'FatAss, Genius, Billionaire, Playboy, Philanthropist',
      },
      {
        "name": 'Chirag Mittal',
        "profilepic":
            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
        "username": '20bds017',
        "batch": '2024',
        "about": 'FatAss, Genius, Billionaire, Playboy, Philanthropist',
      },
      {
        "name": 'Devansh Purvar',
        "profilepic":
            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
        "username": '20bds018',
        "batch": '2024',
        "about": 'FatAss, Genius, Billionaire, Playboy, Philanthropist',
      },
    ];

    for (var userData in userData) {
      String collectionPath = 'users/DSAI/batches/Batch 2024';
      String documentID = userData['username'];
      await _firestore
          .collection(collectionPath + '/users')
          .doc(documentID)
          .set(userData);
    }
  } catch (error) {
    print("Error:$error");
  }
}

void addCommunitiesToFirebase() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    List<Map<String, dynamic>> discussionData = [
      {
        "name": "Web 3",
        "bio":
            "The go-to place for web3 enthusiasts to indulge in juicy gossip.",
        "image": "",
        "activeMembers": 100,
      },
      {
        "name": "Open Source",
        "bio":
            "The go-to place for open source enthusiasts to indulge in juicy gossip.",
        "image": "",
        "activeMembers": 100,
      },
      {
        "name": "Apple Ecosystem",
        "bio": "The go-to place for apple fanboys to indulge in juicy gossip.",
        "image": "",
        "activeMembers": 120,
      }
    ];

    for (var discussion in discussionData) {
      String collectionPath = 'discussions/';
      String documentID = discussion['name'];
      await _firestore
          .collection(collectionPath)
          .doc(documentID)
          .set(discussion);
    }
  } catch (e) {
    print(e);
  }
}
