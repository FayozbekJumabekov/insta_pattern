import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_pattern/controllers/control_page_controller.dart';
import '../models/post_model.dart';
import '../services/firestore_service.dart';
import '../services/log_service.dart';
import '../services/storage_service.dart';
import '../views/widget_catalog.dart';

class UploadController extends GetxController {

  File? image;
  bool isLoading = false;
  final picker = ImagePicker();
  TextEditingController captionController = TextEditingController();

  void setImage(File? image) {
    this.image = image;
    update();
  }

  /// Get Image from local device
  Future<void> getImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setImage(File(pickedFile.path));
      Log.i('File Selected!!! ');
    } else {
      Log.e('No file selected');
    }
  }

  /// Send Request FireStore
  void sendRequest() {
    StoreService.uploadImage(image!, StoreService.folderPostImg).then((imgUrl) {
      getResponsePost(imgUrl!);
    });
  }

  /// Get Response
  void getResponsePost(String imgUrl) {
    String caption = captionController.text.trim().toString();
    Post post = Post(postImage: imgUrl, caption: caption);
    apiStorePost(post);
  }

  /// Store Post
  void apiStorePost(Post post) async {
    // For postFolder
    Post posted = await FireStoreService.storePost(post);
    // For feedFolder
    FireStoreService.storeFeed(posted).then((value) {
      goToFeedPage();
    });
  }

  /// Upload Function
  void uploadPost(BuildContext context) {
    if ((image == null) || (captionController.text.isEmpty)) {
      WidgetCatalog.showSnackBar(context, "Empty field !!!");
      return;
    } else {
      isLoading = true;
      FocusScope.of(context).requestFocus(FocusNode());
      update();
      sendRequest();
    }
  }

  Future<void> goToFeedPage() async {
    image = null;
    isLoading = false;
    Get.find<ControlPageController>().pageController.jumpToPage(0);
    update();
  }

  @override
  void onClose() {
    super.onClose();
    captionController.dispose();
  }
}
