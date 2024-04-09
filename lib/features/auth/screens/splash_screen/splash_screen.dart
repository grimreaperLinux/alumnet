import 'package:alumnet/constants/image_strings.dart';
import 'package:alumnet/constants/text_strings.dart';
import 'package:alumnet/constants/sizes.dart';
import 'package:alumnet/constants/colors.dart';
import 'package:alumnet/features/auth/controllers/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  // ignore: use_super_parameters
  SplashScreen({Key? key}) : super(key: key);

  final splashScreenController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashScreenController.startAnimation();
    return Scaffold(
      body: Stack(
        children: [
          // Obx(
          //   () => AnimatedPositioned(
          //     duration: const Duration(seconds: 1),
          //     top: splashScreenController.animate.value ? 0 : -30,
          //     left: splashScreenController.animate.value ? 0 : -30,
          //     child: const Image(
          //       image: AssetImage(tSplashScreenTopIcon),
          //     ),
          //   ),
          // ),
          // Obx(
          //   () => AnimatedPositioned(
          //     duration: const Duration(seconds: 1),
          //     top: 80,
          //     left: splashScreenController.animate.value ? tDefaultSize : -80,
          //     child: AnimatedOpacity(
          //       duration: const Duration(milliseconds: 2000),
          //       opacity: splashScreenController.animate.value ? 1 : 0,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             tAppName,
          //             style: Theme.of(context).textTheme.headline3,
          //           ),
          //           Text(
          //             tAppTagLine,
          //             style: Theme.of(context).textTheme.headline2,
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Center(
                child: const Image(
                  image: AssetImage(tSplashImage),
                ),
              ),
            ),
          // Obx(
          //   () => AnimatedPositioned(
          //     duration: const Duration(seconds: 2),
          //     bottom: splashScreenController.animate.value ? 60 : 0,
          //     right: tDefaultSize,
          //     child: AnimatedOpacity(
          //       duration: const Duration(milliseconds: 2000),
          //       opacity: splashScreenController.animate.value ? 1 : 0,
          //       child: Container(
          //         width: tSplashContainerSize,
          //         height: tSplashContainerSize,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(100),
          //           color: tPrimaryColor,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
