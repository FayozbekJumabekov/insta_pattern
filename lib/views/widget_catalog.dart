import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:insta_pattern/views/shimmer_anim.dart';
import '../services/auth_service.dart';

class WidgetCatalog {
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
  static Widget buildMovieShimmer(bool isHasLeading,BuildContext context) => ListTile(
    leading: (isHasLeading)
        ? CustomWidget.circular(height: 80, width: 80)
        : null,
    title: Align(
      alignment: Alignment.centerLeft,
      child: CustomWidget.rectangular(
        height: 16,
        width: MediaQuery.of(context).size.width * 0.3,
      ),
    ),
    subtitle: CustomWidget.rectangular(height: 14),
  );


  /// Android Dialog
  static void androidDialog({
    required String title,
    required String content,
    required GestureTapCallback onTapNo,
    required GestureTapCallback onTapYes,
    required BuildContext context,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("Cancel")),
              TextButton(onPressed: onTapYes, child: const Text("Confirm"))
            ],
          );
        });
  }

  /// DraggableSheet
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.all(const Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20.0,
              sigmaY: 20.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.black26,
                  width: 0.5,
                ),
              ),
              child: Wrap(
                children: [
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.25,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: Colors.black12,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.settings,
                      size: 30,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.archive,
                      size: 30,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Archive',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                      leading: const Icon(
                        Icons.qr_code,
                        size: 30,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'QR code',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      leading: const Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Log out',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        WidgetCatalog.androidDialog(
                            title: "Log Out",
                            content: "Do you want to log out ?",
                            onTapNo: () {
                              Navigator.pop(context);
                            },
                            onTapYes: () {
                              AuthenticationService.signOutUser(context);
                            },
                            context: context);
                      }),
                  ListTile(
                      leading: const Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Delete account',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        WidgetCatalog.androidDialog(
                            title: "Delete Account",
                            content: "Do you want to delete account ?",
                            onTapNo: () {
                              Navigator.pop(context);
                            },
                            onTapYes: () {
                              AuthenticationService.deleteUser(context);
                            },
                            context: context);
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
