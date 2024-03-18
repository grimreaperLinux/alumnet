import 'package:alumnet/models/user.dart';

class PostItem {
  late String id;
  final User user;
  final DateTime timeOfCreation;
  final String text;
  List<String> images = [];
  final int likes;
  final List<Comment> comments;
  final int noOfShares;

  PostItem({
    required this.user,
    required this.timeOfCreation,
    required this.text,
    required this.likes,
    required this.comments,
    required this.noOfShares,
  });
}

class Comment {
  late String id;
  final User user;
  final String comment;
  final DateTime timeOfComment;

  Comment({
    required this.user,
    required this.comment,
    required this.timeOfComment,
  });
}

class PostLink {
  final String link;
  final String text;

  PostLink({required this.link, required this.text});
}
