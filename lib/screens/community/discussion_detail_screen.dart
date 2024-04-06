import 'package:alumnet/models/community.dart';
import 'package:alumnet/models/discussion.dart';
import 'package:flutter/material.dart';

class DiscussionDetailScreen extends StatefulWidget {
  final Discussion discussion;
  final Community community;

  DiscussionDetailScreen({required this.discussion, required this.community});

  @override
  _DiscussionDetailViewState createState() => _DiscussionDetailViewState();
}

class _DiscussionDetailViewState extends State<DiscussionDetailScreen> {
  String comment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Spacer(),
                        Icon(Icons.search),
                        SizedBox(width: 20),
                        Icon(Icons.share),
                        SizedBox(width: 20),
                        Icon(Icons.more_vert),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          'https://via.placeholder.com/150',
                          width: 35,
                          height: 35,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.community.name),
                            Row(
                              children: [
                                Text(
                                  widget.discussion.postedBy.name,
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '5h',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    Text(
                      widget.discussion.headline,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // getContent(),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.message),
                      label: Text(widget.discussion.activityCount.toString()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add a Comment',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  comment = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.discussion.content.elements.map((element) {
        switch (element.type) {
          case ContentType.text:
            return Text(element.value);
          case ContentType.link:
            return InkWell(
              onTap: () {},
              child: Text(element.value),
            );
          case ContentType.image:
            return Image.network(element.value);
        }
      }).toList(),
    );
  }
}
