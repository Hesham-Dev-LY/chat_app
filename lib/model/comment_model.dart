import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CommentModel {
  String? body;
  String? date;
  String? userId;
  String? userName;

  CommentModel.fromJson(Map<String, dynamic> data) {
    body = data['body'];
    var dddd = DateFormat(
      'h:m a - yyyy/MM/dd',
      'ar',
    )..useNativeDigits = false;
    date = dddd.format((data['date'] as Timestamp).toDate());
    userId = data['userId'];
    userName = data['userName'];
  }

  CommentModel.comment({required this.body});

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'date': FieldValue.serverTimestamp(),
      'userId': userId ?? FirebaseAuth.instance.currentUser!.uid,
      'userName': userName ??
          FirebaseAuth.instance.currentUser!.displayName ??
          'unknown',
    };
  }
}
