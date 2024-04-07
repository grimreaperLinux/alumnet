import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostItem {
  String id;
  final String userId;
  final DateTime timeOfCreation;
  final String text;
  List<String> images = [];
  List<String> likes = [];
  List<Comment> comments = [];
  final int noOfShares;
  List<PostLink> links = [];
  List<Attachment> attachments = [];

  PostItem({
    required this.userId,
    required this.timeOfCreation,
    required this.text,
    this.noOfShares = 0,
    this.id = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'timeOfCreation': timeOfCreation.toIso8601String(),
      'text': text,
      'images': images,
      'likes': likes,
      'noOfShares': noOfShares,
      'links': links.map((link) => link.toJson()).toList(),
      'attachments': attachments.map((attachment) => attachment.toJson()).toList(),
    };
  }

  factory PostItem.fromFirestore(Map<String, dynamic> snapshot, String snapshotId, bool snapshotExists) {
    final data = snapshot;
    if (!snapshotExists) throw Exception('Snapshot data is null');

    PostItem newPost = PostItem(
      id: snapshotId,
      userId: data['userId'],
      timeOfCreation: DateTime.parse(data['timeOfCreation']),
      text: data['text'],
      noOfShares: data['noOfShares'] ?? 0,
    );

    newPost.attachments = (data['attachments'] as List<dynamic>?)?.map((item) => Attachment.fromJson(item)).toList() ?? [];
    newPost.links = (data['links'] as List<dynamic>?)?.map((item) => PostLink.fromJson(item)).toList() ?? [];
    newPost.comments = (data['comments'] as List<dynamic>?)?.map((item) => Comment.fromJson(item)).toList() ?? [];
    newPost.images = List<String>.from(data['images'] ?? []);
    newPost.likes = List<String>.from(data['likes'] ?? []);

    return newPost;
  }
}

class Comment {
  final String userId;
  final String comment;
  final DateTime timeOfComment;

  Comment({required this.userId, required this.comment, required this.timeOfComment});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'comment': comment,
      'timeOfComment': timeOfComment.toIso8601String(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['userId'],
      comment: json['comment'],
      timeOfComment: DateTime.parse(json['timeOfComment']),
    );
  }
}

class PostLink {
  final String link;
  final String text;

  PostLink({required this.link, required this.text});

  factory PostLink.fromJson(Map<String, dynamic> json) {
    return PostLink(
      link: json['link'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'text': text,
    };
  }
}

class Attachment {
  final String name;
  final String downloadUrl;

  Attachment({required this.name, required this.downloadUrl});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'downloadUrl': downloadUrl,
    };
  }

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      name: json['name'],
      downloadUrl: json['downloadUrl'],
    );
  }
}

class PostList extends ChangeNotifier {
  final List<PostItem> _postList = [];

  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentSnapshot? _lastDocument;
  bool hasMorePosts = true;

  List<PostItem> get postList {
    return [..._postList];
  }

  Future<void> createPostItem(PostItem post) async {
    try {
      DocumentReference documentRef = await db.collection('posts').add(post.toJson());
      post.id = documentRef.id;
      _postList.add(post);
      print(_postList);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> getPosts() async {
    if (!hasMorePosts) return;

    var query = db.collection('posts').orderBy('timeOfCreation', descending: true).limit(5);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      QuerySnapshot querySnapshot = await query.get();
      var documents = querySnapshot.docs;

      if (documents.isEmpty) {
        hasMorePosts = false;
        notifyListeners();
        return;
      }

      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }

      _lastDocument = documents.last;
      var posts = documents.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return PostItem.fromFirestore(data, doc.id, doc.exists);
      }).toList();
      _postList.addAll(posts);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
