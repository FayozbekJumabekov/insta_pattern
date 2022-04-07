import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../controllers/like_controller.dart';
import '../models/user_model.dart';

Widget userLikeListTile(LikeController _controller, User user) {
  return (_controller.users.isNotEmpty)
      ? Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
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
                      )),
            ),
            title: Text.rich(TextSpan(
                text: user.fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                children: const [
                  TextSpan(
                      text: ' liked your post',
                      style: TextStyle(fontWeight: FontWeight.w400))
                ])),
            trailing: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: user.likedImage!,
            ),
          ),
        )
      : const Center(
          child: Text(
            "No Activity",
            style: TextStyle(color: Colors.black),
          ),
        );
}
