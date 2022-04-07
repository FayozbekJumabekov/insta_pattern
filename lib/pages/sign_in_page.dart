import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/sign_in_controller.dart';
import 'package:insta_pattern/pages/sign_up_page.dart';
import 'package:insta_pattern/views/custom_textfield.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);
  static const String id = 'sign_in_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<SignInController>(
            init: SignInController(),
            builder: (_controller) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1),
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
                              CustomTextField(
                                  textEditingController:
                                      _controller.emailController,
                                  hintText: "Email"),
                              CustomTextField(
                                  textEditingController:
                                      _controller.passwordController,
                                  hintText: "Password"),
                              const SizedBox(
                                height: 20,
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              /// Sign In Button
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      fixedSize: Size(50, 50)),
                                  onPressed: () {
                                    _controller.doSignIn(context);
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )),
                            ],
                          ),
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
                              text: "Don't have an account? ",
                              children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                  Get.offNamed(SignUpPage.id);
                                  },
                                style: TextStyle(color: Colors.blue.shade900),
                                text: "Sign Up"),
                          ])),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
