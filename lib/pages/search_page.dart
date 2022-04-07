import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../views/glow_widget.dart';
import '../views/image_detail.dart';
import '../views/searched_user_listtile.dart';
import '../views/widget_catalog.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SearchController>(
          init: SearchController(),
          builder: (_controller) {
            return Glow(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverList(
                        delegate: SliverChildListDelegate([
                      textField(context, _controller),
                    ]))
                  ];
                },
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// Users
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _controller.users.length,
                              itemBuilder: (context, index) {
                                return (!_controller.isLoading)
                                    ? userSearchListTile(context, _controller,
                                        _controller.users[index])
                                    : WidgetCatalog.buildMovieShimmer(
                                        true, context);
                              }),

                          /// Images
                          if (_controller.users.isEmpty)
                            MasonryGridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              itemCount: _controller.posts.length,
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, PageRouteBuilder(
                                        fullscreenDialog: true,
                                        transitionDuration:
                                        Duration(milliseconds: 1000),
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                            secondaryAnimation) {
                                          return ImageDetailPage(
                                              post: _controller.posts[index]);
                                        },
                                        transitionsBuilder:
                                            (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                            secondaryAnimation,
                                            Widget child) {
                                          return FadeTransition(
                                            opacity: CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.elasticInOut,
                                            ),
                                            child: child,
                                          );
                                        }));

                                  },
                                  child: Hero(
                                    tag: _controller.posts[index].id!,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            _controller.posts[index].postImage!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, index) =>
                                            const Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/im_placeholder.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    if (_controller.isLoading)
                      const Center(
                          child: CupertinoActivityIndicator(
                        radius: 20,
                      ))
                  ],
                ),
              ),
            );
          }),
    );
  }

  Container textField(BuildContext context, SearchController _controller) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05, left: 10, right: 10),
      height: MediaQuery.of(context).size.height * 0.045,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(5)),

      /// TextField Search
      child: TextField(
        style: const TextStyle(
            color: Colors.black, decoration: TextDecoration.none),
        cursorColor: Colors.black,
        controller: _controller.textEditingController,
        onChanged: (text) {
          _controller.sendSearchRequest(text);
        },
        decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(
                color: Colors.grey.shade700, decoration: TextDecoration.none),
            prefixIcon: const Icon(
              CupertinoIcons.search,
              size: 20,
              color: Colors.black,
            ),
            suffixIcon: const Icon(
              CupertinoIcons.location_solid,
              size: 20,
              color: Colors.black,
            ),
            // contentPadding: EdgeInsets.all(15),
            border: InputBorder.none),
      ),
    );
  }
}
