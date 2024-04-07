import 'package:flutter/material.dart';

Widget buildTimeAgoText(DateTime timeString) {
  final inputTime = timeString.toLocal();
  final currentTime = DateTime.now();

  final difference = currentTime.difference(inputTime);

  String formattedTime;
  if (difference.inDays > 0) {
    formattedTime = '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    formattedTime = '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    formattedTime = '${difference.inMinutes}m ago';
  } else {
    formattedTime = '${difference.inSeconds}s ago';
  }

  return Text(formattedTime);
}
