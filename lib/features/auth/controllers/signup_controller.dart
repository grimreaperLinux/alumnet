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

  Future<void> createUser(UserModel usermodel) async {
    try {
      Future<Map<String, dynamic>?> user1 =
          AuthRepo.instance.getUserById(usermodel.instituteId);
      Future<Map<String, dynamic>?> user2 =
          AuthRepo.instance.getUserByEmail(usermodel.email);
      user2.then((value) async {
        if (value != null) {
          Get.snackbar('Error', 'User with Email already exists');
          return;
        } else {
          user1.then((value) async {
            if (value == null) {
              await userRepo.instance.createUser(UserModel(
                email: email.text,
                fullName: fullName.text,
                instituteId: id.text,
                password: password.text,
              ));
              String? error = await AuthRepo.instance
                  .createUserWithEmailAndPassword(
                      usermodel.email, usermodel.password) as String?;
              if (error != null) {
                throw error;
              }
            } else {
              Get.snackbar('Error', 'User with Institute Id already exists');
            }
          });
        }
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
