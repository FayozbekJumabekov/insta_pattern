import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/log_service.dart';
import '../services/storage_service.dart';

class ProfDetailController extends GetxController {
  bool isLoading = true;
  User? user;
  File? image;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    apiLoadUser();
  }

  Future<void> apiLoadUser() async {
    FireStoreService.loadUser().then((value) {
      user = value;
      update();
    });
  }

  // for edit user
  void apiChangePhoto() {
    if (image == null) return;
    isLoading = false;
    update();
    StoreService.uploadImage(image!, StoreService.folderUserImg).then((imgUrl) {
      isLoading = true;
      user!.imageUrl = imgUrl;
      update();
      FireStoreService.updateUser(user!);
    });
  }

  /// Get Image from local device
  Future<void> getImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      apiChangePhoto();
      update();
      Log.i('File Selected!!! ');
    } else {
      Log.e('No file selected');
    }
  }
}
