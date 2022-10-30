import 'dart:math';

import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/core/home/home_screen.dart';
import 'package:chat_app/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/core_screen.dart';

class SignUp extends StatefulWidget {
  // -------------------------------------------------------------- //

  // -------------------------------------------------------------- //
  @override
  _SignUpState createState() => _SignUpState();

  SignUp();
}

class _SignUpState extends State<SignUp> {
  // -------------------------------------------------------------- //
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController userNameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // TODO SignUp Function
  signMeUp() async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      await authMethods
          .signUpWithEmailAndPassword(emailEditingController.text,
              passwordEditingController.text, context)
          .then((result) {
        if (result != null) {
          Map<String, dynamic> userDataMap = {
            "name": userNameEditingController.text,
            "email": emailEditingController.text,
            'authId': FirebaseAuth.instance.currentUser!.uid,
            'image': null,
            'fromGoogle': false,
            'catetedAt': FieldValue.serverTimestamp(),
          };
          FirebaseAuth.instance.currentUser!
              .updateDisplayName(userNameEditingController.text);
          databaseMethods.uploadUserInfo(userDataMap,
              id: authMethods.auth.currentUser!.uid);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userNameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => CoreScreen()));
        }
      }).catchError((e) {
        log(e);
        setState(() {
          isLoading = true;
        });
      });
    }
  }

  // -------------------------------------------------------------- //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              padding: EdgeInsets.only(top: 60),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return (val ?? '').isEmpty ||
                                      (val?.length ?? 0) < 3
                                  ? 'اسم المستخدم مطلوب'
                                  : null;
                            },
                            controller: userNameEditingController,
                            style: simpleTextStyle(color: Colors.blue),
                            decoration: textFieldInputDecoration(
                              'اسم المستخدم',
                              Icon(
                                Icons.account_circle,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val ?? '')
                                  ? null
                                  : "الرجاء التأكد من البريد الإلكتروني";
                            },
                            controller: emailEditingController,
                            style: simpleTextStyle(color: Colors.blue),
                            decoration: textFieldInputDecoration(
                              'البريد الإلكتروني',
                              Icon(
                                Icons.email_outlined,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            validator: (val) {
                              return (val?.length ?? 0) < 6
                                  ? 'مطلوب 6 خانات على الأقل'
                                  : null;
                            },
                            controller: passwordEditingController,
                            style: simpleTextStyle(color: Colors.blue),
                            obscureText: true,
                            decoration: textFieldInputDecoration(
                              'كلمة المرور',
                              Icon(
                                Icons.vpn_key,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        signMeUp();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text('انشاء حساب', style: simpleTextStyle()),
                        decoration: BoxDecoration(
                          // Border
                          borderRadius: BorderRadius.circular(10.0),
                          // Gradient
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'التسجيل بواسطة Google',
                        style: TextStyle(color: Colors.black87, fontSize: 16.0),
                      ),
                      decoration: BoxDecoration(
                        // Border
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('لديك حساب بالفعل ؟', style: simpleTextStyle()),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              ' سجل الدخول',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 50.0),
                  ],
                ),
              ),
            ),
    );
  }
}
