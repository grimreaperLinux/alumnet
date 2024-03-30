import 'package:alumnet/constants/image_strings.dart';
import 'package:alumnet/constants/sizes.dart';
import 'package:alumnet/features/auth/controllers/forgot_controller.dart';
import 'package:flutter/material.dart';
import 'package:alumnet/constants/text_strings.dart';
import 'package:get/get.dart';

class ForgotPasswordEmail extends StatelessWidget {
  const ForgotPasswordEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotController());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
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
                  children: [
                    SizedBox(height: tFormHeight * 8),
                    Text(forgotPasswordTitle,
                        style: Theme.of(context).textTheme.headline3),
                    Form(
                        key: _formKey,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: tFormHeight - 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return tEmailCannotBeEmpty;
                                    }
                                    if (!GetUtils.isEmail(value)) {
                                      return "Invalid Email";
                                    }
                                    return null;
                                  },
                                  controller: controller.email,
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
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.resetPassword(
                                            controller.email.text.trim());
                                      }
                                    },
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
