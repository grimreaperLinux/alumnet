import 'package:alumnet/constants/image_strings.dart';
import 'package:alumnet/constants/sizes.dart';
import 'package:alumnet/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alumnet/features/auth/screens/login/login.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: [
            Positioned(
              top: 25,
              left: 5,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            Positioned(
              top: 25,
              right: 15,
              child: Image(
                image: AssetImage(tWelcomeScreenImage),
                height: 50,
                width: 50,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(tDefaultSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1
                  SizedBox(height: tFormHeight * 5),
                  Text(tSignUp, style: Theme.of(context).textTheme.headline1),
                  // Section 2
                  Form(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: tFormHeight - 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: tName,
                              hintText: tName,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: tFormHeight - 20),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: tEmail,
                              hintText: tEmail,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: tFormHeight - 20),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.numbers),
                              labelText: tUserId,
                              hintText: tUserId,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: tFormHeight - 20),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: tPassword,
                              hintText: tPassword,
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          const SizedBox(height: tFormHeight - 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(tSignUp.toUpperCase()),
                            ),
                          ),
                          const SizedBox(height: tFormHeight),
                          Center(
                            child: TextButton(
                              onPressed: () =>
                                  Get.to(() => const LoginScreen()),
                              child: Text.rich(
                                TextSpan(
                                  text: tAlreadyHaveAnAccount,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  children: const [
                                    TextSpan(
                                      text: tLogin,
                                      style: TextStyle(color: Colors.blue),
                                    ) // TextSpan
                                  ],
                                ), // TextSpan
                              ), // Text.rich
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]
          ),
        ),
      ),
    );
  }
}
