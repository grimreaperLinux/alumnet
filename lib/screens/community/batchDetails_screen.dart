import 'package:alumnet/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BatchDetails extends StatefulWidget {
  final String branch;
  final String batch;

  BatchDetails({required this.branch, required this.batch});

  @override
  State<BatchDetails> createState() => _BatchDetailsState();
}

class _BatchDetailsState extends State<BatchDetails> {
  List<User> data = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .doc(widget.branch)
        .collection('batches')
        .doc(widget.batch)
        .collection("users")
        .get();

    setState(() {
      data = querySnapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.branch}: ${widget.batch}"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: data.length, // Adjust this according to your actual data
          itemBuilder: (context, index) {
            return UserLink(user: data[index]);
          },
        ),
      ),
    );
  }
}

class UserLink extends StatelessWidget {
  final User user;

  UserLink({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage(user.profilepic),
          child: Icon(Icons.person),
        ),
        SizedBox(height: 8),
        Column(
          children: [
            Text(
              user.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "@${user.username}",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
