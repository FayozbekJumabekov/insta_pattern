import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_pattern/services/log_service.dart';
import 'package:insta_pattern/utils/utils.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import 'http_service.dart';
import 'local_db_service.dart';

class FireStoreService {
  // init
  static final instance = FirebaseFirestore.instance;

  // folder
  static const String usersFolder = "users";
  static const String allPostsFolder = "all_posts";
  static const String postsFolder = "posts";
  static const String feedsFolder = "feeds";
  static const String likesFolder = "likes";
  static const String followingFolder = "following";
  static const String followerFolder = "followers";

  /// User Related

  static Future<void> storeUser(User user) async {
    user.uid = await GetXLocalDB.load(StorageKeys.UID);
    Map<String, String> params = await Utils.deviceParams();

    user.device_id = params["device_id"]!;
    user.device_type = params["device_type"]!;
    user.device_token = params["device_token"]!;
    return instance.collection(usersFolder).doc(user.uid).set(user.toJson());
  }

  static Future<User> loadUser() async {
    String uid = (await GetXLocalDB.load(StorageKeys.UID))!;
    var value = await instance.collection(usersFolder).doc(uid).get();
    return User.fromJson(value.data()!);
  }

  static Future<void> updateUser(User user) async {
    return instance.collection(usersFolder).doc(user.uid).update(user.toJson());
  }

  static Future<List<User>> searchUsers(String keyword) async {
    User user = await loadUser();
    List<User> users = [];
    // write request
    var querySnapshot = await instance
        .collection(usersFolder)
        .orderBy("fullName")
        .startAt([keyword]).endAt([keyword + '\uf8ff']).get();
    Log.i(querySnapshot.docs.toString());

    for (var element in querySnapshot.docs) {
      users.add(User.fromJson(element.data()));
    }
    users.remove(user);

    List<User> following = [];

    var querySnapshot2 = await instance
        .collection(usersFolder)
        .doc(user.uid)
        .collection(followingFolder)
        .get();
    for (var result in querySnapshot2.docs) {
      following.add(User.fromJson(result.data()));
    }

    for (User user in users) {
      if (following.contains(user)) {
        user.followed = true;
      } else {
        user.followed = false;
      }
    }
    return users;
  }

  /// Post Related

  /// Post methods
  static Future<Post> storePost(Post post) async {
    // filled post
    User me = await loadUser();
    me.postCount = me.postCount + 1;
    Log.w(me.postCount.toString());
    await updateUser(me);
    post.uid = me.uid;
    post.fullName = me.fullName;
    post.profileImage = me.imageUrl;
    post.device_token = me.device_token;
    post.isMine = true;
    post.createdDate = Utils.getMonthDayYear(DateTime.now().toString());

    String postId = instance
        .collection(usersFolder)
        .doc(me.uid)
        .collection(postsFolder)
        .doc()
        .id;
    post.id = postId;
    // Store to All post for Search page
   await storePostForAll(post, postId);

    // Store to users posts
    await instance
        .collection(usersFolder)
        .doc(me.uid)
        .collection(postsFolder)
        .doc(postId)
        .set(post.toJson());
    return post;
  }
  static Future<void> storePostForAll(Post post,String postId) async {
    post.isMine = true;
    // Store to All post for Search page
    await instance.collection(allPostsFolder).doc(postId).set(post.toJson());
  }


  static Future<Post> storeFeed(Post post) async {
    String uid = (await GetXLocalDB.load(StorageKeys.UID))!;
    await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(feedsFolder)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = (await GetXLocalDB.load(StorageKeys.UID))!;
    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(feedsFolder)
        .get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      if (post.uid == uid) {
        post.isMine = true;
      } else {
        post.isMine = false;
      }
      posts.add(post);
    }

    return posts;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = (await GetXLocalDB.load(StorageKeys.UID))!;
    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(postsFolder)
        .get();

    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    return posts;
  }

  static Future<List<Post>> loadSomeonesPosts(User user) async {
    List<Post> posts = [];
    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(user.uid)
        .collection(postsFolder)
        .get();

    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    return posts;
  }

  static Future<List<Post>> loadAllPosts() async {
    List<Post> posts = [];
    var querySnapshot = await instance.collection(allPostsFolder).get();

    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    return posts;
  }

  /// Like Post methods
  static Future<Post> likePost(Post post, bool isLiked) async {
    User user = await loadUser();
    post.isLiked = isLiked;
    if (isLiked) {
      user.likedImage = post.postImage;
      post.likedCount = post.likedCount + 1;
      post.likedByUsers.add(user.toJson());
    } else {
      user.likedImage = null;
      post.likedCount = post.likedCount - 1;
      post.likedByUsers.removeWhere((element) => (element['uid'] == user.uid));
    }


    // Update my liked Feed post
    await instance
        .collection(usersFolder)
        .doc(user.uid)
        .collection(feedsFolder)
        .doc(post.id)
        .update(post.toJson());
    await storedLikeByUsers(user, post, isLiked);

    //Update my liked post
    if (user.uid == post.uid) {
      await instance
          .collection(usersFolder)
          .doc(user.uid)
          .collection(postsFolder)
          .doc(post.id)
          .update(post.toJson());
    } else {
      await methodLikeSomeones(user, post, isLiked);
    }
    post.isLiked = !post.isLiked;
    Network.POST(Network.paramCreateLike(
            post.device_token, user.fullName!, post.fullName!))
        .then((value) {
      Log.i("Notif response : $value");
    });
    return post;
  }

  static Future<void> methodLikeSomeones(
      User user, Post post, bool isLiked) async {
    await storePostForAll(post, post.id!);

    // Update someones liked Feed post
    await instance
        .collection(usersFolder)
        .doc(post.uid)
        .collection(feedsFolder)
        .doc(post.id)
        .update(post.toJson());
    // Update someones liked Posts post

    await instance
        .collection(usersFolder)
        .doc(post.uid)
        .collection(postsFolder)
        .doc(post.id)
        .update(post.toJson());
  }

  static Future<Post> storedLikeByUsers(
      User user, Post post, bool isLiked) async {
    // Add or Remove from likesFolder
    ((isLiked) && (user.uid != post.uid))
        ? await instance
            .collection(usersFolder)
            .doc(post.uid)
            .collection(likesFolder)
            .doc(post.id! + user.uid!)
            .set(user.toJson())
        : await instance
            .collection(usersFolder)
            .doc(post.uid)
            .collection(likesFolder)
            .doc(post.id! + user.uid!)
            .delete();
    return post;
  }

  static Future<List<User>> loadLikes() async {
    String uid = (await GetXLocalDB.load(StorageKeys.UID))!;
    List<User> likeUsers = [];
    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(likesFolder)
        .get();

    for (var element in querySnapshot.docs) {
      User user = User.fromJson(element.data());
      likeUsers.add(user);
    }
    return likeUsers;
  }

  /// Follow methods
  static Future<User> followUser(User someone) async {
    User me = await loadUser();
    me.followingCount = me.followingCount + 1;
    updateUser(me);
    someone.followersCount = someone.followersCount + 1;
    updateUser(someone);
    // I followed to someone
    await instance
        .collection(usersFolder)
        .doc(me.uid)
        .collection(followingFolder)
        .doc(someone.uid)
        .set(someone.toJson());

    // I am in someone's following list
    await instance
        .collection(usersFolder)
        .doc(someone.uid)
        .collection(followerFolder)
        .doc(me.uid)
        .set(me.toJson());
    Network.POST(Network.paramCreateFollow(
            someone.device_token, me.fullName!, someone.fullName!))
        .then((value) {
      Log.i("Notif response : $value");
    });

    return someone;
  }

  static Future<User> unFollowUser(User someone) async {
    User me = await loadUser();
    me.followingCount = me.followingCount - 1;
    updateUser(me);
    someone.followersCount = someone.followersCount - 1;
    updateUser(someone);
    // I unFollowed to someone
    await instance
        .collection(usersFolder)
        .doc(me.uid)
        .collection(followingFolder)
        .doc(someone.uid)
        .delete();

    // I am deleted in someone's following list
    await instance
        .collection(usersFolder)
        .doc(someone.uid)
        .collection(followerFolder)
        .doc(me.uid)
        .delete();
    return someone;
  }

  static Future storePostsToMyFeed(User someone) async {
    // Store someone`s posts to my feed
    List<Post> posts = [];

    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(someone.uid)
        .collection(postsFolder)
        .get();
    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      post.isLiked = false;
      posts.add(post);
    }
    for (Post post in posts) {
      storeFeed(post);
    }
    Log.w("Stored Feed Done");
  }

  static Future removePostsFromMyFeed(User someone) async {
    // Remove someone`s posts from my feed
    List<Post> posts = [];

    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(someone.uid)
        .collection(postsFolder)
        .get();
    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    for (Post post in posts) {
      removeMyPost(post);
    }
    Log.w("Removed Feed Done");
  }

  /// Remove My Posts
  static Future removeMyPost(Post post) async {
    String uid = (await GetXLocalDB.load(StorageKeys.UID))!;

    /// Remove Post My Feed
    await instance
        .collection(usersFolder)
        .doc(uid)
        .collection(feedsFolder)
        .doc(post.id)
        .delete();

    if (post.uid == uid) {
      User me = await loadUser();
      me.postCount = me.postCount - 1;
      updateUser(me);
      await instance
          .collection(usersFolder)
          .doc(uid)
          .collection(postsFolder)
          .doc(post.id)
          .delete();
      await instance.collection(allPostsFolder).doc(post.id).delete();

    }

  }
  static Future updatePostsToFollowersFeed(User me) async {
    // Store someone's posts to my feed
    List<String> userUids = [];
    var querySnapshot = await instance
        .collection(usersFolder)
        .doc(me.uid)
        .collection(followerFolder)
        .get();

    for (var element in querySnapshot.docs) {
      User follower = User.fromJson(element.data());
      userUids.add(follower.uid!);
    }
    for (String follower in userUids) {
      var querySnapshot = await instance
          .collection(usersFolder)
          .doc(follower)
          .collection(feedsFolder)
          .where("uid", isEqualTo: me.uid)
          .get();
      for (var element in querySnapshot.docs) {
        Post post = Post.fromJson(element.data());
        post.profileImage = me.imageUrl;
        post.fullName = me.fullName;
        await instance
            .collection(usersFolder)
            .doc(follower)
            .collection(feedsFolder)
            .doc(post.id)
            .update(post.toJson());
      }
    }
  }

}
