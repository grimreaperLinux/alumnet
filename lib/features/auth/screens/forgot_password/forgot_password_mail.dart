import 'package:alumnet/constants/image_strings.dart';
import 'package:alumnet/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:alumnet/constants/text_strings.dart';

class ForgotPasswordEmail extends StatelessWidget {
  const ForgotPasswordEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 25,
                left: 5,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
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
                  children: [
                    SizedBox(height: tFormHeight * 8),
                    Text(forgotPasswordTitle,
                        style: Theme.of(context).textTheme.headline3),
                    Form(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: tFormHeight - 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.email),
                                    labelText: tEmail,
                                    hintText: tEmail,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: tFormHeight),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text(tResetPassword),
                                  ),
                                ),
                              ],
                            )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
