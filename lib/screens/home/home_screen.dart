import 'package:alumnet/screens/home/create_post_screen.dart';
import 'package:alumnet/widgets/feed_post.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "What's New",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PostCreationScreen.routename);
                  },
                  icon: const Icon(Icons.add_box_rounded))
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SocialCard(
                    hello: true,
                  ),
                  SocialCard(
                    hello: false,
                  ),
                  // Add more SocialCard widgets as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
