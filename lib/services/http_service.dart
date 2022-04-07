import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;


class Network {
  /// Set isTester ///
  static bool isTester = true;

  /// Servers Types ///
  static String SERVER_DEVELOPMENT = "fcm.googleapis.com";
  static String SERVER_PRODUCTION = "fcm.googleapis.com";

  /// * Http Apis *///
  static String API_SEND = "/fcm/send";

  /// Getting Header ///
  static Map<String, String> getHeaders() {
    Map<String, String> header = {
      "Authorization":
          "key=AAAAx3gFCaU:APA91bGtDQNhcfRRnesxC74XPb7XAhd0sMJzbe_5Ze8BT7Ylj-ZLy3d0wFOFgmmbsG--FjhtJtHy3zrMkFJVTFUYC4h9YyxMF0Nv3XyYPYbhXLSzIPPKw7T8IeiMT3a56qFwXzULHgdn",
      "Content-Type": "application/json",
    };
    return header;
  }

  /// Selecting Test Server or Production Server  ///

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  ///* Http Requests *///

  /// POST method///
  static Future<String?> POST(Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), API_SEND);
    var response =
        await post(uri, headers: getHeaders(), body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

 static Future<void> sharePost(String content, String imgUrl) async {
    final url = Uri.parse(imgUrl);
    final response = await http.get(url);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/image.jpg";
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path], text: content);
  }


  static Map<String, dynamic> paramCreateFollow(
      String fcm_token, String username, String someoneName) {
    Map<String, dynamic> params = {};
    params.addAll({
      'notification': {
        'title': 'My Instagram',
        'body': '$username followed you!'
      },
      'registration_ids': [fcm_token],
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    });
    return params;
  }

  static Map<String, dynamic> paramCreateLike(
      String fcm_token, String username, String someoneName) {
    Map<String, dynamic> params = {};
    params.addAll({
      'notification': {
        'title': 'My Instagram',
        'body': '$username liked your photo!'
      },
      'registration_ids': [fcm_token],
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    });
    return params;
  }
}
