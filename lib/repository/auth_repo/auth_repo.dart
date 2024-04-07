import 'package:alumnet/features/auth/screens/welcome/welcome.dart';
import 'package:alumnet/home.dart';
import 'package:alumnet/repository/auth_repo/exceptions/signup_failure.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    Map<String, dynamic>? userDoc = await getUserByEmail(user == null ? '' : user.email as String);
    user == null ? Get.offAll(() => const WelcomeScreen()) : Get.offAll(() => AlumnetHome(userDoc: userDoc as Map<String, dynamic>));
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
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

  Future<void> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Map<String, dynamic>? userDoc = await getUserByEmail(email);
      firebaseUser.value != null ? Get.offAll(() => AlumnetHome(userDoc: userDoc as Map<String, dynamic>)) : Get.to(() => WelcomeScreen());
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

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message.toString());
    } catch (_) {
      Get.snackbar('Error', _.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var userData = doc.data() as Map<String, dynamic>;
        // Include the document ID in the userData map
        userData['id'] = doc.id;
        return userData;
      } else {
        print('User not found with email: $email');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where('instituteId', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return userData;
      } else {
        print('User not found with id: $id');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  loginWithIdAndPassword(String id, String password) async {
    // Implement login with id and password
    Future<Map<String, dynamic>?> user = AuthRepo.instance.getUserById(id);

    user.then((userData) {
      if (userData != null) {
        // User data retrieved successfully, you can now use userData map
        loginUserWithEmailAndPassword(userData['email'], password);
      } else {
        // User not found or error occurred during data retrieval
        Get.snackbar('Error', 'User not found');
      }
    }).catchError((error) {
      // Handle error if any
      Get.snackbar('Error', 'Error fetching user data: $error');
    });
  }

  Future<Map<String, dynamic>?> getUserByIdEmail(String id, String email) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Users').where('instituteId', isEqualTo: id).where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return userData;
      } else {
        print('User not found with id: $id');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
