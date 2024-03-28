import 'package:alumnet/constants/image_strings.dart';
import 'package:alumnet/constants/sizes.dart';
import 'package:alumnet/constants/text_strings.dart';
import 'package:alumnet/features/auth/screens/login/login.dart';
import 'package:alumnet/features/auth/screens/signup/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage(tWelcomeScreenImage),
              height: height * 0.6,
            ),
            Column(
              children: [
                Text(
                  tWelcomeTitle,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  tWelcomeSubTitle,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => const LoginScreen()),
                    style: Theme.of(context).outlinedButtonTheme.style,
                    child: Text(
                      tLogin.toUpperCase(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const SignUpScreen()),
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: Text(
                      tSignUp.toUpperCase(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
