import 'package:flutter/material.dart';

class CommentsModal extends StatefulWidget {
  @override
  _CommentsModalState createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  final TextEditingController _commentController = TextEditingController();

  // Dummy data for comments
  final List<Map<String, dynamic>> comments = [
    {
      'author': 'Diana Ross',
      'text': 'Like another day another fight. Next day, we will rise again.',
      'replies': [
        {'author': 'Arun Krishnan', 'text': 'Here\'s my reply.', 'likes': 26},
      ],
      'likes': 120,
      'time': 'Yesterday',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16), // Reduce space on top
              Text(
                'Comments',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    // ... Comment and reply rendering
                  },
                ),
              ),
              Padding(
                // Add padding equal to the keyboard height when it's visible
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        // TODO: Implement sending a comment
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> comment;
  final bool isChild;

  const CommentCard({
    Key? key,
    required this.comment,
    this.isChild = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment['author'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(comment['text']),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(comment['time'] ?? 'Just now'),
                if (!isChild) ...[
                  TextButton(
                    onPressed: () {
                      // TODO: Implement reply to comment
                    },
                    child: Text('Reply'),
                  ),
                ],
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined, size: 16),
                    SizedBox(width: 4),
                    Text('${comment['likes'] ?? 0}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
