import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_pattern/models/user_model.dart';
import 'package:insta_pattern/views/detail_page_widget.dart';
import '../models/post_model.dart';
import '../services/firestore_service.dart';
import '../views/glow_widget.dart';

class DetailPage extends StatefulWidget {
  User user;
  bool? isFollowed;
  DetailPage({required this.user, this.isFollowed, Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Post> posts = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadPost();
  }

  void loadPost() {
    setState(() {
      isLoading = true;
    });
    FireStoreService.loadSomeonesPosts(widget.user).then((posts) {
      setState(() {
        this.posts = posts;
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: ListTile(
            contentPadding: const EdgeInsets.symmetric(),
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.user.email!,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        body: Glow(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverList(
                    delegate: SliverChildListDelegate([
                  DetailPageWidget(
                    user: widget.user,
                    isFollowed: widget.isFollowed,
                  ),
                ]))
              ];
            },
            body: Column(
              children: [
                const Divider(
                  height: 0,
                ),
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

                      /// Posts
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                          itemCount: posts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: CachedNetworkImage(
                                imageUrl: posts[index].postImage!,
                                placeholder: (context, url) => const Image(
                                  image: AssetImage(
                                      'assets/images/im_placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            );
                          },
                        ),
                      ),

                      /// Tagged Posts
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          itemCount: posts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 1,
                                  crossAxisSpacing: 1,
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: CachedNetworkImage(
                                imageUrl: posts[index].postImage!,
                                placeholder: (context, url) => const Image(
                                  image: AssetImage(
                                      'assets/images/im_placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
