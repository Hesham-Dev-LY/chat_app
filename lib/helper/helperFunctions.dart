import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'default_button.dart';

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

Future okCancelDialog(context, String title,
    {String? message,
    String okText = 'موافق',
    String? args,
    String cancelText = 'إلغاء الأمر',
    bool showCancelButton = false}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 18, height: 1.5),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  if (message != null)
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 14.0, left: 8.0, right: 8.0),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: DefaultButton(
                                onClick: () {
                                  Navigator.pop(context, true);
                                },
                                backColor: Colors.blue,
                                fontSize: 14,
                                textColor: Colors.white,
                                label: okText)),
                      ),
                      if (showCancelButton)
                        SizedBox(
                          width: 8,
                        ),
                      if (showCancelButton)
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: DefaultButton(
                              onClick: () {
                                Navigator.pop(context, false);
                              },
                              label: cancelText,
                              fontSize: 14,
                              textColor: Colors.white,
                              backColor: Colors.grey),
                        )),
                    ],
                  )
                ],
              ),
            ),
          ));
}

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

  Future<String?> getImage({required String userId}) async {
    String? url;
    try {
      url = await FirebaseStorage.instance
          .ref('profile/$userId.jpg')
          .getDownloadURL();
    } catch (ex) {}
    return url;
  }
}
