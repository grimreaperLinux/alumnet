import 'package:alumnet/features/auth/screens/welcome/welcome.dart';
import 'package:alumnet/home.dart';
import 'package:alumnet/repository/auth_repo/exceptions/signup_failure.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 3000));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        : Get.offAll(() => AlumnetHome());
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpFailure.code(e.code);
      Get.snackbar('Error', ex.message);
      throw ex;
    } catch (e) {
      const ex = SignUpFailure();
      Get.snackbar('Error', ex.message);
      throw ex;
    }
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => AlumnetHome())
          : Get.to(() => WelcomeScreen());
    } catch (_) {
      Get.snackbar('Error', "Invalid id or password");
      throw _;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (_) {
      Get.snackbar('Error', _.toString());
    }
  }

}
