import 'package:alumnet/repository/auth_repo/auth_repo.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ForgotIdController extends GetxController {
  static ForgotIdController get instance => Get.find();

  final email = TextEditingController();

  void forgotId(String email) {
    Future<Map<String, dynamic>?> user =
        AuthRepo.instance.getUserByEmail(email);
    user.then((userData) {
      if (userData != null) {
        // User data retrieved successfully, you can now use userData map
        Get.snackbar('Success', 'Your ID is ${userData['instituteId']}',
            duration: const Duration(seconds: 5));
      } else {
        // User not found or error occurred during data retrieval
        Get.snackbar('Error', 'User not found');
      }
    }).catchError((error) {
      // Handle error if any
      Get.snackbar('Error', 'Error fetching user data: $error');
    });
  }
}
