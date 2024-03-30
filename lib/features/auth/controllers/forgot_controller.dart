import 'package:alumnet/repository/auth_repo/auth_repo.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ForgotController extends GetxController {
  static ForgotController get instance => Get.find();

  final email = TextEditingController();

  void resetPassword(String email) {
    AuthRepo.instance.forgotPassword(email);
  }
}
