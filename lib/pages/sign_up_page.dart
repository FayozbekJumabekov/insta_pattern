import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/sign_up_controller.dart';
import 'package:insta_pattern/pages/sign_in_page.dart';
import 'package:insta_pattern/views/custom_textfield.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = 'sign_up_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: GetBuilder<SignUpController>(
            init: SignUpController(),
            builder: (_controller) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ///Instagram Text
                                const Text(
                                  'Instagram',
                                  style: TextStyle(
                                      fontFamily: 'Billabong', fontSize: 50),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(
                                  height: 50,
                                ),

                                /// TextFields
                                /// Full Name
                                CustomTextField(
                                    textEditingController:
                                        _controller.nameController,
                                    hintText: "FullName"),
                                /// Email Name
                                CustomTextField(
                                    textEditingController:
                                        _controller.emailController,
                                    hintText: "Email"),
                                /// Password Name
                                CustomTextField(
                                    textEditingController:
                                        _controller.passwordController,
                                    hintText: "Password"),
                                /// Confirm Password
                                CustomTextField(
                                    textEditingController:
                                        _controller.cpasswordController,
                                    hintText: "Confirm"),
                                const SizedBox(
                                  height: 20,
                                ),

                                /// Sign Up Button
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        fixedSize: const Size(50, 50)),
                                    onPressed: () {
                                      _controller.doSignUp(context);
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )),
                              ],
                            ),
                          ),

                          const Divider(
                            color: Colors.grey,
                            height: 40,
                          ),

                          /// Already have account SignIn Text
                          RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  text: "Already have account? ",
                                  children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                      Get.offNamed(SignInPage.id);                                      },
                                    style:
                                        TextStyle(color: Colors.blue.shade900),
                                    text: "Sign In"),
                              ])),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  if (_controller.isLoading)
                    const CupertinoActivityIndicator(
                      radius: 30,
                    )
                ],
              );
            }));
  }
}
