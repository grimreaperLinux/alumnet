import 'package:alumnet/models/community.dart';
import 'package:alumnet/models/discussion.dart';
import 'package:alumnet/models/user.dart';
import 'package:alumnet/screens/community/discussion_detail_screen.dart';
import 'package:alumnet/screens/community/services/discussion_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiscussionPost extends StatefulWidget {
  final Discussion discussion;
  final Community community;
  DiscussionPost({required this.discussion, required this.community});

  @override
  _DiscussionPostState createState() => _DiscussionPostState();
}

class _DiscussionPostState extends State<DiscussionPost> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final User currentUser = Provider.of<CurrentUser>(context).currentUser;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.discussion.postedBy.profilepic),
                radius: 20,
              ),
              SizedBox(width: 8),
              Text(
                widget.discussion.postedBy.name,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 8),
              Text(
                timeago.format(
                    DateTime.parse(
                        widget.discussion.postedAt.toIso8601String()),
                    locale: 'en_short'),
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
            widget.discussion.headline,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  setState(() {
                    isLiked = !isLiked;
                  });
                  final discussionId = widget.discussion.id;
                  final communityId = widget.community.name;
                  final userId = currentUser.id;
                  if (isLiked) {
                    try {
                      await DiscussionService().addLikeToDiscussion(
                          communityId, discussionId, userId);
                    } catch (e) {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    }
                  } else {
                    try {
                      await DiscussionService().removeLikeFromDiscussion(
                          communityId, discussionId, userId);
                    } catch (e) {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    }
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                    ),
                    SizedBox(width: 4),
                    Text("${widget.discussion.likes?.length ?? 0}"),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscussionDetailScreen(
                        discussion: widget.discussion,
                        community: widget.community,
                        currentLevel: 0,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.message),
                    SizedBox(width: 4),
                    Text("Comment"),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
