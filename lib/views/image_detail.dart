import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/image_detail_controller.dart';
import 'package:insta_pattern/models/post_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'user_detail_page.dart';

class ImageDetailPage extends StatefulWidget {
  Post post;

  ImageDetailPage({required this.post, Key? key}) : super(key: key);

  @override
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {

  @override
  void initState() {
    super.initState();
    Get.find<ImageDetailController>().getPost(widget.post);
    Get.find<ImageDetailController>().followingCondition();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageDetailController>(
        init:  ImageDetailController(),
        builder: (_controller){
      return Hero(
        tag: _controller.post!.id!,
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  /// Header
                  GestureDetector(
                    onTap: () {
                      if (_controller.myUid != _controller.user.uid) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  user: _controller.user,
                                  isFollowed: _controller.isFollowed!,
                                )));
                      }
                    },
                    child: Container(
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
                            child: (_controller.post!.profileImage != null)
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _controller.post!.profileImage!,
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
                          _controller.post!.fullName!,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  /// Image
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: _controller.post!.postImage!,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Image(
                          image: AssetImage('assets/images/im_placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      if (_controller.isLoading)
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
                      if (!_controller.post!.isMine)
                        IconButton(
                            onPressed: () {
                              if (_controller.isActiveClick(DateTime.now())) {
                                (_controller.post!.isLiked)
                                    ? _controller.likePost(_controller.post!, false)
                                    : _controller.likePost(_controller.post!, true);
                                return;
                              }
                            },
                            icon: (_controller.post!.isLiked)
                                ? const Icon(
                              FontAwesomeIcons.solidHeart,
                              color: Colors.red,
                            )
                                : const Icon(
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
                          onPressed: ()  {
                           _controller.sharePost();
                          },
                          icon: const Icon(
                            CupertinoIcons.paperplane_fill,
                            color: Colors.black,
                          )),
                    ],
                  ),

                  /// Likes Count
                  if (_controller.likedByUsers.length >= 2)
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
                            child: (_controller.likedByUsers
                                .elementAt(_controller.likedByUsers.length - 2)
                                .imageUrl !=
                                null)
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _controller.likedByUsers
                                    .elementAt(_controller.likedByUsers.length - 2)
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
                                  border:
                                  Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(100)),
                              child: (_controller.likedByUsers.last.imageUrl != null)
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: _controller.likedByUsers.last.imageUrl!,
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
                            "...${_controller.post!.likedCount} likes",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),

                  /// Liked By
                  if (_controller.likedByUsers.isNotEmpty)
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                            children: (_controller.likedByUsers.length >= 2)
                                ? List.generate(
                                3,
                                    (index) => TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                    text: (index != 2)
                                        ? '${_controller.likedByUsers.reversed.elementAt(index).fullName}, '
                                        : ' and others'))
                                : List.generate(
                                1,
                                    (index) => TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                    text:
                                    '${_controller.likedByUsers.reversed.elementAt(index).fullName}'))),
                      ),
                    ),

                  /// Caption
                  (_controller.post!.caption != null)
                      ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: RichText(
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                          text: _controller.post!.caption,
                        )),
                  )
                      : const SizedBox.shrink(),

                  /// data
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      _controller.post!.createdDate!,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
