import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/profile_detail_controller.dart';
import 'package:insta_pattern/views/image_pick_bottomsheet.dart';
import 'package:insta_pattern/views/widget_catalog.dart';

class ProfDetails extends StatelessWidget {
  const ProfDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfDetailController>(
        init: ProfDetailController(),
        builder: (_controller) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
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
                        leading: GestureDetector(
                          onTap: () {
                            buildShowModalBottomSheet(context,_controller);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(100)),
                            padding: EdgeInsets.all(2),
                            child: Container(
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
                                  : const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                    ),
                            ),
                          ),
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
              ((_controller.user != null))
                  ? Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// Profile Name
                          Text(
                            _controller.user!.fullName!,
                            style: TextStyle(
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
                                  primary: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color:
                                            Color.fromRGBO(60, 60, 67, 0.18)),
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              onPressed: () {},
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                    )
                  : WidgetCatalog.buildMovieShimmer(false,context),

              /// # Story List
              Container(
                alignment: Alignment.centerLeft,
                height: MediaQuery.of(context).size.height * 0.18,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// # Add story
                    Container(
                      height: 70,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.black)),
                      child: const Icon(
                        Icons.add_sharp,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    /// Story Description
                    Container(
                      width: 70,
                      alignment: Alignment.center,
                      child: const Text(
                        "Add new",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.01,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
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
