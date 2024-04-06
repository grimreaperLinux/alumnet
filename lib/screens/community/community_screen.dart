import 'package:alumnet/models/community.dart';
import 'package:alumnet/screens/community/batchList_screen.dart';
import 'package:alumnet/screens/community/discussion_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final List<Community> communityData = [
    Community(name: "Open Source", image: "", activeMembers: 220),
    Community(name: "Web3", image: "", activeMembers: 120),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
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
                addUsersToFirebase();
              },
              child: Text('Add users to Firebase'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
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
            ),
            Text(
              "Communities",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
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
            )
          ],
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
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.cloud),
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
                Text(
                  'Type: Verified',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  communityData.activeMembers.toString(),
                  style: TextStyle(fontSize: 20),
                ),
                Text('Active Members', style: TextStyle(fontSize: 12)),
              ],
            ),
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
