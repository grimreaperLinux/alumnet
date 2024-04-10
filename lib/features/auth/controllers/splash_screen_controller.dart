// import 'package:alumnet/features/auth/screens/welcome/welcome.dart';
import 'package:alumnet/features/auth/screens/on_boarding/on_boarding_screen.dart';
import 'package:alumnet/features/auth/screens/welcome/welcome.dart';
import 'package:get/get.dart';
import 'package:alumnet/home.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(seconds: 5));
    // Get.to(OnBoardingScreen());
  }
}
