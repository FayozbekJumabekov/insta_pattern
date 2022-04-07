import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/control_page_controller.dart';
import 'package:insta_pattern/pages/feed_page.dart';
import 'package:insta_pattern/pages/like_page.dart';
import 'package:insta_pattern/pages/profile_page.dart';
import 'package:insta_pattern/pages/search_page.dart';
import 'package:insta_pattern/pages/upload_page.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({Key? key}) : super(key: key);
  static const String id = 'control_page';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControlPageController>(
        init: ControlPageController(),
        builder: (_controller) {
          return Scaffold(
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                _controller.setSelectIndex(index);
              },
              controller: _controller.pageController,
              children: [
                FeedPage(
                  pageController: _controller.pageController,
                ),
                const SearchPage(),
                UploadPage(
                  pageController: _controller.pageController,
                ),
                const LikePage(),
                const ProfilePage()
              ],
            ),
            bottomNavigationBar: CupertinoTabBar(
              inactiveColor: Colors.black,
              currentIndex: _controller.selectedIndex,
              activeColor: Colors.purple,
              onTap: (index) {
                _controller.setSelectIndex(index);
                _controller.pageController.jumpToPage(index);
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.plusSquare),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border_outlined),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_alt_circle_fill),
                ),
              ],
            ),
          );
        });
  }
}
