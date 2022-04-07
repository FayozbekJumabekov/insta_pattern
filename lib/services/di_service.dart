import 'package:get/get.dart';
import 'package:insta_pattern/controllers/control_page_controller.dart';
import 'package:insta_pattern/controllers/feed_controller.dart';
import 'package:insta_pattern/controllers/image_detail_controller.dart';
import 'package:insta_pattern/controllers/like_controller.dart';
import 'package:insta_pattern/controllers/profile_controller.dart';
import 'package:insta_pattern/controllers/profile_detail_controller.dart';
import 'package:insta_pattern/controllers/search_controller.dart';
import 'package:insta_pattern/controllers/sign_in_controller.dart';
import 'package:insta_pattern/controllers/sign_up_controller.dart';
import 'package:insta_pattern/controllers/upload_controller.dart';
import 'package:insta_pattern/controllers/user_detail_controlle.dart';

class DIService {
  static Future<void> init() async {
    Get.lazyPut<ControlPageController>(() => ControlPageController(),
        fenix: true);
    Get.lazyPut<FeedController>(() => FeedController(), fenix: true);
    Get.lazyPut<SearchController>(() => SearchController(), fenix: true);
    Get.lazyPut<UploadController>(() => UploadController(), fenix: true);
    Get.lazyPut<LikeController>(() => LikeController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<SignUpController>(() => SignUpController(), fenix: true);
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
    Get.lazyPut<ProfDetailController>(() => ProfDetailController(), fenix: true);
    Get.lazyPut<ImageDetailController>(() => ImageDetailController(), fenix: true);
    Get.lazyPut<UserDetailController>(() => UserDetailController(), fenix: true);

  }
}
