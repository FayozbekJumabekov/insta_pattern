import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserDetailController extends GetxController {
  bool isLoading = true;
  User? user;
  DateTime? loginClickTime;
  bool? isFollowed;

  /// Follow
  Future<void> followUser(User user) async {
    FireStoreService.followUser(user).then((value) {
      user.followed = true;
      isFollowed = true;
      update();
    });
    await FireStoreService.storePostsToMyFeed(user);
  }

  /// UnFollow
  Future<void> unFollowUser(User user) async {
    user.followed = false;
    isFollowed = false;
    update();
    FireStoreService.unFollowUser(user).then((value) {});
    await FireStoreService.removePostsFromMyFeed(user);
  }

  void getUser(User user, bool isFollowed) {
    this.user = user;
    this.isFollowed = isFollowed;
    update();
  }
  bool isActiveClick(DateTime currentTime) {
    if (loginClickTime == null) {
      loginClickTime = currentTime;
      return true;
    }
    if (currentTime.difference(loginClickTime!).inSeconds < 4) {
      //set this difference time in seconds
      return false;
    }

    loginClickTime = currentTime;
    return true;
  }

}
