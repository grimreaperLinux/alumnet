import 'package:flutter/material.dart';

class User {
  final String id;
  String profilepic = '';
  final String name;
  String username = '';
  List<String> likedPosts = [];
  String batch = '';
  String about = '';
  String branch = '';
  final String email;
  String instituteId = '';

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
    user.likedPosts = [];

    return user;
  }
}

class CurrentUser extends ChangeNotifier {
  final List<User> _currentUser = [];

  User get currentUser => _currentUser[0];

  void setCurrentUser(Map<String, dynamic> userData) {
    _currentUser.add(User(
      name: userData['fullName'],
      id: userData['id'],
      email: userData['email'],
      instituteId: userData['instituteId'],
    ));

    print(currentUser.instituteId);
  }
}
