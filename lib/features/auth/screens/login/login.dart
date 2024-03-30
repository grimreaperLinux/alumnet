import 'package:alumnet/constants/image_strings.dart';
import 'package:alumnet/constants/sizes.dart';
import 'package:alumnet/constants/text_strings.dart';
import 'package:alumnet/features/auth/controllers/login_controller.dart';
import 'package:alumnet/features/auth/screens/forgot_password/forgot_id_mail.dart';
import 'package:alumnet/features/auth/screens/forgot_password/forgot_password_mail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alumnet/features/auth/screens/signup/signup.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  Text(tLogin, style: Theme.of(context).textTheme.headline1),
                  // Section 2
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: tFormHeight - 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: controller.id,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: tUserId,
                              hintText: tUserId,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: tFormHeight - 20),
                          TextFormField(
                            controller: controller.password,
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  LoginController.instance.logInUser(
                                      controller.id.text.trim(),
                                      controller.password.text.trim());
                                }
                              },
                              child: Text(tLogin.toUpperCase()),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  builder: (context) => Container(
                                    height: tDefaultSize * 12,
                                    padding: const EdgeInsets.all(tDefaultSize),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(tForgetPasswordTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2),
                                        // Text(tForgetPasswordSubTitle,
                                        //     style: Theme.of(context)
                                        //         .textTheme
                                        //         .bodyText2),
                                        const SizedBox(height: 30.0),
                                        GestureDetector(
                                          onTap: () =>
                                              Get.to(ForgotPasswordEmail()),
                                          child: Container(
                                            padding: const EdgeInsets.all(20.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.grey.shade200,
                                            ), // BoxDecoration
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.mail_outline_rounded,
                                                    size: 60.0),
                                                const SizedBox(width: 10.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(tEmail,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6),
                                                    Text(tResetViaEMail,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2)
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        GestureDetector(
                                          onTap: () => Get.to(ForgotIdEmail()),
                                          child: Container(
                                            padding: const EdgeInsets.all(20.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.grey.shade200,
                                            ), // BoxDecoration
                                            child: Row(
                                              children: [
                                                const Icon(Icons.person,
                                                    size: 60.0),
                                                const SizedBox(width: 10.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(tUserId,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6),
                                                    Text(tIdViaEmail,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2)
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Text(tForgetPassword),
                            ),
                          ),
                          const SizedBox(height: tFormHeight * 3.5),
                          Center(
                            child: TextButton(
                              onPressed: () =>
                                  Get.to(() => const SignUpScreen()),
                              child: Text.rich(
                                TextSpan(
                                  text: tDontHaveAnAccount,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  children: const [
                                    TextSpan(
                                      text: tSignUp,
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
