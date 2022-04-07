import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_pattern/services/local_db_service.dart';
import '../pages/sign_in_page.dart';
import 'log_service.dart';

class AuthenticationService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static bool logger = true;

  /// SignUp
  static Future<User?> signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      Log.i(user.toString());
      // Set name and email
      user!.updateDisplayName(name);
      user.updateEmail(email);
      return user;
    } on FirebaseAuthException catch (e) {
      Log.e(e.code);
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      } else {
        showSnackBar(context, e.code);
      }
    } catch (e) {
      Log.e(e.toString());
    }
    return null;
  }

  /// SignIn
  static Future<User?> signInUser(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      Log.e(e.code);
      if (e.code == 'user-not-found') {
        showSnackBar(context, "No user found for that email");
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Wrong password...");
      } else {
        showSnackBar(context, e.code);
      }
    } catch (e) {
      Log.e(e.toString());
    }
    return null;
  }

  /// SignOut
  static Future<void> signOutUser(BuildContext context) async {
    GetXLocalDB.remove(StorageKeys.UID);
    return await auth.signOut().then((value) => {
          Navigator.pushNamedAndRemoveUntil(
              context, SignInPage.id, (route) => false)
        });
  }

  /// Delete Account
  static Future<void> deleteUser(BuildContext context) async {
    GetXLocalDB.remove(StorageKeys.UID);
    try {
      await auth.currentUser!.delete().then((value) => {
            Log.i("Successfully Deleted"),
            Navigator.pushNamedAndRemoveUntil(
                context, SignInPage.id, (route) => false)
          });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.code);
      if (e.code == 'requires-recent-login') {
        Log.e(e.code);
      }
    }
    return;
  }

  /// SnackBar
  static void showSnackBar(BuildContext context, String content) {
    SnackBar snackBar = SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: Colors.yellow),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
