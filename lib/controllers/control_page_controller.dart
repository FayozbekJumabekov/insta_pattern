import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/utils.dart';

class ControlPageController extends GetxController {
  int selectedIndex = 0;
  PageController pageController = PageController();

  void setSelectIndex(int selectedIndex) {
    this.selectedIndex = selectedIndex;
    update();
  }

  initNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      Utils.showLocalNotification(message, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.showLocalNotification(message, context);
    });
  }

  @override
  void onInit() {
    super.onInit();
    initNotification(Get.context!);
  }
  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}
