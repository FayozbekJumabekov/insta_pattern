import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insta_pattern/pages/control_page.dart';
import 'package:insta_pattern/pages/sign_in_page.dart';
import 'package:insta_pattern/pages/sign_up_page.dart';
import 'package:insta_pattern/pages/splash_page.dart';
import 'package:insta_pattern/services/di_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insta_pattern/services/local_db_service.dart';

Future<void> main() async {
  await GetStorage.init();
  await DIService.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // notification
  await notificationConfig();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _startPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {

          GetXLocalDB.remove(StorageKeys.UID);
          return SignInPage();
        } else {
          GetXLocalDB.store(StorageKeys.UID, snapshot.data!.uid);
          return SplashPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: _startPage(),
      routes: {
        SplashPage.id: (context) => SplashPage(),
        SignUpPage.id: (context) => SignUpPage(),
        SignInPage.id: (context) => SignInPage(),
        ControlPage.id: (context) => ControlPage()
      },
    );
  }
}

Future<void> notificationConfig() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  var initAndroidSetting =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = const IOSInitializationSettings();
  var initSetting =
      InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting);
}
