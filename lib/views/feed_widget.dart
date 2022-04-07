import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_pattern/models/post_model.dart';
import 'package:insta_pattern/models/user_model.dart';
import 'package:insta_pattern/services/firestore_service.dart';
import 'package:insta_pattern/services/http_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedWidget extends StatefulWidget {
  Post post;
  final Function? load;

  FeedWidget({required this.post, required this.load, Key? key})
      : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  late Post post;
  DateTime? loginClickTime;
  bool isLoading = false;
  List<User> likedByUsers = [];

  void likePost(Post post, bool isLiked) async {
    setState(() {
      isLoading = true;
    });
    await FireStoreService.likePost(post, isLiked).then((value) {
      setState(() {
        getDataFromParentWidget();
        isLoading = false;
      });
    });
  }

  void removePost(Post post) {
    FireStoreService.removeMyPost(post).then((value) {
      widget.load!();
    });
  }

  void getDataFromParentWidget() {
    setState(() {
      post = widget.post;
      likedByUsers = List.from(post.likedByUsers.map((e) => User.fromJson(e)));
    });
  }

  @override
  void didUpdateWidget(covariant FeedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    getDataFromParentWidget();
  }

  @override
  void initState() {
    super.initState();
    getDataFromParentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Header
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListTile(
              horizontalTitleGap: 10,

              /// Profile Image
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(100)),
                padding: EdgeInsets.all(2),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(100)),
                  child: (post.profileImage != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: post.profileImage!,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/im_profile.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              title: Text(
                post.fullName!,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                onPressed: () {
                  buildShowModalBottomSheet(context, post);
                },
                padding: const EdgeInsets.only(left: 20),
                icon: const Icon(
                  FontAwesomeIcons.ellipsisV,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
          ),

          /// Image
          Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: post.postImage!,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Image(
                  image: AssetImage('assets/images/im_placeholder.png'),
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              if (isLoading)
                const CupertinoActivityIndicator(
                  radius: 30,
                  color: Colors.blue,
                )
            ],
          ),

          /// Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Like button
              if (!post.isMine)
                IconButton(
                    onPressed: () {
                      if (isActiveClick(DateTime.now())) {
                        (post.isLiked)
                            ? likePost(post, false)
                            : likePost(post, true);
                        return;
                      }
                    },
                    icon: (post.isLiked)
                        ? const Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.red,
                    )
                        : Icon(
                      FontAwesomeIcons.heart,
                      color: Colors.black,
                    )),
              // Comment button
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.comment,
                    color: Colors.black,
                  )),
              // Share button
              IconButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Network.sharePost(post.caption!, post.postImage!)
                        .then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                  icon: const Icon(
                    CupertinoIcons.paperplane_fill,
                    color: Colors.black,
                  )),
            ],
          ),

          /// Likes Count
          if (likedByUsers.length >= 2)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(100)),
                    child: (likedByUsers
                                .elementAt(likedByUsers.length - 2)
                                .imageUrl !=
                            null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: likedByUsers
                                  .elementAt(likedByUsers.length - 2)
                                  .imageUrl!,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/images/im_profile.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Transform.translate(
                    offset: Offset(-8, 0),
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(100)),
                      child: (likedByUsers.last.imageUrl != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: likedByUsers.last.imageUrl!,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                'assets/images/im_profile.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    "...${post.likedCount} likes",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ],
              ),
            ),

          /// Liked By
          if (likedByUsers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: RichText(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: 'Liked by ',
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black),
                    children: (likedByUsers.length >= 2)
                        ? List.generate(
                            3,
                            (index) => TextSpan(
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                text: (index != 2)
                                    ? '${likedByUsers.reversed.elementAt(index).fullName}, '
                                    : ' and others'))
                        : List.generate(
                            1,
                            (index) => TextSpan(
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                text:
                                    '${likedByUsers.reversed.elementAt(index).fullName}'))),
              ),
            ),

          /// Caption
          (post.caption != null)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: RichText(
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                        text: post.caption,
                      )),
                )
              : const SizedBox.shrink(),

          /// data
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              post.createdDate!,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  bool isActiveClick(DateTime currentTime) {
    if (loginClickTime == null) {
      loginClickTime = currentTime;
      print("first click");
      return true;
    }
    print('diff is ${currentTime.difference(loginClickTime!).inSeconds}');
    if (currentTime.difference(loginClickTime!).inSeconds < 4) {
      //set this difference time in seconds
      return false;
    }

    loginClickTime = currentTime;
    return true;
  }

  /// BottomSheet
  Future<dynamic> buildShowModalBottomSheet(BuildContext context, Post post) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(children: [
              const SizedBox(
                height: 10,
              ),

              /// Share
              ListTile(
                  leading: Icon(FontAwesomeIcons.share),
                  title: Text(
                    'Share Posts',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Network.sharePost(post.caption!, post.postImage!)
                        .then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                    });
                  }),

              /// Remove Photo
              ListTile(
                  leading: const Icon(FontAwesomeIcons.trash),
                  title: Text(
                    (post.isMine) ? "Remove Post" : "Hide Post",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  onTap: () {
                    removePost(post);
                    Navigator.of(context).pop();
                  }),
            ]),
          );
        });
  }
}
