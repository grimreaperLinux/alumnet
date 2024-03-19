import 'package:alumnet/models/user.dart';

class PostItem {
  late String id;
  final User user;
  final DateTime timeOfCreation;
  final String text;
  List<String> images = [];
  final int likes;
  List<Comment> comments = [];
  final int noOfShares;
  List<PostLink> links = [];
  List<String> attachments = [];

  PostItem({
    required this.user,
    required this.timeOfCreation,
    required this.text,
    this.likes = 0,
    this.noOfShares = 0,
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
