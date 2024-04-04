import 'package:alumnet/repository/auth_repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class God {
  User? getGod() {
    User? currentUser = AuthRepo.instance.currentUser;
    return currentUser;
  }
}
