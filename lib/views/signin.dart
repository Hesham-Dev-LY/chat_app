import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:chat_app/views/home_screen.dart';
import 'package:chat_app/views/signup.dart';
import 'package:chat_app/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  // -------------------------------------------------------------- //
  // "SignIn()" constructor

  // -------------------------------------------------------------- //
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // -------------------------------------------------------------- //
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot<Map<String, dynamic>>? snapshotUserInfo;
  signMeIn() async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      try {
        await authMethods
            .signInWithEmailAndPassword(emailEditingController.text,
                passwordEditingController.text, context)
            .then((value) async {
          if (value != null) {
            databaseMethods
                .getUserByUserEmail(emailEditingController.text)
                .then((value) {
              snapshotUserInfo = value;
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(
                  snapshotUserInfo!.docs[0].data()['name']);
              HelperFunctions.saveUserEmailSharedPreference(
                  snapshotUserInfo!.docs[0].data()['email']);
            });
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        });
      } catch (ex) {
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  googleSignMeIn() async {
    setState(() {
      isLoading = true;
    });

    authMethods.signInWithGoogle().then((result) async {
      print(authMethods.name);
      print(authMethods.email);
      if (result != null) {
        Map<String, String> googleData = {
          'googleUserName': authMethods.name,
          'googleUserEmail': authMethods.email
        };
        await DatabaseMethods().uploadUserInfo(googleData);
        snapshotUserInfo =
            await DatabaseMethods().getUserByUserEmail(authMethods.email);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo!.docs[0].data()["googleUserName"]);
        HelperFunctions.saveUserEmailSharedPreference(
            snapshotUserInfo!.docs[0].data()["googleUserEmail"]);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    });
  }

  // -------------------------------------------------------------- //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              padding: EdgeInsets.only(top: 60),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val ?? '')
                                  ? null
                                  : "Valid email required";
                            },
                            controller: emailEditingController,
                            style: simpleTextStyle(color: Colors.blue),
                            decoration: textFieldInputDecoration(
                              'Email',
                              Icon(Icons.email_outlined),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            validator: (val) {
                              return (val?.length ?? 0) < 6
                                  ? 'Minimum 6 characters required'
                                  : null;
                            },
                            controller: passwordEditingController,
                            style: simpleTextStyle(color: Colors.blue),
                            obscureText: true,
                            decoration: textFieldInputDecoration(
                              'Password',
                              Icon(Icons.vpn_key),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 8.0),
                    // Container(
                    //   alignment: Alignment.centerRight,
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    //   child:
                    //       Text('Forgot Password ?', style: simpleTextStyle()),
                    // ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        signMeIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text('Sign In', style: simpleTextStyle()),
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
                    GestureDetector(
                      onTap: () {
                        googleSignMeIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Sign In with Google',
                          style:
                              TextStyle(color: Colors.black87, fontSize: 16.0),
                        ),
                        decoration: BoxDecoration(
                          // Border
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              ' Register Now ',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        Text('? Don\'t have an account ',
                            style: simpleTextStyle(color: Colors.grey)),
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
