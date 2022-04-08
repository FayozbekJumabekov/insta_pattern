import 'package:get/get.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/http_service.dart';
import '../services/local_db_service.dart';

class ImageDetailController extends GetxController {
  Post? post;
  DateTime? loginClickTime;
  bool isLoading = false;
  bool? isFollowed;
  late User user;
  late String myUid;
  List<User> likedByUsers = [];
  List<String?> following = [];

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  void getPost(Post post) async{
    this.post = post;
    likedByUsers = List.from(post.likedByUsers.map((e) => User.fromJson(e)));
    user = await loadUser();
    update();
  }

  void sharePost() async {
    isLoading = true;
    update();
    await Network.sharePost(post!.caption!, post!.postImage!).then((value) {
      isLoading = false;
      update();
    });
  }

  void likePost(Post post, bool isLiked) async {
    isLoading = true;
    update();
    await FireStoreService.likePost(post, isLiked).then((value) {
      isLoading = false;
      update();
    });
  }

  void getAllData() async{
    await followingCondition();
  }

  Future<User> loadUser() async {
    String myProfUId = (await GetXLocalDB.load(StorageKeys.UID))!;
    var value = await FireStoreService.instance
        .collection(FireStoreService.usersFolder)
        .doc(post!.uid)
        .get();
    myUid = myProfUId;
    user = User.fromJson(value.data()!);
    update();
    return User.fromJson(value.data()!);
  }

  Future<bool> followingCondition() async {
    String uid = (await GetXLocalDB.load(StorageKeys.UID))!;

    var querySnapshot2 = await FireStoreService.instance
        .collection(FireStoreService.usersFolder)
        .doc(uid)
        .collection(FireStoreService.followingFolder)
        .get();
    for (var result in querySnapshot2.docs) {
      following.add(User.fromJson(result.data()).uid);
      update();
    }

    if (following.contains(post!.uid)) {
      isFollowed = true;
      update();
      return true;
    } else {
      isFollowed = false;
      update();
      return false;
    }
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
