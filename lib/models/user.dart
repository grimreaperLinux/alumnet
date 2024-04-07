import 'package:flutter/material.dart';

class User {
  final String id;
  String profilepic;
  final String name;
  String username;
  List<String> likedPosts;
  String batch;
  String about;
  String branch;
  final String email;
  String instituteId;

  User({
    required this.name,
    required this.id,
    required this.email,
    this.username = '',
    this.batch = '',
    this.about = '',
    this.branch = '',
    this.instituteId = '',
    this.profilepic = '',
    this.likedPosts = const [],
  });

  factory User.fromDummyData() {
    return User(
      name: 'Aniket Raj',
      id: 'this_is_a_special_id',
      email: 'ani9431619703@gmail.com',
      username: 'grimreaperLinux',
      batch: '2024',
      about: 'Genius, Billionaire, Playboy, Philanthropist',
      branch: "DSAI",
      profilepic:
          'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
      likedPosts: [],
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      profilepic: map['profilepic'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      batch: map['batch'] ?? '',
      about: map['about'] ?? '',
      branch: map['branch'] ?? '',
      email: map['email'] ?? '',
      instituteId: map['instituteId'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profilepic': profilepic,
      'name': name,
      'username': username,
      'batch': batch,
      'about': about,
      'branch': branch,
      'email': email,
      'instituteId': instituteId,
    };
  }
}

class CurrentUser extends ChangeNotifier {
  late User _currentUser;

  User get currentUser => _currentUser;

  void setCurrentUser(Map<String, dynamic> userData) {
    _currentUser = User(
      name: userData['fullName'] ?? '',
      id: userData['id'] ?? '',
      email: userData['email'] ?? '',
      instituteId: userData['instituteId'] ?? '',
      profilepic: userData['profilepic'] ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtvL6ttzTju01j4VLLzVJNVxjUyMe08UQt_5bdnyHjIQ&s',
      about: userData['about'] ?? '',
      batch: userData['batch'] ?? '',
    );

    print(currentUser.instituteId);
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': _currentUser.name,
      'profilepic': _currentUser.profilepic,
      'username': _currentUser.username,
      'batch': _currentUser.batch,
      'about': _currentUser.about,
    };
  }
}
