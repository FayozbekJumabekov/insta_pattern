import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/models/user_model.dart' as model;
import 'package:insta_pattern/services/local_db_service.dart';
import '../pages/control_page.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../utils/utils.dart';
import '../views/widget_catalog.dart';

class SignUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool hidePassword = true;
  bool isLoading = false;

  bool _checkValid(BuildContext context, String firstName, String email,
      String password, String cpassword) {
    if (email.isEmpty || password.isEmpty || firstName.isEmpty) {
      WidgetCatalog.showSnackBar(
          context, "Field can not be empty. Please fill it");
      return false;
    }

    if (!Utils.isValidEmail(email)) {
      WidgetCatalog.showSnackBar(context, "Please, enter valid Email");
      return false;
    }

    if (!Utils.isValidPassword(password)) {
      WidgetCatalog.showSnackBar(context,
          "Password must be at least one upper case, one lower case, one digit, one Special character & be at least 8 characters in length");
      return false;
    }

    if (password != cpassword) {
      WidgetCatalog.showSnackBar(context, "Passwords do not match");
      return false;
    }
    return true;
  }

  void doSignUp(BuildContext context) {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = cpasswordController.text.toString().trim();
    String firstName = nameController.text.toString().trim();

    model.User user =
        model.User(fullName: firstName, email: email, password: password);
    if (_checkValid(context, firstName, email, password, cpassword)) {
      isLoading = true;
      update();
      AuthenticationService.signUpUser(
              context: context,
              name: firstName,
              email: email,
              password: password)
          .then((value) => {
                getUser(user, value),
              });
    }
  }

  void getUser(model.User user, User? firebaseuser) async {
    if (firebaseuser != null) {
      GetXLocalDB.store(StorageKeys.UID, firebaseuser.uid);
      user.uid = firebaseuser.uid;
      FireStoreService.storeUser(user).then((value) {
        isLoading = false;
        update();
        Get.toNamed(ControlPage.id);
      });
    } else {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    Utils.initNotification();
  }
}
