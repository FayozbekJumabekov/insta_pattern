class User {
  String? uid;
  String? fullName;
  String? email;
  String? password;
  String? imageUrl;
  String? likedImage;
  bool followed = false;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  String device_id = "";
  String device_type = "";
  String device_token = "";

  User({required this.fullName, required this.email, required this.password});

  User.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    fullName = json["fullName"];
    email = json["email"];
    password = json["password"];
    likedImage = json["likedImage"];
    imageUrl = json["imageUrl"];
    postCount = json["postCount"];
    followersCount = json["followersCount"];
    followingCount = json["followingCount"];
    device_id = json["device_id"];
    device_type = json["device_type"];
    device_token = json["device_token"];
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullName": fullName,
        "email": email,
        "password": password,
        "imageUrl": imageUrl,
        "likedImage": likedImage,
        "postCount": postCount,
        "followingCount": followingCount,
        "followersCount": followersCount,
        "device_id": device_id,
        "device_type": device_type,
        "device_token": device_token,
      };

  @override
  bool operator ==(Object other) {
    return other is User && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
