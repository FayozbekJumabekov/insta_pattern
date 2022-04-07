import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/user_detail_controlle.dart';
import 'package:insta_pattern/models/user_model.dart';
import 'package:insta_pattern/views/widget_catalog.dart';

class DetailPageWidget extends StatefulWidget {
  User? user;
  bool? isFollowed;

  DetailPageWidget({required this.user, this.isFollowed, Key? key})
      : super(key: key);

  @override
  State<DetailPageWidget> createState() => _DetailPageWidgetState();
}

class _DetailPageWidgetState extends State<DetailPageWidget> {

  @override
  void initState() {
    super.initState();
    Get.find<UserDetailController>().getUser(widget.user!, widget.isFollowed!);
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDetailController>(
        init: UserDetailController(),
        builder: (_controller) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  /// # Profile Account pictue and Statistcs
                  ((_controller.user != null) && _controller.isLoading)
                      ? Container(
                          margin: EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width,
                          child: GridTileBar(
                            leading: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(100)),
                              child: (_controller.user?.imageUrl != null)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: _controller.user!.imageUrl!,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                /// Posts
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _controller.user!.postCount.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5),
                                    ),
                                    const Text(
                                      "Posts",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.1),
                                    ),
                                  ],
                                ),

                                /// Followers
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _controller.user!.followersCount.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.3),
                                    ),
                                    const Text(
                                      "Followers",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.1),
                                    ),
                                  ],
                                ),

                                /// Following
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _controller.user!.followingCount.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.3),
                                    ),
                                    const Text(
                                      "Following",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : WidgetCatalog.buildMovieShimmer(true,context),

                  /// # Profile details
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// Profile Name
                        Text(
                          _controller.user!.fullName!,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 1,
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        /// #Edit Button
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color.fromRGBO(60, 60, 67, 0.18)),
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onPressed: () {
                              if (_controller.isActiveClick(DateTime.now())) {
                                (_controller.isFollowed!)
                                    ? _controller.unFollowUser(_controller.user!)
                                    : _controller.followUser(_controller.user!);
                              }
                            },
                            child: Text(
                              (_controller.isFollowed!) ? "Unfollow" : "Follow",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
