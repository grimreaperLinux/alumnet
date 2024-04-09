import 'package:alumnet/models/discussion.dart';
import 'package:flutter/material.dart';

class DiscussionPost extends StatelessWidget {
  final Discussion discussion;
  DiscussionPost({required this.discussion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(discussion.postedBy.profilepic),
                radius: 20,
              ),
              SizedBox(width: 8),
              Text(
                discussion.postedBy.name,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "5h",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          Text(
            discussion.headline,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.message),
              SizedBox(width: 4),
              // Text(discussion.comments.length.toString()),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
