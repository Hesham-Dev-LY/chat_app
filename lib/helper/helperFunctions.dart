import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';

  //TODO saving data to SharedPreference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  //TODO getting data from SharedPreference
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey) ?? false;
  }

  static Future<String?> getUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }
}

Widget loadPhoto(
        {required String url,
        double height = 70.0,
        double? width,
        Color backColor = Colors.grey,
        BoxFit? bf}) =>
    CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: url,
      fit: bf ?? BoxFit.cover,
      errorWidget: (context, url, error) => const Icon(
        Icons.image_not_supported_rounded,
        color: Colors.grey,
      ),
      placeholder: (context, url) => Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CircularProgressIndicator(),
        ),
      ),
    );

void showToast(String text, {bool error = false}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: error ? Colors.red : Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0);
}

void like({bool like = true, required String postId}) {
  FirebaseFirestore.instance.collection('posts').doc(postId).update({
    if (like)
      'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
    if (!like)
      'likes': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
  });
}
