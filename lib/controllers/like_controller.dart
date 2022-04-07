import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class LikeController extends GetxController {
  bool isLoading = false;
  List<User> users = [];

  void sendRequestLikes() {
    isLoading = true;
    update();
    FireStoreService.loadLikes().then((value) {
      getResponse(value);
    });
  }

  void getResponse(List<User> users) {
    if (users.isNotEmpty) {
      isLoading = false;
      this.users = users;
      update();
    } else {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    sendRequestLikes();
  }
}
