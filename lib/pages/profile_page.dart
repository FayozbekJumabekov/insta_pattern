import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/profile_controller.dart';
import '../views/glow_widget.dart';
import '../views/profile_details.dart';
import '../views/widget_catalog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (_controller) {
            return Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: ListTile(
                  contentPadding: const EdgeInsets.symmetric(),
                  title: Row(
                    children: [
                      Text(
                        (_controller.user != null)
                            ? _controller.user!.email!
                            : '',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      WidgetCatalog.buildShowModalBottomSheet(context);
                    },
                    child: const Icon(
                      FontAwesomeIcons.bars,
                      size: 26,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  )
                ],
              ),
              body: Glow(
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        const ProfDetails(),
                      ]))
                    ];
                  },
                  body: Column(
                    children: [
                      const TabBar(
                        indicatorColor: Colors.black,
                        indicatorWeight: 0.8,
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.grid_on_sharp,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.perm_contact_cal_rounded,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            /// Post
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: (_controller.posts.isNotEmpty)
                                  ? GridView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 2),
                                      itemCount: _controller.posts.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 2,
                                              crossAxisSpacing: 2,
                                              crossAxisCount: 3),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CachedNetworkImage(
                                          imageUrl: _controller
                                              .posts[index].postImage!,
                                          placeholder: (context, url) =>
                                              const Image(
                                            image: AssetImage(
                                                'assets/images/im_placeholder.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Text(
                                      "Posts are not found 😕",
                                      style: TextStyle(
                                          fontFamily: 'Billabong',
                                          fontSize: 25),
                                    )),
                            ),

                            /// Tagged Posts
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: (_controller.posts.isNotEmpty)
                                  ? GridView.builder(
                                      itemCount: _controller.posts.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              mainAxisSpacing: 1,
                                              crossAxisSpacing: 1,
                                              crossAxisCount: 2),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CachedNetworkImage(
                                          imageUrl: _controller
                                              .posts[index].postImage!,
                                          placeholder: (context, url) =>
                                              const Image(
                                            image: AssetImage(
                                                'assets/images/im_placeholder.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Text(
                                      "Posts are not found 😕",
                                      style: TextStyle(
                                          fontFamily: 'Billabong',
                                          fontSize: 25),
                                    )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
