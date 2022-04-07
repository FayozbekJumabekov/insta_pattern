import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_pattern/views/user_detail_page.dart';
import '../controllers/search_controller.dart';
import '../models/user_model.dart';

Widget userSearchListTile(
    BuildContext context, SearchController _controller, User user) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(
                    user: user,
                    isFollowed: user.followed,
                  )));
    },
    child: ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            border: Border.all(color: Colors.purple, width: 2),
            borderRadius: BorderRadius.circular(100)),
        child: (user.imageUrl != null)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: user.imageUrl!,
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
      title: Text(
        user.fullName!,
      ),
      subtitle: Text(user.email!),
      trailing: Container(
        height: 30,
        child: TextButton(
          onPressed: () {
            (user.followed)
                ? _controller.unFollowUser(user)
                : _controller.followUser(user);
          },
          child: Text((user.followed) ? "Unfollow" : "Follow"),
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              primary: Colors.black,
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey))),
        ),
      ),
    ),
  );
}
