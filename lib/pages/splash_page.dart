import 'dart:async';
import 'package:flutter/material.dart';
import 'package:insta_pattern/pages/control_page.dart';
import 'package:insta_pattern/utils/utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String id = 'splash_page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void callHomePage() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, ControlPage.id);
    });
  }

  @override
  void initState() {
    super.initState();
    Utils.initNotification();
    callHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image(
                    width: MediaQuery.of(context).size.width * 0.2,
                    image: const AssetImage('assets/images/ic_insta_logo.png')),
              ),
            ),
            Text(
              'from',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Image(
                width: 100, image: AssetImage('assets/images/im_meta.png')),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
