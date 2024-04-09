import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  String profilepic = '';
  final String name;
  String username = '';
  String batch = '';
  String about = '';
  String branch = '';
  final String email;
  String instituteId = '';
  List<String> savedPosts = [];

  User({
    required this.name,
    this.username = '',
    required this.id,
    required this.email,
    this.batch = '',
    this.about = '',
    this.branch = '',
    this.instituteId = '',
    this.profilepic = '',
  });

  factory User.fromdummyData() {
    User user = User(name: 'Aniket Raj', id: 'this_is_a_special_id', email: 'ani9431619703@gmail.com', username: 'grimreaperLinux');
    user.batch = '2024';
    user.about = 'Genius, Billionaire, Playboy, Philanthropist';
    user.branch = "DSAI";
    user.profilepic =
        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D';

    return user;
  }

  factory User.fromFirestore(Map<String, dynamic> data, String documentId) {
    User user = User(
      id: documentId,
      name: data['fullName'] ?? '',
      email: data['email'] ?? '',
      profilepic: data['profilepic'] ?? '',
    );

    user.savedPosts = List<String>.from(data['savedPosts'] ?? []);
    return user;
  }
}

class CurrentUser extends ChangeNotifier {
  final List<User> _currentUser = [];

  User get currentUser => _currentUser[0];
  FirebaseFirestore db = FirebaseFirestore.instance;

  void setCurrentUser(Map<String, dynamic> userData) {
    User user = User(
      name: userData['fullName'],
      id: userData['id'],
      email: userData['email'],
      instituteId: userData['instituteId'],
    );

    user.savedPosts = List<String>.from(userData['savedPosts'] ?? []);
    _currentUser.add(user);

    print(currentUser.savedPosts);
  }

  Future<void> toggleSavePost(String postId, bool isSaved) async {
    try {
      DocumentReference userRef = db.collection('Users').doc(currentUser.id);
      if (isSaved) {
        await userRef.update({
          'savedPosts': FieldValue.arrayUnion([postId]),
        });
      } else {
        await userRef.update({
          'savedPosts': FieldValue.arrayRemove([postId]),
        });
      }

      if (isSaved) {
        _currentUser[0].savedPosts.add(postId);
      } else {
        _currentUser[0].savedPosts.remove(postId);
      }
      notifyListeners();
    } catch (e) {
      print("Error toggling like for post: $e");
    }
  }
}
