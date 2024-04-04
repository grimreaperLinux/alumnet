import 'package:alumnet/repository/auth_repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class God {
  Future<Map<String, dynamic>?> getGod() async {
    User? currentUser = AuthRepo.instance.currentUser;
    Map<String, dynamic>? fireStoreUser;
    await AuthRepo.instance.getUserByEmail(currentUser!.email!).then((user) {
      fireStoreUser = user;
    }).catchError((error) {
      print("Error fetching user data: $error");
    });
    return fireStoreUser;
  }
}
