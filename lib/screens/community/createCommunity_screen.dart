import 'package:alumnet/models/community.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateCommunityScreen extends StatefulWidget {
  @override
  _CreateCommunityScreenState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  TextEditingController _communityNameController = TextEditingController();
  TextEditingController _communityBioController = TextEditingController();
  bool _onlyForSameBatch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _communityNameController,
              decoration: InputDecoration(
                labelText: 'Community Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _communityBioController,
              decoration: InputDecoration(
                labelText: 'Community Bio',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Only For Same Batch'),
                Spacer(),
                Switch(
                  value: _onlyForSameBatch,
                  onChanged: (value) {
                    setState(() {
                      _onlyForSameBatch = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addCommunity();
                Navigator.pop(context);
              },
              child: Text('Create Community'),
            ),
          ],
        ),
      ),
    );
  }

  void addCommunity() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    String communityName = _communityNameController.text;
    String communityBio = _communityBioController.text;

    final communityData = Community(
      name: communityName,
      bio: communityBio,
      image: "",
      activeMembers: 1,
    );

    try {
      await _firestore
          .collection('discussions/')
          .doc(communityName)
          .set(communityData.toMap());
      print('Community added successfully.');
    } catch (e) {
      print('Error adding community: $e');
    }
  }
}
