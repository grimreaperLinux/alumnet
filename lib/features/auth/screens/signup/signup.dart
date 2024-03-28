import 'package:alumnet/constants/image_strings.dart';
import 'package:alumnet/constants/sizes.dart';
import 'package:alumnet/constants/text_strings.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1
                Image(
                  image: AssetImage(tWelcomeScreenImage),
                  height: size.height * 0.2,
                ),
                Text(tSignUpTitle,
                    style: Theme.of(context).textTheme.headline1),
                Text(
                  tSignUpSubTitle,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                // Section 2
                Form(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: tFormHeight - 10),
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
                            onPressed: () {},
                            child: Text.rich(
                              TextSpan(
                                text: tAlreadyHaveAnAccount,
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
        ),
      ),
    );
  }
}
