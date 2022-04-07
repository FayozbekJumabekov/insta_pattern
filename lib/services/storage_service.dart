import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'log_service.dart';

class StoreService {
  static final _storage = FirebaseStorage.instance.ref();
  static const String folderUserImg = "user_image";
  static const String folderPostImg = "post_image";

  static Future<String?> uploadImage(File _image, String folder) async {
    String imgName = "image_" + DateTime.now().toString();
    Reference? firebaseStorageRef = _storage.child(folder).child(imgName);
    UploadTask? uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot? taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    Log.i("Download url :" + downloadUrl);
    return downloadUrl;
  }

  static Future<List<String>> loadStoredImages() async {
    List<String> downloadUrls = [];
    ListResult listResult = await _storage.child(folderPostImg).listAll();
    Log.i(listResult.items.length.toString());

    for (var url in listResult.items) {
      String data = await url.getDownloadURL();
      downloadUrls.add(data);
    }
    return downloadUrls;
  }
}
