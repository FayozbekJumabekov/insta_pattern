import 'package:get/get.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class ProfileController extends GetxController {
  User? user;
  List<Post> posts = [];

  void loadPost() {
    FireStoreService.loadPosts().then((posts) {
      this.posts = posts;
      update();
    });
  }

  Future<void> apiLoadUser() async {
    FireStoreService.loadUser().then((value) {
      user = value;
      update();
    });
  }

  @override
  void onInit() {
    super.onInit();
    apiLoadUser();
    loadPost();
  }
}
