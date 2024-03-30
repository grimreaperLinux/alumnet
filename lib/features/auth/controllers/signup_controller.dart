import 'package:alumnet/features/auth/models/user_model.dart';
import 'package:alumnet/repository/auth_repo/auth_repo.dart';
import 'package:alumnet/repository/user_repo/user_repo.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final id = TextEditingController();

  final userRepo = Get.put(UserRepo());

  Future<void> registerUser(String email, String password) async {
    String? error = await AuthRepo.instance
        .createUserWithEmailAndPassword(email, password) as String?;

    if (error != null) {
      // Get.showSnackbar(GetSnackBar(
      //   message: error.toString(),
      // ));
      throw error;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await registerUser(user.email, user.password);
      await userRepo.instance.createUser(UserModel(
        email: email.text,
        password: password.text,
        fullName: fullName.text,
        instituteId: id.text,
      ));
    } catch (e) {
      print(e.toString());
    }
  }
}
