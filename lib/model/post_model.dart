import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../helper/helperFunctions.dart';

class PostModel {
  String? userName, description, date, userId, image, postId;
  int? commentsCount;
  bool isLiked = false;
  List<dynamic> likes = [];

  PostModel.fromJson(Map data, String id) {
    postId = id;
    userName = data['userName'];
    userId = data['userId'];
    image = data['image'];
    likes = data['likes'] ?? [];
    if (likes.isNotEmpty &&
        likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
      isLiked = true;
    }
    description = data['description'];
    var dddd = DateFormat(
      'h:m a - yyyy/MM/dd',
      'ar',
    )..useNativeDigits = false;
    date = dddd.format((data['date'] as Timestamp).toDate());
    commentsCount = data['commentsCount'];
  }

  PostModel.newPost({required this.description, this.image});

  Future<Map<String, dynamic>> toMap() async {
    return {
      'userName':
          userName ?? (await HelperFunctions.getUserNameSharedPreference()),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'description': description,
      'image': image,
      'commentsCount': commentsCount ?? 0,
      'date': FieldValue.serverTimestamp(),
      'likes': [],
    };
  }
}
