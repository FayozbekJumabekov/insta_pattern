import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class SearchController extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  bool? isFollowed;
  List<User> users = [];
  List<Post> posts = [];

  /// Follow
  Future<void> followUser(User user) async {
    isLoading = true;
    update();
    FireStoreService.followUser(user).then((value) {
      user.followed = true;
      isLoading = false;
      update();
    });
    await FireStoreService.storePostsToMyFeed(user);
  }

  /// UnFollow
  Future<void> unFollowUser(User user) async {
    user.followed = false;
    isLoading = true;
    update();
    FireStoreService.unFollowUser(user).then((value) {
      isLoading = false;
      update();
    });
    await FireStoreService.removePostsFromMyFeed(user);
  }

  /// Search Methods
  void sendSearchRequest(String keyword) {
    if (keyword.isNotEmpty) {
      isLoading = true;
      update();
      FireStoreService.searchUsers(keyword).then((value) {
        getUsers(value);
      });
    } else {
      users.clear();
      update();
    }
  }

  void getUsers(List<User> response) {
    users = response;
    isLoading = false;
    update();
  }

  /// Grid Images
  void sendImgRequest() {
    isLoading = true;
    update();
    FireStoreService.loadAllPosts().then((value) {
      getImages(value);
    });
  }

  getImages(List<Post> response) {
    isLoading = false;
    posts = response;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    sendImgRequest();
  }

  @override
  void onClose() {
    super.onClose();
    textEditingController.dispose();
  }
}
