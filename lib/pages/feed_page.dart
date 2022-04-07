import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/feed_controller.dart';
import '../views/feed_widget.dart';
import '../views/glow_widget.dart';

class FeedPage extends StatelessWidget {
  PageController pageController;

  FeedPage({required this.pageController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: const Text(
            'Instagram',
            style: TextStyle(
                fontSize: 35, color: Colors.black, fontFamily: 'Billabong'),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.facebookMessenger),
              color: Colors.black,
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        body: Glow(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GetBuilder<FeedController>(
                init: FeedController(),
                builder: (_controller) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            /// Feed Widgets
                            ListView.builder(
                                itemCount: _controller.posts.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return FeedWidget(
                                    post: _controller.posts[index],
                                    load: _controller.apiLoadPosts,
                                  );
                                })
                          ],
                        ),
                      ),
                      if (_controller.isLoading)
                        const Center(
                            child: CupertinoActivityIndicator(
                          radius: 30,
                          color: Colors.blue,
                        ))
                    ],
                  );
                }),
          ),
        ));
  }
}
