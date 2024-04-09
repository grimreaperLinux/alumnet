import 'package:alumnet/models/user.dart';
import 'package:flutter/material.dart';

class Comment {
  final String id;
  final User user; //
  final String content;
  final DateTime time;

  Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.time,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'content': content,
      'time': time.toIso8601String(),
    };
  }
}
