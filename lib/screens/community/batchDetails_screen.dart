import 'package:alumnet/models/user.dart';
import 'package:flutter/material.dart';

class BatchDetails extends StatelessWidget {
  final String branch;
  final String batch;

  BatchDetails({required this.branch, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$branch: $batch"),
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
          itemCount: 8, // Adjust this according to your actual data
          itemBuilder: (context, index) {
            return UserLink(
              user: User(
                  name: "Aman Gupta",
                  profilepic: "",
                  username: "20bds024",
                  batch: "2024",
                  about: ""),
            );
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
              "@${user.id}",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
