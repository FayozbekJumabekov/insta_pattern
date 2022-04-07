import 'package:get/get.dart';
import '../models/post_model.dart';
import '../services/firestore_service.dart';

class FeedController extends GetxController {
  List<Post> posts = [];
  List<Post> likedByUsers = [];
  bool isLoading = false;

  void apiLoadPosts() {
    isLoading = true;
    update();
    FireStoreService.loadFeeds().then((posts) {
      getResPosts(posts);
    });
  }

  void getResPosts(List<Post> posts) {
    this.posts = posts;
    isLoading = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    apiLoadPosts();
  }
}
