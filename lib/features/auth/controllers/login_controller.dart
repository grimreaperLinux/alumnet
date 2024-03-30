import 'package:alumnet/repository/auth_repo/auth_repo.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final password = TextEditingController();
  final id = TextEditingController();

  void logInUser(String id, String password) {
    AuthRepo.instance.loginUserWithEmailAndPassword(id, password);
  }
}
