import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/pages/control_page.dart';
import 'package:insta_pattern/services/firestore_service.dart';
import 'package:insta_pattern/services/local_db_service.dart';
import 'package:insta_pattern/utils/utils.dart';
import '../services/auth_service.dart';
import '../services/log_service.dart';
import 'package:insta_pattern/models/user_model.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;

  void doSignIn(BuildContext context) {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    AuthenticationService.signInUser(context, email, password).then((value) => {
          getUser(value),
        });
  }

  void getUser(User? user) async {
    if (user != null) {
      GetXLocalDB.store(StorageKeys.UID, user.uid);
      Utils.initNotification();
      _apiUpdateUser();
      Get.toNamed(ControlPage.id);
    } else {
      Log.e("Null Response");
    }
  }

  void _apiUpdateUser() async {
    model.User userModel = await FireStoreService.loadUser();
    userModel.device_token = (await GetXLocalDB.load(StorageKeys.TOKEN))!;
    await FireStoreService.updateUser(userModel);
  }
}
